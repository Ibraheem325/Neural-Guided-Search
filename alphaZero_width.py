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

# IQN uncertainty oracle: load via the IQN training module so the quantile heads
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


class UncertaintyOracle:
    """
    Pure add-on. Wraps the trained IQN model and returns a scalar WIDTH for a
    state = (sorted q90 - sorted q8) of the BEST action's quantile curve, using
    the exact same definition as the offline width-as-uncertainty validation.
    Does not touch the SAC policy/critics that drive the search.
    """
    # 99-point tau grid; indices 8 and 90 reproduce the validated q[90]-q[8] width.
    _LO = 8
    _HI = 90

    def __init__(self, iqn_model, device: torch.device, num_quantiles: int = 99) -> None:
        self._model = iqn_model
        self._device = device
        self._taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)

    @torch.no_grad()
    def width(self, state: mm.State, goal: mm.GroundConjunctiveCondition) -> Optional[float]:
        q_values, actions = self._model.forward([(state, goal)], taus=self._taus.expand(1, self._taus.shape[1]))[0]
        if q_values.shape[0] == 0:
            return None  # no applicable actions (dead end) -> no width signal
        qs, _ = torch.sort(q_values, dim=1)           # sort each action's quantile curve
        means = qs.mean(dim=1)
        best = int(means.argmax().item())             # best action by mean (matches validation)
        w = (qs[best, self._HI] - qs[best, self._LO]).item()
        return w


class _ValueNormalizer:
    """MuZero-style running min/max normalization into [0, 1]. Reused for widths."""

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
    # No parent pointer: in a DAG a node has many parents, and nothing needs it.
    __slots__ = (
        "state", "state_key", "is_goal",
        "expanded", "is_dead_end",
        "children", "prior", "edge_N", "edge_W", "visit_count",
        "value",
        "width",            # NEW: cached IQN uncertainty (None = unknown / not computed)
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
        self.value = -float("inf")   # no value seen yet
        self.visit_count = 0
        self.width = None            # NEW

    def q(self, action):
        # Q of an edge = the value the child node currently believes it can achieve.
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state: mm.State,
                goal: mm.GroundConjunctiveCondition,
                q1_model: ModelWrapper,
                q2_model: Optional[ModelWrapper]) -> float:
    """V(state) = max_a min(q1, q2). Bootstraps a leaf from the learned critic(s)."""
    q1_vals, _ = q1_model.forward([(state, goal)])[0]
    if q2_model is not None:
        q2_vals, _ = q2_model.forward([(state, goal)])[0]
        q_vals = torch.minimum(q1_vals, q2_vals)
    else:
        q_vals = q1_vals
    return q_vals.max().item()


def _expand(node: Node,
            tt: Dict[object, Node],
            policy_model: ModelWrapper,
            q1_model: ModelWrapper,
            q2_model: Optional[ModelWrapper],
            goal: mm.GroundConjunctiveCondition,
            dead_end_value: float,
            oracle: Optional[UncertaintyOracle],
            width_norm: Optional[_ValueNormalizer]) -> Tuple[float, int]:
    """
    Expand a non-goal leaf against the transposition table.
    Returns (value_to_backup, num_NEW_nodes_created).
    """
    logits, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True

    if len(actions) == 0:
        node.is_dead_end = True  # the only way a node is a dead end: no applicable actions
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
            # NEW: compute the child's uncertainty once, at creation, and register
            # it with the width normalizer. Only when a width mechanism is active
            # (width_norm is not None); goal children get no width.
            if width_norm is not None and not child.is_goal:
                w = oracle.width(successor, goal)
                child.width = w
                if w is not None:
                    width_norm.update(w)
        # else: reuse existing node -- the transposition share.
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0       # per-edge stats, fresh for THIS parent edge

    return _leaf_value(node.state, goal, q1_model, q2_model), generated


def _select(node: Node,
            c_puct: float,
            value_norm: _ValueNormalizer,
            blocked: Optional[set] = None,
            width_norm: Optional[_ValueNormalizer] = None,
            width_beta: float = 0.0,
            width_gamma: float = 0.0,
            width_tau: float = 0.0) -> Tuple[Optional[mm.GroundAction], Optional[Node]]:
    best_score = -float("inf")
    best_action: Optional[mm.GroundAction] = None
    best_child: Optional[Node] = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))
    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue  # cycle prevention: never re-enter a state on this descent
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0  # pessimistic FPU

        # Width signal for this child (normalized to [0,1] over widths seen so far).
        nw = None
        if width_norm is not None and child.width is not None:
            nw = width_norm.normalize(child.width)

        # (1) Multiplicative: width-modulated exploration constant.
        #     c_eff = c_puct * (1 + beta * (nw - 0.5)). beta=0 -> vanilla.
        #     NOTE: when the policy prior is peaked, scaling the exploration term
        #     rarely reorders the argmax (first-visit score is ~ c_eff*prior, and
        #     a strong prior dominates). Kept for comparison.
        c_eff = c_puct
        if width_beta != 0.0 and nw is not None:
            c_eff = c_puct * (1.0 + width_beta * (nw - 0.5))
            if c_eff < 0.0:
                c_eff = 0.0  # never let the exploration term flip sign
        u = c_eff * node.prior[action] * sqrt_parent / (1 + n)

        score = q_norm + u

        # (2) Additive uncertainty bonus: a separate term that does NOT pass
        #     through the prior, so it CAN reorder selection under a peaked
        #     policy. gamma=0 -> vanilla.
        #     Two forms via width_tau:
        #       tau <= 0 : linear bonus   score += gamma * nw   (pulls toward any
        #                  above-average width — tends to over-explore easy states).
        #       tau >  0 : THRESHOLDED    score += gamma  iff nw >= tau, else 0.
        #                  Matches the validated one-sided signal: fire ONLY at
        #                  genuinely high-width (top-regime) children, leaving
        #                  low/medium-width (easy) states at vanilla behavior.
        if width_gamma != 0.0 and nw is not None:
            if width_tau > 0.0:
                if nw >= width_tau:
                    score = score + width_gamma
            else:
                score = score + width_gamma * nw

        if score > best_score:
            best_score, best_action, best_child = score, action, child
    return best_action, best_child


def _backup(path_nodes, path_edges, leaf_value, value_norm):
    # Seed the leaf (last node on the path) with the value we just computed.
    path_nodes[-1].value = max(path_nodes[-1].value, leaf_value)
    # Walk the path bottom-up; each node's value = best over its children's values.
    for node in reversed(path_nodes):
        if node.children:
            best_child = max(c.value for c in node.children.values())
            node.value = max(node.value, best_child)
        node.visit_count += 1
    # Update the normalizer with the edge Q-values we now expose for selection.
    for node, action in path_edges:
        node.edge_N[action] += 1
        value_norm.update(node.q(action))


def _simulate(root: Node,
              tt: Dict[object, Node],
              policy_model: ModelWrapper,
              q1_model: ModelWrapper,
              q2_model: Optional[ModelWrapper],
              goal: mm.GroundConjunctiveCondition,
              c_puct: float,
              value_norm: _ValueNormalizer,
              dead_end_value: float,
              oracle: Optional[UncertaintyOracle],
              width_norm: Optional[_ValueNormalizer],
              width_beta: float,
              width_gamma: float,
              width_tau: float) -> Tuple[Optional[List[mm.GroundAction]], int]:
    path_keys = {root.state_key}              # states visited on THIS descent
    path_nodes: List[Node] = [root]
    path_edges: List[Tuple[Node, mm.GroundAction]] = []
    node = root

    # SELECT: descend by pUCT, never re-entering a state already on this path.
    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys,
                                 width_norm=width_norm, width_beta=width_beta,
                                 width_gamma=width_gamma, width_tau=width_tau)
        if action is None:
            # Every successor is already on this descent path: locally cyclic.
            value = _leaf_value(node.state, goal, q1_model, q2_model)
            _backup(path_nodes, path_edges, value, value_norm)
            return None, 0
        path_edges.append((node, action))
        node = child
        path_nodes.append(node)
        path_keys.add(node.state_key)

    goal_plan: Optional[List[mm.GroundAction]] = None
    generated = 0

    if node.is_goal:
        value = 0.0
        goal_plan = [a for _, a in path_edges]                 # traversed path IS a plan
    elif node.is_dead_end:
        value = dead_end_value
    else:
        value, generated = _expand(node, tt, policy_model, q1_model, q2_model, goal,
                                   dead_end_value, oracle, width_norm)
        for child_action, child in node.children.items():      # immediate goal among children
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    # BACKUP along the single traversed path (no special multi-parent handling).
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
            stop_on_first_solution: bool,
            oracle: Optional[UncertaintyOracle],
            width_beta: float,
            width_gamma: float,
            width_tau: float) -> Tuple[Optional[List[mm.GroundAction]], int, int]:
    root = Node(root_state, root_key, goal.holds(root_state))
    tt: Dict[object, Node] = {root_key: root}   # state_key -> Node (transposition table)
    value_norm = _ValueNormalizer()
    # Width normalizer is needed whenever EITHER width mechanism is active.
    _width_active = oracle is not None and (width_beta != 0.0 or width_gamma != 0.0)
    width_norm = _ValueNormalizer() if _width_active else None
    # Seed the root's width too (so it is consistent, though root width is not used in selection).
    if oracle is not None and not root.is_goal:
        rw = oracle.width(root_state, goal)
        root.width = rw
        if rw is not None and width_norm is not None:
            width_norm.update(rw)
    best_plan: Optional[List[mm.GroundAction]] = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        goal_plan, generated = _simulate(
            root, tt, policy_model, q1_model, q2_model, goal,
            c_puct, value_norm, dead_end_value,
            oracle, width_norm, width_beta, width_gamma, width_tau,
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


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="AlphaZero planner (transposition-table DAG)")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path,
                        help="Optional second critic; if given, leaf value uses min(q1,q2).")
    parser.add_argument("--max_simulations", default=100000000, type=int,
                        help="Total simulation budget for the whole search (NOT per move).")
    parser.add_argument("--max_time", default=None, type=float,
                        help="Optional wall-clock budget in seconds.")
    parser.add_argument("--c_puct", default=1.5, type=float,
                        help="Exploration constant. Q is min/max-normalized to [0,1] first.")
    parser.add_argument("--dead_end_value", default=-1000.0, type=float,
                        help="Value backed up for states with no applicable actions.")
    parser.add_argument("--keep_searching", action="store_true",
                        help="Do not stop at the first goal; keep searching for a shorter plan.")
    # NEW: IQN uncertainty oracle (width-based c_puct modulation).
    parser.add_argument("--iqn_model", default=None, type=Path,
                        help="Optional IQN model (.pth) used ONLY as an uncertainty oracle. "
                             "If omitted, search is exactly vanilla.")
    parser.add_argument("--width_beta", default=0.0, type=float,
                        help="Multiplicative width modulation of c_puct: "
                             "c_eff = c_puct*(1 + beta*(nw-0.5)). 0.0 = vanilla. "
                             "Weak under peaked policies (rarely reorders selection).")
    parser.add_argument("--width_gamma", default=0.0, type=float,
                        help="Additive uncertainty bonus on the selection score. "
                             "0.0 = vanilla. Bypasses the prior; CAN reorder selection.")
    parser.add_argument("--width_tau", default=0.0, type=float,
                        help="Threshold in [0,1] for the additive bonus. tau<=0: linear "
                             "bonus gamma*nw (pulls toward any above-average width). "
                             "tau>0: thresholded — add flat gamma only when normalized "
                             "width >= tau (fire ONLY at high-uncertainty children, the "
                             "validated one-sided regime; leaves easy states at vanilla).")
    return parser.parse_args()


def _plan(problem: mm.Problem,
          policy_model: ModelWrapper,
          q1_model: ModelWrapper,
          q2_model: Optional[ModelWrapper],
          oracle: Optional[UncertaintyOracle],
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
            oracle=oracle, width_beta=args.width_beta, width_gamma=args.width_gamma,
            width_tau=args.width_tau,
        )
        print(f"[Final] Expanded: {generated}, Generated: {generated}", flush=True)
        print(f"[search done] simulations={sims}, unique states generated={generated}", flush=True)

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

    # NEW: optional IQN uncertainty oracle. Loaded separately via the IQN module so
    # its quantile heads are restored. Pure add-on; does not affect priors/values.
    oracle = None
    if args.iqn_model is not None:
        iqn_model, _, _ = _load_iqn_model(domain, args.iqn_model, device)
        iqn_model.eval()
        oracle = UncertaintyOracle(iqn_model, device)
        print(f"[oracle] IQN uncertainty oracle loaded: {args.iqn_model} "
              f"(width_beta={args.width_beta}, width_gamma={args.width_gamma})", flush=True)
    elif args.width_beta != 0.0 or args.width_gamma != 0.0:
        raise RuntimeError("--width_beta/--width_gamma is set but no --iqn_model was given.")

    solution = _plan(problem, policy_model, q1_model, q2_model, oracle, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())