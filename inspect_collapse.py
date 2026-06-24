import random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model

dev = torch.device('cpu')
domain = mm.Domain('example/goldminer_dataset/domain.pddl')
model, _, _ = _load_model(domain, Path('models/goldminer_iqn.pth'), dev)
model.eval()
taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

random.seed(0)
files = sorted(f for f in Path('example/goldminer_dataset/train').glob('*.pddl') if f.name != 'domain.pddl')

def pct(curve, p):  # curve already sorted, 99 pts at 0.01..0.99
    return curve[p-1].item()

found = 0
with torch.no_grad():
    for f in files:
        if found >= 3:
            break
        p = mm.Problem(domain, str(f))
        if len(p.get_goal_condition()) == 0:
            continue
        ss = mm.StateSpaceSampler.new(p, 10000)
        if ss is None or ss.max_steps_to_goal() < 2:
            continue
        goal = p.get_goal_condition()
        states = ss.get_states(); random.shuffle(states)
        for s in states:
            if found >= 3:
                break
            ls = ss.get_state_label(s)
            if ls.is_goal:
                continue
            acts = s.generate_applicable_actions()
            if len(acts) < 2:
                continue
            qv, _ = model.forward([(s, goal)], taus=taus.expand(1, 99))[0]
            qs, _ = torch.sort(qv, dim=1)
            means = qs.mean(dim=1).numpy()
            # find a forced-collapse pair: near-equal mean, different TRUE cost, neither a dead end
            tv, dead = [], []
            for a in acts:
                l = ss.get_state_label(a.apply(s))
                isdead = (l is None or l.is_dead_end)
                dead.append(isdead)
                tv.append(None if isdead else float(l.steps_to_goal))
            pick = None
            for i in range(len(acts)):
                for j in range(i+1, len(acts)):
                    if dead[i] or dead[j]:
                        continue
                    if abs(means[i]-means[j]) <= 0.5 and abs(tv[i]-tv[j]) >= 2:
                        pick = (i, j); break
                if pick: break
            if not pick:
                continue
            i, j = pick
            found += 1
            print("="*70)
            print(f"instance: {f.name}   state depth (true steps-to-goal) = {ls.steps_to_goal}")
            for k, tag in [(i, "A"), (j, "B")]:
                c = qs[k]
                print(f"\n successor {tag}: action = {str(acts[k])[:60]}")
                print(f"   TRUE cost-to-goal = {tv[k]:.0f}")
                print(f"   pred mean         = {means[k]:.3f}")
                print(f"   quantiles: p05={pct(c,5):.2f} p25={pct(c,25):.2f} p50={pct(c,50):.2f} "
                      f"p75={pct(c,75):.2f} p95={pct(c,95):.2f}")
                print(f"   width p90-p10     = {pct(c,90)-pct(c,10):.3f}")
            wi = pct(qs[i],90)-pct(qs[i],10)
            wj = pct(qs[j],90)-pct(qs[j],10)
            worse = "A" if tv[i] > tv[j] else "B"
            wider = "A" if wi > wj else "B"
            print(f"\n  --> worse successor (higher true cost): {worse}")
            print(f"  --> wider distribution:                  {wider}")
            print(f"  --> hypothesis wants these to MATCH:     {'MATCH' if worse==wider else 'MISMATCH'}")
