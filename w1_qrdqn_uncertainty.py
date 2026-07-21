"""
Offline check: does the QR-DQN's W1 Bellman residual track UNCERTAINTY (ensemble
disagreement), across all distances? Directly comparable to the width table. (July 2026)

W1(s) = 1-Wasserstein( Z(s,a*), -1 + gamma*Z(s',b*) ), a*=argmax mean, b*=argmax mean at s'.
Label = std over 5 independent SAC members of max_a min(q1,q2) (epistemic uncertainty).
AUC = P(W1 higher at HIGH-disagreement than LOW-disagreement), tercile split, binned by
distance. Small pool: exact distance. Large instances: bin by -QRDQN value (distance proxy).
"""
import glob, random, statistics
from pathlib import Path
import torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves, rank_auc
from bellman_statespace_label import sample_states

GAMMA = 0.999
dev = create_device(False)
taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

def w1(a, b):
    return (a.sort().values - b.sort().values).abs().mean().item()

def make(domain_file):
    dom = mm.Domain(domain_file)
    qr, _, _ = _load_iqn(dom, Path("models/grid_iqn_qrdqn_best.pth"), dev); qr.eval()
    ens = []
    for i in range(1, 6):
        e1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q1_best.pth"), dev)[0], "q")
        e2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q2_best.pth"), dev)[0], "q")
        ens.append((e1, e2))
    def disagree(s, g):
        vs = []
        for a, b in ens:
            v1, ac = a.forward([(s, g)])[0]
            if len(ac) == 0: return None
            v2, _ = b.forward([(s, g)])[0]; vs.append(torch.minimum(v1, v2).max().item())
        return statistics.pstdev(vs)
    def sig(s, g):
        """returns (W1, width, dist_proxy, greedy_successor)"""
        qs, acts = iqn_curves(qr, s, g, taus)
        if qs is None or not acts: return None
        means = qs.mean(1); ai = int(means.argmax()); curve = qs[ai]
        width = (curve[89] - curve[9]).item()
        s2 = acts[ai].apply(s)
        qs2, a2 = iqn_curves(qr, s2, g, taus)
        wv = None
        if qs2 is not None and a2:
            bi = int(qs2.mean(1).argmax()); wv = w1(curve, -1 + GAMMA * qs2[bi])
        return wv, width, -means[ai].item(), s2
    return dom, disagree, sig

def banded(rows, bands, sidx):
    out = []
    for lo, hi in bands:
        g = [r for r in rows if lo <= r[0] < hi]
        if len(g) < 30: out.append((None, len(g))); continue
        ds = sorted(r[1] for r in g); loq, hiq = ds[len(ds)//3], ds[2*len(ds)//3]
        hi_s = [r[sidx] for r in g if r[1] >= hiq]; lo_s = [r[sidx] for r in g if r[1] <= loq]
        out.append((rank_auc(hi_s, lo_s) if len(hi_s) > 5 and len(lo_s) > 5 else None, len(g)))
    return out

# ---- small pool: exact distance ----
domS, disS, sigS = make("../Domains/Domains2/grid/domain.pddl")
rng = random.Random(0)
files = [p for p in sorted(glob.glob("../Domains/Domains2/grid/instances/*.pddl")) if "domain" not in p]
rng.shuffle(files)
small = []; used = 0
with torch.no_grad():
    for f in files:
        if used >= 40: break
        p = mm.Problem(domS, f); ss = mm.StateSpaceSampler.new(p, 200_000)
        if ss is None or ss.max_steps_to_goal() < 4: continue
        ss.set_seed(0); g = p.get_goal_condition()
        for s in sample_states(ss, ss.max_steps_to_goal(), 45, rng):
            lab = ss.get_state_label(s)
            if lab.is_goal or lab.is_dead_end: continue
            r = sigS(s, g); dv = disS(s, g)
            if r and r[0] is not None and dv is not None:
                small.append((lab.steps_to_goal, dv, r[0], r[1]))   # (dist, disagree, W1, width)
        used += 1

# ---- far field: large test instances, greedy walk, bin by -qrdqn value ----
domL, disL, sigL = make("example/grid_dataset/domain.pddl")
far = []
with torch.no_grad():
    for f in sorted(glob.glob("example/grid_dataset/test/*.pddl"))[:70]:
        p = mm.Problem(domL, f); g = p.get_goal_condition(); s = p.get_initial_state()
        for _ in range(25):
            if g.holds(s): break
            r = sigL(s, g); dv = disL(s, g)
            if r is None: break
            if r[0] is not None and dv is not None:
                far.append((r[2], dv, r[0], r[1]))                  # (dist_proxy, disagree, W1, width)
            s = r[3]

print("QR-DQN offline: does the signal track ENSEMBLE DISAGREEMENT (uncertainty)? 0.5 = none.\n")
print(f"{'band':>12}{'n':>6}{'W1 AUC':>9}{'width AUC':>11}")
for (a1, n), (aw, _), lab in zip(banded(small, [(1,10),(11,22)], 2), banded(small, [(1,10),(11,22)], 3), ["d 1-10","d 11-22"]):
    print(f"{lab:>12}{n:>6}{(f'{a1:.3f}' if a1 else '-'):>9}{(f'{aw:.3f}' if aw else '-'):>11}")
fb = [(20,40),(40,70),(70,110),(110,1e9)]
labs = ["~20-40","~40-70","~70-110","110+"]
for (a1, n), (aw, _), lab in zip(banded(far, fb, 2), banded(far, fb, 3), labs):
    print(f"{lab:>12}{n:>6}{(f'{a1:.3f}' if a1 else '-'):>9}{(f'{aw:.3f}' if aw else '-'):>11}")
print("\n(width shown alongside as the reference; W1 is the signal under test)")
