"""The prior-flattening curve on goldminer: how far can you flatten before it stops helping?

prior'(a) = (1-w)*P(a) + w/K, with NO signal of any kind (--signal constant).
w=0 is the baseline; w=1.0 discards the SAC policy entirely (uniform prior, Q-critics
guide the search alone).

The shape is the answer:
  peaks in the middle, falls off by w=1.0  -> the policy carries real information and the
                                              problem is CALIBRATION (overconfidence)
  still climbing at w=1.0                  -> the policy is worse than no policy for
                                              guiding search; the problem is COMPETENCE

Reference points measured offline (policy_quality_gold.py): goldminer top-1 = plan action
81.3% vs 40.8% uniform, so the policy IS informative and the curve is predicted to peak in
the middle. w=1.0 winning would contradict that and needs explaining.

Usage: venv/bin/python analyze_flat.py [results_prefix]
"""
import re, glob, os, sys, statistics as st

PRE = sys.argv[1] if len(sys.argv) > 1 else "results"
BASE = f"{PRE}/gm_base"
ARMS = [("0.00 (baseline)", BASE), ("0.10", f"{PRE}/gm_flat010"), ("0.20", f"{PRE}/gm_flat020"),
        ("0.28", f"{PRE}/gm_flat028"), ("0.42", f"{PRE}/gm_flat042"),
        ("0.60", f"{PRE}/gm_flat060"), ("0.80", f"{PRE}/gm_flat080"),
        ("1.00 (policy off)", f"{PRE}/gm_flat100")]
# for context, the best signal-based arms on the same instances
REF = [("OPTION 9 add b=1 k=1", f"{PRE}/gm_abs_t1b1k1"),
       ("OPTION 9 add b=1 k=0", f"{PRE}/gm_abs_t1b1k0"),
       ("OPTION 9 SHUFFLE",     f"{PRE}/gm_abs_t1b1k1_shuf"),
       ("OPTION 9 RANDOM",      f"{PRE}/gm_abs_t1b1k1_rndm"),
       ("binc b=4 (gated)",     f"{PRE}/gm_binc40")]


def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            o[os.path.basename(f)[:-4]] = (int(e.group(1)), "Found a solution" in s)
    return o


B = load(BASE)
if not B:
    sys.exit(f"missing baseline {BASE}")
bs = {x for x in B if B[x][1]}
N = len(B)
print(f"\nGOLDMINER prior-flattening curve   baseline {len(bs)}/{N} solved, "
      f"median {st.median([B[x][0] for x in bs]):.0f} expansions\n")
hdr = (f"{'w':<20}{'n':>5}{'solved':>8}{'cov%':>8}{'net%':>9}{'mean ratio':>12}"
       f"{'improved':>10}{'regressed':>11}")
print(hdr); print("-" * len(hdr))


def row(label, d, is_base=False):
    A = load(d)
    if not A:
        return f"{label:<20}   -- not run"
    sv = {x for x in A if A[x][1]}
    flag = "!" if len(A) < N else " "
    if is_base:
        return (f"{label:<20}{len(A):>4}{flag}{len(sv):>8}{100*len(sv)/N:>7.1f}%"
                f"{'-':>9}{'-':>12}{'-':>10}{'-':>11}")
    k = sorted(sv & bs)
    if not k:
        return f"{label:<20}   -- no shared solved instances"
    tb = sum(B[x][0] for x in k); ta = sum(A[x][0] for x in k)
    r = [A[x][0] / B[x][0] for x in k]
    imp = sum(1 for x in k if A[x][0] < B[x][0])
    reg = sum(1 for x in k if A[x][0] > B[x][0])
    return (f"{label:<20}{len(A):>4}{flag}{len(sv):>8}{100*len(sv)/N:>7.1f}%"
            f"{100*(tb-ta)/tb:>+8.1f}%{sum(r)/len(r):>12.3f}{imp:>10}{reg:>11}")


for i, (label, d) in enumerate(ARMS):
    print(row(label, d, is_base=(i == 0)))
print(f"\n{'--- signal arms, same instances ---':<20}")
print(hdr); print("-" * len(hdr))
for label, d in REF:
    print(row(label, d))
print("\ncov% is over all {} instances, so a partial array (flagged !) is not hidden.".format(N))
