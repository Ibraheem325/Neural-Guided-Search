"""
Why a 20-step greedy walk cannot identify the correction factor w, while the
whole-state-space fit can. Direct simulation. (July 2026)

The supervisor's proposal: walk ~20 steps, use "each step costs 1" to solve for w from the
per-step value drops. This script runs exactly that, many times, and reports the SPREAD of
the resulting w across independent walks -- next to the whole-state-space fit for reference.

'Noise' here means: the model's value is not a smooth function of distance. Two states one
step apart should differ by exactly 1; in practice that difference scatters, and a large
fraction of single steps have the WRONG SIGN (the model rates the state that is one step
CLOSER as worse). Over only ~20 steps those errors do not average out.
"""
import argparse, glob, random
from pathlib import Path
import numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ

ap = argparse.ArgumentParser()
ap.add_argument("--domain_file", default="../Domains/Domains2/grid/domain.pddl", type=Path)
ap.add_argument("--instances", default="../Domains/Domains2/grid/instances", type=Path)
ap.add_argument("--dqn", default="models/grid_dqn.pth")
ap.add_argument("--walk", default=20, type=int)
ap.add_argument("--max_instances", default=60, type=int)
ap.add_argument("--seed", default=0, type=int)
a = ap.parse_args()

dev = create_device(False); domain = mm.Domain(str(a.domain_file))
dqn = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(a.dqn), dev)[0], "q")
V = lambda s, g: dqn.forward([(s, g)])[0][0].max().item()

rng = random.Random(a.seed)
files = [p for p in sorted(glob.glob(str(a.instances / "*.pddl"))) if "domain" not in p]
rng.shuffle(files)

all_steps, walk_ws, all_pairs = [], [], []
used = 0
with torch.no_grad():
    for f in files:
        if used >= a.max_instances: break
        p = mm.Problem(domain, f)
        ss = mm.StateSpaceSampler.new(p, 200_000)
        if ss is None or ss.max_steps_to_goal() < a.walk: continue
        ss.set_seed(a.seed); goal = p.get_goal_condition()
        # start as far from the goal as possible, then walk optimally toward it
        try: s = list(ss.sample_states_n_steps_from_goal(ss.max_steps_to_goal(), 1))[0]
        except Exception: continue
        drops = []
        for _ in range(a.walk):
            lab = ss.get_state_label(s)
            if lab.is_goal or lab.is_dead_end: break
            d0 = lab.steps_to_goal
            all_pairs.append((d0, V(s, goal)))
            nxt = None
            for act in s.generate_applicable_actions():
                s2 = act.apply(s); l2 = ss.get_state_label(s2)
                if not l2.is_dead_end and l2.steps_to_goal == d0 - 1: nxt = s2; break
            if nxt is None: break
            drops.append(V(s, goal) - V(nxt, goal))
            s = nxt
        if len(drops) >= a.walk // 2:
            all_steps += drops
            walk_ws.append(-1.0 / np.mean(drops))     # his estimator, on THIS walk
        used += 1

e = np.array(all_steps); w = np.array(walk_ws)
wrong = (e > 0).mean()
print(f"\nDQN on grid: {used} instances, {len(w)} independent {a.walk}-step optimal walks, {len(e)} steps total.\n")
print("INDIVIDUAL STEPS  (each should give a drop of exactly -1.00)")
print(f"   mean {e.mean():+.3f}   sd {e.std():.3f}   min {e.min():+.2f}   max {e.max():+.2f}")
print(f"   fraction of steps with the WRONG SIGN (model says the closer state is worse): {wrong*100:.0f}%")
print(f"\nw ESTIMATED FROM EACH {a.walk}-STEP WALK SEPARATELY  (his protocol)")
q = np.percentile(w, [5, 25, 50, 75, 95])
print(f"   5%={q[0]:+.2f}  25%={q[1]:+.2f}  median={q[2]:+.2f}  75%={q[3]:+.2f}  95%={q[4]:+.2f}")
print(f"   min={w.min():+.2f}   max={w.max():+.2f}   sd={w.std():.2f}")
print(f"   -> spread across walks spans {q[4]-q[0]:.1f} units; two walks on the SAME model")
print(f"      disagree by more than the quantity being estimated.")
D = np.array([r[0] for r in all_pairs], float); Vv = np.array([r[1] for r in all_pairs], float)
wl, _ = np.linalg.lstsq(np.stack([Vv, np.ones_like(Vv)], 1), -D, rcond=None)[0]
r2 = np.corrcoef(Vv, -D)[0, 1] ** 2
print(f"\nWHOLE-STATE-SPACE FIT (all {len(D)} states, exact distances, one line)")
print(f"   w = {wl:.3f}   R^2 = {r2:.3f}   <- ONE stable number, because the fit spans the")
print(f"   full distance range instead of one step, so the per-state scatter averages out.")
