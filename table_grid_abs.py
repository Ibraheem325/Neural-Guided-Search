"""Grid: the multiplicative tilt at a floor where it can act (eps_p=0.60), and the
c(s)-only arm (beta=0, kappa=1). Same two-table format as table_tau_kappa.py.

Each arm has a MATCHED SIGNAL-FREE CONTROL that moves the same amount of probability
mass / carries the same mean exploration pressure, so the tables answer "does the signal's
ALLOCATION matter" rather than "does perturbing the prior matter":

  grid_mul_e060_k0   vs grid_flat060          same 0.60 mass, tilted vs blind
  grid_abs_t1b0k1    vs grid_abs_t1b0k1_ctl   same mean c_puct (2.05), per-state vs flat

READ THIS FIRST: the grid baseline solves 479/480, so there is NO coverage headroom and
any coverage loss is a pure negative. The only meaningful axis here is expansion
efficiency. Grid's arm ranking is also below chance offline (the signal's top action is
the plan action 18% of the time at mistake nodes vs 24% for random guessing, n=914), so
a null on the allocation question is the expected outcome, not a surprise.

Usage: venv/bin/python table_grid_abs.py [--prefix results]
"""
import re, glob, os, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("--prefix", default="results")
A_ = ap.parse_args()

BASE = f"{A_.prefix}/az_probe_qrval_base"

# (label, arm dir, matched-control dir, what the control holds fixed)
PAIRS = [("mul eps=0.60 k=0", "grid_mul_e060_k0", "grid_flat060",
          "same 0.60 prior mass, blind"),
         ("add beta=0 k=1",   "grid_abs_t1b0k1",  "grid_abs_t1b0k1_ctl",
          "same mean c_puct=2.05, flat")]


def load(d):
    """{instance: (expansions, solved)}, plus mean in-search g_s where OPTION 9 logged it."""
    out, gs = {}, []
    for f in glob.glob(f"{A_.prefix}/{d}/*.out" if not d.startswith(A_.prefix) else d + "/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            out[n] = (int(e.group(1)), "Found a solution" in s)
        g = re.search(r"\[Abs\] nodes modulated: \d+, mean g_s: ([\d.]+)", s)
        if g:
            gs.append(float(g.group(1)))
    return out, (st.mean(gs) if gs else None)


def compare(a, b):
    shared = [i for i in a if i in b and a[i][1] and b[i][1] and b[i][0] > 0]
    if not shared:
        return None
    r = sorted(a[i][0] / b[i][0] for i in shared)
    sa = sum(a[i][0] for i in shared); sb = sum(b[i][0] for i in shared)
    win = sum(1 for i in shared if a[i][0] < b[i][0])
    loss = sum(1 for i in shared if a[i][0] > b[i][0])
    return dict(n=len(shared), med=st.median(r), mean=sum(r) / len(r),
                net=100.0 * (sb - sa) / sb, win=win, loss=loss)


base, _ = load(BASE)
ncov = lambda d: sum(1 for v in d.values() if v[1])
if not base:
    raise SystemExit(f"baseline not found: {A_.prefix}/{BASE}")

print(f"### GRID   vs baseline {BASE} ({ncov(base)}/{len(base)} solved) ###\n")
print("| arm | cov | net% | mean | median | improved | regressed | identical |")
print("| --- | --- | ---- | ---- | ------ | -------- | --------- | --------- |")
missing = []
for label, ad, cd, _ in PAIRS:
    for tag, d in ((f"{label}  ARM", ad), (f"{label}  CTL", cd)):
        A, _g = load(d)
        if not A:
            missing.append(d)
            continue
        c = compare(A, base)
        if c is None:
            continue
        tie = c["n"] - c["win"] - c["loss"]
        print(f"| {tag} | {ncov(A)} | {c['net']:+.1f}% | {c['mean']:.3f} | {c['med']:.3f} "
              f"| {c['win']} | {c['loss']} | {tie} ({100*tie/c['n']:.0f}%) |")

print("\nNOTE: do NOT compare ARM and CTL rows above against each other -- they use "
      "different\nshared sets (arm n base vs ctl n base) and net% is expansion-weighted "
      "and outlier-\ndominated. The controlled comparison is the next table.\n")

print("\n### ARM vs ITS MATCHED CONTROL (the actual test) ###\n")
print("| pair | control holds fixed | shared | median | mean | net% | improved | regressed | identical |")
print("| ---- | ------------------- | ------ | ------ | ---- | ---- | -------- | --------- | --------- |")
for label, ad, cd, what in PAIRS:
    arm, g_arm = load(ad); ctl, _ = load(cd)
    if not arm or not ctl:
        continue
    c = compare(arm, ctl)
    if c is None:
        continue
    tie = c["n"] - c["win"] - c["loss"]
    print(f"| {label} | {what} | {c['n']} | {c['med']:.3f} | {c['mean']:.3f} "
          f"| {c['net']:+.1f}% | {c['win']} | {c['loss']} | {tie} ({100*tie/c['n']:.0f}%) |")

print("\nmedian < 1.000 with improved > regressed => the signal's allocation beats the "
      "matched blind control.")
print("median = 1.000 with a large 'identical' share => the channel did not engage at all.")

for label, ad, cd, _ in PAIRS:
    arm, g_arm = load(ad)
    if arm and g_arm is not None:
        print(f"\n[{label}] in-search mean g_s = {g_arm:.3f}  "
              f"=> c(s)/c_puct = {1+g_arm:.3f} at kappa=1 (effective c_puct "
              f"{1.5*(1+g_arm):.2f} vs control 2.05)")

if missing:
    print("\nnot on disk: " + ", ".join(sorted(set(missing))))
