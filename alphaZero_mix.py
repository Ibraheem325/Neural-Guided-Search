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

    def forward(self, state_goals):
        input_list = []
        actions_list = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        values_list = self.model.forward(input_list).readout(self.readout_name)  # type: ignore
        return list(zip(values_list, actions_list))


class QuantileOracle:
    """IQN oracle. Returns the best-action sorted quantile curve for a state.
    width  = curve[HI] - curve[LO]      (per-state spread)
    W1(p->c) = mean|sorted(curve_p) - sorted(curve_c)|  (per-transition shift)
    Both derived from the same cached curve. Pure add-on; SAC policy/critics untouched.
    """
    _LO = 8
    _HI = 90

    def __init__(self, iqn_model, device, num_quantiles=99):
        self._model = iqn_model
        self._device = device
        self._taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)

    @torch.no_grad()
    def best_curve(self, state, goal):
        q_values, actions = self._model.forward(
            [(state, goal)], taus=self._taus.expand(1, self._taus.shape[1]))[0]
        if q_values.shape[0] == 0:
            return None
        qs, _ = torch.sort(q_values, dim=1)
        means = qs.mean(dim=1)
        best = int(means.argmax().item())
        return qs[best].detach()

    @staticmethod
    def width_of(curve):
        if curve is None:
            return None
        return (curve[QuantileOracle._HI] - curve[QuantileOracle._LO]).item()


def _edge_w1(parent_curve, child_curve):
    if parent_curve is None or child_curve is None:
        return None
    return torch.mean(torch.abs(parent_curve - child_curve)).item()


class Node:
    __slots__ = (
        "state", "state_key", "is_goal", "expanded", "is_dead_end",
        "children", "prior", "edge_N", "edge_W", "visit_count", "value",
        "curve", "width",
    )

    def __init__(self, state, state_key, is_goal):
        self.state = state
        self.state_key = state_key
        self.is_goal = is_goal
        self.expanded = False
        self.is_dead_end = False
        self.children = {}
        self.prior = {}
        self.edge_N = {}
        self.edge_W = {}
        self.value = -float("inf")
        self.visit_count = 0
        self.curve = None    # best-action quantile curve (for W1)
        self.width = None    # per-state width (for width metric)

    def q(self, action):
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state, goal, q1_model, q2_model):
    q1_vals, _ = q1_model.forward([(state, goal)])[0]
    if q2_model is not None:
        q2_vals, _ = q2_model.forward([(state, goal)])[0]
        q_vals = torch.minimum(q1_vals, q2_vals)
    else:
        q_vals = q1_vals
    return q_vals.max().item()


def _expand(node, tt, policy_model, q1_model, q2_model, goal, dead_end_value, oracle, active):
    logits, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True

    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0

    # parent curve/width cached for metric computation
    if active and node.curve is None and not node.is_goal:
        node.curve = oracle.best_curve(node.state, goal)
        node.width = QuantileOracle.width_of(node.curve)

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
            if active and not child.is_goal:
                child.curve = oracle.best_curve(successor, goal)
                child.width = QuantileOracle.width_of(child.curve)
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0

    return _leaf_value(node.state, goal, q1_model, q2_model), generated


def _select(node, c_puct, value_norm, blocked=None, metric=None, mix_alpha=0.0):
    best_score = -float("inf")
    best_action = None
    best_child = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))

    # Supervisor's additive mixture:
    #   P'(a) = (1-alpha) * P(a) + alpha * ( metric(a) / sum_b metric(b) )
    # metric(a) = width(child_a)          if metric == 'width'
    #           = W1(node -> child_a)     if metric == 'w1'
    # Unlike the multiplicative form, a policy-suppressed (low P) action can still
    # receive up to alpha * (its metric share) of prior mass -> it CAN win at a
    # peaked decision. alpha=0 -> vanilla. Stays a valid normalized distribution.
    mixed_prior = None
    if mix_alpha != 0.0 and metric is not None:
        raw = {}
        total = 0.0
        for action, child in node.children.items():
            if metric == 'width':
                m = child.width
            else:  # 'w1'
                m = _edge_w1(node.curve, child.curve)
            m = 0.0 if (m is None or m < 0.0) else m
            raw[action] = m
            total += m
        if total > 0.0:
            mixed_prior = {a: (1.0 - mix_alpha) * node.prior[a] + mix_alpha * (raw[a] / total)
                           for a in node.children}
        # if total == 0 (all metrics zero/None), fall back to raw prior (no mix)

    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0
        p_use = mixed_prior[action] if mixed_prior is not None else node.prior[action]
        u = c_puct * p_use * sqrt_parent / (1 + n)
        score = q_norm + u
        if score > best_score:
            best_score, best_action, best_child = score, action, child
    return best_action, best_child


class _ValueNormalizer:
    def __init__(self):
        self._min = float("inf"); self._max = -float("inf")
    def update(self, v):
        if v < self._min: self._min = v
        if v > self._max: self._max = v
    def normalize(self, v):
        if self._max > self._min:
            return (v - self._min) / (self._max - self._min)
        return v


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
              c_puct, value_norm, dead_end_value, oracle, metric, mix_alpha):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root
    active = oracle is not None and mix_alpha != 0.0

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys,
                                 metric=metric, mix_alpha=mix_alpha)
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
                                   dead_end_value, oracle, active)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state, root_key, policy_model, q1_model, q2_model, goal,
            max_simulations, max_time, c_puct, dead_end_value,
            stop_on_first_solution, oracle, metric, mix_alpha):
    root = Node(root_state, root_key, goal.holds(root_state))
    tt = {root_key: root}
    value_norm = _ValueNormalizer()
    active = oracle is not None and mix_alpha != 0.0
    if active and not root.is_goal:
        root.curve = oracle.best_curve(root_state, goal)
        root.width = QuantileOracle.width_of(root.curve)
    best_plan = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        goal_plan, generated = _simulate(
            root, tt, policy_model, q1_model, q2_model, goal,
            c_puct, value_norm, dead_end_value, oracle, metric, mix_alpha,
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
    p = argparse.ArgumentParser(description="AlphaZero + IQN additive-mixture prior")
    p.add_argument("--domain", required=True, type=Path)
    p.add_argument("--problem", required=True, type=Path)
    p.add_argument("--policy_model", required=True, type=Path)
    p.add_argument("--q1_model", required=True, type=Path)
    p.add_argument("--q2_model", default=None, type=Path)
    p.add_argument("--max_simulations", default=100000000, type=int)
    p.add_argument("--max_time", default=None, type=float)
    p.add_argument("--c_puct", default=1.5, type=float)
    p.add_argument("--dead_end_value", default=-1000.0, type=float)
    p.add_argument("--keep_searching", action="store_true")
    p.add_argument("--iqn_model", default=None, type=Path,
                   help="IQN model (.pth) used ONLY as the metric oracle.")
    p.add_argument("--metric", default="w1", choices=["width", "w1"],
                   help="Which IQN signal to mix into the prior.")
    p.add_argument("--mix_alpha", default=0.0, type=float,
                   help="Blend: P'(a)=(1-alpha)*P(a)+alpha*(metric(a)/sum metric). "
                        "0.0 = vanilla AlphaZero.")
    return p.parse_args()


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
            oracle=oracle, metric=args.metric, mix_alpha=args.mix_alpha,
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
        print(f"[oracle] IQN loaded: {args.iqn_model} "
              f"(metric={args.metric}, mix_alpha={args.mix_alpha})", flush=True)
    elif args.mix_alpha != 0.0:
        raise RuntimeError("--mix_alpha set but no --iqn_model given.")

    solution = _plan(problem, policy_model, q1_model, q2_model, oracle, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())