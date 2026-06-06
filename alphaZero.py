"""
AlphaZero-style planner for deterministic, fully-observable classical planning.

Key differences from the previous per-step-MCTS version, and why:

1.  ONE PERSISTENT TREE rooted at the initial state.
    In a deterministic single-agent domain, applying an action "in simulation"
    and "for real" is the identical operation (action.apply(state)) with no
    opponent and no stochasticity. There is therefore no reason to re-root and
    discard the tree after every committed move (the old design). We grow a
    single tree and read the plan straight off the root->goal path.

    Consequence: the simulation count is no longer "simulations per move". It is
    now a GLOBAL search budget (--max_simulations / --max_time). The parameter
    does not disappear; it changes meaning.

2.  VALUE NORMALIZATION (MuZero-style running min/max).
    The SAC critics estimate -(discounted cost-to-go): negative, ~0 at the goal,
    higher == better. These values have magnitude in the tens/hundreds, so the
    raw pUCT exploration term (~c) is negligible against Q-differences and the
    prior is ignored. We normalize Q into [0,1] using the tree's running min/max
    before combining with the exploration term, exactly as MuZero does for
    unbounded value scales.

3.  CYCLE PREVENTION (the old `visited_states` was computed but never used).
    During expansion we skip any successor whose state already appears on the
    root->node path. This makes every tree path acyclic by construction, so the
    selection descent can never loop.

4.  Goal value 0.0 is kept (it is the maximum under the sign convention).
    Dead ends (no applicable non-cyclic successors) get a strongly negative,
    configurable value so search is pushed away from them.

5.  Clipped double-Q leaf evaluation: V(leaf) = max_a min(q1(leaf,a), q2(leaf,a)),
    matching the SAC target. q2 is optional.

6.  No redundant work: actions are generated once per expansion (taken from the
    policy forward's returned action list); the policy network is only evaluated
    when a leaf is actually expanded, never on goal/dead-end leaves.
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
    """MuZero-style running min/max normalization of Q-values into [0, 1]."""

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
        # Range not yet established: leave value as-is (it will be small early on).
        return value


class Node:
    __slots__ = (
        "state", "state_key", "is_goal", "parent",
        "expanded", "is_dead_end",
        "children", "prior", "edge_N", "edge_W", "visit_count",
    )

    def __init__(self, state: mm.State, state_key, is_goal: bool, parent: Optional["Node"]) -> None:
        self.state = state
        self.state_key = state_key
        self.is_goal = is_goal
        self.parent = parent
        self.expanded = False
        self.is_dead_end = False
        self.children: Dict[mm.GroundAction, "Node"] = {}
        self.prior: Dict[mm.GroundAction, float] = {}
        self.edge_N: Dict[mm.GroundAction, int] = {}
        self.edge_W: Dict[mm.GroundAction, float] = {}
        self.visit_count = 0

    def q(self, action: mm.GroundAction) -> float:
        n = self.edge_N[action]
        return self.edge_W[action] / n if n > 0 else 0.0


def _ancestor_keys(node: Node) -> set:
    keys = set()
    n: Optional[Node] = node
    while n is not None:
        keys.add(n.state_key)
        n = n.parent
    return keys


def _leaf_value(state: mm.State,
                goal: mm.GroundConjunctiveCondition,
                q1_model: ModelWrapper,
                q2_model: Optional[ModelWrapper]) -> float:
    """V(state) = max_a min(q1, q2). Bootstraps the leaf from the learned critic(s)."""
    q1_vals, _ = q1_model.forward([(state, goal)])[0]
    if q2_model is not None:
        q2_vals, _ = q2_model.forward([(state, goal)])[0]
        q_vals = torch.minimum(q1_vals, q2_vals)
    else:
        q_vals = q1_vals
    return q_vals.max().item()


def _expand(node: Node,
            policy_model: ModelWrapper,
            q1_model: ModelWrapper,
            q2_model: Optional[ModelWrapper],
            goal: mm.GroundConjunctiveCondition,
            dead_end_value: float) -> Tuple[float, int]:
    """Expand a non-goal leaf. Returns (value_to_backup, num_children_created)."""
    logits, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True

    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0

    probs = torch.softmax(logits, dim=0)
    ancestors = _ancestor_keys(node)
    for i, action in enumerate(actions):
        successor = action.apply(node.state)
        successor_key = get_state_key(successor)
        if successor_key in ancestors:
            continue  # cycle prevention: never link to a state on the path to here
        child = Node(successor, successor_key, goal.holds(successor), node)
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0
        node.edge_W[action] = 0.0

    if len(node.children) == 0:
        node.is_dead_end = True  # all successors were cyclic
        return dead_end_value, 0

    return _leaf_value(node.state, goal, q1_model, q2_model), len(node.children)


def _select(node: Node, c_puct: float, value_norm: _ValueNormalizer) -> Tuple[Optional[mm.GroundAction], Optional[Node]]:
    best_score = -float("inf")  # was -1 in the old code: a real bug for negative Q
    best_action: Optional[mm.GroundAction] = None
    best_child: Optional[Node] = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))
    for action, child in node.children.items():
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0  # pessimistic FPU
        u = c_puct * node.prior[action] * sqrt_parent / (1 + n)
        score = q_norm + u
        if score > best_score:
            best_score, best_action, best_child = score, action, child
    return best_action, best_child


def _backup(path_nodes: List[Node],
            path_edges: List[Tuple[Node, mm.GroundAction]],
            value: float,
            value_norm: _ValueNormalizer) -> None:
    for node in path_nodes:
        node.visit_count += 1
    for node, action in path_edges:
        node.edge_N[action] += 1
        node.edge_W[action] += value
        value_norm.update(node.q(action))


def _simulate(root: Node,
              policy_model: ModelWrapper,
              q1_model: ModelWrapper,
              q2_model: Optional[ModelWrapper],
              goal: mm.GroundConjunctiveCondition,
              c_puct: float,
              value_norm: _ValueNormalizer,
              dead_end_value: float) -> Tuple[Optional[List[mm.GroundAction]], int]:
    """One select->expand->evaluate->backup pass. Returns (goal_plan_or_None, children_created)."""
    path_nodes: List[Node] = [root]
    path_edges: List[Tuple[Node, mm.GroundAction]] = []
    node = root

    # SELECT: descend by pUCT to a leaf / goal / dead end.
    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm)
        if action is None or child is None:
            break
        path_edges.append((node, action))
        node = child
        path_nodes.append(node)

    goal_plan: Optional[List[mm.GroundAction]] = None
    generated = 0

    if node.is_goal:
        # Reached a goal node: the path to it IS a plan.
        value = 0.0
        goal_plan = [a for _, a in path_edges]
    elif node.is_dead_end:
        value = dead_end_value
    else:
        # EXPAND + EVALUATE the leaf.
        value, generated = _expand(node, policy_model, q1_model, q2_model, goal, dead_end_value)
        # Detect a goal among the freshly created children immediately.
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    # BACKUP along the traversed path.
    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state: mm.State,
            root_key,
            policy_model: ModelWrapper,
            q1_model: ModelWrapper,
            q2_model: Optional[ModelWrapper],
            goal: mm.GroundConjunctiveCondition,
            max_simulations: int,
            max_time: Optional[float],
            c_puct: float,
            dead_end_value: float,
            stop_on_first_solution: bool) -> Tuple[Optional[List[mm.GroundAction]], int, int]:
    root = Node(root_state, root_key, goal.holds(root_state), parent=None)
    value_norm = _ValueNormalizer()
    best_plan: Optional[List[mm.GroundAction]] = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        goal_plan, generated = _simulate(
            root, policy_model, q1_model, q2_model, goal, c_puct, value_norm, dead_end_value
        )
        total_generated += generated
        sims += 1

        if goal_plan is not None and (best_plan is None or len(goal_plan) < len(best_plan)):
            best_plan = goal_plan
            print(f"  [sim {sims}] found goal path of length {len(best_plan)}", flush=True)
            if stop_on_first_solution:
                break

        if sims % 500 == 0:
            print(f"  [sim {sims}] root visits={root.visit_count}, generated={total_generated}", flush=True)

    return best_plan, sims, total_generated


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="AlphaZero planner (single persistent tree)")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path,
                        help="Optional second critic; if given, leaf value uses min(q1,q2) per SAC.")
    # NOTE: this replaces the old per-step --n_simulations. It is now a GLOBAL budget.
    parser.add_argument("--max_simulations", default=20000, type=int,
                        help="Total simulation budget for the whole search (NOT per move).")
    parser.add_argument("--max_time", default=None, type=float,
                        help="Optional wall-clock budget in seconds.")
    parser.add_argument("--c_puct", default=1.5, type=float,
                        help="Exploration constant. Q is min/max-normalized to [0,1] first.")
    parser.add_argument("--dead_end_value", default=-1000.0, type=float,
                        help="Value backed up for states with no non-cyclic successors.")
    parser.add_argument("--keep_searching", action="store_true",
                        help="Do not stop at the first goal; keep searching for a shorter plan "
                             "until the budget is exhausted.")
    return parser.parse_args()


def _plan(problem: mm.Problem,
          policy_model: ModelWrapper,
          q1_model: ModelWrapper,
          q2_model: Optional[ModelWrapper],
          args: argparse.Namespace) -> Optional[List[mm.GroundAction]]:
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
        )
        print(f"[search done] simulations={sims}, states generated={generated}", flush=True)

        if plan is None:
            return None

        # Verify the extracted plan actually reaches the goal.
        state = initial
        for action in plan:
            state = action.apply(state)
        assert goal.holds(state), "Extracted plan does not reach the goal!"
        return plan


def _main(args: argparse.Namespace) -> None:
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

    solution = _plan(problem, policy_model, q1_model, q2_model, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())