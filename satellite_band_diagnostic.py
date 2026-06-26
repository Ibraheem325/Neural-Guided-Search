#!/usr/bin/env python3
"""
satellite_band_diagnostic.py
Is the mid-W1 high-error band (deciles ~7-8) a real phenomenon or an artifact
of limited instance diversity / depth confounding?

Checks:
 (A) Among the high-error states in the mid-W1 band, how many DISTINCT instances
     contribute? If concentrated in a few instances -> artifact, not domain property.
 (B) Depth distribution per W1 decile -> is the mid band just a depth range?
 (C) Re-run with MORE instances (configurable) to see if the band persists.
 (D) Bootstrap: resample instances with replacement, recompute the top/mid-band
     high-error rate, report variability -> is the effect stable to which
     instances are included?

Outputs per-decile: meanW1, meanErr, %high-err, mean depth, #distinct instances.

Usage:
  venv/bin/python satellite_band_diagnostic.py \
    --model models/satellite_iqn.pth --seeds 42 43 44 \
    --max-instances 120 --states-per-instance 40 --state-cap 20000
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def collect(domain, model, instances, taus, seed, cap, maxi, sper):
    random.seed(seed)
    files = sorted(f for f in Path(instances).glob('*.pddl') if f.name != 'domain.pddl')
    W, ERR, DEP, INST = [], [], [], []
    used = 0
    with torch.no_grad():
        for fi, f in enumerate(files):
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(seed); goal = p.get_goal_condition(); used += 1
            states = ss.get_states(); random.shuffle(states); taken = 0
            for s in states:
                if taken >= sper: break
                ls = ss.get_state_label(s)
                if ls.is_goal: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 1: continue
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                qs, _ = torch.sort(qv, dim=1); means = qs.mean(dim=1)
                best = int(means.argmax().item()); q_s = qs[best].cpu().numpy()
                s2 = acts[best].apply(s); ls2 = ss.get_state_label(s2)
                if ls2 is not None and ls2.is_goal:
                    w1 = 0.0
                else:
                    acts2 = s2.generate_applicable_actions()
                    if len(acts2) < 1:
                        taken += 1; continue
                    qv2, _ = model.forward([(s2, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                    qs2, _ = torch.sort(qv2, dim=1); means2 = qs2.mean(dim=1)
                    b2 = int(means2.argmax().item())
                    w1 = float(np.mean(np.abs(q_s - qs2[b2].cpu().numpy())))
                W.append(w1); ERR.append(abs(means[best].item() - (-float(ls.steps_to_goal))))
                DEP.append(float(ls.steps_to_goal)); INST.append(fi); taken += 1
            if used >= maxi: break
    print(f"  [seed {seed}] instances used: {used}")
    return map(np.array, (W, ERR, DEP, INST))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', default='example/satellite_dataset/domain.pddl')
    ap.add_argument('--instances', default='example/satellite_dataset/train')
    ap.add_argument('--model', required=True); ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=20000); ap.add_argument('--max-instances', type=int, default=120)
    ap.add_argument('--states-per-instance', type=int, default=40); ap.add_argument('--high-quantile', type=float, default=0.9)
    args = ap.parse_args()
    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    AW, AE, AD, AI = [], [], [], []
    for sd in args.seeds:
        W, E, D, I = collect(domain, model, args.instances, taus, sd,
                             args.state_cap, args.max_instances, args.states_per_instance)
        AW.append(W); AE.append(E); AD.append(D); AI.append(I)
    W = np.concatenate(AW); ERR = np.concatenate(AE); DEP = np.concatenate(AD)
    # offset instance ids per seed so they're distinct across seeds
    INST = np.concatenate([I + k*100000 for k, I in enumerate(AI)])

    he = np.quantile(ERR, args.high_quantile)
    base = (ERR >= he).mean()
    print(f"\nPOOLED states={len(W)}  high-err thr={he:.2f}  base={100*base:.1f}%  "
          f"distinct instances total={len(set(INST))}")

    print("\n(A,B) per W1 decile: error, %high-err, mean depth, #distinct instances among high-err")
    print(f"{'dec':>3} {'W1rng':>14} {'meanErr':>8} {'%hi':>5} {'depth':>6} {'#inst(hi)':>9} {'#states(hi)':>11}")
    order = np.argsort(W)
    for i, idx in enumerate(np.array_split(order, 10)):
        hi = idx[ERR[idx] >= he]
        ninst = len(set(INST[hi].tolist()))
        print(f"{i+1:3d} [{W[idx].min():.2f},{W[idx].max():.2f}] {ERR[idx].mean():8.3f} "
              f"{100*(ERR[idx]>=he).mean():5.0f} {DEP[idx].mean():6.1f} {ninst:9d} {len(hi):11d}")

    # (C) instance-concentration of the mid-band (deciles 7-8) high-error states
    mid = order[int(0.6*len(order)):int(0.8*len(order))]
    midhi = mid[ERR[mid] >= he]
    if len(midhi):
        from collections import Counter
        c = Counter(INST[midhi].tolist())
        top = c.most_common(5)
        frac_top3 = sum(n for _, n in top[:3]) / len(midhi)
        print(f"\n(C) mid-band (decile 7-8) high-err states: n={len(midhi)} "
              f"from {len(c)} distinct instances")
        print(f"    top-3 instances account for {100*frac_top3:.0f}% of them "
              f"(high => artifact of few instances)")

    # depth-matched: within deciles 7-8, is high-err explained by depth?
    print("\n(D) depth-matched check in mid-band: compare depth of high-err vs low-err there")
    midlo = mid[ERR[mid] < he]
    if len(midhi) and len(midlo):
        print(f"    mid-band high-err depth mean={DEP[midhi].mean():.1f} (n={len(midhi)}) | "
              f"low-err depth mean={DEP[midlo].mean():.1f} (n={len(midlo)})")
        print("    (if depths differ a lot, the band is depth-driven, not W1-driven)")

    # bootstrap over instances for top-5% and mid-band lift
    print("\n(E) bootstrap over instances (100 resamples): lift stability")
    insts = np.array(sorted(set(INST.tolist())))
    def lift_for(mask_idx):
        sel = np.zeros(len(W), bool); sel[mask_idx] = True
        r = (ERR[sel] >= he).mean()
        return r / base if base > 0 else np.nan
    top5_thr = np.quantile(W, 0.95)
    rng = np.random.default_rng(0)
    top5_lifts, mid_lifts = [], []
    for _ in range(100):
        chosen = set(rng.choice(insts, size=len(insts), replace=True).tolist())
        m = np.array([x in chosen for x in INST])
        if m.sum() < 50: continue
        Wm, Em = W[m], ERR[m]
        t = Wm >= np.quantile(Wm, 0.95)
        top5_lifts.append(((Em[t] >= he).mean()) / base)
        om = np.argsort(Wm); mb = om[int(0.6*len(om)):int(0.8*len(om))]
        mid_lifts.append(((Em[mb] >= he).mean()) / base)
    print(f"    top-5% W1 lift: mean={np.mean(top5_lifts):.2f}  std={np.std(top5_lifts):.2f}  "
          f"[{np.percentile(top5_lifts,5):.2f},{np.percentile(top5_lifts,95):.2f}]")
    print(f"    mid-band   lift: mean={np.mean(mid_lifts):.2f}  std={np.std(mid_lifts):.2f}  "
          f"[{np.percentile(mid_lifts,5):.2f},{np.percentile(mid_lifts,95):.2f}]")
    print("\n    If CIs straddle 1.0 and std is large => consistent with NOISE.")
    print("    If lift stays >1 across resamples => stable effect, not noise.")


if __name__ == '__main__':
    main()