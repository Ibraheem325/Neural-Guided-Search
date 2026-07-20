"""
WHERE does the IQN lose the distance signal, and how does it differ from the DQN?
(July 2026)

THE QUESTION. On big test instances the IQN reports ~-9.5 regardless of true
distance, while the DQN still reaches ~-123. Both read the SAME GNN action
embedding and both train with huber_loss(delta=1.0), so the loss shape is NOT the
difference. The decisive question is WHERE the IQN goes flat:
  * flat only BEYOND its training range (<=~22)  -> an EXTRAPOLATION failure
  * flat even WITHIN the training range          -> an in-distribution LEARNING failure
These call for completely different fixes, so measure before theorising.

METHOD. Small pool -> mm.StateSpaceSampler gives the EXACT distance to goal. For
each true distance d, average V_IQN(s) = max_a mean_tau Z(s,a) and V_DQN(s) =
max_a Q(s,a) over the SAME states, and report the per-step slope of each.

Run:
  venv/bin/python iqn_vs_dqn_calibration.py \
    --domain_file "../Domains/Domains2/grid/domain.pddl" \
    --instances   "../Domains/Domains2/grid/instances" \
    --iqn models/grid_iqn.pth --dqn models/grid_dqn.pth --max_instances 40
"""
import argparse, glob, random, statistics
from pathlib import Path
import numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves

ap = argparse.ArgumentParser()
ap.add_argument("--domain_file", required=True, type=Path)
ap.add_argument("--instances", required=True, type=Path)
ap.add_argument("--iqn", required=True, type=Path)
ap.add_argument("--dqn", required=True, type=Path)
ap.add_argument("--max_instances", default=40, type=int)
ap.add_argument("--max_states", default=200_000, type=int)
ap.add_argument("--per_d", default=3, type=int)
ap.add_argument("--seed", default=0, type=int)
a = ap.parse_args()

dev = create_device(False); domain = mm.Domain(str(a.domain_file))
taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
iqn, _, _ = _load_iqn(domain, a.iqn, dev); iqn.eval()
dqn = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, a.dqn, dev)[0], "q")

rows = []
rng = random.Random(a.seed)
files = [p for p in sorted(glob.glob(str(a.instances / "*.pddl"))) if "domain" not in p]
rng.shuffle(files); used = 0
with torch.no_grad():
    for f in files:
        if used >= a.max_instances: break
        p = mm.Problem(domain, f)
        ss = mm.StateSpaceSampler.new(p, a.max_states)
        if ss is None or ss.max_steps_to_goal() < 3: continue
        ss.set_seed(a.seed); goal = p.get_goal_condition()
        for d in range(1, ss.max_steps_to_goal() + 1):
            try: sts = list(ss.sample_states_n_steps_from_goal(d, a.per_d))
            except Exception: continue
            for s in sts:
                lab = ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end: continue
                qs, _ = iqn_curves(iqn, s, goal, taus)
                if qs is None: continue
                vi = qs.mean(dim=1).max().item()
                vd = dqn.forward([(s, goal)])[0][0].max().item()
                rows.append((lab.steps_to_goal, vi, vd))
        used += 1

print(f"\nSAME states, {used} grid instances, n={len(rows)}. Exact distance from StateSpaceSampler.")
print(f"{'true d':>7} | {'V_IQN':>8} | {'V_DQN':>9} |  n")
ds = sorted({r[0] for r in rows})
for d in ds:
    g = [r for r in rows if r[0] == d]
    if len(g) < 2: continue
    print(f"{d:>7} | {statistics.mean(x[1] for x in g):>8.2f} | {statistics.mean(x[2] for x in g):>9.2f} | {len(g):>3}")

def slope(lo, hi, idx):
    sel = [r for r in rows if lo <= r[0] <= hi]
    if len(sel) < 10: return None
    X = np.array([r[0] for r in sel], float); Y = np.array([r[idx] for r in sel], float)
    return np.polyfit(X, Y, 1)[0]

print("\nPER-STEP SLOPE (dV/dd; a perfectly calibrated model would be -1.00):")
for lo, hi in [(1, 5), (1, 10), (10, 20), (1, 22)]:
    si, sd = slope(lo, hi, 1), slope(lo, hi, 2)
    if si is None: continue
    print(f"  d in [{lo:>2},{hi:>2}]   IQN {si:>7.3f}   DQN {sd:>7.3f}")
print("\nIf the IQN slope is already ~0 for d<=22 it is an IN-DISTRIBUTION learning failure,")
print("not extrapolation -- rescaling/retraining-range fixes would not help.")
