import argparse
import math
import time
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import Dict, List, Optional, Tuple
from utils import create_device, get_state_key
import pymimir_rl as rl

# IQN oracle: load via the IQN training module so the quantile heads
# (cosine_projection / quantile_head) are restored, not just the base RGNN.
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
    Pure add-on. Wraps the trained IQN model and returns, for a state, the SORTED
    quantile curve of the BEST action (best = highest mean over the tau grid),
    on the same 99-point tau grid used in the offline W1 validation.

    W1 is a per-TRANSITION quantity, so the search caches each node's best-action
    curve and computes edge-W1(parent -> child) as the mean absolute difference
    between the parent's and child's sorted curves -- exactly the validation
    definition of the W1 shift along a transition.
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
            return None  # no applicable actions (dead end) -> no curve
        qs, _ = torch.sort(q_values, dim=1)        # sort each action's quantile curve
        means = qs.mean(dim=1)
        best = int(means.argmax().item())          # best action by mean (matches validation)
        return qs[best].detach()                   # [num_quantiles], sorted


def _edge_w1(parent_curve: Optional[torch.Tensor], child_curve: Optional[torch.Tensor]) -> Optional[float]:
    """W1 between two sorted quantile curves = mean |sorted(p) - sorted(c)| (validation form)."""
    if parent_curve is None or child_curve is None:
        return None
    return torch.mean(torch.abs(parent_curve - child_curve)).item()


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
        return value  # range not established yet


class Node:
    __slots__ = (
        "state", "state_key", "is_goal",
        "expanded", "is_dead_end",
        "children", "prior", "edge_N", "edge_W", "visit_count",
        "value",
        "curve",           # NEW: cached best-action sorted quantile curve (None = unknown)
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
        self.curve = None            # NEW

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

    # Ensure THIS node has its best-action curve cached (parent side of edge-W1).
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


def _select(node, c_puct, value_norm, blocked=None, w1_norm=None, w1_lambda=0.0):
    best_score = -float("inf")
    best_action = None
    best_child = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))

    # Prior-boost by edge-W1: raise each child's prior by the W1 shift along the
    # transition into it, renormalize, use the boosted prior inside pUCT.
    #   P'(a) = P(a) * (1 + w1_lambda * norm_W1(parent -> child_a)), normalized.
    # Inside the pUCT term so it decays with visits. w1_lambda=0 -> vanilla.
    boosted_prior = None
    if w1_lambda != 0.0 and w1_norm is not None and node.curve is not None:
        raw = {}
        total = 0.0
        for action, child in node.children.items():
            w1 = _edge_w1(node.curve, child.curve)
            nw = w1_norm.normalize(w1) if w1 is not None else 0.0
            pb = node.prior[action] * (1.0 + w1_lambda * nw)
            raw[action] = pb
            total += pb
        if total > 0.0:
            boosted_prior = {a: v / total for a, v in raw.items()}

    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0  # pessimistic FPU
        p_use = boosted_prior[action] if boosted_prior is not None else node.prior[action]
        u = c_puct * p_use * sqrt_parent / (1 + n)
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


def _register_edge_w1(node, w1_norm):
    """Register a node's outgoing edge-W1 values with the running normalizer."""
    if w1_norm is None or node.curve is None:
        return
    for child in node.children.values():
        w1 = _edge_w1(node.curve, child.curve)
        if w1 is not None:
            w1_norm.update(w1)


def _simulate(root, tt, policy_model, q1_model, q2_model, goal,
              c_puct, value_norm, dead_end_value, oracle, w1_norm, w1_lambda):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root

    w1_active = oracle is not None and w1_lambda != 0.0

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys,
                                 w1_norm=w1_norm, w1_lambda=w1_lambda)
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
        _register_edge_w1(node, w1_norm)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state, root_key, policy_model, q1_model, q2_model, goal,
            max_simulations, max_time, c_puct, dead_end_value,
            stop_on_first_solution, oracle, w1_lambda):
    root = Node(root_state, root_key, goal.holds(root_state))
    tt = {root_key: root}
    value_norm = _ValueNormalizer()
    w1_active = oracle is not None and w1_lambda != 0.0
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
            c_puct, value_norm, dead_end_value, oracle, w1_norm, w1_lambda,
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
    parser = argparse.ArgumentParser(description="AlphaZero planner with IQN edge-W1 prior-boost")
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
    parser.add_argument("--w1_lambda", default=0.0, type=float,
                        help="Prior-boost strength using edge-W1: "
                             "P'(a)=P(a)*(1+w1_lambda*norm_W1(parent->child)), renormalized, "
                             "inside the pUCT term. 0.0 = vanilla.")
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
            oracle=oracle, w1_lambda=args.w1_lambda,
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
        print(f"[oracle] IQN quantile oracle loaded: {args.iqn_model} "
              f"(w1_lambda={args.w1_lambda})", flush=True)
    elif args.w1_lambda != 0.0:
        raise RuntimeError("--w1_lambda is set but no --iqn_model was given.")

    solution = _plan(problem, policy_model, q1_model, q2_model, oracle, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())