#!/usr/bin/env python3
"""
w1_trigger_eval.py
============================================================================
W1 is used as a ONE-SIDED trigger: search fires only when W1 is HIGH. So the
right question is not the symmetric Spearman(W1, error) but:

    Conditional on W1 being high, is the model actually in trouble (high error)?

This script evaluates W1 as a trigger:
  (1) mean error per W1 decile  -- does error rise in the top deciles?
  (2) PRECISION-style: of the top-k% W1 states, what fraction are "high-error"
      (error >= the global high-error threshold), vs the base rate. lift>1 in
      the top bin => triggering on high W1 catches real trouble.
  (3) For reference, the symmetric Spearman and the depth-controlled partial,
      and the same one-sided view AFTER removing the lowest-W1 mass (since
      zero-shift states never trigger and can dominate a symmetric measure).

Runnable on any domain. Compare grid vs logistics.

Usage:
  venv/bin/python w1_trigger_eval.py \
    --domain example/logistics_dataset/domain.pddl \
    --instances example/logistics_dataset/train \
    --model models/logistics_iqn.pth \
    --seeds 42 43 44 --state-cap 20000 --max-instances 40 --states-per-instance 30
============================================================================
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def sp(a, b):
    a, b = np.asarray(a, float), np.asarray(b, float)
    if len(a) < 3 or a.std() == 0 or b.std() == 0: return float('nan')
    return float(np.corrcoef(np.argsort(np.argsort(a)), np.argsort(np.argsort(b)))[0, 1])

def partial(a, b, c):
    ra, rb, rc = (np.argsort(np.argsort(x)).astype(float) for x in (a, b, c))
    ra = ra - np.polyval(np.polyfit(rc, ra, 1), rc)
    rb = rb - np.polyval(np.polyfit(rc, rb, 1), rc)
    if ra.std() == 0 or rb.std() == 0: return float('nan')
    return float(np.corrcoef(ra, rb)[0, 1])


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


def report(tag, W, ERR, DEP, hq):
    n = len(W)
    he = np.quantile(ERR, hq)              # global high-error threshold
    base = (ERR >= he).mean()              # base rate of high-error states
    print(f"\n================  {tag}  ================")
    print(f"states={n}  high-error thr (q{hq})={he:.2f}  base rate={100*base:.1f}%")
    print(f"  symmetric Spearman(W1,error)      = {sp(W, ERR):+.3f}")
    print(f"  PARTIAL(W1,error|depth)           = {partial(W, ERR, DEP):+.3f}")

    # (1) mean error by W1 decile
    print("\n  (1) mean error by W1 decile (does error rise where W1 is high?):")
    order = np.argsort(W)
    deciles = np.array_split(order, 10)
    for i, idx in enumerate(deciles):
        print(f"      W1 decile {i+1:2d}: W1[{W[idx].min():.2f},{W[idx].max():.2f}] "
              f"meanW1={W[idx].mean():.3f}  meanErr={ERR[idx].mean():.3f}  "
              f"%high-err={100*(ERR[idx]>=he).mean():.0f}")

    # (2) precision/lift in top-k% W1
    print("\n  (2) trigger precision: among top-k% W1 states, lift of high-error rate:")
    for k in (0.05, 0.10, 0.20, 0.30):
        thr = np.quantile(W, 1 - k)
        sel = W >= thr
        if sel.sum() == 0: continue
        rate = (ERR[sel] >= he).mean()
        print(f"      top {int(100*k):2d}% W1 (W1>={thr:.2f}, n={int(sel.sum())}): "
              f"high-err rate={100*rate:.1f}%  lift={rate/base:.2f}")

    # (3) one-sided correlation after dropping zero/low-shift mass
    nz = W > np.quantile(W, 0.30)   # drop bottom 30% (incl. zero-shift drive states)
    if nz.sum() > 20:
        print(f"\n  (3) Spearman(W1,error) within top-70% W1 (drop low-shift mass) "
              f"= {sp(W[nz], ERR[nz]):+.3f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True); ap.add_argument('--instances', required=True)
    ap.add_argument('--model', required=True); ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=20000); ap.add_argument('--max-instances', type=int, default=40)
    ap.add_argument('--states-per-instance', type=int, default=30); ap.add_argument('--high-quantile', type=float, default=0.9)
    ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()
    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)
    print("="*70); print(f"W1 AS A ONE-SIDED TRIGGER — {args.model}"); print("="*70)
    AW, AE, AD = [], [], []
    for sd in args.seeds:
        W, E, D = collect(domain, model, args.instances, taus, sd,
                          args.state_cap, args.max_instances, args.states_per_instance)
        report(f"SEED {sd}", W, E, D, args.high_quantile); AW.append(W); AE.append(E); AD.append(D)
    if len(args.seeds) > 1:
        report("POOLED", np.concatenate(AW), np.concatenate(AE), np.concatenate(AD), args.high_quantile)
    print("\nRead: if top-k% W1 has lift>1 (esp. top 5-10%), then triggering search")
    print("on high W1 catches genuinely high-error states -- W1 works as a one-sided")
    print("trigger even if the symmetric correlation is ~0 or negative.")


if __name__ == '__main__':
    main()