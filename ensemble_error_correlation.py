"""How error-correlated is the 5-seed SAC ensemble? (Tests whether disagreement is a
trustworthy uncertainty label, or whether members are 'confidently wrong together'.)

On probe optimal-path states (exact remaining distance known), for each of the 5 members:
    V_i(s) = max_a min(q1_i, q2_i)(s,a)
Fit each member's own affine calibration to true distance (V_i ~ a_i*d + b_i), take the
RESIDUAL e_i(s) = V_i(s) - (a_i*d + b_i) as that member's error at s. Then:
  (1) pairwise correlation of the members' errors  -> high = errors correlated = disagreement
      systematically UNDERESTIMATES true uncertainty (the user's concern).
  (2) does ensemble disagreement track the ensemble's actual |error|? (within-distance, to
      remove the distance confound) -> low = disagreement doesn't know where it's wrong.

Uses deepest-probe-per-source (distinct trajectories; avoids the nested-path duplication).
Run: venv/bin/python ensemble_error_correlation.py
"""
import glob, os, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from collections import defaultdict
from utils import create_device
import alphaZero_bellman as AZ

PROBE = "example/probe_near_goal_d5-20"
dev = create_device(False)
dom = mm.Domain(f"{PROBE}/domain.pddl")
ens = []
for i in range(1, 6):
    e1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q1_best.pth"), dev)[0], "q")
    e2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q2_best.pth"), dev)[0], "q")
    ens.append((e1, e2))
canon = lambda x: str(x).lower().replace(" ", "")


@torch.no_grad()
def member_values(state, goal):
    """V_i(s) = max_a min(q1_i,q2_i)(s,a) for each member; None if no actions."""
    vs = []
    for e1, e2 in ens:
        v1, acts = e1.forward([(state, goal)])[0]
        v2, _ = e2.forward([(state, goal)])[0]
        if v1.shape[0] == 0:
            return None
        vs.append(torch.minimum(v1, v2).max().item())
    return vs


# ---- collect (true_distance, [V_1..V_5]) on deepest-per-source plan tails ----
files = sorted(f for f in glob.glob(f"{PROBE}/*.pddl") if "domain" not in os.path.basename(f))
deepest = {}
for f in files:
    p = os.path.basename(f)[:-5].split("_"); src = "_".join(p[2:]); d = int(p[1][1:])
    if src not in deepest or d > deepest[src][0]:
        deepest[src] = (d, f)
sample = [v[1] for _, v in sorted(deepest.items())]

dists, V = [], [[] for _ in range(5)]
for pf in sample:
    plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
    prob = mm.Problem(dom, pf); s = prob.get_initial_state(); g = prob.get_goal_condition()
    for i, line in enumerate(plan):
        d = len(plan) - i
        vs = member_values(s, g)
        if vs is not None:
            dists.append(d)
            for m in range(5):
                V[m].append(vs[m])
        nxt = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
        if nxt is None:
            break
        s = nxt.apply(s)
print(f"collected {len(dists)} states from {len(sample)} trajectories\n", flush=True)

n = len(dists)
def lstsq_residuals(y, x):
    """residuals of y ~ a*x + b."""
    mx = sum(x)/len(x); my = sum(y)/len(y)
    sxx = sum((xi-mx)**2 for xi in x); sxy = sum((xi-mx)*(yi-my) for xi, yi in zip(x, y))
    a = sxy/sxx if sxx else 0.0; b = my - a*mx
    return [yi - (a*xi + b) for xi, yi in zip(x, y)], a

# per-member residual (error after removing each member's own linear calibration to distance)
E = []
print("per-member calibration slope dV/dd (should be ~ -1 if calibrated):")
for m in range(5):
    res, a = lstsq_residuals(V[m], dists)
    E.append(res)
    print(f"  member {m+1}: slope {a:+.3f}, residual std {statistics.pstdev(res):.3f}")

def corr(a, b):
    ma = sum(a)/len(a); mb = sum(b)/len(b)
    num = sum((ai-ma)*(bi-mb) for ai, bi in zip(a, b))
    da = (sum((ai-ma)**2 for ai in a))**0.5; db = (sum((bi-mb)**2 for bi in b))**0.5
    return num/(da*db) if da and db else 0.0

# (1) pairwise error correlation
print("\n(1) PAIRWISE ERROR CORRELATION between members (high => errors shared => disagreement underestimates uncertainty):")
pairs = []
for i in range(5):
    for j in range(i+1, 5):
        c = corr(E[i], E[j]); pairs.append(c)
print(f"  mean pairwise error-corr = {statistics.mean(pairs):.3f}   (range {min(pairs):.3f}..{max(pairs):.3f})")
# variance decomposition: shared vs member-specific
mean_err = [statistics.mean(E[m][k] for m in range(5)) for k in range(n)]
var_total = statistics.pstdev([E[m][k] for m in range(5) for k in range(n)])**2
var_shared = statistics.pstdev(mean_err)**2
print(f"  shared (common-mode) fraction of error variance = {var_shared/var_total:.2f}  "
      f"(1.0 = all members err identically; 0 = independent)")

# (2) does disagreement track actual error?  within-distance to remove the distance confound
print("\n(2) does ensemble DISAGREEMENT track the ensemble's actual |error|?  (Spearman within each distance)")
disagree = [statistics.pstdev([V[m][k] for m in range(5)]) for k in range(n)]
abserr = [abs(mean_err[k]) for k in range(n)]
byd = defaultdict(lambda: ([], []))
for k in range(n):
    byd[dists[k]][0].append(disagree[k]); byd[dists[k]][1].append(abserr[k])
def spearman(x, y):
    rx = {v: i for i, v in enumerate(sorted(range(len(x)), key=lambda t: x[t]))}
    ry = {v: i for i, v in enumerate(sorted(range(len(y)), key=lambda t: y[t]))}
    xr = [rx[i] for i in range(len(x))]; yr = [ry[i] for i in range(len(y))]
    return corr(xr, yr)
sps = []
for d in sorted(byd):
    dis, ae = byd[d]
    if len(dis) >= 8:
        sp = spearman(dis, ae); sps.append(sp)
        print(f"  d={d:>2} (n={len(dis):>2}): Spearman(disagreement, |error|) = {sp:+.3f}")
if sps:
    print(f"  --> median across distances = {statistics.median(sps):+.3f}  "
          f"(near 0 => disagreement does NOT know where the ensemble is wrong)")
