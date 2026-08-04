"""Compare arms on the set of instances EVERY listed arm solved (plus the baseline).

Why this exists: the per-arm tables average expansion ratios over each arm's OWN
shared-solved set. An arm that fails on hard instances silently DROPS them instead of
counting them as losses, so its mean ratio is flattered and two arms' means are not
comparable. Example: binc b=4 averages 0.935 over 318 instances while flatten w=0.28
averages 0.985 over ~337 -- the gap is partly a different denominator, not performance.

This restricts to one common set so the columns can actually be compared, and reports
coverage separately (which is where an arm that drops instances should be penalised).

Usage: venv/bin/python analyze_matched.py <arm_dir> [<arm_dir> ...]  [--base gm_base]
"""
import re, glob, os, sys, statistics as st

args = [a for a in sys.argv[1:] if not a.startswith("--")]
base = "gm_base"
if "--base" in sys.argv:
    base = sys.argv[sys.argv.index("--base") + 1]
    args = [a for a in args if a != base]
PRE = "results"


def load(d):
    o = {}
    for f in glob.glob(f"{PRE}/{d}/*.out"):
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            o[os.path.basename(f)[:-4]] = (int(e.group(1)), "Found a solution" in s)
    return o


B = load(base)
if not B:
    sys.exit(f"missing baseline {PRE}/{base}")
bs = {x for x in B if B[x][1]}
A = {d: load(d) for d in args}
for d, v in A.items():
    if not v:
        sys.exit(f"missing arm {PRE}/{d}")
solved = {d: {x for x in v if v[x][1]} for d, v in A.items()}
common = set(bs)
for s in solved.values():
    common &= s
common = sorted(common)

print(f"\nbaseline {base}: {len(bs)}/{len(B)} solved")
print(f"MATCHED set: {len(common)} instances solved by the baseline and all "
      f"{len(args)} arms\n")
hdr = (f"{'arm':<26}{'solved':>8}{'cov%':>8}{'mean':>8}{'median':>8}"
       f"{'improved':>10}{'regressed':>11}{'dropped':>9}")
print(hdr); print("-" * len(hdr))
for d in args:
    v = A[d]
    r = [v[x][0] / B[x][0] for x in common]
    imp = sum(1 for x in common if v[x][0] < B[x][0])
    reg = sum(1 for x in common if v[x][0] > B[x][0])
    drop = len(bs - solved[d])          # baseline-solved instances this arm lost
    print(f"{d:<26}{len(solved[d]):>8}{100*len(solved[d])/len(B):>7.1f}%"
          f"{st.mean(r):>8.3f}{st.median(r):>8.3f}{imp:>10}{reg:>11}{drop:>9}")
print("\ndropped = instances the baseline solved and this arm did NOT. They are excluded"
      "\nfrom the ratio columns, so an arm with a large 'dropped' has an optimistic mean.")
if len(args) > 1:
    print("\nhead-to-head on the matched set:")
    for i in range(len(args)):
        for j in range(i + 1, len(args)):
            a, b = args[i], args[j]
            w = sum(1 for x in common if A[a][x][0] < A[b][x][0])
            l = sum(1 for x in common if A[a][x][0] > A[b][x][0])
            if w + l:
                print(f"  {a} vs {b}: {w} / {l}  ({100*w/(w+l):.0f}% to {a})")
