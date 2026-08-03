"""What is special about the probes that need a huge search?

Correlates baseline expansions against (a) static instance features and (b) the quality
of the SAC prior along the optimal path -- to separate "the instance is big" from
"the policy guides badly here".

Usage:
  venv/bin/python why_heavy.py <results_baseline_dir> <probe_dir> <policy.pth> [n_probes]
"""
import sys, re, glob, os, csv, io, statistics as st, collections, torch
import pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ

RES, PROBE, POLICY = sys.argv[1], sys.argv[2], sys.argv[3]
NMAX = int(sys.argv[4]) if len(sys.argv) > 4 else 288
dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")
dom = mm.Domain(PROBE + "/domain.pddl")
raw, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(POLICY), dev)
policy = AZ.ModelWrapper(raw, "policy")

exp = {}
for f in glob.glob(RES + "/*.out"):
    n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
    e = re.search(r"\[Final\] Expanded: (\d+)", s)
    if e: exp[n] = (int(e.group(1)), "Found a solution" in s)

t = open(PROBE + "/labels.csv", newline="").read().replace("\r", "")
L = {r["file"][:-5]: r for r in csv.DictReader(io.StringIO(t))}

rows = []
with torch.no_grad():
    for pf in sorted(glob.glob(PROBE + "/*.pddl")):
        n = os.path.basename(pf)[:-5]
        if "domain" in n or n not in exp or n not in L: continue
        prob = mm.Problem(dom, pf); s0 = prob.get_initial_state(); g = prob.get_goal_condition()
        acts = s0.generate_applicable_actions()
        d = int(L[n]["distance_to_goal"])
        m = re.search(r"-c(\d+)s(\d+)p(\d+)", n)
        c, sl, pk = (map(int, m.groups()) if m else (0, 0, 0))
        # prior quality along the optimal path
        plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")] \
               if os.path.exists(pf + ".plan") else []
        ranks, pas = [], []
        st_ = s0
        for line in plan[:12]:
            lg, aa = policy.forward([(st_, g)])[0]
            if len(aa) == 0: break
            p = torch.softmax(lg, dim=0)
            i = next((j for j, a in enumerate(aa) if canon(a) == canon(line)), None)
            if i is None: break
            order = torch.argsort(p, descending=True)
            ranks.append(int((order == i).nonzero()[0, 0]) + 1)
            pas.append(p[i].item())
            st_ = aa[i].apply(st_)
        if not ranks: continue
        rows.append(dict(name=n, exp=exp[n][0], solved=exp[n][1], d=d, br=len(acts),
                         c=c, s=sl, pk=pk, obj=int(L[n]["num_objects"]),
                         rank=st.median(ranks), top1=100*sum(1 for r in ranks if r == 1)/len(ranks),
                         pa=st.median(pas)))
        if len(rows) >= NMAX: break

def corr(a, b):
    ma, mb = sum(a)/len(a), sum(b)/len(b)
    num = sum((x-ma)*(y-mb) for x, y in zip(a, b))
    da = (sum((x-ma)**2 for x in a))**.5; db = (sum((y-mb)**2 for y in b))**.5
    return num/(da*db) if da and db else 0.0
def spear(a, b):
    ra = {v: i for i, v in enumerate(sorted(range(len(a)), key=lambda t: a[t]))}
    rb = {v: i for i, v in enumerate(sorted(range(len(b)), key=lambda t: b[t]))}
    return corr([ra[i] for i in range(len(a))], [rb[i] for i in range(len(b))])

print(f"n={len(rows)} probes\n")
E = [r["exp"] for r in rows]
print("Spearman correlation with BASELINE EXPANSIONS:")
for f, lab in [("br", "branching at root"), ("obj", "num objects"), ("pk", "packages"),
               ("s", "locations per city"), ("c", "cities"), ("d", "distance to goal"),
               ("rank", "median rank of optimal action"), ("top1", "% steps where a* is top-1"),
               ("pa", "median P(a*)")]:
    print(f"   {lab:<32}{spear([r[f] for r in rows], E):+.3f}")

rows.sort(key=lambda r: -r["exp"])
k = max(1, len(rows)//10)
hv, lt = rows[:k], rows[k:]
print(f"\n{'':<26}{'HEAVY top10%':>14}{'rest':>12}")
for f, lab in [("exp", "expansions (median)"), ("br", "branching"), ("obj", "objects"),
               ("pk", "packages"), ("s", "locs/city"), ("d", "distance"),
               ("rank", "rank of a* (median)"), ("top1", "% a* is top-1"), ("pa", "P(a*) median")]:
    a = st.median([r[f] for r in hv]); b = st.median([r[f] for r in lt])
    print(f"{lab:<26}{a:>14.2f}{b:>12.2f}")
