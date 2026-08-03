"""How many probes need a LARGE search, and what are they?

expansions_needed is what decides whether a per-expansion-cost signal can afford to run.
This reports, per baseline: the expansion distribution, the fraction of probes above
thresholds, how much of the total expansion mass they carry, and what those heavy
instances look like (topology / packages / distance).

Usage: venv/bin/python expansion_load.py <results_dir> [<probe_dir>] [label]
"""
import sys, re, glob, os, csv, io, statistics as st, collections

RES = sys.argv[1]
PROBE = sys.argv[2] if len(sys.argv) > 2 and os.path.isdir(sys.argv[2]) else None
LABEL = sys.argv[3] if len(sys.argv) > 3 else os.path.basename(RES)

rows = {}
for f in glob.glob(RES + "/*.out"):
    n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
    e = re.search(r"\[Final\] Expanded: (\d+)", s)
    p = re.search(r"Found a solution of length (\d+)!", s)
    if e:
        rows[n] = (int(e.group(1)), p is not None)

L = {}
if PROBE and os.path.exists(PROBE + "/labels.csv"):
    t = open(PROBE + "/labels.csv", newline="").read().replace("\r", "")
    L = {r["file"][:-5]: r for r in csv.DictReader(io.StringIO(t))}

allv = [v[0] for v in rows.values()]
solved = {k: v[0] for k, v in rows.items() if v[1]}
if not allv:
    print(f"{LABEL}: no results found in {RES}"); sys.exit()

v = sorted(allv); tot = sum(v)
print(f"=== {LABEL} ===  n={len(v)}  solved={len(solved)}  total expansions={tot:,}")
print(f"  median={st.median(v):.0f}  q75={v[int(.75*len(v))]}  q90={v[int(.90*len(v))]}  "
      f"q99={v[int(.99*len(v))]}  max={v[-1]:,}")
print(f"\n  {'threshold':>12}{'probes':>9}{'% of set':>10}{'% of all expansions':>22}")
for th in [100, 1000, 5000, 10000, 50000, 100000]:
    heavy = [x for x in v if x >= th]
    if not heavy: continue
    print(f"  {th:>12,}{len(heavy):>9}{100*len(heavy)/len(v):>9.1f}%{100*sum(heavy)/tot:>21.1f}%")

if L:
    # characterise the heavy tail
    thr = v[int(.90 * len(v))]
    heavy = [k for k, val in rows.items() if val[0] >= thr]
    light = [k for k, val in rows.items() if val[0] < thr]
    def prof(keys, tag):
        topo = collections.Counter(); pk = collections.Counter(); ds = []
        for k in keys:
            m = re.search(r"-c(\d+)s(\d+)p(\d+)", k) or re.search(r"p-(\d+x\d+)-", k)
            if m and m.re.pattern.startswith("-c"):
                topo[f"c{m.group(1)}s{m.group(2)}"] += 1; pk[int(m.group(3))] += 1
            elif m:
                topo[m.group(1)] += 1
            if k in L: ds.append(int(L[k]["distance_to_goal"]))
        print(f"  {tag:<26} n={len(keys):>4}  d median={st.median(ds) if ds else 0:.0f}")
        print(f"     {dict(topo.most_common(6))}")
        if pk: print(f"     packages: {dict(sorted(pk.items())[:8])}")
    print(f"\n  profile of the heaviest 10% (>= {thr:,} expansions) vs the rest:")
    prof(heavy, "HEAVY (top 10%)")
    prof(light, "rest")
