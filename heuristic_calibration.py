"""Is the Q heuristic squashed on test states deeper than anything seen in training,
and is that why weighted A* (w>1) wins?

qstar.py searches with f = g + w*(-Q(s,a)), unit step cost. Its own comment asserts
h = -Q is compressed ("DQN outputs ~-123 where true cost-to-go ~700"), so g dominates f
and Q* degenerates toward uniform-cost search; w re-scales h onto the true cost scale.
That is an assertion, not a measurement. This measures it.

METHOD. Walk each instance's OPTIMAL plan. At step i of a length-L plan the true
cost-to-go is exactly L-i, so every state on the path is a labelled example -- no state
space enumeration needed. Record (true, h_pred = -max_a Q(s,a)) and compare splits.

WHAT TO READ.
  train vs test true-distance range -> is the test set outside the training range at all?
  h_pred by true-distance bucket    -> does h_pred flatten as true grows? that is squashing
  implied w = median(true/h_pred)   -> the factor that would put h back on the true scale
If the implied w lands near the w that empirically won the sweep, the compression story
is the explanation. If it does not, something else is driving the sweep.

Only grid and rovers have .plan files on BOTH sides; the other four domains cannot be
measured this way.

Usage: venv/bin/python heuristic_calibration.py NAME:DATASET_DIR:MODEL [...] [--n 40]
"""
import sys, glob, os, statistics as st, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device

N_INST = int(sys.argv[sys.argv.index("--n") + 1]) if "--n" in sys.argv else 40
SETS = [a for a in sys.argv[1:] if ":" in a]
if not SETS:
    sys.exit(__doc__)
dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")

for spec in SETS:
    name, ddir, mpath = spec.split(":")
    dom = mm.Domain(ddir + "/domain.pddl")
    model, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(mpath), dev)
    model.eval()

    @torch.no_grad()
    def h_of(state, goal):
        acts = state.generate_applicable_actions()
        if len(acts) == 0:
            return None
        q = model.forward([(state, list(acts), goal)]).readout("q")[0]
        return -q.max().item()          # best action's estimate of cost-to-go

    print(f"\n{'='*78}\n{name.upper()}   model={os.path.basename(mpath)}\n{'='*78}")
    per_split = {}
    for split in ("train", "test"):
        pts = []
        files = sorted(glob.glob(f"{ddir}/{split}/*.pddl"))
        files = [f for f in files if "domain" not in os.path.basename(f)
                 and os.path.exists(f + ".plan")]
        if not files:
            print(f"  {split}: no instances with .plan -- skipped")
            continue
        files = files[:: max(1, len(files) // N_INST)][:N_INST]
        for pf in files:
            plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
            if not plan:
                continue
            prob = mm.Problem(dom, pf)
            s = prob.get_initial_state(); g = prob.get_goal_condition()
            L = len(plan)
            step = max(1, L // 15)                     # ~15 points per instance
            for i, line in enumerate(plan):
                if i % step == 0:
                    hp = h_of(s, g)
                    if hp is not None:
                        pts.append((L - i, hp))        # (true cost-to-go, predicted)
                nxt = next((a for a in s.generate_applicable_actions()
                            if canon(a) == canon(line)), None)
                if nxt is None:
                    break
                s = nxt.apply(s)
        per_split[split] = pts
        tr = [t for t, _ in pts]
        print(f"\n  {split}: {len(pts)} states from {len(files)} instances   "
              f"true cost-to-go {min(tr)}..{max(tr)} (median {st.median(tr):.0f})")
        print(f"    {'true bucket':<16}{'n':>6}{'med true':>10}{'med h_pred':>12}"
              f"{'ratio true/h':>14}")
        buckets = [(1, 10), (10, 20), (20, 40), (40, 80), (80, 160), (160, 10**9)]
        for lo, hi in buckets:
            b = [(t, h) for t, h in pts if lo <= t < hi]
            if len(b) < 3:
                continue
            mt = st.median([t for t, _ in b]); mh = st.median([h for _, h in b])
            lab = f"{lo}-{hi if hi < 10**9 else '+'}"
            print(f"    {lab:<16}{len(b):>6}{mt:>10.0f}{mh:>12.1f}"
                  f"{(mt/mh if mh > 1e-6 else float('nan')):>14.2f}")
        rat = [t / h for t, h in pts if h > 1e-6]
        if rat:
            print(f"    implied w = median(true/h_pred) = {st.median(rat):.2f}")
    if "train" in per_split and "test" in per_split:
        rtr = [t / h for t, h in per_split["train"] if h > 1e-6]
        rte = [t / h for t, h in per_split["test"] if h > 1e-6]
        if rtr and rte:
            print(f"\n  implied w  train {st.median(rtr):.2f}   test {st.median(rte):.2f}")
            print(f"  -> h is under-estimating by {st.median(rte):.1f}x on test states.")
