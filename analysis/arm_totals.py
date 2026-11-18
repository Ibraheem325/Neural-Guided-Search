"""Total expansions for an arm vs the baseline, on each of the three defensible sets.

WHY THREE. An arm that solves 145 instances and a baseline that solves 272 have totals
that are not comparable: the arm's is smaller partly because it attempted fewer. Reporting
"arm 200k vs baseline 900k" as a saving would be wrong. The three framings:

  OWN SET     each side over the instances IT solved. Describes what each configuration
              actually did, but the sets differ, so the difference is NOT a saving.
  SHARED      instances BOTH solved. The only set on which a difference is a real saving.
  BASELINE'S  baseline over all it solved, vs the arm on that same set -- with the arm's
              failures counted at the time limit's expansion count if available, else
              flagged. Shows the cost of the arm's coverage loss.

Usage: venv/bin/python arm_totals.py <arm_dir> <baseline_dir> [--prefix results]
   e.g. venv/bin/python arm_totals.py logi_mul_e060_k0 multiloc_base_topopolicy
"""
import re, glob, os, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("arm")
ap.add_argument("base")
ap.add_argument("--prefix", default="results")
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


arm, base = load(A_.arm), load(A_.base)
if not arm or not base:
    raise SystemExit("missing results dir")

a_solved = {i for i, v in arm.items() if v[1]}
b_solved = {i for i, v in base.items() if v[1]}
shared = sorted(a_solved & b_solved)

print(f"{A_.arm}  vs  {A_.base}\n")

print("--- OWN SET (each over the instances it solved -- NOT a like-for-like comparison) ---")
ta = sum(arm[i][0] for i in a_solved)
tb = sum(base[i][0] for i in b_solved)
print(f"  {A_.arm:<28} {len(a_solved):>4} solved   {ta:>12,} expansions   "
      f"mean {ta/len(a_solved):>9,.0f}")
print(f"  {A_.base:<28} {len(b_solved):>4} solved   {tb:>12,} expansions   "
      f"mean {tb/len(b_solved):>9,.0f}")
print(f"  (the arm solved {len(b_solved)-len(a_solved)} FEWER instances, so a smaller total")
print( "   here does not mean it searched less per problem)")

print(f"\n--- SHARED SET ({len(shared)} instances both solved -- the real comparison) ---")
sa = sum(arm[i][0] for i in shared)
sb = sum(base[i][0] for i in shared)
print(f"  {A_.arm:<28} {sa:>12,} expansions   mean {sa/len(shared):>9,.0f}   "
      f"median {st.median([arm[i][0] for i in shared]):>8,.0f}")
print(f"  {A_.base:<28} {sb:>12,} expansions   mean {sb/len(shared):>9,.0f}   "
      f"median {st.median([base[i][0] for i in shared]):>8,.0f}")
print(f"  difference: {sb-sa:>+12,}  ({100.0*(sb-sa)/sb:+.1f}% vs baseline)")
win = sum(1 for i in shared if arm[i][0] < base[i][0])
loss = sum(1 for i in shared if arm[i][0] > base[i][0])
print(f"  per instance: {win} improved / {loss} regressed / {len(shared)-win-loss} identical")

print(f"\n--- THE COVERAGE COST ---")
lost = sorted(b_solved - a_solved)
gained = sorted(a_solved - b_solved)
print(f"  instances the baseline solved and the arm did NOT: {len(lost)}")
if lost:
    bl = sum(base[i][0] for i in lost)
    print(f"    baseline spent {bl:,} expansions solving them "
          f"(mean {bl/len(lost):,.0f})")
    al = [arm[i][0] for i in lost if i in arm]
    if al:
        print(f"    the arm spent {sum(al):,} on them and solved none "
              f"(mean {st.mean(al):,.0f}) -- wasted, and excluded from every ratio above")
print(f"  instances the arm solved and the baseline did NOT: {len(gained)}")
