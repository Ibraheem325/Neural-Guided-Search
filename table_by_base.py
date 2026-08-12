"""The results table with BASE PROBLEMS as the unit, not probes.

WHY THIS IS THE HONEST TABLE. A probe is a state lifted from inside one dataset instance;
rovers' 480 probes come from 37 base problems, goldminer's from 29, grid's from 30. Probes
from the same base problem share a map, an object set and a goal -- they are the same
problem entered at different depths, not independent experiments. Counting them as
independent inflates everything built on counts.

That is not hypothetical. Goldminer's multiplicative tilt read 73/27 per probe and looked
like the study's positive result; grouped by base problem it was 14/15, p=1.0000. And on
rovers the RANDOM control -- no signal at all -- posts net +52.2%, of which two probes from
the same two base problems supply 58%.

Columns, per arm:
  probes      probes solved / total, and coverage
  BP cov      mean fraction of a base problem's probes the arm solves (1.00 = solves all of
              every problem it touches). Falls when an arm fails whole problems.
  BP imp/reg  base problems where the arm's TOTAL expansions over its shared-solved probes
              are lower / higher than the baseline's. This is the count the binomial uses.
  p           exact two-sided binomial on those counts, p=0.5 null.
  med ratio   median over base problems of (arm total expansions / baseline total), i.e.
              the typical PROBLEM, not the typical probe.
  FLIPS       base problems whose per-probe sign is not consistent across depths. A real
              effect should keep its sign when the same problem is entered one step deeper;
              widespread flipping means the measurement is depth noise.

Deliberately NO net% column: it is expansion-weighted and on every domain measured so far it
is dominated by a handful of pathological base problems where the baseline explodes.

Usage: venv/bin/python table_by_base.py --domain rovers [--prefix results]
"""
import re, glob, os, argparse, statistics as st
from math import comb
from domains_config import DOMAINS

ap = argparse.ArgumentParser()
ap.add_argument("--domain", default="rovers", choices=sorted(DOMAINS))
ap.add_argument("--prefix", default="results")
A_ = ap.parse_args()

CFG = DOMAINS[A_.domain]
PROBE = re.compile(r"^\d+_d(\d+)_(.+)$")


def load(d):
    out = {}
    for f in glob.glob(f"{A_.prefix}/{d}/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        L = re.search(r"Found a solution of length (\d+)", s)
        if e:
            out[n] = (int(e.group(1)), int(L.group(1)) if L else None, L is not None)
    return out


def binom_p(k, n):
    if n == 0:
        return 1.0
    p = [comb(n, i) * 0.5 ** n for i in range(n + 1)]
    return sum(x for x in p if x <= p[k] * 1.0000001)


def base_of(name):
    m = PROBE.match(name)
    return m.group(2) if m else None


base = load(CFG["base"])
if not base:
    raise SystemExit(f"baseline not found: {A_.prefix}/{CFG['base']}")

# every probe in the set, grouped by base problem -- the denominator for BP coverage
all_probes = {}
for p in glob.glob(CFG["probe"] + "/*.pddl"):
    n = os.path.basename(p)[:-5]
    b = base_of(n) or n      # no `_d<dd>_` group -> whole instance, its own base problem
    all_probes.setdefault(b, set()).add(n)
NBASE = len(all_probes)
NPROBE = sum(len(v) for v in all_probes.values())

print(f"### {A_.domain.upper()} -- BASE PROBLEMS AS THE UNIT ###")
if not NBASE:
    raise SystemExit(f"no instances found in {CFG['probe']}")
print(f"probe set {CFG['probe']}: {NPROBE} probes from {NBASE} base problems "
      f"({NPROBE/NBASE:.1f} per problem)\n")

for title, rows in CFG["tables"]:
    print(f"--- {title} ---")
    print("| arm | probes | cov% | BP cov | BP imp | BP reg | p | med ratio | FLIPS |")
    print("| --- | ------ | ---- | ------ | ------ | ------ | - | --------- | ----- |")

    def emit(label, a, is_base=False):
        solved = {i for i, v in a.items() if v[2]}
        bpcov = st.mean(len(solved & v) / len(v) for v in all_probes.values())
        if is_base:
            print(f"| {label} | {len(solved)}/{NPROBE} | {100*len(solved)/NPROBE:.1f}% "
                  f"| {bpcov:.2f} | — | — | — | — | — |")
            return
        grp = {}
        for i in solved:
            if i not in base or not base[i][2] or base[i][0] <= 0:
                continue
            b = base_of(i)
            if b is None:
                continue
            g = grp.setdefault(b, {"a": 0, "c": 0, "sign": set()})
            g["a"] += a[i][0]; g["c"] += base[i][0]
            g["sign"].add(1 if a[i][0] < base[i][0] else -1 if a[i][0] > base[i][0] else 0)
        imp = sum(1 for g in grp.values() if g["a"] < g["c"])
        reg = sum(1 for g in grp.values() if g["a"] > g["c"])
        flips = sum(1 for g in grp.values() if 1 in g["sign"] and -1 in g["sign"])
        med = st.median([g["a"] / g["c"] for g in grp.values()]) if grp else float("nan")
        print(f"| {label} | {len(solved)}/{NPROBE} | {100*len(solved)/NPROBE:.1f}% "
              f"| {bpcov:.2f} | {imp} | {reg} | {binom_p(imp, imp+reg):.4f} "
              f"| {med:.3f} | {flips}/{len(grp)} |")

    emit("BASELINE", base, is_base=True)
    missing = []
    for lbl, d in rows:
        a = load(d)
        if not a:
            missing.append(d); continue
        emit(lbl, a)
    if missing:
        print("\nnot on disk: " + ", ".join(missing))
    print()

print("BP cov  = mean fraction of a base problem's probes the arm solves.")
print("BP imp/reg compare TOTAL expansions per base problem against the baseline.")
print("med ratio is over base problems, so it describes the typical PROBLEM.")
print("FLIPS counts problems whose per-probe sign is inconsistent across depths -- a real")
print("effect should hold its sign when the same problem is entered one step deeper.")
