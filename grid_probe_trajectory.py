#!/usr/bin/env python3
"""
grid_probe_trajectory.py
Supervisor's controlled experiment: all keys in one location.

Walk the agent along the forced approach path toward the key location, then
reach the state where multiple keys can be picked up. At each step print:
  - the best action chosen
  - the width (q90-q8) of the best-action distribution
  - the W1 shift from the previous step's best-action distribution
  - at the key-choice state: the width and mean of EACH competing pickup action

Prediction:
  (1) while walking up: low, flat width and small W1 shift (model is certain).
  (2) at the key location: width/shift jump, and the competing pickup actions
      have similar distributions (model can't tell which key matches the lock).

Usage:
  venv/bin/python grid_probe_trajectory.py \
      --domain example/grid_dataset/domain.pddl \
      --instance grid_probe_corridor.pddl \
      --model models/grid_iqn.pth
"""
import argparse
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def atoms_by_pred(state):
    d = {}
    for a in state.get_atoms():
        d.setdefault(a.get_predicate().get_name(), []).append([str(t) for t in a.get_terms()])
    return d


def describe(state):
    a = atoms_by_pred(state)
    robot = [r[0] for r in a.get('at-robot', [])]
    holding = [h[0] for h in a.get('holding', [])]
    rpos = robot[0] if robot else '?'
    held = holding[0] if holding else 'none'
    return f"robot@{rpos} holding={held}"


def act_str(a):
    return str(a)


def best_dist(model, state, goal, taus):
    """Return (best_index, actions, sorted-quantiles-per-action, means)."""
    acts = state.generate_applicable_actions()
    qv, _ = model.forward([(state, goal)], taus=taus.expand(1, taus.shape[1]))[0]
    qs, _ = torch.sort(qv, dim=1)
    means = qs.mean(dim=1)
    best = int(means.argmax().item())
    return best, acts, qs.cpu().numpy(), means.cpu().numpy()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True)
    ap.add_argument('--instance', required=True)
    ap.add_argument('--model', required=True)
    ap.add_argument('--num-quantiles', type=int, default=99)
    ap.add_argument('--max-steps', type=int, default=12)
    args = ap.parse_args()

    dev = torch.device('cpu')
    domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev)
    model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)

    problem = mm.Problem(domain, args.instance)
    goal = problem.get_goal_condition()
    # ground-truth state space (small instance) so we can show true distances too
    ss = mm.StateSpaceSampler.new(problem, 200000)
    state = problem.get_initial_state()

    print("="*78)
    print("CONTROLLED GRID PROBE — all keys at one cell")
    print(f"instance: {args.instance}")
    print("="*78)
    print(f"{'step':>4} {'state':<28} {'bestW':>6} {'W1_shift':>9}  best-action")
    prev_qbest = None
    with torch.no_grad():
        for step in range(args.max_steps):
            best, acts, qs, means = best_dist(model, state, goal, taus)
            if len(acts) == 0:
                print(f"{step:4d} {describe(state):<28}  (no applicable actions)")
                break
            qbest = qs[best]
            width = qbest[90] - qbest[8]
            w1 = 0.0 if prev_qbest is None else float(np.mean(np.abs(qbest - prev_qbest)))
            print(f"{step:4d} {describe(state):<28} {width:6.2f} {w1:9.3f}  {act_str(acts[best])[:40]}")

            # if this is a key-choice state (multiple pickup actions), expand them
            pickups = [(i, a) for i, a in enumerate(acts) if 'pickup' in act_str(a).lower()]
            if len(pickups) >= 2:
                print(f"      -- KEY-CHOICE STATE: {len(pickups)} pickup options --")
                for i, a in pickups:
                    w = qs[i][90] - qs[i][8]
                    print(f"         mean={means[i]:7.3f}  width={w:6.2f}  {act_str(a)[:46]}")
                # spread of means across pickups = how distinguishable they are
                pm = np.array([means[i] for i, _ in pickups])
                print(f"      mean spread across pickups = {pm.max()-pm.min():.3f} "
                      f"(small => model cannot tell the keys apart)")

            # step forward greedily
            prev_qbest = qbest
            state = acts[best].apply(state)
            if ss is not None:
                ls = ss.get_state_label(state)
                if ls is not None and ls.is_goal:
                    print(f"{step+1:4d} {describe(state):<28}  GOAL REACHED")
                    break

    print("\nInterpretation:")
    print("  approach steps: expect small bestW and small W1_shift (model certain).")
    print("  key-choice step: expect a jump in W1_shift/width, and a SMALL mean spread")
    print("  across the pickup options => the model cannot distinguish the matching key")
    print("  from the wrong ones (the localized expressivity failure, made visible).")


if __name__ == '__main__':
    main()