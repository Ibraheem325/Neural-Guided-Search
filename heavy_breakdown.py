"""Where does the expansion explosion actually happen: topology, packages, or depth?

Usage: venv/bin/python heavy_breakdown.py <results_dir> <probe_dir>
"""
import sys, re, glob, os, csv, io, statistics as st, collections

RES, PROBE = sys.argv[1], sys.argv[2]
rows = {}
for f in glob.glob(RES + "/*.out"):
    n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
    e = re.search(r"\[Final\] Expanded: (\d+)", s)
    if e: rows[n] = (int(e.group(1)), "Found a solution" in s)
t = open(PROBE + "/labels.csv", newline="").read().replace("\r", "")
L = {r["file"][:-5]: int(r["distance_to_goal"]) for r in csv.DictReader(io.StringIO(t))}

R = []
for n, (e, ok) in rows.items():
    m = re.search(r"-c(\d+)s(\d+)p(\d+)", n)
    if not m or n not in L: continue
    R.append((f"c{m.group(1)}s{m.group(2)}p{m.group(3)}", L[n], e, ok))

HEAVY = 20000
print(f"threshold for 'exploded' = {HEAVY:,} expansions "
      f"(roughly what the Bellman arms could afford)\n")
print("=== BY CONFIGURATION ===")
print(f"{'config':>10}{'n':>5}{'median':>10}{'q90':>10}{'max':>10}{'>20k':>8}{'%':>7}")
g = collections.defaultdict(list)
for c, d, e, ok in R: g[c].append(e)
for c in sorted(g):
    v = sorted(g[c]); hv = sum(1 for x in v if x >= HEAVY)
    print(f"{c:>10}{len(v):>5}{st.median(v):>10.0f}{v[int(.9*len(v))]:>10}{v[-1]:>10}"
          f"{hv:>8}{100*hv/len(v):>6.0f}%")

print("\n=== BY DISTANCE (all configs pooled) ===")
print(f"{'d':>4}{'n':>5}{'median':>10}{'max':>10}{'>20k':>8}{'%':>7}")
g2 = collections.defaultdict(list)
for c, d, e, ok in R: g2[d].append(e)
for d in sorted(g2):
    v = sorted(g2[d]); hv = sum(1 for x in v if x >= HEAVY)
    print(f"{d:>4}{len(v):>5}{st.median(v):>10.0f}{v[-1]:>10}{hv:>8}{100*hv/len(v):>6.0f}%")

print("\n=== CONFIGURATION x DEPTH: % of probes over 20k expansions ===")
cfgs = sorted(g); buckets = [(5, 8), (9, 12), (13, 16), (17, 20)]
print(f"{'config':>10}" + "".join(f"{f'd{a}-{b}':>12}" for a, b in buckets))
for c in cfgs:
    line = f"{c:>10}"
    for a, b in buckets:
        v = [e for cc, d, e, ok in R if cc == c and a <= d <= b]
        line += f"{(f'{100*sum(1 for x in v if x>=HEAVY)/len(v):.0f}% ({len(v)})' if v else '-'):>12}"
    print(line)
