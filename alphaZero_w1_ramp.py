"""
AlphaZero (transposition-table DAG) with a VISIT-RAMPED ADDITIVE W1 prior floor.

Motivation (from the Grid/Goldminer W1 analyses):
  - Multiplicative boost  P'(a) = P(a)(1 + lambda*nW1(a))  cannot act where the
    policy is peaked: P(a)=0 gates the boost shut (0 * anything = 0). On Grid,
    ~90-98% of plan-path nodes are peaked, so the boost only ever acts on the
    few flat "key-choice" nodes.
  - Every variant that instead injects exploration unconditionally (decoupled
    additive c1*P + c2*f, prior mixing az_grid_mix_w1_a*, threshold gating
    az_grid_t*) destroyed coverage: the peaked policy is RIGHT most of the
    time, and easy instances get wrecked by permanent extra exploration.

This formula is exactly baseline pUCT until a node accumulates evidence of
being stuck (many visits without the search moving on), then gradually opens
alternatives, ordered by W1:

    P'(a) = ( P(a) + beta * min(1, N(s)/N0) * nW1(a) ) / Z(s)
    U(s,a) = Q_norm(s,a) + c_puct * P'(a) * sqrt(N(s)) / (1 + N(s,a))

  - N(s)=0 (fresh node)   -> P' = P, identical to baseline. Easy instances,
    which never hammer a single node N0 times, are untouched by construction.
  - N(s)>=N0 (stuck node) -> every action gets an additive floor proportional
    to its normalized edge-W1, so a P=0 sibling can be reached. This restores
    the UCT requirement that every action has nonzero effective prior, i.e.
    the exploration-term guarantee the standard formula loses at P(a)=0.
  - W1 only decides the ORDER in which alternatives open (its one demonstrated
    skill), not a permanent redistribution of the prior.

beta controls how much prior mass the alternatives can gain once ramped;
N0 controls how many parent visits count as "stuck".
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


class PolicyEnsemble:
    """Averages the softmax priors of M seed-diverse SAC policies; M=1 == single."""

    def __init__(self, policies):
        self.policies = policies

    @torch.no_grad()
    def forward(self, state_goals):
        out = []
        per_policy = [pol.forward(state_goals) for pol in self.policies]
        for i in range(len(state_goals)):
            actions = per_policy[0][i][1]
            acc = None
            for pp in per_policy:
                p = torch.softmax(pp[i][0], dim=0)
                acc = p.clone() if acc is None else acc + p
            out.append((acc / len(self.policies), actions))
        return out


class QuantileOracle:
    def __init__(self, iqn_model, device: torch.device, num_quantiles: int = 99) -> None:
        self._model = iqn_model
        self._device = device
        self._taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)

    @torch.no_grad()
    def best_curve(self, state: mm.State, goal: mm.GroundConjunctiveCondition) -> Optional[torch.Tensor]:
        q_values, _ = self._model.forward(
            [(state, goal)], taus=self._taus.expand(1, self._taus.shape[1]))[0]
        if q_values.shape[0] == 0:
            return None
        qs, _ = torch.sort(q_values, dim=1)
        means = qs.mean(dim=1)
        best = int(means.argmax().item())
        return qs[best].detach()


def _edge_w1(parent_curve, child_curve) -> Optional[float]:
    if parent_curve is None or child_curve is None:
        return None
    return torch.mean(torch.abs(parent_curve - child_curve)).item()


def _edge_signal(node, child, signal):
    """Per-edge guidance value: 'w1' = belief shift parent->child;
    'width' = belief spread q[90]-q[8] at the child state."""
    if signal == "width":
        if child.curve is None:
            return None
        return (child.curve[90] - child.curve[8]).item()
    return _edge_w1(node.curve, child.curve)


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
    probs, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True
    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0

    if w1_active and node.curve is None and not node.is_goal:
        node.curve = oracle.best_curve(node.state, goal)

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


def _register_edge_w1(node, w1_norm, signal="w1"):
    if w1_norm is None or node.curve is None:
        return
    for action, child in node.children.items():
        v = _edge_signal(node, child, signal)
        if v is not None:
            node.edge_W[action] = v
            w1_norm.update(v)


def _select(node, c_puct, value_norm, blocked=None,
            w1_norm=None, w1_beta=0.0, w1_n0=32, w1_lambda=0.0, w1_ramp_topk=0,
            w1_ramp_uniform=False, signal="w1"):
    """
    Combined multiplicative boost + visit-ramped additive W1 floor:
        ramp  = min(1, N(s)/N0)
        P'(a) = ( P(a) * (1 + lambda * nW1(a)) + beta * ramp * nW1(a) ) / Z
        U     = Q_norm + c_puct * P'(a) * sqrt(N(s)) / (1 + N(s,a))
    The multiplicative part acts immediately at flat decision nodes; the
    additive part opens P=0 siblings only after the node has been visited
    ~N0 times. beta=0 -> pure multiplicative; lambda=0 -> pure ramp;
    both 0 -> baseline.
    w1_ramp_topk > 0 restricts the ADDITIVE floor to the k children with the
    highest W1 (Goldminer regime: ~1.5 high-W1 siblings per node). This caps
    how many alternative branches per node the escape hatch can open, which
    is what blew up expansions when the floor applied to every sibling along
    a deep corridor.
    """
    boosted_prior = None
    if (w1_beta != 0.0 or w1_lambda != 0.0) and w1_norm is not None \
            and node.curve is not None:
        ramp = min(1.0, node.visit_count / float(w1_n0)) if w1_beta != 0.0 else 0.0
        nw_by_action = {}
        for action, child in node.children.items():
            v = node.edge_W.get(action)
            if v is None:
                v = _edge_signal(node, child, signal)
                if v is not None:
                    node.edge_W[action] = v
            nw_by_action[action] = w1_norm.normalize(v) if v is not None else 0.0
        floor_actions = set(nw_by_action)
        if w1_ramp_topk and w1_ramp_topk > 0 and len(nw_by_action) > w1_ramp_topk:
            floor_actions = set(sorted(nw_by_action, key=lambda a: nw_by_action[a],
                                       reverse=True)[:w1_ramp_topk])
        raw = {}
        total = 0.0
        for action in node.children:
            nw = nw_by_action[action]
            pb = node.prior[action] * (1.0 + w1_lambda * nw)
            if action in floor_actions:
                # uniform floor ignores the W1 ranking: every floored child
                # gets the same weight (control for "does W1's ordering help?")
                floor_w = 0.5 if w1_ramp_uniform else nw
                pb += w1_beta * ramp * floor_w
            raw[action] = pb
            total += pb
        if total > 0.0:
            boosted_prior = {a: v / total for a, v in raw.items()}

    best_score = -float("inf")
    best_action = None
    best_child = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))

    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0
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


def _simulate(root, tt, policy_model, q1_model, q2_model, goal,
              c_puct, value_norm, dead_end_value, oracle, w1_norm, w1_beta, w1_n0, w1_lambda, w1_ramp_topk, w1_ramp_uniform, signal):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root

    w1_active = oracle is not None and (w1_beta != 0.0 or w1_lambda != 0.0)

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys,
                                w1_norm=w1_norm, w1_beta=w1_beta, w1_n0=w1_n0, w1_lambda=w1_lambda,
                                w1_ramp_topk=w1_ramp_topk, w1_ramp_uniform=w1_ramp_uniform,
                                signal=signal)
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
        _register_edge_w1(node, w1_norm, signal)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state, root_key, policy_model, q1_model, q2_model, goal,
            max_simulations, max_time, c_puct, dead_end_value,
            stop_on_first_solution, oracle, w1_beta, w1_n0, w1_lambda, w1_ramp_topk, w1_ramp_uniform, signal):
    root = Node(root_state, root_key, goal.holds(root_state))
    tt = {root_key: root}
    value_norm = _ValueNormalizer()
    w1_active = oracle is not None and (w1_beta != 0.0 or w1_lambda != 0.0)
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
            c_puct, value_norm, dead_end_value, oracle, w1_norm, w1_beta, w1_n0, w1_lambda, w1_ramp_topk, w1_ramp_uniform, signal,
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
    parser = argparse.ArgumentParser(description="AlphaZero with visit-ramped additive W1 prior floor")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--policy_models", nargs="+", default=None, type=Path,
                        help="If given, average these seed-diverse policies' priors "
                             "(de-peaks mistake nodes so the W1 multiplicative boost can act).")
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path)
    parser.add_argument("--iqn_model", required=True, type=Path)
    parser.add_argument("--max_simulations", default=100000000, type=int)
    parser.add_argument("--max_time", default=None, type=float)
    parser.add_argument("--c_puct", default=1.5, type=float)
    parser.add_argument("--w1_beta", default=0.5, type=float,
                        help="Max additive prior mass an alternative can gain once the ramp saturates.")
    parser.add_argument("--w1_lambda", default=0.0, type=float,
                        help="Multiplicative boost strength (0 = off).")
    parser.add_argument("--w1_n0", default=32, type=int,
                        help="Parent visits at which the ramp saturates ('stuck' threshold).")
    parser.add_argument("--w1_ramp_topk", default=0, type=int,
                        help="Restrict the additive floor to the k highest-W1 children (0 = all).")
    parser.add_argument("--signal", choices=["w1", "width"], default="w1",
                        help="Per-edge guidance: w1 = parent->child belief shift; width = q90-q8 spread at child.")
    parser.add_argument("--w1_ramp_uniform", action="store_true",
                        help="Floor uses uniform weight instead of the W1 ranking (control).")
    parser.add_argument("--dead_end_value", default=-1000.0, type=float)
    parser.add_argument("--keep_searching", action="store_true")
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
            oracle=oracle, w1_beta=args.w1_beta, w1_n0=args.w1_n0, w1_lambda=args.w1_lambda,
            w1_ramp_topk=args.w1_ramp_topk, w1_ramp_uniform=args.w1_ramp_uniform,
            signal=args.signal,
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

    policy_paths = args.policy_models if args.policy_models else [args.policy_model]
    policies = [ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, pp, device)[0], "policy")
                for pp in policy_paths]
    policy_model = PolicyEnsemble(policies)
    print(f"[config] policy ensemble: {len(policies)} policies", flush=True)
    q1_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    q1_model = ModelWrapper(q1_raw, "q")

    q2_model = None
    if args.q2_model is not None:
        q2_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
        q2_model = ModelWrapper(q2_raw, "q")

    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()
    oracle = QuantileOracle(iqn_raw, device)
    print(f"[config] signal={args.signal} ramp boost: w1_beta={args.w1_beta} w1_n0={args.w1_n0} w1_lambda={args.w1_lambda} topk={args.w1_ramp_topk} uniform={args.w1_ramp_uniform} c_puct={args.c_puct}", flush=True)

    solution = _plan(problem, policy_model, q1_model, q2_model, oracle, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())
