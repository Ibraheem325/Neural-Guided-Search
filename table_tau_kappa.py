"""Paired table for the c(s) = c_puct*(1 + kappa*g_s) sweep (review point 6).

Each arm is compared against its MATCHED-LEVEL control, not against the baseline. The
control is kappa=0 at c_puct = 1.5*(1 + kappa*mean g_s), so the pair carries the same
mean exploration pressure and differs only in whether that pressure is allocated
per-state. Both sides run abs_signal=add with beta=0, so the prior transform is identical
and explore_mult is the only difference.

  arm beats control  => state-adaptive exploration is real
  arm == control     => c(s) is a disguised global c_puct knob, and point 6 is negative

LEVEL-MATCH AUDIT. The control's c_puct was set from mean g_s measured OFFLINE on plan
states (new_signal_data.json). During search the visited-state distribution differs, so
the realised level can drift. Every arm prints "[Abs] ... mean g_s: X" per instance; the
'realised' column averages those and reports the effective c_puct the arm actually ran at.
If that column is far from the control's c_puct, the pair is NOT matched and the
comparison must be re-read (or the control re-run at the realised value).

Usage: venv/bin/python table_tau_kappa.py [--prefix results]
"""
import re, glob, os, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("--prefix", default="results")
A_ = ap.parse_args()

BASE = f"{A_.prefix}/gm_base"
C_PUCT0 = 1.5

# (label, arm dir, control dir, control's c_puct)
# k1's arm ran earlier as gm_abs_t1b0k1 (c_puct=1.5, tau=1, beta=0, kappa=1); only its
# control is new, so the pair is assembled here rather than resubmitting the arm.
PAIRS = [("tau=1.00 kappa=1", "gm_abs_t1b0k1", "gm_tk_t1k1_ctl",   2.08),
         ("tau=1.00 kappa=3", "gm_tk_t1k3",    "gm_tk_t1k3_ctl",   3.24),
         ("tau=1.00 kappa=5", "gm_tk_t1k5",    "gm_tk_t1k5_ctl",   4.40),
         ("tau=0.25 kappa=3", "gm_tk_t025k3",  "gm_tk_t025k3_ctl", 4.49)]


def load(d):
    """{instance: (expansions, solved)} plus the mean realised g_s over instances."""
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
    """Ratio stats on the set both solved."""
    shared = [i for i in a if i in b and a[i][1] and b[i][1] and b[i][0] > 0]
    if not shared:
        return None
    r = sorted(a[i][0] / b[i][0] for i in shared)
    sa = sum(a[i][0] for i in shared)
    sb = sum(b[i][0] for i in shared)
    win = sum(1 for i in shared if a[i][0] < b[i][0])
    loss = sum(1 for i in shared if a[i][0] > b[i][0])
    return dict(n=len(shared), med=st.median(r), net=100.0 * (sb - sa) / sb,
                win=win, loss=loss)


base, _ = load(BASE)
ncov = lambda d: sum(1 for v in d.values() if v[1])

print(f"baseline {BASE}: {ncov(base)}/{len(base)} solved\n")
print(f"{'pair':<18} {'cov arm':>8} {'cov ctl':>8} {'realised':>20} "
      f"{'n':>4} {'median':>7} {'net%':>7} {'win/loss':>10}")
print("-" * 92)

missing = []
for label, ad, cd, cp in PAIRS:
    arm, g_arm = load(ad)
    ctl, _ = load(cd)
    if not arm or not ctl:
        missing.append(f"{label}: " + ", ".join(
            d for d, x in ((ad, arm), (cd, ctl)) if not x))
        continue
    kappa = float(label.split("kappa=")[1])
    if g_arm is not None:
        eff = C_PUCT0 * (1 + kappa * g_arm)
        real = f"g_s={g_arm:.3f} c={eff:.2f} vs {cp:.2f}"
    else:
        real = "n/a"
    c = compare(arm, ctl)
    if c is None:
        print(f"{label:<18} {ncov(arm):>8} {ncov(ctl):>8} {real:>20}  (no shared solved)")
        continue
    print(f"{label:<18} {ncov(arm):>8} {ncov(ctl):>8} {real:>20} "
          f"{c['n']:>4} {c['med']:>7.3f} {c['net']:>+7.1f} {c['win']:>4}/{c['loss']:<5}")

print("\nmedian/net/win are ARM vs its MATCHED CONTROL (not vs baseline).")
print("median < 1.000 and win > loss => per-state allocation beats the same mean pressure.")
print("'realised' is the arm's in-search mean g_s and the effective c_puct it implies;")
print("it must be close to the control's c_puct for the pair to be level-matched.")
if missing:
    print("\nnot yet on disk:")
    for m in missing:
        print("  " + m)
