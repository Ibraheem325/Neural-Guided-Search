"""OPTION 9 (absolute-scale signal) arms vs the matched baseline, on goldminer.

Same accounting as analyze_three_way.py: compare only on instances BOTH arms solved,
report coverage separately so a coverage loss cannot masquerade as a saving.

  cov       % of instances solved by this arm
  net%      total expansions saved vs baseline on the shared set (+ = fewer = better)
  chg%      % of shared instances where the arm changed the expansion count at all
  medRatio  median expansions(arm)/expansions(baseline), over the CHANGED instances
            (over all instances it pins to exactly 1.000 and is uninformative)
  win%      of instances that changed, the % that IMPROVED
  shorter   instances where the arm found a SHORTER plan (these inflate net% without
            the search being better guided -- 83% of the old W1 "saving" was 3 such)

Usage: venv/bin/python analyze_abs.py [results_dir_prefix]
"""
import re, glob, os, sys, statistics as st, random

PRE = sys.argv[1] if len(sys.argv) > 1 else "results"
BASE = f"{PRE}/gm_base"
ARMS = [("t1 b1 k1   (doc default)", f"{PRE}/gm_abs_t1b1k1"),
        ("t1 b1 k0   (prior only)",  f"{PRE}/gm_abs_t1b1k0"),
        ("t1 b0 k1   (c(s) only)",   f"{PRE}/gm_abs_t1b0k1"),
        ("t1 b2 k1   (beta sweep)",  f"{PRE}/gm_abs_t1b2k1"),
        ("t1 b1 k1   SHUFFLE ctrl",  f"{PRE}/gm_abs_t1b1k1_shuf")]


def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if not e:
            continue
        pl = re.search(r"Found a solution of length (\d+)", s)
        g = re.search(r"mean g_s: ([\d.]+)", s)
        tvm = re.search(r"mean prior mass moved: ([\d.]+)", s)
        o[n] = dict(exp=int(e.group(1)), solved="Found a solution" in s,
                    plan=int(pl.group(1)) if pl else 0,
                    g=float(g.group(1)) if g else None,
                    tv=float(tvm.group(1)) if tvm else None)
    return o


def boot(v, n=4000):
    """Bootstrap CI of the MEDIAN, matching the medRatio point estimate."""
    if not v:
        return (0.0, 0.0)
    random.seed(0)
    m = []
    for _ in range(n):
        m.append(st.median([v[random.randrange(len(v))] for _ in v]))
    m.sort()
    return m[int(.025 * n)], m[int(.975 * n)]


B = load(BASE)
if not B:
    sys.exit(f"missing baseline {BASE}")
bs = {x for x in B if B[x]["solved"]}
print(f"\nGOLDMINER  baseline {BASE}: {len(bs)}/{len(B)} solved, "
      f"median {st.median([B[x]['exp'] for x in bs]):.0f} expansions\n")

hdr = (f"{'arm':<28}{'n':>5}{'cov':>8}{'net%':>9}{'chg%':>7}{'medRatio':>10}{'95% CI':>16}"
       f"{'win%':>7}{'shorter':>9}{'mean g_s':>10}{'massMoved':>11}")
print(hdr)
print("-" * len(hdr))
for label, d in ARMS:
    A = load(d)
    if not A:
        print(f"{label:<28}  -- missing {d}")
        continue
    sv = {x for x in A if A[x]["solved"]}
    k = sorted(sv & bs)
    if not k:
        print(f"{label:<28}  -- no shared solved instances")
        continue
    tb = sum(B[x]["exp"] for x in k)
    ta = sum(A[x]["exp"] for x in k)
    # Most instances are byte-identical to baseline (median ~21 expansions), so the
    # median over ALL of them pins to exactly 1.000 and says nothing. Report the median
    # over the instances the arm actually CHANGED, plus what fraction that is.
    chg = [x for x in k if A[x]["exp"] != B[x]["exp"]]
    r = [A[x]["exp"] / B[x]["exp"] for x in chg]
    lo, hi = boot(r)
    imp = sum(1 for x in k if A[x]["exp"] < B[x]["exp"])
    reg = sum(1 for x in k if A[x]["exp"] > B[x]["exp"])
    short = sum(1 for x in k if A[x]["plan"] and B[x]["plan"] and A[x]["plan"] < B[x]["plan"])
    gs = [A[x]["g"] for x in k if A[x]["g"] is not None]
    tvs = [A[x]["tv"] for x in k if A[x]["tv"] is not None]
    flag = "!" if len(A) < len(B) else " "   # partial array: fewer .out files than baseline
    print(f"{label:<28}{len(A):>4}{flag}{100*len(sv)/len(A):>7.1f}%{100*(tb-ta)/tb:>+8.1f}%"
          f"{100*len(chg)/len(k):>6.0f}%{(st.median(r) if r else float('nan')):>10.3f}"
          f"{f'[{lo:.3f},{hi:.3f}]':>16}"
          f"{(100*imp/(imp+reg) if imp+reg else 0):>6.0f}%{short:>9}"
          f"{(st.mean(gs) if gs else float('nan')):>10.3f}"
          f"{(st.mean(tvs) if tvs else float('nan')):>11.4f}")

print("\ncoverage losses vs baseline (instances the baseline solved and the arm did not):")
for label, d in ARMS:
    A = load(d)
    if not A:
        continue
    lost = sorted(bs - {x for x in A if A[x]["solved"]})
    print(f"  {label:<28}{len(lost):>4}" + (f"   {', '.join(lost[:6])}" if lost else ""))
