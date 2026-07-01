#!/usr/bin/env python3
"""
logi_w1_diffusion.py
Diagnose WHY W1 prior-boost over-explores on logistics.

Hypothesis: in high-branching nodes, multiplying every child's prior by
(1 + lambda*norm_W1) and renormalizing spreads mass over MANY children
(diffusion) instead of concentrating on one, so search fans out.

For a sample of states from logistics train instances, we measure per node:
  - branching (num children)
  - how many children have HIGH normalized W1 (>0.5, >0.8)
  - effective number of actions under the RAW policy prior (perplexity)
  - effective number under the BOOSTED prior (perplexity)
    -> if boosted perplexity >> raw, the boost is diffusing the policy.
  - same but for a TOP-1 boost (only the single max-W1 child boosted)
    -> if top-1 keeps perplexity low, that's the fix.

Perplexity = exp(entropy(p)) = "effective number of actions". Higher = flatter.

Usage: venv/bin/python logi_w1_diffusion.py --domain-key logistics --lam 1.0
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model as load_iqn
import pymimir_rgnn as rgnn


def perplexity(p):
    p = np.asarray(p, dtype=float)
    p = p[p > 0]
    if len(p) == 0: return 0.0
    return float(np.exp(-(p * np.log(p)).sum()))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain-key', default='logistics')
    ap.add_argument('--split', default='train')
    ap.add_argument('--lam', type=float, default=1.0)
    ap.add_argument('--state-cap', type=int, default=20000)
    ap.add_argument('--max-instances', type=int, default=15)
    ap.add_argument('--states-per-instance', type=int, default=30)
    args = ap.parse_args()

    base = f'example/{args.domain_key}_dataset'
    dom = mm.Domain(f'{base}/domain.pddl')
    dev = torch.device('cpu')
    iqn, _, _ = load_iqn(dom, Path(f'models/{args.domain_key}_iqn.pth'), dev); iqn.eval()
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f'models/{args.domain_key}_sac_policy.pth'), dev)
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    def best_curve(state, goal):
        qv, _ = iqn.forward([(state, goal)], taus=taus.expand(1, 99))[0]
        if qv.shape[0] == 0: return None
        qs, _ = torch.sort(qv, dim=1); m = qs.mean(dim=1); b = int(m.argmax())
        return qs[b].detach()

    def policy_prior(state, goal):
        acts = state.generate_applicable_actions()
        logits = pol_raw.forward([(state, acts, goal)]).readout('policy')[0]
        return torch.softmax(logits, dim=0).cpu().numpy(), acts

    files = sorted(f for f in Path(f'{base}/{args.split}').glob('*.pddl') if f.name != 'domain.pddl')
    rows = []
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(dom, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, args.state_cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(0); goal = p.get_goal_condition(); used += 1
            states = ss.get_states(); random.seed(0); random.shuffle(states); taken = 0
            for s in states:
                if taken >= args.states_per_instance: break
                ls = ss.get_state_label(s)
                if ls.is_goal or ls.is_dead_end: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 2: continue
                pc = best_curve(s, goal)
                if pc is None: continue
                prior, _ = policy_prior(s, goal)
                # edge W1 for each child
                w1s = []
                for a in acts:
                    cc = best_curve(a.apply(s), goal)
                    w1s.append(0.0 if cc is None else torch.mean(torch.abs(pc - cc)).item())
                w1s = np.array(w1s)
                # normalize W1 within this node (proxy; real run uses global running norm)
                if w1s.max() > w1s.min():
                    nw = (w1s - w1s.min()) / (w1s.max() - w1s.min())
                else:
                    nw = np.zeros_like(w1s)
                # boosted prior (all children) and top-1 boosted
                boost_all = prior * (1 + args.lam * nw); boost_all /= boost_all.sum()
                top1 = nw.copy(); mask = np.zeros_like(top1); mask[np.argmax(top1)] = 1
                boost_top1 = prior * (1 + args.lam * nw * mask); boost_top1 /= boost_top1.sum()
                rows.append((
                    len(acts),
                    int((nw > 0.5).sum()), int((nw > 0.8).sum()),
                    perplexity(prior), perplexity(boost_all), perplexity(boost_top1),
                ))
                taken += 1
            if used >= args.max_instances: break

    a = np.array(rows, dtype=float)
    print(f"=== {args.domain_key} W1 diffusion (lam={args.lam}) — {len(a)} nodes ===")
    print(f"branching:                 mean={a[:,0].mean():.2f} median={np.median(a[:,0]):.0f} max={a[:,0].max():.0f}")
    print(f"# children with norm_W1>0.5: mean={a[:,1].mean():.2f}   >0.8: mean={a[:,2].mean():.2f}")
    print(f"perplexity (eff. #actions):")
    print(f"  raw policy prior:        mean={a[:,3].mean():.2f}")
    print(f"  boosted ALL children:    mean={a[:,4].mean():.2f}   (delta {a[:,4].mean()-a[:,3].mean():+.2f})")
    print(f"  boosted TOP-1 only:      mean={a[:,5].mean():.2f}   (delta {a[:,5].mean()-a[:,3].mean():+.2f})")
    print()
    print("Read: if 'boosted ALL' perplexity >> raw, the boost FLATTENS the policy")
    print("(diffusion -> over-exploration). If TOP-1 stays near raw, top-k boosting is the fix.")


if __name__ == '__main__':
    main()