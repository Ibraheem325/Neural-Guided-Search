"""WHY does an arm fail on instances the baseline solved? Three very different reasons.

Every run prints progress lines
    [sim N] root visits=N, unique states=U, generated=G, iqn_calls=I
so for a failed run we know how many simulations it managed AND how much of the state
space it actually reached. That separates:

  COMPUTE-BOUND  few simulations, and fewer states reached than the baseline needed.
                 The signal costs an IQN forward per child (~20/node on logistics), so the
                 wall clock ran out before the search got anywhere. Fixable with more time.
  STUCK          many simulations but very few unique states -- the search kept re-descending
                 into a tiny region it had already exhausted. Not a budget problem: more
                 time would change nothing.
  WANDERING      many simulations AND more states than the baseline needed to solve, still
                 no goal. The search was misdirected -- it explored plenty, just wrongly.

COMPUTE-BOUND blames the budget. STUCK and WANDERING blame the signal.

Usage: venv/bin/python analyze_failures.py <baseline> <arm> [<arm> ...]
"""
import re, glob, os, sys, statistics as st

if len(sys.argv) < 3:
    sys.exit(__doc__)
BASE, ARMS = sys.argv[1], sys.argv[2:]
PRE = "results"
RE_SIM = re.compile(r"\[sim (\d+)\] root visits=\d+, unique states=(\d+), generated=(\d+)")


def load(d):
    o = {}
    for f in glob.glob(f"{PRE}/{d}/*.out"):
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if not e:
            continue
        sims = 0
        for m in RE_SIM.finditer(s):
            sims = max(sims, int(m.group(1)))
        o[os.path.basename(f)[:-4]] = dict(
            gen=int(e.group(1)), solved="Found a solution" in s, sims=sims)
    return o


B = load(BASE)
if not B:
    sys.exit(f"missing baseline {PRE}/{BASE}")
bs = {x for x in B if B[x]["solved"]}
bsims = st.median([B[x]["sims"] for x in bs if B[x]["sims"]]) or 1
print(f"\nbaseline {BASE}: {len(bs)} solved, median expansions "
      f"{st.median([B[x]['gen'] for x in bs]):.0f}, median simulations {bsims:.0f}\n")
hdr = (f"{'arm':<28}{'failed':>8}{'compute':>10}{'stuck':>8}{'wander':>8}"
       f"{'  med sims':>11}{'med gen':>9}{'(base gen)':>11}")
print(hdr); print("-" * len(hdr))
for d in ARMS:
    A = load(d)
    if not A:
        print(f"{d:<28}  -- not run")
        continue
    lost = sorted(bs - {x for x in A if A[x]["solved"]})
    lost = [x for x in lost if x in A]
    if not lost:
        print(f"{d:<28}{0:>8}   (no coverage loss)")
        continue
    comp = stuck = wander = 0
    for x in lost:
        a, b = A[x], B[x]
        if a["gen"] >= b["gen"]:
            wander += 1                       # reached at least as far as the baseline did
        elif a["sims"] >= 0.5 * bsims:
            stuck += 1                        # plenty of simulations, little of the space
        else:
            comp += 1                         # never got the simulations in
    n = len(lost)
    print(f"{d:<28}{n:>8}{100*comp/n:>9.0f}%{100*stuck/n:>7.0f}%{100*wander/n:>7.0f}%"
          f"{st.median([A[x]['sims'] for x in lost]):>11.0f}"
          f"{st.median([A[x]['gen'] for x in lost]):>9.0f}"
          f"{st.median([B[x]['gen'] for x in lost]):>11.0f}")
print("\ncompute = fewer states than the baseline needed AND under half its simulations")
print("stuck   = fewer states than the baseline needed, but simulations were not the limit")
print("wander  = reached at least as many states as the baseline needed, still no goal")
print("\nmed gen vs (base gen) is the direct read: gen well BELOW base = never got there;")
print("gen well ABOVE = searched more than enough and missed.")
