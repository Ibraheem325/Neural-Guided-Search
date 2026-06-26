#!/usr/bin/env python3
"""
logistics_high_w1_inspect.py
Why does W1 (distributional shift) correlate NEGATIVELY with error on logistics?
Hypothesis: high W1 happens at legitimate high-information transitions
(load/unload/fly) where the model correctly reshapes its estimate and is RIGHT,
rather than at states where it is uncertain/wrong.

For each sampled state we record W1 (best s-a -> best successor s-a) and the
action TYPE that the greedy-best action is (the transition producing the shift),
plus model error. Then we tabulate mean W1 and mean error by action type, and
print the top-W1 states with their action.
"""
import argparse, random
from pathlib import Path
from collections import defaultdict
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def action_type(a):
    s = str(a).lstrip('(').split()[0].lower()
    return s


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', default='example/logistics_dataset/domain.pddl')
    ap.add_argument('--instances', default='example/logistics_dataset/train')
    ap.add_argument('--model', default='models/logistics_iqn.pth')
    ap.add_argument('--seed', type=int, default=42)
    ap.add_argument('--state-cap', type=int, default=20000)
    ap.add_argument('--max-instances', type=int, default=40)
    ap.add_argument('--states-per-instance', type=int, default=30)
    args = ap.parse_args()

    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
    random.seed(args.seed)
    files = sorted(f for f in Path(args.instances).glob('*.pddl') if f.name != 'domain.pddl')

    rows = []  # (W1, err, action_type, action_str)
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, args.state_cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(args.seed); goal = p.get_goal_condition(); used += 1
            states = ss.get_states(); random.shuffle(states); taken = 0
            for s in states:
                if taken >= args.states_per_instance: break
                ls = ss.get_state_label(s)
                if ls.is_goal: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 1: continue
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, 99))[0]
                qs, _ = torch.sort(qv, dim=1); means = qs.mean(dim=1)
                best = int(means.argmax().item()); q_s = qs[best].cpu().numpy()
                a_best = acts[best]
                s2 = a_best.apply(s); ls2 = ss.get_state_label(s2)
                if ls2 is not None and ls2.is_goal:
                    w1 = 0.0
                else:
                    acts2 = s2.generate_applicable_actions()
                    if len(acts2) < 1:
                        taken += 1; continue
                    qv2, _ = model.forward([(s2, goal)], taus=taus.expand(1, 99))[0]
                    qs2, _ = torch.sort(qv2, dim=1); means2 = qs2.mean(dim=1)
                    b2 = int(means2.argmax().item()); q_s2 = qs2[b2].cpu().numpy()
                    w1 = float(np.mean(np.abs(q_s - q_s2)))
                err = abs(means[best].item() - (-float(ls.steps_to_goal)))
                rows.append((w1, err, action_type(a_best), str(a_best)))
                taken += 1
            if used >= args.max_instances: break

    W = np.array([r[0] for r in rows]); E = np.array([r[1] for r in rows])
    types = [r[2] for r in rows]
    print(f"states={len(rows)}  meanW1={W.mean():.3f}  meanErr={E.mean():.3f}\n")

    # mean W1 and error by action type
    by = defaultdict(list)
    for w, e, t, _ in rows: by[t].append((w, e))
    print(f"{'action type':22s} {'n':>5} {'meanW1':>8} {'meanErr':>8}")
    for t in sorted(by, key=lambda k: -np.mean([x[0] for x in by[k]])):
        ws = [x[0] for x in by[t]]; es = [x[1] for x in by[t]]
        print(f"{t:22s} {len(ws):5d} {np.mean(ws):8.3f} {np.mean(es):8.3f}")

    # top-20 highest W1 states
    print("\nTop-20 highest-W1 states (action that produces the shift):")
    for w, e, t, astr in sorted(rows, key=lambda r: -r[0])[:20]:
        print(f"  W1={w:.2f}  err={e:.2f}  {astr[:60]}")

    # correlation of W1 with whether action is a 'load/unload/fly' (info events)
    info = np.array([1.0 if t.startswith(('load','unload','fly')) else 0.0 for t in types])
    move = np.array([1.0 if t.startswith('drive') else 0.0 for t in types])
    print(f"\ninfo-events (load/unload/fly): n={int(info.sum())} meanW1={W[info==1].mean():.3f} meanErr={E[info==1].mean():.3f}")
    print(f"drive moves:                  n={int(move.sum())} meanW1={W[move==1].mean():.3f} meanErr={E[move==1].mean():.3f}")


if __name__ == '__main__':
    main()