#!/usr/bin/env python3
"""
grid_bottleneck_discovery.py
============================================================================
LEVEL 2 — let the model's ERRORS reveal which structures are expressivity-hard,
instead of assuming it's the lock decision.

Method:
  * Sample labeled grid states (true cost-to-go known on training instances).
  * Compute model error |pred_mean - (-true_steps)| per state.
  * Extract simple STRUCTURAL descriptors from each state's PDDL atoms
    (holding a key? lock adjacent? held-key/lock shape match? counts of
    keys/locks/shapes/locked cells; arm empty; etc.).
  * Split states into HIGH-error (top quantile) vs the rest.
  * For each descriptor, report how over/under-represented it is in the
    high-error set vs baseline. Descriptors strongly over-represented among
    high-error states are the candidate expressivity bottlenecks -- DISCOVERED,
    not assumed.

If "holding wrong key near lock" dominates -> confirms the supervisor's call.
If something else also shows up -> a second hard structure we didn't label.

Usage:
  venv/bin/python grid_bottleneck_discovery.py \
      --domain example/grid_dataset/domain.pddl \
      --instances example/grid_dataset/train \
      --model models/grid_iqn.pth \
      [--seeds 42 43 44] [--high-quantile 0.9]
============================================================================
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def atoms_by_pred(state):
    d = {}
    for atom in state.get_atoms():
        name = atom.get_predicate().get_name()
        terms = [str(t) for t in atom.get_terms()]
        d.setdefault(name, []).append(terms)
    return d


def descriptors(state):
    """Boolean / small-int structural features, all read from PDDL atoms only."""
    a = atoms_by_pred(state)
    holding = a.get('holding', [])
    keyshape = {k[0]: k[1] for k in a.get('key-shape', [])}
    lockshape = {l[0]: l[1] for l in a.get('lock-shape', [])}
    locked = {l[0] for l in a.get('locked', [])}
    open_ = {o[0] for o in a.get('open', [])}
    robot = [r[0] for r in a.get('at-robot', [])]
    conn = a.get('conn', [])
    keys = {k[0] for k in a.get('key', [])}
    shapes = {s[0] for s in a.get('shape', [])}

    held = {h[0] for h in holding}
    rpos = robot[0] if robot else None
    adj = set()
    if rpos is not None:
        adj = {c[1] for c in conn if c[0] == rpos} | {c[0] for c in conn if c[1] == rpos}

    lock_adjacent = any(lp in adj for lp in locked)
    # shape match between any held key and any adjacent locked cell
    adj_locked = [lp for lp in locked if lp in adj]
    held_shapes = {keyshape.get(h) for h in held}
    adj_lock_shapes = {lockshape.get(lp) for lp in adj_locked}
    shape_match_adj = bool(held_shapes & adj_lock_shapes) if (held and adj_locked) else False

    f = {}
    f['holding_key']        = len(held) > 0
    f['arm_empty']          = len(a.get('arm-empty', [])) > 0
    f['lock_adjacent']      = lock_adjacent
    f['holding+lock_adj']   = (len(held) > 0) and lock_adjacent
    f['holding+lock_adj+match']    = (len(held) > 0) and shape_match_adj
    f['holding+lock_adj+mismatch'] = (len(held) > 0) and lock_adjacent and not shape_match_adj
    # instance-level structural complexity (constant within an instance, but
    # included so we can see if hard states cluster in complex instances)
    f['num_keys_ge3']       = len(keys) >= 3
    f['num_shapes_ge2']     = len(shapes) >= 2
    f['num_locked_ge2']     = len(locked) >= 2
    f['some_lock_still_locked'] = len(locked) > 0
    return f


def collect(domain, model, instances, taus, seed, state_cap, max_instances, states_per):
    random.seed(seed)
    files = sorted(f for f in Path(instances).glob('*.pddl') if f.name != 'domain.pddl')
    errs, feats = [], []
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, state_cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(seed)
            goal = p.get_goal_condition()
            used += 1
            states = ss.get_states(); random.shuffle(states)
            taken = 0
            for s in states:
                if taken >= states_per: break
                ls = ss.get_state_label(s)
                if ls.is_goal: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 1: continue
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                qs, _ = torch.sort(qv, dim=1)
                means = qs.mean(dim=1)
                best = int(means.argmax().item())
                err = abs(means[best].item() - (-float(ls.steps_to_goal)))
                errs.append(err)
                feats.append(descriptors(s))
                taken += 1
            if used >= max_instances: break
    return np.array(errs), feats


def report(tag, errs, feats, hq):
    n = len(errs)
    thr = np.quantile(errs, hq)
    high = errs >= thr
    keys = sorted({k for f in feats for k in f})
    print(f"\n================  {tag}  ================")
    print(f"states={n}  high-error cutoff (q{hq})={thr:.2f}  high-error n={int(high.sum())}")
    print(f"{'descriptor':28s} {'base%':>7} {'high%':>7} {'lift':>6}")
    rows = []
    for k in keys:
        v = np.array([1.0 if f.get(k) else 0.0 for f in feats])
        base = v.mean()
        hi = v[high].mean() if high.sum() else float('nan')
        lift = (hi / base) if base > 0 else float('nan')
        rows.append((lift if lift==lift else -1, k, base, hi, lift))
    # sort by lift descending; lift>1 => over-represented among high-error states
    for lift, k, base, hi, l in sorted(rows, reverse=True):
        print(f"{k:28s} {100*base:7.1f} {100*hi:7.1f} {l:6.2f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True)
    ap.add_argument('--instances', required=True)
    ap.add_argument('--model', required=True)
    ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=200_000)
    ap.add_argument('--max-instances', type=int, default=60)
    ap.add_argument('--states-per-instance', type=int, default=40)
    ap.add_argument('--high-quantile', type=float, default=0.9)
    ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()

    dev = torch.device('cpu')
    domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev)
    model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)

    print("="*70)
    print("LEVEL 2 — error-driven expressivity-bottleneck discovery (grid)")
    print(f"model: {args.model}  seeds: {args.seeds}  high-quantile: {args.high_quantile}")
    print("lift>1 => structure is OVER-represented among high-error states")
    print("="*70)
    allE, allF = [], []
    for sd in args.seeds:
        E, F = collect(domain, model, args.instances, taus, sd,
                       args.state_cap, args.max_instances, args.states_per_instance)
        report(f"SEED {sd}", E, F, args.high_quantile)
        allE.append(E); allF += F
    if len(args.seeds) > 1:
        report("POOLED", np.concatenate(allE), allF, args.high_quantile)

    print("\nRead: the descriptor(s) with the highest LIFT among high-error states")
    print("are the discovered expressivity bottlenecks. If 'holding+lock_adj+mismatch'")
    print("tops it, the wrong-key trap is confirmed as THE hard structure. Anything")
    print("else with high lift is a hard structure we did not assume.")


if __name__ == '__main__':
    main()