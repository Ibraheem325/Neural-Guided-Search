#!/usr/bin/env python3
"""
branching_probe.py
Diagnose whether a SELECTION-TIME width signal has room to work in a domain.

A width-guided selection can only change the search if, at the states the search
actually visits, there is (a) a real choice (branching factor > 1 after removing
the just-came-from successor), AND (b) the sibling successors differ in width
(so width can prefer one over another). Grid corridors fail (a). This measures
both, per domain.

For each domain, over a sample of states from test instances:
  - branching: number of applicable actions
  - effective branching: applicable actions whose successor is NOT the parent
    state (cheap proxy for cycle-blocking)
  - sibling width spread: std of best-action width across the successors of a
    state (the quantity a prior-boost / selection bonus actually uses)

Usage:
  venv/bin/python branching_probe.py --domain-key grid
  (repeat for logistics, goldminer)
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model as load_iqn


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain-key', required=True, help='grid | logistics | goldminer | satellite | rovers')
    ap.add_argument('--split', default='test')
    ap.add_argument('--state-cap', type=int, default=50000)
    ap.add_argument('--max-instances', type=int, default=20)
    ap.add_argument('--states-per-instance', type=int, default=40)
    args = ap.parse_args()

    base = f'example/{args.domain_key}_dataset'
    dom = mm.Domain(f'{base}/domain.pddl')
    dev = torch.device('cpu')
    iqn, _, _ = load_iqn(dom, Path(f'models/{args.domain_key}_iqn.pth'), dev); iqn.eval()
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    def best_width(state, goal):
        qv, _ = iqn.forward([(state, goal)], taus=taus.expand(1, 99))[0]
        if qv.shape[0] == 0: return None
        qs, _ = torch.sort(qv, dim=1); m = qs.mean(dim=1); b = int(m.argmax())
        return (qs[b, 90] - qs[b, 8]).item()

    files = sorted(f for f in Path(f'{base}/{args.split}').glob('*.pddl') if f.name != 'domain.pddl')
    random.seed(0)
    branch, eff_branch, sib_std = [], [], []
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(dom, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, args.state_cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(0); goal = p.get_goal_condition(); used += 1
            states = ss.get_states(); random.shuffle(states); taken = 0
            for s in states:
                if taken >= args.states_per_instance: break
                ls = ss.get_state_label(s)
                if ls.is_goal or ls.is_dead_end: continue
                acts = s.generate_applicable_actions()
                if len(acts) == 0: continue
                skey = str(s.get_atoms())
                widths = []
                eff = 0
                for a in acts:
                    succ = a.apply(s)
                    if str(succ.get_atoms()) != skey:
                        eff += 1
                    w = best_width(succ, goal)
                    if w is not None: widths.append(w)
                branch.append(len(acts))
                eff_branch.append(eff)
                if len(widths) >= 2:
                    sib_std.append(float(np.std(widths)))
                taken += 1
            if used >= args.max_instances: break

    b = np.array(branch); e = np.array(eff_branch); ss_ = np.array(sib_std)
    print(f"=== {args.domain_key} ({args.split}) — {len(b)} states sampled ===")
    print(f"branching factor:        mean={b.mean():.2f} median={np.median(b):.0f} "
          f"max={b.max()}  %states with >1 action = {100*(b>1).mean():.0f}%")
    print(f"effective branching:     mean={e.mean():.2f} median={np.median(e):.0f}  "
          f"%states with >1 (non-return) = {100*(e>1).mean():.0f}%")
    if len(ss_):
        print(f"sibling width spread:    mean_std={ss_.mean():.3f} median_std={np.median(ss_):.3f}  "
              f"%states (>=2 sibs) with std>0.2 = {100*(ss_>0.2).mean():.0f}%")
        print(f"  (states with >=2 siblings: {len(ss_)} of {len(b)})")
    else:
        print("sibling width spread:    no states with >=2 siblings")
    print()
    print("Interpretation:")
    print("  Selection-time width can only help where there's a real choice AND")
    print("  siblings differ in width. Low effective branching (~1) => no room.")
    print("  High %states with eff-branch>1 and sibling-std>0.2 => room to work.")


if __name__ == '__main__':
    main()