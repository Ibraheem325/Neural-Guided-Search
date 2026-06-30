"""
Diagnostic: at each branching node the AlphaZero search descends through, classify
whether the model is (A) confidently wrong, (B) signal-present-but-unused, or (C) correct.

Ground truth comes from StateSpaceSampler.get_state_label(...).steps_to_goal, so the
"correct child" = applicable successor with minimal true steps_to_goal. This does NOT
depend on the training-label file; it re-derives V* from the fully expanded instance.

Run ONLY on small instances that StateSpaceSampler.new can fully expand (same ones used
for the offline check). For each branching node we log:
  - policy entropy
  - whether the policy's argmax child is the correct child
  - W1(parent->child) and width(child) for the correct child, and their rank among siblings
  - the classification bucket

Then it prints aggregate counts so you can see whether Grid is dominated by (A) or (B).

Usage:
  python diag_grid_branching.py --domain examples/grid/domain.pddl \
      --problem examples/grid/val/<inst>.pddl \
      --policy_model grid_policy_best.pth \
      --q1_model grid_q1_best.pth \
      [--q2_model grid_q2_best.pth] \
      --iqn_model grid_iqn_best.pth \
      --max_simulations 20000 --c_puct 1.5
"""
import argparse
import math
import time
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from utils import create_device, get_state_key
from alphaZero import ModelWrapper, _ValueNormalizer, Node, _leaf_value

# IQN wrappers live in train_iqn.py
from train_iqn import IQNModelWrapper, RiskSensitivePolicyWrapper


# ---------------------------------------------------------------------------
# Ground-truth oracle built from the fully expanded state space.
# ---------------------------------------------------------------------------
class _Oracle:
    """Maps state_key -> true steps_to_goal (or +inf for dead ends), from StateSpaceSampler."""

    def __init__(self, sampler: mm.StateSpaceSampler) -> None:
        self._sampler = sampler
        self._cache: Dict[object, float] = {}

    def steps_to_goal(self, state: mm.State) -> float:
        key = get_state_key(state)
        cached = self._cache.get(key)
        if cached is not None:
            return cached
        label = self._sampler.get_state_label(state)
        val = float("inf") if label.is_dead_end else float(label.steps_to_goal)
        self._cache[key] = val
        return val

    def correct_children(self, state: mm.State) -> set:
        """state_keys of successors that lie on a shortest path (min true steps_to_goal)."""
        best = float("inf")
        succ_vals: List[Tuple[object, float]] = []
        for action in state.generate_applicable_actions():
            s2 = action.apply(state)
            v = self.steps_to_goal(s2)
            succ_vals.append((get_state_key(s2), v))
            if v < best:
                best = v
        return {k for k, v in succ_vals if v == best and v < float("inf")}


# ---------------------------------------------------------------------------
# IQN-derived metrics: width(child) and W1(parent -> child).
# These mirror however you compute them in your AlphaZero+IQN integration.
# Quantiles for a state-action come from IQNModelWrapper.forward.
# ---------------------------------------------------------------------------
def _action_quantiles(iqn: IQNModelWrapper,
                      state: mm.State,
                      goal: mm.GroundConjunctiveCondition,
                      num_quantiles: int = 64) -> Tuple[torch.Tensor, list]:
    taus = torch.rand(1, num_quantiles, device=next(iqn.parameters()).device)
    out = iqn.forward([(state, goal)], taus=taus)
    q_values, actions = out[0]  # q_values: [num_actions, num_quantiles]
    return q_values, actions


def _width(quantiles_row: torch.Tensor) -> float:
    # distribution spread for one action's quantiles
    if quantiles_row.numel() == 0:
        return 0.0
    return (quantiles_row.quantile(0.9) - quantiles_row.quantile(0.1)).abs().item()


def _w1(parent_row: torch.Tensor, child_row: torch.Tensor) -> float:
    # 1-Wasserstein between two sorted quantile samples of equal length
    if parent_row.numel() == 0 or child_row.numel() == 0:
        return 0.0
    p = torch.sort(parent_row).values
    c = torch.sort(child_row).values
    n = min(p.numel(), c.numel())
    return (p[:n] - c[:n]).abs().mean().item()


# ---------------------------------------------------------------------------
# Instrumented descent. We reuse the real search's select/expand/backup from
# alphaZero, but wrap _select to log the branching decision against the oracle.
# To stay faithful, we import the real functions and only intercept logging.
# ---------------------------------------------------------------------------
import alphaZero as az


class _Stats:
    def __init__(self) -> None:
        self.A_confidently_wrong = 0
        self.B_signal_unused = 0
        self.C_correct = 0
        self.total_branches = 0
        # extra detail
        self.B_w1_rank_of_correct: List[int] = []
        self.A_entropy: List[float] = []
        self.B_entropy: List[float] = []

    def report(self) -> None:
        t = max(1, self.total_branches)
        print("\n==== Grid branching diagnosis ====")
        print(f"total branching nodes visited: {self.total_branches}")
        print(f"  (C) policy already correct      : {self.C_correct}  ({100*self.C_correct/t:.1f}%)")
        print(f"  (A) confidently wrong, no signal: {self.A_confidently_wrong}  ({100*self.A_confidently_wrong/t:.1f}%)")
        print(f"  (B) signal present, unused      : {self.B_signal_unused}  ({100*self.B_signal_unused/t:.1f}%)")
        if self.B_w1_rank_of_correct:
            import statistics
            print(f"  (B) median W1-rank of correct child among siblings (1=highest W1): "
                  f"{statistics.median(self.B_w1_rank_of_correct):.1f}")
        if self.A_entropy:
            import statistics
            print(f"  (A) median policy entropy: {statistics.median(self.A_entropy):.3f}")
        if self.B_entropy:
            import statistics
            print(f"  (B) median policy entropy: {statistics.median(self.B_entropy):.3f}")
        print("\nInterpretation:")
        print("  A >> B  -> supervisor right: signal genuinely absent, no pUCT change helps.")
        print("  B sizable -> equation IS the bottleneck; correct child carries metric but")
        print("               isn't explored. Worth redesigning the pUCT term.")


def classify_node(node: Node,
                  oracle: _Oracle,
                  policy_model: ModelWrapper,
                  iqn: IQNModelWrapper,
                  goal: mm.GroundConjunctiveCondition,
                  stats: _Stats,
                  w1_top_frac: float = 0.2,
                  conf_threshold: float = 0.7) -> None:
    actions = list(node.children.keys())
    if len(actions) < 2:
        return  # not a branch
    stats.total_branches += 1

    # policy distribution
    logits, pol_actions = policy_model.forward([(node.state, goal)])[0]
    probs = torch.softmax(logits, dim=0)
    entropy = float(-(probs * (probs + 1e-12).log()).sum().item())
    argmax_idx = int(probs.argmax().item())
    policy_choice_key = get_state_key(pol_actions[argmax_idx].apply(node.state))
    top_prob = float(probs.max().item())

    correct_keys = oracle.correct_children(node.state)
    if not correct_keys:
        # node is a dead end region / no progressing child; skip
        stats.total_branches -= 1
        return

    if policy_choice_key in correct_keys:
        stats.C_correct += 1
        return

    # Policy is wrong here. Does the metric flag the correct child?
    parent_q, _ = _action_quantiles(iqn, node.state, goal)
    # map each action -> child W1 and width
    child_w1: List[Tuple[object, float]] = []
    for i, action in enumerate(pol_actions):
        child_state = action.apply(node.state)
        child_q, _ = _action_quantiles(iqn, child_state, goal)
        # W1 parent action-row vs child best-row (parent->child shift)
        prow = parent_q[i] if i < parent_q.shape[0] else parent_q.mean(0)
        crow = child_q.mean(0) if child_q.numel() else prow
        child_w1.append((get_state_key(child_state), _w1(prow, crow)))

    # rank correct child by W1 (1 = highest W1)
    ranked = sorted(child_w1, key=lambda kv: kv[1], reverse=True)
    rank_of_correct = next((r + 1 for r, (k, _) in enumerate(ranked) if k in correct_keys), None)
    top_k = max(1, int(math.ceil(w1_top_frac * len(ranked))))
    correct_in_top = rank_of_correct is not None and rank_of_correct <= top_k

    if correct_in_top:
        # metric DOES elevate the correct child -> signal present, pUCT failed to use it
        stats.B_signal_unused += 1
        stats.B_w1_rank_of_correct.append(rank_of_correct)
        stats.B_entropy.append(entropy)
    else:
        # confidently wrong: sharp policy on wrong child AND metric doesn't flag correct one
        if top_prob >= conf_threshold:
            stats.A_confidently_wrong += 1
            stats.A_entropy.append(entropy)
        else:
            # policy diffuse but metric also unhelpful — count as A (no usable signal)
            stats.A_confidently_wrong += 1
            stats.A_entropy.append(entropy)


def run(args) -> None:
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    device = create_device(False)

    print("Expanding full state space for ground truth...", flush=True)
    sampler = mm.StateSpaceSampler.new(problem, 100_000)
    if sampler is None:
        raise RuntimeError("Instance too large to fully expand; pick a smaller one.")
    oracle = _Oracle(sampler)

    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    q1_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    policy_model = ModelWrapper(policy_raw, "policy")
    q1_model = ModelWrapper(q1_raw, "q")
    q2_model = None
    if args.q2_model is not None:
        q2_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
        q2_model = ModelWrapper(q2_raw, "q")

    # load IQN
    iqn_raw, extras = rgnn.RelationalGraphNeuralNetwork.load(domain, args.iqn_model, device)
    iqn_meta = extras.get("iqn_wrapper")
    iqn = IQNModelWrapper(iqn_raw, iqn_meta["num_cosines"] if iqn_meta else 64).to(device)
    if iqn_meta:
        sd = iqn_meta["state_dict"]
        iqn.load_state_dict(sd, strict=False)

    stats = _Stats()
    goal = problem.get_goal_condition()

    # Run the real search, but after each simulation walk the current tree's expanded
    # branching nodes and classify those we haven't seen. Simpler + faithful: monkeypatch
    # _expand to classify each node right when it gets expanded.
    seen = set()
    orig_expand = az._expand

    def traced_expand(node, tt, pol, q1, q2, g, dev):
        ret = orig_expand(node, tt, pol, q1, q2, g, dev)
        if node.state_key not in seen and node.expanded and not node.is_dead_end:
            seen.add(node.state_key)
            with torch.no_grad():
                classify_node(node, oracle, policy_model, iqn, g, stats)
        return ret

    az._expand = traced_expand
    try:
        with torch.no_grad():
            az._search(
                problem.get_initial_state(), get_state_key(problem.get_initial_state()),
                policy_model, q1_model, q2_model, goal,
                args.max_simulations, args.max_time, args.c_puct, args.dead_end_value,
                stop_on_first_solution=False,
            )
    finally:
        az._expand = orig_expand

    stats.report()


def _parse() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("--domain", required=True, type=Path)
    p.add_argument("--problem", required=True, type=Path)
    p.add_argument("--policy_model", required=True, type=Path)
    p.add_argument("--q1_model", required=True, type=Path)
    p.add_argument("--q2_model", default=None, type=Path)
    p.add_argument("--iqn_model", required=True, type=Path)
    p.add_argument("--max_simulations", default=20000, type=int)
    p.add_argument("--max_time", default=None, type=float)
    p.add_argument("--c_puct", default=1.5, type=float)
    p.add_argument("--dead_end_value", default=-1000.0, type=float)
    return p.parse_args()


if __name__ == "__main__":
    run(_parse())