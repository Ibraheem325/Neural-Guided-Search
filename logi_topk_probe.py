#!/usr/bin/env python3
"""
logi_topk_probe.py
Before sweeping top-k on the cluster, measure OFFLINE what top-k actually does
to selection on logistics nodes, to distinguish three hypotheses:

  H1 (sweet spot): some middle k changes selection MORE than top-1 but less
     than all -> a graded effect that could yield a U-shape in expansions.
  H2 (monotonic):  effect grows with k from the start; top-1 already minimal.
  H3 (wrong knob): the boost is renormalized away against a peaked policy, so
     even all-boost barely changes the FIRST-VISIT selected child -> k won't help.

For a sample of states we compute, at each k in {1,2,3,5,all}, using the SAME
first-visit pUCT proxy the search uses (Q=0, N=0 -> score ~ boosted_prior):
  - fraction of nodes where the argmax child CHANGES vs vanilla (no boost)
  - mean L1 movement of the prior distribution
  - mean rank the vanilla-best action falls to under the boost
If 'argmax changes' stays ~0 across all k, the prior-boost cannot steer first
visits at all (H3). If it grows with k, k is a real lever (H1/H2 distinguished
by whether mid-k changes MORE per-unit than the blowup region).

Usage: venv/bin/python logi_topk_probe.py --domain-key logistics --lam 1.0
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model as load_iqn
import pymimir_rgnn as rgnn


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain-key', default='logistics')
    ap.add_argument('--split', default='train')
    ap.add_argument('--lam', type=float, default=1.0)
    ap.add_argument('--state-cap', type=int, default=20000)
    ap.add_argument('--max-instances', type=int, default=15)
    ap.add_argument('--states-per-instance', type=int, default=40)
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

    ks = [1, 2, 3, 5, 10**9]   # 10**9 = "all"
    klabels = ['1', '2', '3', '5', 'all']
    # accumulators
    changed = {kl: 0 for kl in klabels}
    l1move = {kl: [] for kl in klabels}
    rankdrop = {kl: [] for kl in klabels}
    n_nodes = 0

    files = sorted(f for f in Path(f'{base}/{args.split}').glob('*.pddl') if f.name != 'domain.pddl')
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
                logits = pol_raw.forward([(s, acts, goal)]).readout('policy')[0]
                prior = torch.softmax(logits, dim=0).cpu().numpy()
                # edge W1 per child, normalized within node (proxy for running norm)
                w1 = np.array([0.0 if (cc := best_curve(a.apply(s), goal)) is None
                               else torch.mean(torch.abs(pc - cc)).item() for a in acts])
                nw = (w1 - w1.min()) / (w1.max() - w1.min()) if w1.max() > w1.min() else np.zeros_like(w1)
                vanilla_best = int(prior.argmax())
                n_nodes += 1
                for k, kl in zip(ks, klabels):
                    m = np.zeros_like(nw)
                    if k >= len(nw):
                        m[:] = 1.0
                    else:
                        m[np.argsort(nw)[::-1][:k]] = 1.0
                    bp = prior * (1 + args.lam * nw * m); bp /= bp.sum()
                    if int(bp.argmax()) != vanilla_best:
                        changed[kl] += 1
                    l1move[kl].append(float(np.abs(bp - prior).sum()))
                    # rank the vanilla-best action now holds under boosted prior (0 = still best)
                    order = np.argsort(bp)[::-1]
                    rankdrop[kl].append(int(np.where(order == vanilla_best)[0][0]))
                taken += 1
            if used >= args.max_instances: break

    print(f"=== {args.domain_key} top-k selection effect (lam={args.lam}) — {n_nodes} nodes ===")
    print(f"{'k':>4} {'argmax_changed%':>16} {'mean_L1_move':>13} {'mean_rankdrop':>14}")
    for kl in klabels:
        pc = 100 * changed[kl] / max(1, n_nodes)
        print(f"{kl:>4} {pc:>15.1f}% {np.mean(l1move[kl]):>13.3f} {np.mean(rankdrop[kl]):>14.2f}")
    print()
    print("Read:")
    print("  argmax_changed% ~0 for ALL k  -> H3: boost can't steer first visits; k is wrong knob.")
    print("  grows with k                  -> k is a real lever (then sweep on cluster for U vs monotonic).")


if __name__ == '__main__':
    main()