#!/usr/bin/env python3
"""
validate_width_hypothesis.py
============================================================================
Phase II — validating the assumption underlying IQN-guided AlphaZero.

HYPOTHESIS (Eisawy / Stahlberg):
    The WIDTH of an IQN's predicted value distribution at a state is a signal
    for the model's *own uncertainty / lack of expressivity* at that state.
      - narrow distribution  -> model is confident, value trustworthy
      - wide   distribution  -> model is uncertain / forced to collapse
                                distinguishable successors -> value NOT trustworthy
    Intended search use: spend search effort where width is high, save it
    where width is low (trigger exploration only when needed).

This script validates that assumption BEFORE any search integration, in three
steps, each producing a table you can put in the thesis:

  TEST 1 - Does width track model error at all?
           Spearman(width, |error|) should be clearly > 0.
  TEST 2 - Is width just a proxy for depth (distance-to-goal)?
           Report Spearman(width, depth) AND the partial correlation
           PARTIAL(width, error | depth). The partial is the real test:
           if it stays positive, width carries error info BEYOND depth.
  TEST 3 - "Forced collapse" mechanism (Stahlberg's exact case).
           A state is a forced-collapse case when two successors have
           near-equal PREDICTED mean but different TRUE cost (the model was
           forced to give them the same value). Hypothesis: such states are
           WIDER than non-collapse states AT THE SAME DEPTH. Reported as a
           within-depth-band table.

Usage:
    venv/bin/python validate_width_hypothesis.py \
        --domain example/grid_dataset/domain.pddl \
        --instances example/grid_dataset/train \
        --model models/grid_iqn.pth \
        [--seeds 42 43 44] [--max-instances 60] [--states-per-instance 40] \
        [--state-cap 200000]

Notes / caveats (documented for reproducibility):
  * Uses TRAINING instances by default: they expand quickly and are labeled.
    For Test 0 the question is whether the signal EXISTS in the model, which
    does not require large test states.
  * Rank (Spearman) statistics are used throughout so that any monotone /
    affine rescaling between the IQN readout and true steps-to-goal does not
    affect the result (readout is ~ -steps up to an affine map under -1/step
    reward).
  * Quantiles are SORTED before computing width: neural quantile functions are
    not guaranteed monotone (crossings are normal); sorting at read-time is the
    standard fix and does not change conclusions here.
  * Empty-goal instances and instances whose state space is flat
    (max_steps_to_goal < 2) or too large to expand under --state-cap are skipped.
============================================================================
"""

import argparse
import random
from pathlib import Path

import numpy as np
import torch
import pymimir as mm

from train_iqn import _load_model


# ----------------------------- config knobs --------------------------------

NEAR_MEAN_TOL = 0.5      # |mean_i - mean_j| <= this  => "near-equal predicted mean"
FORCED_TRUE_GAP = 2.0    # true-cost gap >= this among near-mean siblings => forced collapse
WIDTH_LO_Q, WIDTH_HI_Q = 8, 90   # quantile indices (on a 99-pt grid) for width = q[HI]-q[LO]
DEAD_END_COST = 1000.0
DEPTH_BANDS = [(1, 3), (4, 6), (7, 10), (11, 20), (21, 40)]


# ----------------------------- helpers -------------------------------------

def rank(x: np.ndarray) -> np.ndarray:
    return np.argsort(np.argsort(x)).astype(float)


def spearman(a: np.ndarray, b: np.ndarray) -> float:
    if len(a) < 3 or np.std(a) == 0 or np.std(b) == 0:
        return float('nan')
    return float(np.corrcoef(rank(a), rank(b))[0, 1])


def partial_spearman(a: np.ndarray, b: np.ndarray, c: np.ndarray) -> float:
    """Spearman correlation of a and b after linearly removing rank(c) from both."""
    if len(a) < 4:
        return float('nan')
    ra, rb, rc = rank(a), rank(b), rank(c)
    ra = ra - np.polyval(np.polyfit(rc, ra, 1), rc)
    rb = rb - np.polyval(np.polyfit(rc, rb, 1), rc)
    if np.std(ra) == 0 or np.std(rb) == 0:
        return float('nan')
    return float(np.corrcoef(ra, rb)[0, 1])


def collect_records(domain, model, instances, taus, *, seed,
                    max_instances, states_per_instance, state_cap):
    """Return per-state arrays: width, abs_error, depth, forced_gap."""
    random.seed(seed)
    files = sorted(f for f in Path(instances).glob('*.pddl') if f.name != 'domain.pddl')
    W, ERR, DEPTH, FORCED = [], [], [], []
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0:        # skip empty-goal (corrupt) instance
                continue
            ss = mm.StateSpaceSampler.new(p, state_cap)
            if ss is None or ss.max_steps_to_goal() < 2:  # skip un-expandable / flat
                continue
            ss.set_seed(seed)
            goal = p.get_goal_condition()
            used += 1
            states = ss.get_states()
            random.shuffle(states)
            taken = 0
            for s in states:
                if taken >= states_per_instance:
                    break
                ls = ss.get_state_label(s)
                if ls.is_goal:
                    continue
                if ls.is_dead_end:
                    continue
                actions = s.generate_applicable_actions()
                if len(actions) < 1:
                    continue
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                qs, _ = torch.sort(qv, dim=1)                 # sort: fix quantile crossings
                means = qs.mean(dim=1)
                widths = qs[:, WIDTH_HI_Q] - qs[:, WIDTH_LO_Q]
                best = int(means.argmax().item())             # higher readout = better (reward -1/step)
                W.append(widths[best].item())
                ERR.append(abs(means[best].item() - (-float(ls.steps_to_goal))))
                DEPTH.append(float(ls.steps_to_goal))
                # forced-collapse gap: largest true-cost gap among near-equal-mean siblings
                tv = []
                for a in actions:
                    l = ss.get_state_label(a.apply(s))
                    tv.append(DEAD_END_COST if (l is None or l.is_dead_end) else float(l.steps_to_goal))
                mn = means.detach().cpu().numpy()
                fr = 0.0
                for i in range(len(actions)):
                    for j in range(i + 1, len(actions)):
                        if abs(mn[i] - mn[j]) <= NEAR_MEAN_TOL:
                            fr = max(fr, abs(tv[i] - tv[j]))
                FORCED.append(fr)
                taken += 1
            if used >= max_instances:
                break
    return (np.array(W), np.array(ERR), np.array(DEPTH), np.array(FORCED), used)


def report(tag, W, ERR, DEPTH, FORCED, n_instances):
    print(f"\n================  {tag}  ================")
    print(f"instances used: {n_instances}   states: {len(W)}")

    print("\n-- TEST 1: does width track model error? --")
    print(f"   Spearman(width, error)        = {spearman(W, ERR):+.3f}   (hypothesis: > 0)")

    print("\n-- TEST 2: is width just a depth proxy? --")
    print(f"   Spearman(width, depth)        = {spearman(W, DEPTH):+.3f}   (width also tracks depth)")
    print(f"   PARTIAL(width, error | depth) = {partial_spearman(W, ERR, DEPTH):+.3f}   <-- REAL TEST (>0 => info beyond depth)")
    print(f"   PARTIAL(width, forced | depth)= {partial_spearman(W, FORCED, DEPTH):+.3f}   (fine calibration to collapse magnitude)")

    print("\n-- TEST 3: forced-collapse states wider at MATCHED depth? --")
    print(f"   (forced collapse = near-equal predicted mean but true-cost gap >= {FORCED_TRUE_GAP})")
    has = FORCED >= FORCED_TRUE_GAP
    none = FORCED == 0.0
    if has.sum():
        print(f"   overall: forced(n={int(has.sum())}) mean width={W[has].mean():.3f} | "
              f"normal(n={int(none.sum())}) mean width={W[none].mean():.3f}")
    print(f"   {'depth band':>12} | {'forced n':>8} {'width':>6} | {'normal n':>8} {'width':>6}")
    for lo, hi in DEPTH_BANDS:
        m = (DEPTH >= lo) & (DEPTH <= hi)
        fc = m & (FORCED >= FORCED_TRUE_GAP)
        nc = m & (FORCED == 0.0)
        if fc.sum() >= 5 and nc.sum() >= 5:
            print(f"   {f'{lo}-{hi}':>12} | {int(fc.sum()):>8} {W[fc].mean():>6.2f} | "
                  f"{int(nc.sum()):>8} {W[nc].mean():>6.2f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True)
    ap.add_argument('--instances', required=True, help='dir of labeled .pddl (use train split)')
    ap.add_argument('--model', required=True, help='IQN checkpoint')
    ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--max-instances', type=int, default=60)
    ap.add_argument('--states-per-instance', type=int, default=40)
    ap.add_argument('--state-cap', type=int, default=200_000)
    ap.add_argument('--num-quantiles', type=int, default=99)
    ap.add_argument('--cpu', action='store_true', default=True)
    args = ap.parse_args()

    device = torch.device('cpu' if args.cpu else 'cuda')
    domain = mm.Domain(args.domain)
    model, _policy, _extras = _load_model(domain, Path(args.model), device)
    model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=device).unsqueeze(0)

    print("=" * 76)
    print("WIDTH-AS-UNCERTAINTY VALIDATION")
    print(f"domain     : {args.domain}")
    print(f"instances  : {args.instances}")
    print(f"model      : {args.model}")
    print(f"seeds      : {args.seeds}")
    print(f"width def  : sorted q[{WIDTH_HI_Q}] - q[{WIDTH_LO_Q}] on {args.num_quantiles}-pt grid")
    print("=" * 76)

    # pooled across seeds (for the headline numbers) + per-seed (for stability)
    allW, allE, allD, allF = [], [], [], []
    for sd in args.seeds:
        W, E, D, F, n = collect_records(
            domain, model, args.instances, taus, seed=sd,
            max_instances=args.max_instances,
            states_per_instance=args.states_per_instance,
            state_cap=args.state_cap)
        report(f"SEED {sd}", W, E, D, F, n)
        allW.append(W); allE.append(E); allD.append(D); allF.append(F)

    if len(args.seeds) > 1:
        report("POOLED (all seeds)",
               np.concatenate(allW), np.concatenate(allE),
               np.concatenate(allD), np.concatenate(allF), -1)

    print("\nDone. Interpretation guide:")
    print("  TEST1 Spearman(width,error) > 0          -> width relates to error")
    print("  TEST2 PARTIAL(width,error|depth) > ~0.25 -> width carries error info beyond depth (KEY)")
    print("  TEST3 forced width > normal width in each band -> collapse regions are wider (mechanism)")
    print("  Low PARTIAL(width,forced|depth) is expected: width is a usable THRESHOLD flag,")
    print("  not a calibrated meter of collapse magnitude. Use width as a gate, not a linear weight.")


if __name__ == '__main__':
    main()