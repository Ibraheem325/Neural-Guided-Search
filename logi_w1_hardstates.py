#!/usr/bin/env python3
"""
logi_w1_hardstates.py  (CHECK 2)
Does the W1 signal predict value-error on HARD logistics states, or only on easy
ones? If W1's error-prediction survives on large-instance / deep (far-from-goal)
states, a harder test set would give the AlphaZero W1 boost real signal to act on
-> worth generating hard instances. If the lift collapses toward 1.0 on hard
states (like satellite beyond its depth band), harder instances won't help.

Signal: per-transition W1 shift = mean|sorted(best_curve(s)) - sorted(best_curve(s'))|
along the greedy(best-mean) successor. Error: |V_pred(s) - V*(s)| using the
true goal distance from the state-space sampler.

One-sided TRIGGER LIFT = P(high error | W1 in top q%) / P(high error | base).
Lift >> 1 means high-W1 flags error. We report it stratified by:
  - instance object-count tercile (small / med / large)
  - goal-distance tercile (shallow / mid / deep)
so you can see if the signal holds where search actually struggles.

Usage: venv/bin/python logi_w1_hardstates.py --domain-key logistics
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model as load_iqn


def count_objects_typed(problem_path: str) -> int:
    """Corrected typed-PDDL object count: strip '- typename' before counting."""
    txt = Path(problem_path).read_text()
    import re
    m = re.search(r'\(:objects(.*?)\)', txt, re.S | re.I)
    if not m: return 0
    body = m.group(1)
    # remove '- type' annotations
    body = re.sub(r'-\s+\S+', ' ', body)
    return len([t for t in body.split() if t.strip()])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain-key', default='logistics')
    ap.add_argument('--splits', nargs='+', default=['train', 'val'],
                    help='which splits to pull states from (use ones that EXPAND under the cap)')
    ap.add_argument('--state-cap', type=int, default=50000)
    ap.add_argument('--max-instances', type=int, default=60)
    ap.add_argument('--states-per-instance', type=int, default=60)
    ap.add_argument('--err-quantile', type=float, default=0.75, help='"high error" = top (1-q) of errors')
    ap.add_argument('--trigger-quantile', type=float, default=0.90, help='"high W1" = top (1-q)')
    args = ap.parse_args()

    base = f'example/{args.domain_key}_dataset'
    dom = mm.Domain(f'{base}/domain.pddl')
    dev = torch.device('cpu')
    iqn, _, _ = load_iqn(dom, Path(f'models/{args.domain_key}_iqn.pth'), dev); iqn.eval()
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    def best_curve_and_mean(state, goal):
        qv, _ = iqn.forward([(state, goal)], taus=taus.expand(1, 99))[0]
        if qv.shape[0] == 0: return None, None
        qs, _ = torch.sort(qv, dim=1); m = qs.mean(dim=1); b = int(m.argmax())
        return qs[b].detach(), float(m[b].item())

    recs = []  # (w1, err, nobj, gd)
    files = []
    for sp in args.splits:
        files += sorted(f for f in Path(f'{base}/{sp}').glob('*.pddl') if f.name != 'domain.pddl')
    random.seed(0); random.shuffle(files)
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(dom, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, args.state_cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(0); goal = p.get_goal_condition()
            nobj = count_objects_typed(str(f))
            states = ss.get_states(); random.shuffle(states); taken = 0
            for s in states:
                if taken >= args.states_per_instance: break
                ls = ss.get_state_label(s)
                if ls.is_goal or ls.is_dead_end: continue
                gd = ls.steps_to_goal
                cur, mean_pred = best_curve_and_mean(s, goal)
                if cur is None: continue
                # greedy(best-mean) successor for the W1 shift
                acts = s.generate_applicable_actions()
                if len(acts) == 0: continue
                # pick successor of the best action (recompute best action index)
                qv, _ = iqn.forward([(s, goal)], taus=taus.expand(1, 99))[0]
                qs, _ = torch.sort(qv, dim=1); b = int(qs.mean(dim=1).argmax())
                succ = acts[b].apply(s)
                scur, _ = best_curve_and_mean(succ, goal)
                if scur is None: continue
                w1 = float(torch.mean(torch.abs(cur - scur)).item())
                # value error: predicted mean is NEGATIVE cost-to-go in these models;
                # compare |(-mean_pred) - gd|
                err = abs((-mean_pred) - gd)
                recs.append((w1, err, nobj, gd))
                taken += 1
            used += 1
            if used >= args.max_instances: break

    a = np.array(recs, dtype=float)
    if len(a) < 50:
        print(f"only {len(a)} states — too few; try more splits/instances"); return
    w1, err, nobj, gd = a[:,0], a[:,1], a[:,2], a[:,3]
    err_hi = err >= np.quantile(err, args.err_quantile)
    base_rate = err_hi.mean()

    def lift(mask):
        if mask.sum() == 0: return float('nan'), 0
        sub = a[mask]
        e = sub[:,1] >= np.quantile(err, args.err_quantile)
        # high-W1 within this subset
        thr = np.quantile(sub[:,0], args.trigger_quantile)
        hi = sub[:,0] >= thr
        if hi.sum() == 0: return float('nan'), 0
        rate_hi = e[hi].mean()
        return (rate_hi / base_rate if base_rate > 0 else float('nan')), int(hi.sum())

    print(f"=== {args.domain_key} W1 trigger-lift on hard states — {len(a)} states ===")
    print(f"object count: min={nobj.min():.0f} max={nobj.max():.0f} mean={nobj.mean():.1f}")
    print(f"goal distance: min={gd.min():.0f} max={gd.max():.0f} mean={gd.mean():.1f}")
    print(f"base high-error rate (top {100*(1-args.err_quantile):.0f}%): {base_rate:.3f}")
    overall, n = lift(np.ones(len(a), bool))
    print(f"\nOVERALL W1 top-{100*(1-args.trigger_quantile):.0f}% lift = {overall:.2f}  (n_hi={n})")

    def terciles(vals):
        q1, q2 = np.quantile(vals, [1/3, 2/3]); return q1, q2

    print("\n--- stratified by OBJECT COUNT (is signal alive on large instances?) ---")
    o1, o2 = terciles(nobj)
    for name, mask in [('small', nobj <= o1), ('med', (nobj > o1) & (nobj <= o2)), ('large', nobj > o2)]:
        l, n = lift(mask)
        rng = f"{a[mask,2].min():.0f}-{a[mask,2].max():.0f}" if mask.sum() else "-"
        print(f"  {name:6s} (obj {rng}): lift={l:.2f}  (n={int(mask.sum())}, n_hi={n})")

    print("\n--- stratified by GOAL DISTANCE (is signal alive deep / far from goal?) ---")
    g1, g2 = terciles(gd)
    for name, mask in [('shallow', gd <= g1), ('mid', (gd > g1) & (gd <= g2)), ('deep', gd > g2)]:
        l, n = lift(mask)
        rng = f"{a[mask,3].min():.0f}-{a[mask,3].max():.0f}" if mask.sum() else "-"
        print(f"  {name:7s} (gd {rng}): lift={l:.2f}  (n={int(mask.sum())}, n_hi={n})")

    print("\nRead: lift >> 1 means high-W1 flags high-error. If it STAYS high on")
    print("'large' and 'deep' -> hard instances will give the boost real signal")
    print("(generate them). If it COLLAPSES to ~1 on large/deep -> harder instances")
    print("won't help; logistics is signal-limited, not difficulty-limited.")


if __name__ == '__main__':
    main()