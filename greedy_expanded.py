"""Recover 'expanded' for greedy_sac_plan.py / greedy_q_plan.py runs from their logs.

Those scripts never printed an expansion count, because for a greedy walk it is redundant
with the plan length: the loop expands exactly one state per iteration and never
backtracks (it argmaxes over successors with visited-masking). So

    expanded = number of steps taken

which for a SOLVED instance equals the plan length. The reason to recover it from the log
rather than reuse the plan length is FAILED instances -- there is no plan length there, but
the walk still expanded states before giving up, and that is the number a benchmark table
needs so failures are not silently scored as zero effort.

Each loop iteration prints "<value>: <action>" (three decimals), while the final solution
listing prints "<index>: <action>". The two are distinguishable by the leading token.

Usage: venv/bin/python greedy_expanded.py <dir> [<dir> ...]
"""
import re, glob, os, sys, statistics as st

RE_STEP = re.compile(r"^-?\d+\.\d{3}: ")          # per-iteration line
RE_LEN = re.compile(r"Found a solution of length (\d+)")

if len(sys.argv) < 2:
    sys.exit(__doc__)
print(f"{'dir':<34}{'n':>5}{'solved':>8}{'cov%':>8}"
      f"{'medExp(solved)':>16}{'medExp(failed)':>16}{'medLen':>8}")
print("-" * 95)
for d in sys.argv[1:]:
    n = solved = 0
    exp_s, exp_f, lens = [], [], []
    for f in sorted(glob.glob(os.path.join(d, "*.out"))):
        n += 1
        steps = 0
        ln = None
        with open(f, errors="ignore") as fh:
            for line in fh:
                if RE_STEP.match(line):
                    steps += 1
                    continue
                m = RE_LEN.search(line)
                if m:
                    ln = int(m.group(1))
        if ln is not None:
            solved += 1; exp_s.append(steps); lens.append(ln)
        else:
            exp_f.append(steps)
    if not n:
        print(f"{d:<34}   -- no .out files")
        continue
    med = lambda v: f"{st.median(v):.0f}" if v else "-"
    print(f"{os.path.basename(d.rstrip('/')):<34}{n:>5}{solved:>8}{100*solved/n:>7.1f}%"
          f"{med(exp_s):>16}{med(exp_f):>16}{med(lens):>8}")
print("\nexpanded = states the greedy walk expanded (one per step, no backtracking).")
print("For solved runs it should equal the plan length; a mismatch means the log was")
print("truncated or the run used --disable_closed_set and revisited states.")
