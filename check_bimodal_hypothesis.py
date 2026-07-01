"""
Numerically test the supervisor's hypothesis at co-located conflicting-key states:

  "picking one key at random either unlocks a door immediately (high reward) or
   doesn't (low reward), so the IQN distribution should be wide there."

For each train instance containing a co-located-key conflict (>=2 distinct-shape
locks AND a location holding keys of >=2 shapes), this script:

  1. Finds the conflict location and the two (or more) candidate keys there.
  2. Uses the fully-expanded state space (train instances only) to get the TRUE
     cost-to-go after picking up each candidate key -- this tells us whether the
     outcomes genuinely differ (part 1 of the hypothesis).
  3. Queries the IQN oracle's quantile curve for the state right after each pickup,
     and reports width (q90-q10) and the state-level width AT the pickup decision
     itself -- this tells us whether the model's distribution reflects that
     variance (part 2 of the hypothesis).

Usage:
  venv/bin/python check_bimodal_hypothesis.py \
    --domain example/grid_dataset/domain.pddl \
    --instances example/grid_dataset/train/008_....pddl example/grid_dataset/train/....pddl \
    --iqn_model models/grid_iqn.pth
"""
import argparse
import re
from pathlib import Path

import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from utils import create_device, get_state_key
from train_iqn import _load_model as _load_iqn_model


def find_conflict_location(pddl_text: str):
    """Return (location, [key_names]) for the first location holding keys of
    >=2 distinct shapes, or None if no such location exists."""
    key_shape = dict(re.findall(r'\(key-shape (\S+) (\S+)\)', pddl_text))
    at = re.findall(r'\(at (\S+) (\S+)\)', pddl_text)
    loc_keys = {}
    for k, loc in at:
        if k in key_shape:
            loc_keys.setdefault(loc, []).append(k)
    for loc, keys in loc_keys.items():
        shapes = {key_shape[k] for k in keys}
        if len(shapes) >= 2:
            # keep one representative key per shape at this location
            reps = {}
            for k in keys:
                reps.setdefault(key_shape[k], k)
            return loc, list(reps.values())
    return None


def true_cost_after_pickup(sampler, problem, state, key_name: str):
    """Apply the pickup action for key_name (found among applicable actions) and
    return the TRUE steps_to_goal of the resulting state (inf if dead end)."""
    for action in state.generate_applicable_actions():
        if 'pickup' in str(action) and key_name in str(action):
            succ = action.apply(state)
            label = sampler.get_state_label(succ)
            return (float('inf') if label.is_dead_end else float(label.steps_to_goal)), succ
    return None, None


@torch.no_grad()
def iqn_width(model, state, goal, device, num_quantiles=99):
    """Best-action sorted quantile curve width (q90-q10), None if no actions."""
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
    args = ap.parse_args()

    device = create_device(False)
    domain = mm.Domain(str(args.domain))
    iqn_model, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_model.eval()

    print(f"{'instance':45s} {'true_cost_diff':>15s} {'width_at_decision':>18s} {'width_key_A':>12s} {'width_key_B':>12s} verdict")
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
        # Find a state where the robot is at `loc` (pre-pickup decision point).
        # Use the initial state's problem; walk states via sampler isn't direct,
        # so instead: start from init, if robot isn't at loc we can't test this
        # instance's INITIAL decision cleanly -- restrict to instances where the
        # decision is reachable from init in a way get_state_label covers (it
        # covers the whole space, so this is fine as long as we can construct a
        # state at loc). For a robust generic check we instead evaluate the
        # width of the "pickup key_a" vs "pickup key_b" post-states starting
        # from the state where BOTH keys are present at loc AND robot is there --
        # here we take the raw initial state's own reachable state with matching
        # robot location by BFS-search via applicable actions is complex; instead
        # we directly test the state where both `at key_a loc` and `at key_b loc`
        # hold using get_state_label's underlying representation.
        # Simplification: use the INITIAL state's applicable-action pickups if the
        # robot already starts at loc; otherwise report "not directly reachable".
        init = problem.get_initial_state()
        robot_at = re.search(r'\(at-robot (\S+)\)', text)
        if robot_at is None or robot_at.group(1) != loc:
            print(f"{inst_path.name:45s}  (robot doesn't start at conflict loc, needs pathing -- skip for now)")
            continue

        cost_a, succ_a = true_cost_after_pickup(sampler, problem, init, key_a)
        cost_b, succ_b = true_cost_after_pickup(sampler, problem, init, key_b)
        if cost_a is None or cost_b is None:
            print(f"{inst_path.name:45s}  (pickup action not found, skip)")
            continue

        diff = abs(cost_a - cost_b) if cost_a != float('inf') and cost_b != float('inf') else float('inf')
        w_decision = iqn_width(iqn_model, init, goal, device)
        w_a = iqn_width(iqn_model, succ_a, goal, device)
        w_b = iqn_width(iqn_model, succ_b, goal, device)

        # Verdict: does true cost differ meaningfully (part 1) and does width
        # reflect it (part 2)?
        true_differs = diff > 2.0  # more than a couple steps apart
        model_wide = (w_decision or 0) > 1.5  # same 1.5 threshold used elsewhere in this project
        if true_differs and model_wide:
            verdict = "SUPPORTS hypothesis"
        elif true_differs and not model_wide:
            verdict = "outcomes differ, but model NOT wide -> narrow-confident-wrong"
        elif not true_differs:
            verdict = "outcomes DON'T differ much -> hypothesis mechanism absent here"
        print(f"{inst_path.name:45s} {diff:15.1f} {w_decision if w_decision else -1:18.2f} "
              f"{w_a if w_a else -1:12.2f} {w_b if w_b else -1:12.2f} {verdict}")


if __name__ == '__main__':
    main()