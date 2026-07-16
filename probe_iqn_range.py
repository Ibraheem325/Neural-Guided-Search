"""
Measure an IQN checkpoint's VALUE RANGE and calibration vs true distance.

THE QUESTION. On the grid test instances the shipped IQN saturates: it reports
~-9.5 whether the goal is 20 steps away or 780. The SAC critic -- identical
architecture (12 layers, emb 32, smax) and identical training instances, but its
loss has NO target clamp -- still responds out to ~-65. The IQN loss clamps every
solution-transition target to [observed_return, -1] (use_bounds=True). That clamp
is a CORRECT bound, but with short training trajectories it pins every target
into a short range. This probe tests whether the clamp is what caps the range.

WHAT TO LOOK FOR (this is a RANGE test, not an accuracy test -- a short,
non-converged run is fine):
  * shipped IQN  -> max |V| ~ 9-12   (saturated)
  * if --no_use_bounds extends the range past ~-15/-20, the clamp is implicated
    and a full retrain is justified.
  * if it stays pinned near -10, the clamp is exonerated -> the cause is the
    training distance range (hindsight subgoals + small instances), a much
    bigger redesign.

Two modes:
  --instances DIR   : small pool; uses mm.StateSpaceSampler for EXACT true
                      distance, so it also reports calibration (V vs -d).
  --test_dir DIR    : big instances; no oracle, so it reports the value RANGE
                      only (max |V| over states reached by a policy walk).

Usage:
  venv/bin/python probe_iqn_range.py --domain example/grid_dataset/domain.pddl \
      --iqn_model models/grid_iqn.pth \
      --instances "$D/Domains2/grid/instances" --max_instances 40
"""
import argparse
import random
import statistics
from pathlib import Path

import torch
import pymimir as mm

from utils import create_device
from train_iqn import _load_model as _load_iqn_model
from bellman_epsilon_label import iqn_curves


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain", required=True, type=Path)
    ap.add_argument("--iqn_model", required=True, type=Path)
    ap.add_argument("--instances", type=Path, default=None,
                    help="Small pool -> exact distance via StateSpaceSampler (calibration).")
    ap.add_argument("--test_dir", type=Path, default=None,
                    help="Big instances -> value RANGE only (no oracle).")
    ap.add_argument("--max_instances", default=40, type=int)
    ap.add_argument("--max_states", default=200_000, type=int)
    ap.add_argument("--walk", default=300, type=int, help="policy-walk length for --test_dir")
    ap.add_argument("--seed", default=0, type=int)
    args = ap.parse_args()

    rng = random.Random(args.seed)
    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.domain))
    iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn.eval()
    print(f"model: {args.iqn_model}")

    vals = []
    if args.instances is not None:
        rows = []
        cands = sorted(p for p in args.instances.glob("*.pddl") if "domain" not in p.name)
        rng.shuffle(cands)
        used = 0
        with torch.no_grad():
            for f in cands:
                if used >= args.max_instances:
                    break
                p = mm.Problem(domain, str(f))
                ss = mm.StateSpaceSampler.new(p, args.max_states)
                if ss is None or ss.max_steps_to_goal() < 3:
                    continue
                ss.set_seed(args.seed)
                goal = p.get_goal_condition()
                for d in range(1, ss.max_steps_to_goal() + 1):
                    try:
                        sts = list(ss.sample_states_n_steps_from_goal(d, 2))
                    except Exception:
                        continue
                    for s in sts:
                        lab = ss.get_state_label(s)
                        if lab.is_goal or lab.is_dead_end:
                            continue
                        qs, _ = iqn_curves(iqn, s, goal, taus)
                        if qs is None:
                            continue
                        v = qs.mean(dim=1).max().item()
                        rows.append((lab.steps_to_goal, v))
                        vals.append(v)
                used += 1
        print(f"\nCALIBRATION on the small pool ({used} instances, exact distance):")
        print(f"{'true dist':>10} | {'V_IQN':>8} |  n")
        for d in range(1, 21):
            g = [r[1] for r in rows if r[0] == d]
            if len(g) < 2:
                continue
            print(f"{d:>10} | {statistics.mean(g):>8.2f} | {len(g):>2}")

    if args.test_dir is not None:
        cands = sorted(p for p in args.test_dir.glob("*.pddl") if "domain" not in p.name)
        rng.shuffle(cands)
        with torch.no_grad():
            for f in cands[:args.max_instances]:
                p = mm.Problem(domain, str(f))
                goal = p.get_goal_condition()
                s = p.get_initial_state()
                seen = set()
                for _ in range(args.walk):
                    if goal.holds(s):
                        break
                    qs, acts = iqn_curves(iqn, s, goal, taus)
                    if qs is None or not acts:
                        break
                    means = qs.mean(dim=1)
                    vals.append(means.max().item())
                    nxt = acts[int(means.argmax())].apply(s)
                    k = str(nxt)
                    if k in seen:
                        break
                    seen.add(k)
                    s = nxt
        print(f"\nVALUE RANGE on big test instances (IQN-greedy walk, no oracle):")

    if vals:
        vals.sort()
        q = lambda f: vals[min(len(vals) - 1, int(f * len(vals)))]
        print(f"\n*** VALUE RANGE over {len(vals)} states ***")
        print(f"   most negative V : {vals[0]:.2f}   <-- THE NUMBER THAT MATTERS")
        print(f"   p01 {q(.01):.2f}   p10 {q(.10):.2f}   median {q(.50):.2f}   max {vals[-1]:.2f}")
        print(f"\n   shipped grid_iqn saturates at ~ -9.5 (max |V| ~ 12).")
        print(f"   If --no_use_bounds pushes 'most negative V' well past -15, the clamp is implicated.")


if __name__ == "__main__":
    main()
