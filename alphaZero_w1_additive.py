"""
AlphaZero (transposition-table DAG) with an ADDITIVE, decoupled IQN edge-W1
exploration bonus. Logistics-only variant.

Selection term (the ONLY change vs the base planner):

    U(s,a) = Q_norm(s,a)
             + [ c_puct * P(s,a) + beta * W1_norm(parent->a) ] * sqrt(N(s)) / (1 + N(s,a))

Rationale (Logistics): the SAC policy is near-deterministic, so a multiplicative
boost P*(1+lambda*W1) is bounded by a tiny P(a) and can never lift a low-prior
successor. Here beta*W1 is INDEPENDENT of P(a), so it can compete even when
P(a) ~ 0.01. It still rides inside the pUCT exploration term, so it decays as
1/(1+N) and Q takes over once a node is visited -> graceful fallback if the
signal is wrong. The prior distribution is untouched (no renormalization).

beta=0.0 reduces this to vanilla pUCT. Suggested start: beta = 0.5 * c_puct.

NOTE: this file deliberately does NOT include the FPU-reduction / visit-gate /
top-k machinery from alphaZero_w1.py. The Grid depth-runaway failure mode is a
separate problem; this variant is for Logistics, where the bottleneck is the
peaked prior, not frontier value-grounding.
"""
import argparse
import math
import os as _os_top
import time
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import Dict, List, Optional, Tuple
from utils import create_device, get_state_key
import pymimir_rl as rl

from train_iqn import _load_model as _load_iqn_model


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, readout_name: str) -> None:
        super().__init__()
        self.model = model
        self.readout_name = readout_name

    def forward(
        self, state_goals: List[Tuple[mm.State, mm.GroundConjunctiveCondition]]
    ) -> List[Tuple[torch.Tensor, List[mm.GroundAction]]]:
        input_list: List[Tuple[mm.State, List[mm.GroundAction], mm.GroundConjunctiveCondition]] = []
        actions_list: List[List[mm.GroundAction]] = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        values_list = self.model.forward(input_list).readout(self.readout_name)  # type: ignore
        return list(zip(values_list, actions_list))


class QuantileOracle:
    """
    Wraps the trained IQN model. For a state, returns the SORTED quantile curve
    of the BEST action (best = highest mean over the tau grid), on the same
    99-point tau grid used in offline W1 validation. edge-W1(parent->child) is the
    mean absolute difference of the parent's and child's sorted curves.
    Does not touch the SAC policy/critics that drive the search.
    """
    def __init__(self, iqn_model, device: torch.device, num_quantiles: int = 99) -> None:
        self._model = iqn_model
        self._device = device
        self._taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)

    @torch.no_grad()
    def best_curve(self, state: mm.State, goal: mm.GroundConjunctiveCondition) -> Optional[torch.Tensor]:
        q_values, actions = self._model.forward(
            [(state, goal)], taus=self._taus.expand(1, self._taus.shape[1]))[0]
        if q_values.shape[0] == 0:
            return None
        qs, _ = torch.sort(q_values, dim=1)
        means = qs.mean(dim=1)
        best = int(means.argmax().item())
        return qs[best].detach()


def _edge_w1(parent_curve: Optional[torch.Tensor], child_curve: Optional[torch.Tensor],
             signed: bool = False) -> Optional[float]:
    if parent_curve is None or child_curve is None:
        return None
    magnitude = torch.mean(torch.abs(parent_curve - child_curve)).item()
    if not signed:
        return magnitude
    # Positive = child is better (progress), negative = child is worse (regressive).
    sign = 1.0 if child_curve.mean().item() > parent_curve.mean().item() else -1.0
    return sign * magnitude


class _ValueNormalizer:
    """MuZero-style running min/max normalization into [0, 1]. Reused for W1 values."""

    def __init__(self) -> None:
        self._min = float("inf")
        self._max = -float("inf")

    def update(self, value: float) -> None:
        if value < self._min:
            self._min = value
        if value > self._max:
            self._max = value

    def normalize(self, value: float) -> float:
        if self._max > self._min:
            return (value - self._min) / (self._max - self._min)
        return value


class Node:
    __slots__ = (
        "state", "state_key", "is_goal",
        "expanded", "is_dead_end",
        "children", "prior", "edge_N", "edge_W", "visit_count",
        "value", "curve",
    )

    def __init__(self, state: mm.State, state_key, is_goal: bool) -> None:
        self.state = state
        self.state_key = state_key
        self.is_goal = is_goal
        self.expanded = False
        self.is_dead_end = False
        self.children: Dict[mm.GroundAction, "Node"] = {}
        self.prior: Dict[mm.GroundAction, float] = {}
        self.edge_N: Dict[mm.GroundAction, int] = {}
        self.edge_W: Dict[mm.GroundAction, float] = {}
        self.value = -float("inf")
        self.visit_count = 0
        self.curve = None

    def q(self, action):
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state, goal, q1_model, q2_model) -> float:
    q1_vals, _ = q1_model.forward([(state, goal)])[0]
    if q2_model is not None:
        q2_vals, _ = q2_model.forward([(state, goal)])[0]
        q_vals = torch.minimum(q1_vals, q2_vals)
    else:
        q_vals = q1_vals
    return q_vals.max().item()


def _expand(node, tt, policy_model, q1_model, q2_model, goal, dead_end_value,
            oracle, w1_active) -> Tuple[float, int]:
    logits, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True

    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0

    if w1_active and node.curve is None and not node.is_goal:
        node.curve = oracle.best_curve(node.state, goal)

    probs = torch.softmax(logits, dim=0)
    generated = 0
    for i, action in enumerate(actions):
        successor = action.apply(node.state)
        key = get_state_key(successor)
        child = tt.get(key)
        if child is None:
            child = Node(successor, key, goal.holds(successor))
            tt[key] = child
            generated += 1
            if w1_active and not child.is_goal:
                child.curve = oracle.best_curve(successor, goal)
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0

    return _leaf_value(node.state, goal, q1_model, q2_model), generated


def _select(node, c_puct, value_norm, blocked=None, w1_norm=None, beta=0.0,
            signed=False, relative=False):
    """
    Additive decoupled selection:
        U = Q_norm + [c_puct*P + beta*W1_boost] * sqrt(N(s)) / (1 + N(s,a))

    Three modes (mutually exclusive, relative takes priority):
      relative=True  -- boost(a) = max(0, signed_W1(a) - signed_W1(dominant))
                        where dominant = highest-prior non-blocked child.
                        Activates only when some alternative genuinely beats the
                        dominant in IQN-predicted progress; self-silencing on
                        nodes where the policy already picks the best-W1 action.
      signed=True    -- boost(a) = max(0, signed_W1(a))
                        Suppresses regressive moves, boosts any progress move.
      (neither)      -- boost(a) = unsigned W1(a)  (original behaviour)

    beta=0 -> vanilla pUCT regardless of mode.
    """
    best_score = -float("inf")
    best_action = None
    best_child = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))

    use_signed = signed or relative
    w1_active = beta != 0.0 and w1_norm is not None and node.curve is not None

    # Relative mode: find the signed W1 of the highest-prior non-blocked child.
    # The additive boost for each action is then max(0, signed_W1(a) - dom_signed),
    # which is zero for the dominant and for anything worse, and positive only for
    # alternatives that show more IQN-predicted progress than the dominant choice.
    dom_signed = 0.0
    if relative and w1_active:
        dom_action = None
        dom_prior = -1.0
        for a, c in node.children.items():
            if blocked is not None and c.state_key in blocked:
                continue
            if node.prior[a] > dom_prior:
                dom_prior = node.prior[a]
                dom_action = a
        if dom_action is not None:
            dom_w1 = node.edge_W.get(dom_action)
            if dom_w1 is None:
                dom_w1 = _edge_w1(node.curve, node.children[dom_action].curve, signed=True)
            dom_signed = dom_w1 if dom_w1 is not None else 0.0

    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0

        explore = c_puct * node.prior[action]
        if w1_active:
            w1 = node.edge_W.get(action)
            if w1 is None:
                w1 = _edge_w1(node.curve, child.curve, signed=use_signed)
            if w1 is not None:
                if relative:
                    boost = max(0.0, w1 - dom_signed)
                elif signed:
                    boost = max(0.0, w1)
                else:
                    boost = w1
                if boost > 0.0:
                    w1_norm.update(boost)   # live-calibrate normalizer on relative boosts
                    explore += beta * w1_norm.normalize(boost)
        u = explore * sqrt_parent / (1 + n)

        score = q_norm + u
        if score > best_score:
            best_score, best_action, best_child = score, action, child
    return best_action, best_child


def _backup(path_nodes, path_edges, leaf_value, value_norm):
    path_nodes[-1].value = max(path_nodes[-1].value, leaf_value)
    for node in reversed(path_nodes):
        if node.children:
            best_child = max(c.value for c in node.children.values())
            node.value = max(node.value, best_child)
        node.visit_count += 1
    for node, action in path_edges:
        node.edge_N[action] += 1
        value_norm.update(node.q(action))


def _register_edge_w1(node, w1_norm, signed=False, relative=False):
    """Cache each outgoing edge-W1 in node.edge_W and feed the running normalizer.

    Relative mode caches signed W1 (for dom_signed lookup in _select) but does NOT
    update the normalizer here — the normalizer is calibrated live in _select on the
    actual relative boosts so its range matches what is actually applied.
    """
    if w1_norm is None or node.curve is None:
        return
    use_signed = signed or relative
    for action, child in node.children.items():
        w1 = _edge_w1(node.curve, child.curve, signed=use_signed)
        if w1 is not None:
            node.edge_W[action] = w1
            if not relative:
                # Signed mode: only positive values define the normalizer range.
                # Unsigned mode: all values update the normalizer.
                if not use_signed or w1 > 0.0:
                    w1_norm.update(w1)
            # relative mode: normalizer updated in _select on actual boost values.


def _simulate(root, tt, policy_model, q1_model, q2_model, goal,
              c_puct, value_norm, dead_end_value, oracle, w1_norm, beta, signed, relative):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root

    w1_active = oracle is not None and beta != 0.0

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys,
                                 w1_norm=w1_norm, beta=beta, signed=signed, relative=relative)
        if action is None:
            value = _leaf_value(node.state, goal, q1_model, q2_model)
            _backup(path_nodes, path_edges, value, value_norm)
            return None, 0
        path_edges.append((node, action))
        node = child
        path_nodes.append(node)
        path_keys.add(node.state_key)

    goal_plan = None
    generated = 0

    if node.is_goal:
        value = 0.0
        goal_plan = [a for _, a in path_edges]
    elif node.is_dead_end:
        value = dead_end_value
    else:
        value, generated = _expand(node, tt, policy_model, q1_model, q2_model, goal,
                                   dead_end_value, oracle, w1_active)
        _register_edge_w1(node, w1_norm, signed=signed, relative=relative)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state, root_key, policy_model, q1_model, q2_model, goal,
            max_simulations, max_time, c_puct, dead_end_value,
            stop_on_first_solution, oracle, beta, signed, relative):
    root = Node(root_state, root_key, goal.holds(root_state))
    tt = {root_key: root}
    value_norm = _ValueNormalizer()
    w1_active = oracle is not None and beta != 0.0
    w1_norm = _ValueNormalizer() if w1_active else None
    if w1_active and not root.is_goal:
        root.curve = oracle.best_curve(root_state, goal)
    best_plan = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        goal_plan, generated = _simulate(
            root, tt, policy_model, q1_model, q2_model, goal,
            c_puct, value_norm, dead_end_value, oracle, w1_norm, beta, signed, relative,
        )
        total_generated += generated
        sims += 1

        if goal_plan is not None and (best_plan is None or len(goal_plan) < len(best_plan)):
            best_plan = goal_plan
            print(f"  [sim {sims}] found goal path of length {len(best_plan)}", flush=True)
            if stop_on_first_solution:
                break

        if sims % 500 == 0:
            print(f"  [sim {sims}] root visits={root.visit_count}, "
                  f"unique states={len(tt)}, generated={total_generated}", flush=True)

    return best_plan, sims, total_generated


def _parse_arguments():
    parser = argparse.ArgumentParser(description="AlphaZero planner with ADDITIVE decoupled IQN edge-W1 bonus (Logistics)")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path)
    parser.add_argument("--max_simulations", default=100000000, type=int)
    parser.add_argument("--max_time", default=None, type=float)
    parser.add_argument("--c_puct", default=1.5, type=float)
    parser.add_argument("--dead_end_value", default=-1000.0, type=float)
    parser.add_argument("--keep_searching", action="store_true")
    parser.add_argument("--iqn_model", default=None, type=Path,
                        help="IQN model (.pth) used ONLY as a quantile oracle for edge-W1.")
    parser.add_argument("--w1_beta", default=0.0, type=float,
                        help="Additive decoupled exploration weight: "
                             "U += beta*W1_norm * sqrt(N)/(1+n), independent of the prior. "
                             "0.0 = vanilla. Suggested start: 0.5*c_puct.")
    parser.add_argument("--w1_signed", action="store_true",
                        help="Use signed W1: only boost children whose IQN mean improves "
                             "over the parent (progress moves). Regressive moves get zero "
                             "boost. Has no effect when w1_beta=0.")
    parser.add_argument("--w1_relative", action="store_true",
                        help="Relative signed W1: boost(a) = max(0, signed_W1(a) - signed_W1(dominant)). "
                             "Activates only when some alternative has higher IQN-predicted progress "
                             "than the highest-prior action; self-silencing otherwise. "
                             "Takes precedence over --w1_signed. Has no effect when w1_beta=0.")
    return parser.parse_args()


def _plan(problem, policy_model, q1_model, q2_model, oracle, args):
    with torch.no_grad():
        goal = problem.get_goal_condition()
        initial = problem.get_initial_state()
        if goal.holds(initial):
            return []
        plan, sims, generated = _search(
            initial, get_state_key(initial),
            policy_model, q1_model, q2_model, goal,
            args.max_simulations, args.max_time, args.c_puct, args.dead_end_value,
            stop_on_first_solution=not args.keep_searching,
            oracle=oracle, beta=args.w1_beta, signed=args.w1_signed, relative=args.w1_relative,
        )
        print(f"[Final] Expanded: {generated}, Generated: {generated}", flush=True)
        print(f"[search done] simulations={sims}, unique states generated={generated}", flush=True)
        if plan is None:
            return None
        state = initial
        for action in plan:
            state = action.apply(state)
        assert goal.holds(state), "Extracted plan does not reach the goal!"
        return plan


def _main(args):
    print(f"Torch: {torch.__version__}", flush=True)
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    device = create_device(False)

    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    q1_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    policy_model = ModelWrapper(policy_raw, "policy")
    q1_model = ModelWrapper(q1_raw, "q")

    q2_model = None
    if args.q2_model is not None:
        q2_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
        q2_model = ModelWrapper(q2_raw, "q")

    oracle = None
    if args.iqn_model is not None:
        iqn_model, _, _ = _load_iqn_model(domain, args.iqn_model, device)
        iqn_model.eval()
        oracle = QuantileOracle(iqn_model, device)
        mode = "relative" if args.w1_relative else ("signed" if args.w1_signed else "unsigned")
        print(f"[oracle] IQN quantile oracle loaded: {args.iqn_model} "
              f"(w1_beta={args.w1_beta}, mode={mode})", flush=True)
    elif args.w1_beta != 0.0:
        raise RuntimeError("--w1_beta is set but no --iqn_model was given.")

    solution = _plan(problem, policy_model, q1_model, q2_model, oracle, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())