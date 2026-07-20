"""
WHY the learned models fail on barman  (July 2026)

Two *different* failure mechanisms, both confirmed with numbers below.

--- DQN v2 (why Q* gets only ~3.7% coverage) ---
It is NOT untrained: walking the optimal plan of a solved test instance, DQN ranks
the correct next action #1 in 60% of steps (median rank 1 of ~16 applicable). The
failure is a SEARCH PLATEAU, not bad ordering:
  * median cost spread (max-min of -Q) across applicable actions is only ~2.4
  * ~42% of applicable actions fall within 1.0 cost-unit of the best (g-step is 1.0)
Barman has many *symmetric* actions (grasp shot1..shotN, fill any shot, ...) with
near-identical Q, so ~4 actions per state share the same f-layer. Over a 60-step
plan a ~4-way tie per step fans out combinatorially -> Q* exhausts ~10^5 nodes
stuck at one f (observed: 98245 nodes at f=87.690). Weighting (w>1) multiplies the
2.4 spread and breaks *some* ties (buys the 3.7%) but cannot invent discrimination
among truly symmetric actions over a long exact horizon.

--- SAC v1 (why it solves 0, always, in-distribution) ---
The critic is COLLAPSED: over a greedy walk min(q1,q2) stays in -6.68..-6.34, a
spread of only ~0.31 across actions and ~0.34 over the whole walk. A near-constant
value function -> argmax is decided by noise -> greedy falls into a grasp<->leave
2-cycle within 3 steps. Cause: SAC's entropy-driven stochastic exploration never
reaches a 60+-step goal behind reversible actions during training, so the critic
never sees a grounded terminal return; -1 + g*Q with no grounding has a flat
fixed point everywhere. This is a training failure (taxonomy case c) that weighting
cannot fix -- multiplying a 0.31 spread still yields no usable ordering.

Run: venv/bin/python barman_failure_diagnosis.py
"""
import torch, statistics
from collections import Counter
import pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device

dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "").replace("(", "").replace(")", "")

# ---------- DQN v2: ranking + cost dispersion along the optimal path ----------
dom2 = mm.Domain("example/barman_dataset_v2/domain.pddl")
dqnr, _ = rgnn.RelationalGraphNeuralNetwork.load(dom2, Path("models/barman_v2_dqn.pth"), dev); dqnr.eval()
pf = "example/barman_dataset_v2/test/049_p-TST2-n35-c1i7s14-7.pddl"
plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
p = mm.Problem(dom2, pf); goal = p.get_goal_condition(); s = p.get_initial_state()
ranks, nact, best1, spreads, ties = [], [], 0, [], []
with torch.no_grad():
    for line in plan:
        acts = s.generate_applicable_actions()
        cost = -dqnr.forward([(s, acts, goal)]).readout('q')[0]
        order = torch.argsort(cost).tolist()
        cm = {canon(str(a)): j for j, a in enumerate(acts)}
        pj = cm.get(canon(line))
        cmin = cost.min().item()
        spreads.append(cost.max().item() - cmin)
        ties.append((cost <= cmin + 1.0).sum().item())
        if pj is not None:
            r = order.index(pj) + 1; ranks.append(r); nact.append(len(acts))
            if r == 1: best1 += 1
        nxt = next((a for a in acts if canon(a) == canon(line)), None)
        if nxt is None: break
        s = nxt.apply(s)
print("=== DQN v2 on optimal path of 049 (len %d) ===" % len(plan))
print(f"plan action ranked #1: {best1}/{len(ranks)} ({100*best1/len(ranks):.0f}%), median rank {statistics.median(ranks):.0f}/{statistics.median(nact):.0f}")
print(f"median cost spread across actions: {statistics.median(spreads):.2f}; median #actions within 1.0 of best: {statistics.median(ties):.0f}")

# ---------- SAC v1: value collapse on a v1 test instance ----------
dom1 = mm.Domain("example/barman_dataset/domain.pddl")
q1r, _ = rgnn.RelationalGraphNeuralNetwork.load(dom1, Path("models/barman_sac_q1.pth"), dev); q1r.eval()
q2r, _ = rgnn.RelationalGraphNeuralNetwork.load(dom1, Path("models/barman_sac_q2.pth"), dev); q2r.eval()
p1 = mm.Problem(dom1, "example/barman_dataset/test/000_p11.pddl")
goal1 = p1.get_goal_condition(); s = p1.get_initial_state()
seen, verbs, vals, vspr = set(), [], [], []
with torch.no_grad():
    for step in range(40):
        if goal1.holds(s): print("SAC SOLVED at", step); break
        acts = s.generate_applicable_actions()
        v = torch.minimum(q1r.forward([(s, acts, goal1)]).readout('q')[0],
                          q2r.forward([(s, acts, goal1)]).readout('q')[0])
        j = int(v.argmax()); verbs.append(str(acts[j]).split()[0].lstrip("("))
        vals.append(v.max().item()); vspr.append((v.max() - v.min()).item())
        nxt = acts[j].apply(s)
        if str(nxt) in seen: print(f"SAC greedy CYCLE at step {step}"); break
        seen.add(str(nxt)); s = nxt
print("\n=== SAC v1 greedy walk (000_p11) ===")
print(f"top-action verbs: {dict(Counter(verbs))}")
print(f"value range {min(vals):.2f}..{max(vals):.2f}, median spread across actions {statistics.median(vspr):.2f}")
