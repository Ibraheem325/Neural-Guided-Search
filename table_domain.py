"""Survey table for every arm of one domain, against that domain's baseline.

  venv/bin/python table_domain.py <baseline_dir> <arm_glob> [<arm_glob> ...]

  logistics: table_domain.py multiloc_base_topopolicy 'logi_*' 'mlbinc*'
  satellite: table_domain.py sat_base  'sat_*'
  rovers:    table_domain.py rov_base  'rov_*'

Each arm is scored against the baseline on THAT ARM's shared-solved set, which is the
right per-arm summary but makes the ratio columns NOT comparable between arms -- an arm
that fails on hard instances drops them instead of counting them as losses. The 'dropped'
column exposes that. For any comparison BETWEEN arms use analyze_matched.py, which puts
them on one common set and adds head-to-head counts.

cov% is over the baseline's instance count, so a partial slurm array shows up as '!'
rather than silently inflating coverage.
"""
import re, glob, os, sys, statistics as st

if len(sys.argv) < 3:
    sys.exit(__doc__)
BASE, PATS = sys.argv[1], sys.argv[2:]
PRE = "results"


def load(d):
    o = {}
    for f in glob.glob(f"{d}/*.out"):
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            o[os.path.basename(f)[:-4]] = (int(e.group(1)), "Found a solution" in s)
    return o


bdir = BASE if os.path.isdir(BASE) else f"{PRE}/{BASE}"
B = load(bdir)
if not B:
    sys.exit(f"missing or empty baseline: {bdir}")
bs = {x for x in B if B[x][1]}
N = len(B)

arms = []
for p in PATS:
    arms += [d for d in sorted(glob.glob(f"{PRE}/{p}")) if os.path.isdir(d)]
arms = [d for d in dict.fromkeys(arms) if os.path.abspath(d) != os.path.abspath(bdir)]
if not arms:
    sys.exit(f"no result dirs matched {PATS} under {PRE}/ -- nothing has been run yet")

print(f"\nbaseline {bdir}: {len(bs)}/{N} solved, "
      f"median {st.median([B[x][0] for x in bs]):.0f} expansions\n")
hdr = (f"{'arm':<30}{'n':>5}{'solved':>8}{'cov%':>8}{'net%':>9}{'mean':>8}{'median':>8}"
       f"{'improved':>10}{'regressed':>11}{'dropped':>9}")
print(hdr); print("-" * len(hdr))
for d in arms:
    A = load(d)
    sv = {x for x in A if A[x][1]}
    k = sorted(sv & bs)
    label = os.path.basename(d)
    if not k:
        print(f"{label:<30}{len(A):>5}{len(sv):>8}   (no shared solved instances)")
        continue
    tb = sum(B[x][0] for x in k); ta = sum(A[x][0] for x in k)
    r = [A[x][0] / B[x][0] for x in k]
    imp = sum(1 for x in k if A[x][0] < B[x][0])
    reg = sum(1 for x in k if A[x][0] > B[x][0])
    flag = "!" if len(A) < N else " "
    print(f"{label:<30}{len(A):>4}{flag}{len(sv):>8}{100*len(sv)/N:>7.1f}%"
          f"{100*(tb-ta)/tb:>+8.1f}%{st.mean(r):>8.3f}{st.median(r):>8.3f}"
          f"{imp:>10}{reg:>11}{len(bs - sv):>9}")
print("\n!        = fewer .out files than the baseline (partial array)")
print("dropped  = baseline-solved instances this arm did NOT solve; excluded from the")
print("           ratio columns, so a large 'dropped' makes the mean optimistic")
print("net%     = total expansions saved; a sum, so the biggest instances dominate it and")
print("           it can disagree in sign with the median")
print("\nRatios are per-arm shared sets and are NOT comparable across arms.")
print("For that: venv/bin/python analyze_matched.py --base <baseline> <arm> <arm> ...")
