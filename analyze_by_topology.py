"""Is logistics' collapse driven by BRANCHING? Split any arm's results by topology.

The multiloc probe set mixes three topologies with very different branching factors
(measured at initial states over all 288 probes):
    c3s3  n=64   median |A| 17   range 15-20
    c4s2  n=160  median |A| 21   range 15-27
    c4s3  n=64   median |A| 28   range 26-33
If high branching is what breaks the signal arms, the coverage loss should be
CONCENTRATED in c4s3 and mildest in c3s3. If instead it is flat across topologies, the
branching story is wrong and something else (search size, compute budget) is doing the work.

Usage: venv/bin/python analyze_by_topology.py <baseline> <arm> [<arm> ...]
"""
import re, glob, os, sys, statistics as st

if len(sys.argv) < 3:
    sys.exit(__doc__)
BASE, ARMS = sys.argv[1], sys.argv[2:]
PRE = "results"
TOPO = re.compile(r"p-VAL-(c\d+s\d+)")


def load(d):
    o = {}
    for f in glob.glob(f"{PRE}/{d}/*.out"):
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            o[os.path.basename(f)[:-4]] = (int(e.group(1)), "Found a solution" in s)
    return o


def topo(name):
    m = TOPO.search(name)
    return m.group(1) if m else "?"


B = load(BASE)
if not B:
    sys.exit(f"missing baseline {PRE}/{BASE}")
bs = {x for x in B if B[x][1]}
tops = sorted({topo(x) for x in B})
bt = {t: {x for x in bs if topo(x) == t} for t in tops}
print(f"\nbaseline {BASE}: " + "  ".join(
    f"{t} {len(bt[t])}/{sum(1 for x in B if topo(x)==t)}" for t in tops))
print("\n" + f"{'arm':<28}" + "".join(f"{t+' solved':>14}" for t in tops)
      + f"{'  |':>4}{'median ratio by topology':>28}")
print("-" * (28 + 14 * len(tops) + 32))
for d in ARMS:
    A = load(d)
    if not A:
        print(f"{d:<28}  -- not run")
        continue
    sv = {x for x in A if A[x][1]}
    cells, rats = "", ""
    for t in tops:
        k = bt[t] & sv
        pct = 100 * len(k) / max(1, len(bt[t]))
        cells += f"{len(k)}/{len(bt[t])} ({pct:>3.0f}%)".rjust(14)
        r = [A[x][0] / B[x][0] for x in k]
        rats += f"{st.median(r):>9.3f}" if r else f"{'-':>9}"
    print(f"{d:<28}{cells}{'  |':>4}{rats:>28}")
print("\nsolved is out of the BASELINE's solved count for that topology, so 100% = no loss.")
print("If the percentages fall as branching rises (c3s3 -> c4s2 -> c4s3), branching is the")
print("driver. If they are flat, it is not.")
