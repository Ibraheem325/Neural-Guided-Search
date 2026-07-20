"""
Reviving barman DQN by changing the SEARCH, not the model  (July 2026)

Diagnosis (barman_failure_diagnosis.py): barman_v2_dqn learned usable local
ordering (60% top-1 on the optimal path) but Q* (f = g + h) exhausts ~10^5 nodes
and fails, because barman's many SYMMETRIC actions give near-tied costs (~42% of
applicable actions within 1.0 of best) and the +g term forces the search to drain
every tied f-layer -> combinatorial plateau (observed 98245 nodes stuck at f=87.690).

Fix without retraining: drop g. Greedy best-first (f = h = -Q) follows the model's
ordering directly and cannot form the tie-plateau. RESULT on the first 4 v2 test
instances: 3/4 solved in 72-178 expansions (vs Q* ~0 solved, ~10^5 nodes). ~1000x
fewer expansions AND turns failures into solves. => the DQN was never the problem;
Q* was the wrong search for a symmetric long-horizon domain. (Beam search, which
also bounds frontier width, likewise solves these -- it produced our 049 plan.)

Run: venv/bin/python barman_gbfs_revival.py
"""
import torch, heapq, itertools, glob, os
import pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device, get_state_key

dev = create_device(False)
dom = mm.Domain("example/barman_dataset_v2/domain.pddl")
dqnr, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/barman_v2_dqn.pth"), dev); dqnr.eval()

def gbfs(problem, budget=6000):
    goal = problem.get_goal_condition(); s0 = problem.get_initial_state()
    if goal.holds(s0): return ("Solved", 0)
    closed = {get_state_key(s0)}; openl = []; cnt = itertools.count(); exp = 0
    with torch.no_grad():
        acts = s0.generate_applicable_actions()
        q = dqnr.forward([(s0, acts, goal)]).readout('q')[0]
        for a, c in zip(acts, (-q).tolist()): heapq.heappush(openl, (c, next(cnt), s0, a))
        while openl and exp < budget:
            h, _, st, a = heapq.heappop(openl); succ = a.apply(st); exp += 1
            if goal.holds(succ): return ("Solved", exp)
            k = get_state_key(succ)
            if k in closed: continue
            closed.add(k)
            acts = succ.generate_applicable_actions()
            if not acts: continue
            q = dqnr.forward([(succ, acts, goal)]).readout('q')[0]
            for a2, c in zip(acts, (-q).tolist()): heapq.heappush(openl, (c, next(cnt), succ, a2))
    return ("Fail/Timeout", exp)

files = sorted(f for f in glob.glob("example/barman_dataset_v2/test/*.pddl"))[:4]
print("GBFS (f = h only) with barman_v2_dqn, budget 6k:\n")
solved = 0
for f in files:
    st, exp = gbfs(mm.Problem(dom, f))
    solved += st == "Solved"
    print(f"  {os.path.basename(f)[:28]:28} {st:14} exp={exp}")
print(f"\nGBFS solved {solved}/{len(files)}  (Q* w=1 ~0; weighted Q* ~3.7% overall, exhausting ~10^5 nodes)")
