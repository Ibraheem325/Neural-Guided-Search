#!/usr/bin/env python3
"""
satellite_band_finecheck.py
Is the mid-W1 high-error "band" real, or (a) a decile-averaging artifact of a
clumped W1 distribution, or (b) a shallowness/depth effect in disguise?

Checks:
 (1) error vs W1 in FINE equal-width bins (not deciles), with per-bin n and
     standard error on the high-error rate. Shows the true shape of the curve.
 (2) the SAME curve computed WITHIN fixed depth bands (e.g. depth 3-5, 6-8),
     so depth cannot drive the W1->error relationship. If the mid-W1 hump
     survives within a single depth band, it's a real W1 effect.
 (3) W1 distribution itself (is it clumped, causing decile distortion?).

Usage:
  venv/bin/python satellite_band_finecheck.py \
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
    W, ERR, DEP = [], [], []
    used = 0
    with torch.no_grad():
        for f in files:
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
                DEP.append(float(ls.steps_to_goal)); taken += 1
            if used >= maxi: break
    return map(np.array, (W, ERR, DEP))


def curve(W, ERR, he, edges, label):
    print(f"\n{label}")
    print(f"  {'W1 bin':>14} {'n':>6} {'%high':>7} {'se':>6} {'meanErr':>8}")
    for lo, hi in zip(edges[:-1], edges[1:]):
        m = (W >= lo) & (W < hi)
        n = int(m.sum())
        if n == 0:
            print(f"  [{lo:.2f},{hi:.2f})   {0:6d}      -      -        -"); continue
        rate = (ERR[m] >= he).mean()
        se = (rate*(1-rate)/n) ** 0.5
        flag = "  <==" if (rate - 2*se) > 0.15 else ""
        print(f"  [{lo:.2f},{hi:.2f}) {n:6d} {100*rate:7.1f} {100*se:6.1f} {ERR[m].mean():8.3f}{flag}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', default='example/satellite_dataset/domain.pddl')
    ap.add_argument('--instances', default='example/satellite_dataset/train')
    ap.add_argument('--model', required=True); ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=20000); ap.add_argument('--max-instances', type=int, default=120)
    ap.add_argument('--states-per-instance', type=int, default=40); ap.add_argument('--high-quantile', type=float, default=0.9)
    ap.add_argument('--nbins', type=int, default=16)
    args = ap.parse_args()
    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    AW, AE, AD = [], [], []
    for sd in args.seeds:
        W, E, D = collect(domain, model, args.instances, taus, sd,
                         args.state_cap, args.max_instances, args.states_per_instance)
        AW.append(W); AE.append(E); AD.append(D)
    W = np.concatenate(AW); ERR = np.concatenate(AE); DEP = np.concatenate(AD)
    he = np.quantile(ERR, args.high_quantile); base = (ERR >= he).mean()
    print(f"POOLED n={len(W)}  high-err thr={he:.2f}  base rate={100*base:.1f}%")

    # (3) W1 distribution shape
    print(f"\n(3) W1 distribution: min={W.min():.2f} "
          f"p10={np.percentile(W,10):.2f} p50={np.percentile(W,50):.2f} "
          f"p90={np.percentile(W,90):.2f} max={W.max():.2f}")
    # clumping: fraction of W1 mass in [1.1,1.6] (the suspected band)
    print(f"    fraction of states with W1 in [1.1,1.6] = "
          f"{100*((W>=1.1)&(W<1.6)).mean():.0f}%")

    # (1) fine equal-width bins over the bulk of W1 (cap at p99 to avoid a long tail)
    hi_edge = np.percentile(W, 99)
    edges = np.linspace(W.min(), hi_edge, args.nbins + 1)
    curve(W, ERR, he, edges, "(1) FINE equal-width W1 bins (whole sample)  [<== = high-err rate solidly >15%]")

    # (2) within fixed depth bands
    for dlo, dhi in [(3,5),(6,8),(9,12)]:
        m = (DEP >= dlo) & (DEP <= dhi)
        if m.sum() < 200: 
            print(f"\n(2) depth {dlo}-{dhi}: too few states (n={int(m.sum())})"); continue
        e2 = np.linspace(W[m].min(), np.percentile(W[m],99), args.nbins+1)
        curve(W[m], ERR[m], he, e2, f"(2) WITHIN depth {dlo}-{dhi} (n={int(m.sum())}) — does mid-W1 hump survive fixed depth?")

    print("\nVerdict:")
    print("  - if the fine bins show a clear hump at mid-W1 that FALLS at high W1,")
    print("    the band is real (not decile distortion).")
    print("  - if the hump persists within a single depth band, it's a real W1")
    print("    effect, not shallowness in disguise.")
    print("  - if it flattens under fine binning OR within depth, it was an artifact.")


if __name__ == '__main__':
    main()