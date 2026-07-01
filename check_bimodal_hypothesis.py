"""
Extended version of check_bimodal_hypothesis.py: instead of requiring the robot
to START at the co-located-key conflict location, this BFS-walks the fully
expanded state space from the initial state to find ANY reachable state where
the robot is at the conflict location with both candidate keys still present
there (not yet picked up, doors not yet unlocked by another route). From that
state, it tests both pickups exactly as before.

This uses the same StateSpaceSampler expansion (train instances only, small
enough), and needs a way to enumerate/search states -- StateSpaceSampler does
not directly expose a state graph BFS API, so we do our own BFS using
state.generate_applicable_actions() / action.apply(), bounded by a node cap,
independent of the sampler (the sampler is only used afterward for get_state_label
ground truth on specific states we reach).

Usage: identical to check_bimodal_hypothesis.py
"""
import argparse
import re
from collections import deque
from pathlib import Path

import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from utils import create_device, get_state_key
from train_iqn import _load_model as _load_iqn_model


def find_conflict_location(pddl_text: str):
    key_shape = dict(re.findall(r'\(key-shape (\S+) (\S+)\)', pddl_text))
    at = re.findall(r'\(at (\S+) (\S+)\)', pddl_text)
    loc_keys = {}
    for k, loc in at:
        if k in key_shape:
            loc_keys.setdefault(loc, []).append(k)
    for loc, keys in loc_keys.items():
        shapes = {key_shape[k] for k in keys}
        if len(shapes) >= 2:
            reps = {}
            for k in keys:
                reps.setdefault(key_shape[k], k)
            return loc, list(reps.values())
    return None


def bfs_to_conflict_state(problem, conflict_loc: str, key_a: str, key_b: str, node_cap: int = 200_000):
    """BFS from the initial state until we find a state where the robot is at
    conflict_loc AND both key_a and key_b are still 'at' locations (unpicked)."""
    init = problem.get_initial_state()
    seen = {get_state_key(init)}
    queue = deque([init])
    visited = 0
    while queue and visited < node_cap:
        state = queue.popleft()
        visited += 1
        state_str = str(state)
        # crude but robust: check robot location + both keys still placed (not held)
        if f'at-robot {conflict_loc}' in state_str.replace('(', '').replace(')', ' ') \
           or f'(at-robot {conflict_loc})' in state_str:
            if key_a in state_str and key_b in state_str:
                return state
        for action in state.generate_applicable_actions():
            succ = action.apply(state)
            key = get_state_key(succ)
            if key not in seen:
                seen.add(key)
                queue.append(succ)
    return None


def true_cost_after_pickup(sampler, state, key_name: str):
    for action in state.generate_applicable_actions():
        if 'pickup' in str(action) and key_name in str(action):
            succ = action.apply(state)
            label = sampler.get_state_label(succ)
            return (float('inf') if label.is_dead_end else float(label.steps_to_goal)), succ
    return None, None


@torch.no_grad()
def iqn_width(model, state, goal, device, num_quantiles=99):
    taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)
    q_values, actions = model.forward([(state, goal)], taus=taus)[0]
    if q_values.shape[0] == 0:
        return None
    qs, _ = torch.sort(q_values, dim=1)
    means = qs.mean(dim=1)
    best = int(means.argmax().item())
    curve = qs[best]
    n = curve.shape[0]
    lo, hi = int(0.10 * n), int(0.90 * n)
    return (curve[hi] - curve[lo]).item()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True, type=Path)
    ap.add_argument('--instances', required=True, type=Path, nargs='+')
    ap.add_argument('--iqn_model', required=True, type=Path)
    ap.add_argument('--node_cap', default=200_000, type=int)
    args = ap.parse_args()

    device = create_device(False)
    domain = mm.Domain(str(args.domain))
    iqn_model, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_model.eval()

    header = f"{'instance':45s} {'true_cost_diff':>15s} {'width_at_decision':>18s} {'width_key_A':>12s} {'width_key_B':>12s} verdict"
    print(header)
    for inst_path in args.instances:
        text = inst_path.read_text()
        conflict = find_conflict_location(text)
        if conflict is None:
            print(f"{inst_path.name:45s}  (no conflict found, skipping)")
            continue
        loc, keys = conflict
        if len(keys) < 2:
            continue
        key_a, key_b = keys[0], keys[1]

        problem = mm.Problem(domain, str(inst_path))
        sampler = mm.StateSpaceSampler.new(problem, 100_000)
        if sampler is None:
            print(f"{inst_path.name:45s}  (too large to fully expand, skipping)")
            continue

        goal = problem.get_goal_condition()
        decision_state = bfs_to_conflict_state(problem, loc, key_a, key_b, args.node_cap)
        if decision_state is None:
            print(f"{inst_path.name:45s}  (no reachable state with both keys at conflict loc, skip)")
            continue

        cost_a, succ_a = true_cost_after_pickup(sampler, decision_state, key_a)
        cost_b, succ_b = true_cost_after_pickup(sampler, decision_state, key_b)
        if cost_a is None or cost_b is None:
            print(f"{inst_path.name:45s}  (pickup action not found at reached state, skip)")
            continue

        diff = abs(cost_a - cost_b) if cost_a != float('inf') and cost_b != float('inf') else float('inf')
        w_decision = iqn_width(iqn_model, decision_state, goal, device)
        w_a = iqn_width(iqn_model, succ_a, goal, device)
        w_b = iqn_width(iqn_model, succ_b, goal, device)

        true_differs = diff > 2.0
        model_wide = (w_decision or 0) > 1.5
        if true_differs and model_wide:
            verdict = "SUPPORTS hypothesis"
        elif true_differs and not model_wide:
            verdict = "outcomes differ, model NOT wide -> narrow-confident-wrong"
        elif not true_differs:
            verdict = "outcomes DON'T differ much -> mechanism absent here"
        print(f"{inst_path.name:45s} {diff:15.1f} {w_decision if w_decision else -1:18.2f} "
              f"{w_a if w_a else -1:12.2f} {w_b if w_b else -1:12.2f} {verdict}")


if __name__ == '__main__':
    main()