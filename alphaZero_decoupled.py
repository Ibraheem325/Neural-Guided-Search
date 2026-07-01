"""
AlphaZero (transposition-table DAG) with the DECOUPLED additive pUCT formula
proposed by the supervisor. No W1/IQN involved -- this isolates whether the
base equation itself fixes the depth-runaway/tunneling failure mode.

Standard pUCT (what alphaZero.py uses):
    U(s,a) = Q_norm(s,a) + c * P(s,a) * f(s,a)
    where f(s,a) = sqrt(N(s)) / (1 + N(s,a))

Problem: P(s,a) and f(s,a) are MULTIPLIED. If P(s,a) = 0 (peaked policy), the
whole exploration term is 0 regardless of how large f(s,a) grows as the parent
gets revisited. Measured on Grid: 51-63% of branching nodes have the top
action's prior > 0.999, i.e. the other actions' prior rounds to 0 -> their
exploration term is permanently gated shut.

Decoupled formula (this file):
    U(s,a) = Q_norm(s,a) + c1 * P(s,a) + c2 * f(s,a)
P and f are now SEPARATE additive terms. Even when P(s,a) = 0, the c2*f(s,a)
term still exists on its own and grows as the parent is revisited, so an
unvisited sibling can still become attractive purely through the visit-count
based bonus, independent of the (possibly zero) prior.

c1 controls how much weight the raw policy gets; c2 controls how much weight
pure visit-count-based exploration gets. Setting c2=0 with c1=c_puct times f...
NOTE these are not equivalent to a single c_puct: this is a genuinely
different formula, not a re-parameterization of the original. Suggested
starting point: c1 = c2 = c_puct (equal weight to prior-driven and
visit-count-driven exploration).
"""
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


class _ValueNormalizer:
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
        "value",
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


def _expand(node, tt, policy_model, q1_model, q2_model, goal, dead_end_value) -> Tuple[float, int]:
    logits, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True
    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0
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
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0
    return _leaf_value(node.state, goal, q1_model, q2_model), generated


def _select(node, c1, c2, value_norm, blocked=None):
    """
    Decoupled pUCT:  U = Q_norm + c1*P(a) + c2*f(a),  f(a) = sqrt(N(s))/(1+N(s,a))
    P and f are ADDED, not multiplied -- an unvisited sibling with P=0 still
    gets a nonzero, growing exploration term from c2*f(a) alone.
    """
    best_score = -float("inf")
    best_action = None
    best_child = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))

    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0  # FPU unchanged (0.0), isolating this fix
        f = sqrt_parent / (1 + n)
        u = c1 * node.prior[action] + c2 * f
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


def _simulate(root, tt, policy_model, q1_model, q2_model, goal, c1, c2, value_norm, dead_end_value):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c1, c2, value_norm, blocked=path_keys)
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
        value, generated = _expand(node, tt, policy_model, q1_model, q2_model, goal, dead_end_value)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state, root_key, policy_model, q1_model, q2_model, goal,
            max_simulations, max_time, c1, c2, dead_end_value, stop_on_first_solution):
    root = Node(root_state, root_key, goal.holds(root_state))
    tt = {root_key: root}
    value_norm = _ValueNormalizer()
    best_plan = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        goal_plan, generated = _simulate(root, tt, policy_model, q1_model, q2_model, goal,
                                         c1, c2, value_norm, dead_end_value)
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

    # lightweight depth/fanout summary (always on, cheap, no IQN dependency)
    from collections import deque
    depth = {root.state_key: 0}
    dq = deque([root])
    while dq:
        nd = dq.popleft()
        d = depth[nd.state_key]
        for ch in nd.children.values():
            if ch.state_key not in depth:
                depth[ch.state_key] = d + 1
                dq.append(ch)
    exp_nodes = [n for n in tt.values() if n.expanded and not n.is_dead_end and not n.is_goal and n.children]
    if exp_nodes:
        depths = [depth[n.state_key] for n in exp_nodes if n.state_key in depth]
        fanouts = [sum(1 for a in n.children if n.edge_N.get(a, 0) > 0) for n in exp_nodes]
        if depths:
            print(f"[DEPTH] expanded_internal_nodes={len(depths)} "
                  f"mean_depth={sum(depths)/len(depths):.2f} "
                  f"max_depth={max(depths)} "
                  f"mean_fanout={sum(fanouts)/len(fanouts):.2f}", flush=True)

    return best_plan, sims, total_generated


def _parse_arguments():
    parser = argparse.ArgumentParser(description="AlphaZero with DECOUPLED additive pUCT (no W1)")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path)
    parser.add_argument("--max_simulations", default=100000000, type=int)
    parser.add_argument("--max_time", default=None, type=float)
    parser.add_argument("--c1", default=1.5, type=float, help="Weight on the raw prior P(a). Suggested start: same as old c_puct.")
    parser.add_argument("--c2", default=1.5, type=float, help="Weight on the visit-count exploration term f(a)=sqrt(N(s))/(1+N(s,a)), independent of P(a).")
    parser.add_argument("--dead_end_value", default=-1000.0, type=float)
    parser.add_argument("--keep_searching", action="store_true")
    return parser.parse_args()


def _plan(problem, policy_model, q1_model, q2_model, args):
    with torch.no_grad():
        goal = problem.get_goal_condition()
        initial = problem.get_initial_state()
        if goal.holds(initial):
            return []
        plan, sims, generated = _search(
            initial, get_state_key(initial),
            policy_model, q1_model, q2_model, goal,
            args.max_simulations, args.max_time, args.c1, args.c2, args.dead_end_value,
            stop_on_first_solution=not args.keep_searching,
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

    print(f"[config] decoupled pUCT: c1={args.c1} c2={args.c2}", flush=True)
    solution = _plan(problem, policy_model, q1_model, q2_model, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())