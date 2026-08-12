"""Paired comparison aggregated by BASE PROBLEM, not by probe.

WHY THIS EXISTS. The probe sets (probe_near_goal_d5-20, probeGold_near_goal_d5-20, ...)
draw ~30 probes per distance from the SAME underlying test instances, so one base problem
appears many times at different depths. Probe names are

    <probe_idx>_d<depth>_<instance_id>_<problem_name>
    246_d13_016_p-L8-5   ->  base 016_p-L8-5, depth 13

Treating those as independent samples inflates every count-based test. On grid's c(s) pair
the top 10 winners came from only THREE base problems, and 005_p-L6-3 appeared among the
biggest winners at d11/d12 (+530 each) AND the biggest losers at d18/d20 (-679 each) --
the sign flips with depth on the same problem. A binomial over 161 probes reported p=0.018
there; the independent unit is the base problem, so that p is not valid.

This script reports, per base problem: total expansions on both sides, net saving, and the
per-depth win/loss split, so a problem that flips sign with depth is visible rather than
being counted once per probe. The headline is the number of base problems that are net
positive vs net negative -- that count is the one to test.

Usage: venv/bin/python cluster_contrib.py <arm_dir> <ctl_dir> [--prefix results] [--top 15]
"""
import re, glob, os, argparse
from math import comb

ap = argparse.ArgumentParser()
ap.add_argument("arm")
ap.add_argument("ctl")
ap.add_argument("--prefix", default="results")
ap.add_argument("--top", default=15, type=int)
A_ = ap.parse_args()

PROBE = re.compile(r"^\d+_d(\d+)_(.+)$")


def load(d):
    out = {}
    for f in glob.glob(f"{A_.prefix}/{d}/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            out[n] = (int(e.group(1)), "Found a solution" in s)
    return out


def binom_p(k, n):
    if n == 0:
        return 1.0
    p = [comb(n, i) * 0.5 ** n for i in range(n + 1)]
    return sum(x for x in p if x <= p[k] * 1.0000001)


arm, ctl = load(A_.arm), load(A_.ctl)
if not arm or not ctl:
    raise SystemExit("missing results dir")

shared = [i for i in arm if i in ctl and arm[i][1] and ctl[i][1] and ctl[i][0] > 0]

groups = {}
unparsed = 0
for i in shared:
    m = PROBE.match(i)
    if m:
        depth, base = int(m.group(1)), m.group(2)
    else:
        # WHOLE-INSTANCE sets (the in-distribution ones) carry no `_d<dd>_` group: they are
        # not probes cut from a plan, so there is no depth and no shared source problem.
        # Each instance IS its own base problem, which is the ideal case for this test --
        # no clustering to correct for. Previously these fell through as "unparsed" and left
        # zero groups, which divided by zero.
        unparsed += 1
        depth, base = -1, i
    g = groups.setdefault(base, {"a": 0, "c": 0, "win": 0, "loss": 0, "tie": 0, "d": []})
    g["a"] += arm[i][0]; g["c"] += ctl[i][0]
    if arm[i][0] < ctl[i][0]:
        g["win"] += 1
    elif arm[i][0] > ctl[i][0]:
        g["loss"] += 1
    else:
        g["tie"] += 1
    g["d"].append((depth, ctl[i][0] - arm[i][0]))

print(f"{A_.arm}  vs  {A_.ctl}")
print(f"probes shared: {len(shared)}   base problems: {len(groups)}"
      + (f"   ({unparsed} whole instances, each its own base problem)" if unparsed else ""))

tot_c = sum(g["c"] for g in groups.values())
tot_net = sum(g["c"] - g["a"] for g in groups.values())
print(f"net saving: {tot_net:,} ({100.0*tot_net/tot_c:+.1f}%)\n")

rows = sorted(groups.items(), key=lambda kv: kv[1]["c"] - kv[1]["a"], reverse=True)
print(f"per BASE PROBLEM (top and bottom {A_.top} by net saving):")
print(f"{'base problem':<20} {'probes':>7} {'ctl exp':>10} {'arm exp':>10} "
      f"{'net':>9} {'%net':>7} {'w/l/t':>10}  depth split")


def show(kv):
    b, g = kv
    net = g["c"] - g["a"]
    ds = sorted(g["d"])
    flip = (any(s > 0 for _, s in ds) and any(s < 0 for _, s in ds))
    dstr = " ".join(f"d{d}{'+' if s>0 else '-' if s<0 else '='}" for d, s in ds)
    print(f"{b:<20} {len(g['d']):>7} {g['c']:>10,} {g['a']:>10,} {net:>9,} "
          f"{100.0*net/tot_net:>6.1f}% {g['win']}/{g['loss']}/{g['tie']:<4} "
          f"{'FLIPS ' if flip else '      '}{dstr}")


for kv in rows[:A_.top]:
    show(kv)
if len(rows) > 2 * A_.top:
    print(f"{'...':<20} {len(rows)-2*A_.top} more")
for kv in rows[-A_.top:]:
    show(kv)

pos = sum(1 for _, g in rows if g["c"] - g["a"] > 0)
neg = sum(1 for _, g in rows if g["c"] - g["a"] < 0)
tie = len(rows) - pos - neg
flips = sum(1 for _, g in rows
            if any(s > 0 for _, s in g["d"]) and any(s < 0 for _, s in g["d"]))

print(f"\nBASE PROBLEMS net positive: {pos}   net negative: {neg}   unchanged: {tie}")
print(f"exact binomial on base problems (p=0.5): p = {binom_p(pos, pos+neg):.4f}")
print(f"base problems whose sign FLIPS across depths: {flips}/{len(rows)}")
print("\nCompare this p to the per-probe one. Probes from the same base problem are not")
print("independent, so the per-probe test overstates significance; this is the honest unit.")
