"""Is the QR-DQN width signal even relevant to the SAC value function that drives search?

We widen exploration at high QR-DQN-width nodes, but the search's leaf value is the SAC
critic min(q1,q2). If QR-DQN uncertainty doesn't line up with where SAC is unreliable, we
are reading the wrong model (the user's concern).

On probe optimal-path states (exact remaining distance d), per state:
    value_qr  = max_a mean Z(s,a)        width_qr = q90-q10 of the best action's Z(s,a)
    value_sac = max_a min(q1,q2)(s,a)
Fit each model's own affine calibration to d -> residual = that model's ERROR at s.
Report (within-distance, to kill the distance confound):
  (0) corr(value_qr, value_sac)                     -- are they the same value function?
  (1) Spearman(width_qr, |SAC error|)               -- does QR-DQN width predict where SAC is wrong?
  (2) Spearman(width_qr, |QR-DQN error|)            -- ...vs where QR-DQN itself is wrong?
  (3) corr(QR-DQN error, SAC error)                 -- do the two models fail in the same places?
Run: venv/bin/python qrdqn_vs_sac_relevance.py
"""
import glob, os, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from collections import defaultdict
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn

PROBE = "example/probe_near_goal_d5-20"
dev = create_device(False)
dom = mm.Domain(f"{PROBE}/domain.pddl")
q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q1.pth"), dev)[0], "q")
q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q2.pth"), dev)[0], "q")
iqn, _, _ = _load_iqn(dom, Path("models/grid_iqn_qrdqn_best.pth"), dev); iqn.eval()
TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
canon = lambda x: str(x).lower().replace(" ", "")


@torch.no_grad()
def vals(state, goal):
    q, acts = iqn.forward([(state, goal)], taus=TAUS)[0]
    if q.shape[0] == 0:
        return None
    qs, _ = torch.sort(q, dim=1)
    means = qs.mean(dim=1)
    bi = int(means.argmax())
    v_qr = means[bi].item()
    width = (qs[bi][89] - qs[bi][9]).item()
    v1, a1 = q1.forward([(state, goal)])[0]
    v2, _ = q2.forward([(state, goal)])[0]
    v_sac = torch.minimum(v1, v2).max().item()
    return v_qr, width, v_sac


files = sorted(f for f in glob.glob(f"{PROBE}/*.pddl") if "domain" not in os.path.basename(f))
deepest = {}
for f in files:
    p = os.path.basename(f)[:-5].split("_"); src = "_".join(p[2:]); d = int(p[1][1:])
    if src not in deepest or d > deepest[src][0]:
        deepest[src] = (d, f)
sample = [v[1] for _, v in sorted(deepest.items())]

D, VQ, W, VS = [], [], [], []
for pf in sample:
    plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
    prob = mm.Problem(dom, pf); s = prob.get_initial_state(); g = prob.get_goal_condition()
    for i, line in enumerate(plan):
        d = len(plan) - i
        r = vals(s, g)
        if r:
            D.append(d); VQ.append(r[0]); W.append(r[1]); VS.append(r[2])
        nxt = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
        if nxt is None:
            break
        s = nxt.apply(s)
print(f"collected {len(D)} states\n", flush=True)


def corr(a, b):
    ma = sum(a)/len(a); mb = sum(b)/len(b)
    num = sum((x-ma)*(y-mb) for x, y in zip(a, b))
    da = (sum((x-ma)**2 for x in a))**.5; db = (sum((y-mb)**2 for y in b))**.5
    return num/(da*db) if da and db else 0.0

def resid(y, x):
    mx = sum(x)/len(x); my = sum(y)/len(y)
    sxx = sum((xi-mx)**2 for xi in x); sxy = sum((xi-mx)*(yi-my) for xi, yi in zip(x, y))
    a = sxy/sxx if sxx else 0; b = my - a*mx
    return [yi-(a*xi+b) for xi, yi in zip(x, y)]

EQ = resid(VQ, D); ES = resid(VS, D)         # per-model error (residual from own distance calibration)
def spearman(x, y):
    rx = {v: i for i, v in enumerate(sorted(range(len(x)), key=lambda t: x[t]))}
    ry = {v: i for i, v in enumerate(sorted(range(len(y)), key=lambda t: y[t]))}
    return corr([rx[i] for i in range(len(x))], [ry[i] for i in range(len(y))])

print(f"(0) corr(value_qr, value_sac) overall = {corr(VQ, VS):+.3f}   "
      f"(1.0 = identical ranking of states; low = different value functions)")
print(f"(3) corr(QR-DQN error, SAC error) overall = {corr(EQ, ES):+.3f}   "
      f"(do the two models fail in the same places?)")

byd = defaultdict(lambda: ([], [], []))       # d -> (width, |qr_err|, |sac_err|)
for k in range(len(D)):
    byd[D[k]][0].append(W[k]); byd[D[k]][1].append(abs(EQ[k])); byd[D[k]][2].append(abs(ES[k]))
print(f"\nWithin each distance (removes the distance confound):")
print(f"  {'d':>3}{'n':>5}{'width->|SAC err|':>18}{'width->|QRDQN err|':>20}")
s_sac, s_qr = [], []
for d in sorted(byd):
    w, eq, es = byd[d]
    if len(w) >= 8:
        a = spearman(w, es); b = spearman(w, eq); s_sac.append(a); s_qr.append(b)
        print(f"  {d:>3}{len(w):>5}{a:>+18.3f}{b:>+20.3f}")
if s_sac:
    print(f"\n  median  width -> |SAC error|   = {statistics.median(s_sac):+.3f}   "
          f"(near 0 => QR-DQN width does NOT know where SAC is wrong -> irrelevant to search)")
    print(f"  median  width -> |QR-DQN error| = {statistics.median(s_qr):+.3f}   "
          f"(near 0 => width isn't even a good uncertainty signal for its OWN model)")
