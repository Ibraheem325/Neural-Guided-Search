"""
Do the single-model signals (width, W1 Bellman residual) fire where the model is
UNCERTAIN -- not where it is wrong?  (July 2026)

THE RIGHT QUESTION (user's framing). Earlier tests labelled a state by whether the model's
value was WRONG (|V - (-d)|). That is the wrong target: a confidently-wrong model SHOULD
stay quiet, and an uncertain-but-right model SHOULD fire. The purpose of width / W1 is to
find where the model LACKS EXPRESSIVITY, so search can compensate there.

GROUND-TRUTH UNCERTAINTY = ENSEMBLE DISAGREEMENT. Where 5 INDEPENDENTLY trained models
disagree, the data did not pin the value down -> that is exactly "the model is uncertain /
lacks expressivity here." This is the standard epistemic-uncertainty proxy, and it needs NO
oracle distance, so it works at ANY distance -- including the far field the calibration test
could never reach. The SAC ensemble is used for the label because SAC stays responsive far
from the goal (reaches ~-104) where the old IQN ensemble saturates (~-9.5) and its
disagreement would collapse to noise.

    D(s) = std over the 5 SAC members of  V_i(s) = max_a min(q1_i, q2_i)(s,a)

SIGNAL (from a single, independent model -- the calibrated QR-DQN winner):
    width(s) = q90 - q10 of the best action's return distribution
    W1(s)    = W1( Z(s,a*),  -1 + gamma * Z(s',b*) )   (1-step Bellman residual)

METRIC. Within a distance band (to remove the scale confound: both D and width grow with
distance), AUC = P(signal higher at a HIGH-disagreement state than at a LOW-disagreement
state), high/low = top/bottom tercile of D. 0.5 = the signal does NOT track uncertainty.
Also a far-field Spearman on large test instances (no oracle), with the scale confound noted.

Run: venv/bin/python signal_vs_ensemble_uncertainty.py
"""
import argparse, glob, random, statistics
from pathlib import Path
import numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves, rank_auc
from bellman_statespace_label import sample_states

GAMMA = 0.999

def w1(a, b): return (a.sort().values - b.sort().values).abs().mean().item()

ap = argparse.ArgumentParser()
ap.add_argument("--domain_file", default="../Domains/Domains2/grid/domain.pddl", type=Path)
ap.add_argument("--instances", default="../Domains/Domains2/grid/instances", type=Path)
ap.add_argument("--test_dir", default="example/grid_dataset/test", type=Path)
ap.add_argument("--signal_model", default="models/grid_iqn_qrdqn_best.pth")
ap.add_argument("--max_instances", default=40, type=int)
ap.add_argument("--score_states", default=45, type=int)
ap.add_argument("--seed", default=0, type=int)
a = ap.parse_args()

dev = create_device(False); domain = mm.Domain(str(a.domain_file))
taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
sig, _, _ = _load_iqn(domain, Path(a.signal_model), dev); sig.eval()
# SAC ensemble members -> disagreement label
ens = []
for i in range(1, 6):
    q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"models/grid_sac_ens_{i}_q1_best.pth"), dev)[0], "q")
    q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"models/grid_sac_ens_{i}_q2_best.pth"), dev)[0], "q")
    ens.append((q1, q2))

def disagreement(s, g):
    vs = []
    for q1, q2 in ens:
        v1, _ = q1.forward([(s, g)])[0]; v2, _ = q2.forward([(s, g)])[0]
        vs.append(torch.minimum(v1, v2).max().item())
    return statistics.pstdev(vs)

def signals(s, g):
    qs, acts = iqn_curves(sig, s, g, taus)
    if qs is None or not acts: return None
    means = qs.mean(dim=1); ai = int(means.argmax())
    width = (qs[ai].quantile(0.9) - qs[ai].quantile(0.1)).item()
    s2 = acts[ai].apply(s)
    qs2, a2 = iqn_curves(sig, s2, g, taus)
    res = None
    if qs2 is not None and a2:
        bi = int(qs2.mean(dim=1).argmax())
        res = w1(qs[ai], -1 + GAMMA * qs2[bi])
    return width, res

# -------- small pool: banded AUC (controls for the distance/scale confound) --------
rng = random.Random(a.seed)
files = [p for p in sorted(glob.glob(str(a.instances / "*.pddl"))) if "domain" not in p]
rng.shuffle(files)
rows = []; used = 0
with torch.no_grad():
    for f in files:
        if used >= a.max_instances: break
        p = mm.Problem(domain, f); ss = mm.StateSpaceSampler.new(p, 200_000)
        if ss is None or ss.max_steps_to_goal() < 4: continue
        ss.set_seed(a.seed); g = p.get_goal_condition()
        for s in sample_states(ss, ss.max_steps_to_goal(), a.score_states, rng):
            lab = ss.get_state_label(s)
            if lab.is_goal or lab.is_dead_end: continue
            sg = signals(s, g)
            if sg is None or sg[1] is None: continue
            rows.append((lab.steps_to_goal, disagreement(s, g), sg[0], sg[1]))
        used += 1

def banded(rows, sidx, bands):
    out = []
    for lo, hi in bands:
        g = [r for r in rows if lo <= r[0] <= hi]
        if len(g) < 30: out.append(None); continue
        ds = sorted(r[1] for r in g)
        loq, hiq = ds[len(ds)//3], ds[2*len(ds)//3]
        hi_s = [r[sidx] for r in g if r[1] >= hiq]
        lo_s = [r[sidx] for r in g if r[1] <= loq]
        out.append(rank_auc(hi_s, lo_s) if len(hi_s) > 5 and len(lo_s) > 5 else None)
    return out

BANDS = [(1, 10), (11, 22)]
print(f"\nSignal model: {a.signal_model}")
print("Does the signal fire where the SAC ENSEMBLE DISAGREES (= model is uncertain)?")
print("Banded AUC (controls distance). 0.5 = signal does NOT track uncertainty.\n")
print(f"{'signal':<10}{'d 1-10':>9}{'d 11-22':>10}   (n={len(rows)})")
for name, idx in (("width", 2), ("W1 resid", 3)):
    cells = banded(rows, idx, BANDS)
    print(f"{name:<10}" + "".join(f"{c:>9.3f}" if c is not None else f"{'-':>9}" for c in cells))

# -------- far field: large test instances, Spearman (no oracle) --------
def spearman(x, y):
    xr = np.argsort(np.argsort(x)); yr = np.argsort(np.argsort(y))
    return float(np.corrcoef(xr, yr)[0, 1])

far = []
canon = lambda z: str(z).lower().replace(" ", "")
with torch.no_grad():
    for f in sorted(glob.glob(str(a.test_dir / "*.pddl")))[:60]:
        p = mm.Problem(domain, f); g = p.get_goal_condition(); s = p.get_initial_state()
        for _ in range(12):                      # walk a few steps into each instance
            if g.holds(s): break
            sg = signals(s, g)
            if sg is not None and sg[1] is not None:
                far.append((disagreement(s, g), sg[0], sg[1]))
            acts = s.generate_applicable_actions()
            if not acts: break
            qs, _ = iqn_curves(sig, s, g, taus)
            s = acts[int(qs.mean(dim=1).argmax())].apply(s)
if far:
    D = [r[0] for r in far]
    print(f"\nFAR FIELD (large test instances, {len(far)} states, no oracle): Spearman(signal, disagreement)")
    print(f"  width vs disagreement : {spearman([r[1] for r in far], D):+.3f}")
    print(f"  W1    vs disagreement : {spearman([r[2] for r in far], D):+.3f}")
    print("  (confounded by distance -- both grow with it; banded small-pool numbers are the clean test)")
