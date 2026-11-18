"""Is a paired net% broad or carried by a handful of instances?

net% is expansion-weighted, so a single probe with a large absolute saving can dominate
it while the typical instance is unchanged. This has bitten us before: a goldminer arm
once had 82% of its total savings come from ONE probe. Run this before treating any net%
as a real effect.

Prints the top contributors to the total saving, the share carried by the top
1/3/5/10/20/50 (with what fraction of the instance count that is),
and the net% recomputed with the single largest contributor removed.

Usage: venv/bin/python pair_contrib.py <arm_dir> <ctl_dir> [--prefix results]
   e.g. venv/bin/python pair_contrib.py grid_abs_t1b0k1 grid_abs_t1b0k1_ctl
"""
import re, glob, os, sys, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("arm")
ap.add_argument("ctl")
ap.add_argument("--prefix", default="results")
ap.add_argument("--top", default=10, type=int)
A_ = ap.parse_args()


def load(d):
    out = {}
    for f in glob.glob(f"{A_.prefix}/{d}/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            out[n] = (int(e.group(1)), "Found a solution" in s)
    return out


arm, ctl = load(A_.arm), load(A_.ctl)
if not arm or not ctl:
    raise SystemExit(f"missing: {A_.arm if not arm else ''} {A_.ctl if not ctl else ''}")

shared = [i for i in arm if i in ctl and arm[i][1] and ctl[i][1] and ctl[i][0] > 0]
# saving > 0 means the ARM expanded FEWER nodes than the control on that instance
sav = sorted(((ctl[i][0] - arm[i][0]), i) for i in shared)
total_ctl = sum(ctl[i][0] for i in shared)
net = sum(s for s, _ in sav)

print(f"{A_.arm}  vs  {A_.ctl}")
print(f"shared solved: {len(shared)}   control total expansions: {total_ctl:,}")
print(f"net saving: {net:,}  ({100.0*net/total_ctl:+.1f}%)\n")

pos = [(s, i) for s, i in sav if s > 0]
pos.sort(reverse=True)
neg = [(s, i) for s, i in sav if s < 0]

print(f"top {A_.top} instances the ARM saved the most on:")
print(f"{'instance':<34} {'ctl':>9} {'arm':>9} {'saved':>9} {'% of net':>9}")
for s, i in pos[:A_.top]:
    print(f"{i:<34} {ctl[i][0]:>9,} {arm[i][0]:>9,} {s:>9,} {100.0*s/net:>8.1f}%")

print(f"\ntop {A_.top} instances the ARM lost the most on:")
for s, i in sorted(neg)[:A_.top]:
    print(f"{i:<34} {ctl[i][0]:>9,} {arm[i][0]:>9,} {s:>9,} {100.0*s/net:>8.1f}%")

print("\nconcentration of the NET saving:")
for k in (1, 3, 5, 10, 20, 50):
    if k > len(pos):
        break
    share = sum(s for s, _ in pos[:k])
    print(f"  top {k:>2} winners contribute {share:>9,}  = {100.0*share/net:>6.1f}% of net"
          f"   ({100.0*k/len(shared):>4.1f}% of instances)")

if pos:
    drop_s, drop_i = pos[0]
    net2 = net - drop_s
    ctl2 = total_ctl - ctl[drop_i][0]
    print(f"\nremoving the single largest winner ({drop_i}):")
    print(f"  net% {100.0*net/total_ctl:+.1f}%  ->  {100.0*net2/ctl2:+.1f}%")

r = sorted(arm[i][0] / ctl[i][0] for i in shared)
q = lambda f: r[int(f * (len(r) - 1))]
print(f"\nper-instance ratio arm/ctl:  p10 {q(.1):.3f}  p25 {q(.25):.3f}  "
      f"median {q(.5):.3f}  p75 {q(.75):.3f}  p90 {q(.9):.3f}")
print(f"instances differing at all: {sum(1 for x in r if abs(x-1.0) > 1e-9)}/{len(r)}")
