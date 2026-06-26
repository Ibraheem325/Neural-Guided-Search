#!/usr/bin/env python3
"""
shift_metric_generic.py
Domain-agnostic distributional-shift (W1) test, runnable on any domain.

Per state: take the greedy-best action's predicted distribution, and the
greedy-best action's distribution at the successor it leads into. W1 = mean
absolute difference between the two sorted quantile curves (shift in value
units). Also |dW| = |width change|. Test whether shift predicts model error,
including depth-controlled (comparable across domains).

Usage:
  venv/bin/python shift_metric_generic.py \
    --domain example/logistics_dataset/domain.pddl \
    --instances example/logistics_dataset/train \
    --model models/logistics_iqn.pth \
    --seeds 42 43 44 --state-cap 20000 --max-instances 40 --states-per-instance 30
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
    W, DW, ERR, DEP = [], [], [], []
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
                best = int(means.argmax().item())
                q_s = qs[best].cpu().numpy(); w_s = q_s[90] - q_s[8]
                s2 = acts[best].apply(s); ls2 = ss.get_state_label(s2)
                if ls2 is not None and ls2.is_goal:
                    w1 = 0.0; dw = w_s
                else:
                    acts2 = s2.generate_applicable_actions()
                    if len(acts2) < 1:
                        taken += 1; continue
                    qv2, _ = model.forward([(s2, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                    qs2, _ = torch.sort(qv2, dim=1); means2 = qs2.mean(dim=1)
                    b2 = int(means2.argmax().item()); q_s2 = qs2[b2].cpu().numpy()
                    w1 = float(np.mean(np.abs(q_s - q_s2))); dw = abs((q_s2[90]-q_s2[8]) - w_s)
                W.append(w1); DW.append(dw)
                ERR.append(abs(means[best].item() - (-float(ls.steps_to_goal))))
                DEP.append(float(ls.steps_to_goal)); taken += 1
            if used >= maxi: break
    return map(np.array, (W, DW, ERR, DEP))


def report(tag, W, DW, ERR, DEP):
    print(f"\n================  {tag}  ================")
    print(f"states={len(W)}")
    print(f"  Spearman(W1,  error)         = {sp(W, ERR):+.3f}")
    print(f"  Spearman(|dW|, error)        = {sp(DW, ERR):+.3f}")
    print(f"  Spearman(W1,  depth)         = {sp(W, DEP):+.3f}")
    print(f"  PARTIAL(W1, error | depth)   = {partial(W, ERR, DEP):+.3f}  <- compare to grid 0.17, width 0.37/0.38")
    print(f"  W1: median={np.median(W):.3f} mean={W.mean():.3f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True); ap.add_argument('--instances', required=True)
    ap.add_argument('--model', required=True); ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=200000); ap.add_argument('--max-instances', type=int, default=60)
    ap.add_argument('--states-per-instance', type=int, default=40); ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()
    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)
    print("="*70); print(f"DISTRIBUTIONAL SHIFT (W1) — {args.model}"); print("="*70)
    AW, AD, AE, AP = [], [], [], []
    for sd in args.seeds:
        W, D, E, P = collect(domain, model, args.instances, taus, sd,
                             args.state_cap, args.max_instances, args.states_per_instance)
        report(f"SEED {sd}", W, D, E, P); AW.append(W); AD.append(D); AE.append(E); AP.append(P)
    if len(args.seeds) > 1:
        report("POOLED", *[np.concatenate(x) for x in (AW, AD, AE, AP)])


if __name__ == '__main__':
    main()
    