"""
grid_w1_depth_diag.py

Runs W1-boosted AlphaZero on a Grid instance and logs per-simulation depth,
the W1 of each edge taken, and how many distinct children have been visited
at each node along the path. Purpose: understand whether the tunnel effect is
caused by the W1 boost holding one child's boosted_prior above siblings even
after many visits, or by Q_norm from the backup.

Usage (same models as alphaZero_w1.py, plus --w1_lambda):
  venv/bin/python grid_w1_depth_diag.py \
    --domain  example/grid_dataset/domain.pddl \
    --problem <failing_instance.pddl> \
    --policy_model models/grid_sac_policy.pth \
    --q1_model     models/grid_sac_q1.pth \
    --q2_model     models/grid_sac_q2.pth \
    --iqn_model    models/grid_iqn.pth \
    --w1_lambda    1.5 \
    --max_simulations 500

Add --verbose to print each simulation's full path.
"""
import argparse
import math
import time
from collections import defaultdict
from pathlib import Path

import torch
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl

from utils import create_device, get_state_key
from train_iqn import _load_model as _load_iqn_model


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model, readout_name):
        super().__init__()
        self.model = model
        self.readout_name = readout_name

    def forward(self, state_goals):
        input_list, actions_list = [], []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        values_list = self.model.forward(input_list).readout(self.readout_name)
        return list(zip(values_list, actions_list))


class QuantileOracle:
    def __init__(self, iqn_model, device, num_quantiles=99):
        self._model = iqn_model
        self._device = device
        self._taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)

    @torch.no_grad()
    def best_curve(self, state, goal):
        q_values, _ = self._model.forward(
            [(state, goal)], taus=self._taus.expand(1, self._taus.shape[1]))[0]
        if q_values.shape[0] == 0:
            return None
        qs, _ = torch.sort(q_values, dim=1)
        means = qs.mean(dim=1)
        best = int(means.argmax().item())
        return qs[best].detach()


def _edge_w1(c1, c2):
    if c1 is None or c2 is None:
        return None
    return torch.mean(torch.abs(c1 - c2)).item()


class _ValueNorm:
    def __init__(self):
        self._min = float("inf")
        self._max = -float("inf")

    def update(self, v):
        if v < self._min: self._min = v
        if v > self._max: self._max = v

    def normalize(self, v):
        if self._max > self._min:
            return (v - self._min) / (self._max - self._min)
        return v


class Node:
    __slots__ = ("state", "state_key", "is_goal", "expanded", "is_dead_end",
                 "children", "prior", "edge_N", "visit_count", "value", "curve")

    def __init__(self, state, key, is_goal):
        self.state = state
        self.state_key = key
        self.is_goal = is_goal
        self.expanded = False
        self.is_dead_end = False
        self.children = {}
        self.prior = {}
        self.edge_N = {}
        self.visit_count = 0
        self.value = -float("inf")
        self.curve = None

    def q(self, action):
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state, goal, q1, q2):
    v1, _ = q1.forward([(state, goal)])[0]
    v = torch.minimum(v1, q2.forward([(state, goal)])[0][0]) if q2 else v1
    return v.max().item()


def _expand(node, tt, policy, q1, q2, goal, dead_val, oracle, w1_active):
    logits, actions = policy.forward([(node.state, goal)])[0]
    node.expanded = True
    if len(actions) == 0:
        node.is_dead_end = True
        return dead_val, 0
    if w1_active and node.curve is None and not node.is_goal:
        node.curve = oracle.best_curve(node.state, goal)
    probs = torch.softmax(logits, dim=0)
    generated = 0
    for i, action in enumerate(actions):
        succ = action.apply(node.state)
        key = get_state_key(succ)
        child = tt.get(key)
        if child is None:
            child = Node(succ, key, goal.holds(succ))
            tt[key] = child
            generated += 1
            if w1_active and not child.is_goal:
                child.curve = oracle.best_curve(succ, goal)
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0
    return _leaf_value(node.state, goal, q1, q2), generated


def _select(node, c_puct, vnorm, blocked, w1_norm, w1_lambda):
    sqrt_n = math.sqrt(max(1, node.visit_count))
    # Compute boosted priors if w1 active
    boosted = None
    if w1_lambda != 0.0 and w1_norm is not None and node.curve is not None:
        nw = {}
        for a, ch in node.children.items():
            w = _edge_w1(node.curve, ch.curve)
            nw[a] = w1_norm.normalize(w) if w is not None else 0.0
        raw = {a: node.prior[a] * (1.0 + w1_lambda * nw[a]) for a in node.children}
        total = sum(raw.values())
        if total > 0:
            boosted = {a: v / total for a, v in raw.items()}

    best_score, best_action, best_child = -float("inf"), None, None
    for a, ch in node.children.items():
        if blocked and ch.state_key in blocked:
            continue
        n = node.edge_N[a]
        q_norm = vnorm.normalize(node.q(a)) if n > 0 else 0.0
        p = boosted[a] if boosted else node.prior[a]
        score = q_norm + c_puct * p * sqrt_n / (1 + n)
        if score > best_score:
            best_score, best_action, best_child = score, a, ch
    return best_action, best_child


def _backup(path_nodes, path_edges, leaf_val, vnorm):
    path_nodes[-1].value = max(path_nodes[-1].value, leaf_val)
    for node in reversed(path_nodes):
        if node.children:
            node.value = max(node.value, max(c.value for c in node.children.values()))
        node.visit_count += 1
    for node, a in path_edges:
        node.edge_N[a] += 1
        vnorm.update(node.q(a))


def _simulate(root, tt, policy, q1, q2, goal, c_puct, vnorm, dead_val,
              oracle, w1_norm, w1_lambda):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root
    w1_active = oracle is not None and w1_lambda != 0.0

    # Track edge W1 and node visit counts along the path
    path_w1 = []
    path_node_visits = [root.visit_count]
    path_visited_children = []  # how many distinct children visited at each node

    while node.expanded and not node.is_goal and not node.is_dead_end:
        visited_count = sum(1 for n in node.edge_N.values() if n > 0)
        path_visited_children.append(visited_count)

        action, child = _select(node, c_puct, vnorm, path_keys, w1_norm, w1_lambda)
        if action is None:
            val = _leaf_value(node.state, goal, q1, q2)
            _backup(path_nodes, path_edges, val, vnorm)
            return None, 0, len(path_nodes) - 1, path_w1, path_visited_children

        w1_val = _edge_w1(node.curve, child.curve) if (node.curve is not None and child.curve is not None) else None
        path_w1.append(w1_val)

        path_edges.append((node, action))
        node = child
        path_nodes.append(node)
        path_keys.add(node.state_key)
        path_node_visits.append(node.visit_count)

    goal_plan = None
    generated = 0

    if node.is_goal:
        value = 0.0
        goal_plan = [a for _, a in path_edges]
    elif node.is_dead_end:
        value = dead_val
    else:
        value, generated = _expand(node, tt, policy, q1, q2, goal, dead_val, oracle, w1_active)
        if w1_active and node.curve is not None:
            for ch in node.children.values():
                w1 = _edge_w1(node.curve, ch.curve)
                if w1 is not None:
                    w1_norm.update(w1)
        for a, ch in node.children.items():
            if ch.is_goal:
                goal_plan = [a for _, a in path_edges] + [a]
                break

    _backup(path_nodes, path_edges, value, vnorm)
    return goal_plan, generated, len(path_nodes) - 1, path_w1, path_visited_children


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--domain", required=True, type=Path)
    p.add_argument("--problem", required=True, type=Path)
    p.add_argument("--policy_model", required=True, type=Path)
    p.add_argument("--q1_model", required=True, type=Path)
    p.add_argument("--q2_model", default=None, type=Path)
    p.add_argument("--iqn_model", required=True, type=Path)
    p.add_argument("--w1_lambda", default=1.5, type=float)
    p.add_argument("--max_simulations", default=500, type=int)
    p.add_argument("--c_puct", default=1.5, type=float)
    p.add_argument("--dead_end_value", default=-1000.0, type=float)
    p.add_argument("--verbose", action="store_true",
                   help="Print W1 and visit counts along each simulation's path")
    args = p.parse_args()

    device = create_device(False)
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    goal = problem.get_goal_condition()
    initial = problem.get_initial_state()

    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    q1_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    policy = ModelWrapper(policy_raw, "policy")
    q1 = ModelWrapper(q1_raw, "q")
    q2 = None
    if args.q2_model:
        q2_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
        q2 = ModelWrapper(q2_raw, "q")
    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()
    oracle = QuantileOracle(iqn_raw, device)

    root = Node(initial, get_state_key(initial), goal.holds(initial))
    tt = {root.state_key: root}
    vnorm = _ValueNorm()
    w1_norm = _ValueNorm()
    root.curve = oracle.best_curve(initial, goal)

    depths = []
    branch_counts = defaultdict(int)  # depth -> number of sims that reached this depth
    multi_visited_depths = []         # depths where >1 child was already visited
    goal_found = False
    goal_sim = None

    print(f"Problem: {args.problem.name}", flush=True)
    print(f"w1_lambda={args.w1_lambda}  max_sims={args.max_simulations}  c_puct={args.c_puct}\n", flush=True)

    with torch.no_grad():
        for sim in range(1, args.max_simulations + 1):
            plan, generated, depth, path_w1, visited_children = _simulate(
                root, tt, policy, q1, q2, goal,
                args.c_puct, vnorm, args.dead_end_value, oracle, w1_norm, args.w1_lambda)

            depths.append(depth)
            for d in range(depth + 1):
                branch_counts[d] += 1

            # count how many nodes on this path already had >1 visited child
            multi = sum(1 for v in visited_children if v > 1)
            multi_visited_depths.append(multi)

            if plan is not None and not goal_found:
                goal_found = True
                goal_sim = sim
                print(f"[sim {sim}] GOAL FOUND, plan length={len(plan)}, depth={depth}", flush=True)

            if args.verbose:
                w1_strs = [f"{v:.3f}" if v is not None else "N/A" for v in path_w1]
                vc_strs = [str(v) for v in visited_children]
                print(f"  sim {sim:4d}: depth={depth:4d}  "
                      f"W1=[{', '.join(w1_strs[:8])}{'...' if len(w1_strs) > 8 else ''}]  "
                      f"visited_children=[{', '.join(vc_strs[:8])}{'...' if len(vc_strs) > 8 else ''}]",
                      flush=True)
            elif sim <= 30 or sim % 50 == 0:
                print(f"  sim {sim:4d}: depth={depth:4d}  "
                      f"unique_states={len(tt)}  multi_visited_nodes={multi}",
                      flush=True)

    print(f"\n{'='*65}", flush=True)
    print(f"SUMMARY over {args.max_simulations} simulations:", flush=True)
    print(f"  Goal found: {goal_found} (sim {goal_sim})", flush=True)
    print(f"  Unique states generated: {len(tt)}", flush=True)

    if depths:
        depths.sort()
        n = len(depths)
        print(f"\n  Simulation depth distribution:", flush=True)
        print(f"    min={depths[0]}  median={depths[n//2]}  max={depths[-1]}", flush=True)
        print(f"    mean={sum(depths)/n:.1f}", flush=True)
        # percentile breakdown
        buckets = [1, 5, 10, 20, 50, 100, 200, 500, 1000, 9999]
        prev = 0
        for b in buckets:
            count = sum(1 for d in depths if prev < d <= b)
            if count > 0:
                print(f"    depth {prev+1:4d}-{b:4d}: {count:5d} sims ({100*count/n:.1f}%)", flush=True)
            prev = b

    if multi_visited_depths:
        print(f"\n  Nodes with >1 visited child on the path (per sim):", flush=True)
        print(f"    mean={sum(multi_visited_depths)/len(multi_visited_depths):.1f}  "
              f"max={max(multi_visited_depths)}", flush=True)
        zero = sum(1 for v in multi_visited_depths if v == 0)
        print(f"    {zero}/{len(multi_visited_depths)} sims had ZERO nodes with branching "
              f"(pure tunnel, no branching at all)", flush=True)

    print(f"\n  Root node stats at end:", flush=True)
    print(f"    visit_count={root.visit_count}", flush=True)
    if root.children:
        visited_root = sum(1 for n in root.edge_N.values() if n > 0)
        print(f"    children tried at root: {visited_root} / {len(root.children)}", flush=True)
        rows = sorted(root.children.items(),
                      key=lambda kv: root.prior[kv[0]], reverse=True)
        print(f"    Top-5 root actions by prior:", flush=True)
        for a, ch in rows[:5]:
            w1 = _edge_w1(root.curve, ch.curve)
            w1_str = f"{w1:.4f}" if w1 is not None else "N/A"
            print(f"      prior={root.prior[a]:.4f}  edge_N={root.edge_N[a]:4d}  "
                  f"W1={w1_str}  "
                  f"child_visits={ch.visit_count:4d}  {str(a)}", flush=True)


if __name__ == "__main__":
    main()
