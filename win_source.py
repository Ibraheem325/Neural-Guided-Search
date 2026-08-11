"""Are an arm's big wins UNCERTAINTY DETECTION, or just where any perturbation pays off?

THE QUESTION. A concentrated net% is not by itself damning. If the signal measures
uncertainty, it should only fire where the model IS uncertain -- so a handful of instances
carrying the savings is exactly what a working signal looks like, with the rest a flat tax
for computing it. But the identical pattern is produced by an arm that simply perturbs the
prior and gets lucky on the instances where the baseline was stuck. The two stories are
indistinguishable from the net% alone, and they have opposite implications.

Two tests, both needed:

  1. OVERLAP WITH BLIND CONTROLS. Take the instances the arm wins most on, and look at what
     the SIGNAL-FREE controls did on those same instances. If shuffle or flat also win big
     there, the instances were simply perturbation-friendly and the signal contributed
     nothing -- the win is a property of the instance, not of the measurement. If the arm
     wins there and the controls do not, the targeting is doing the work.

     Reported as a rank correlation between the arm's per-instance log-ratio and each
     control's. High correlation = same instances, same magnitude = no signal content.

  2. DOES g_s PREDICT THE WIN? g_s = mean_a e_a/(e_a+tau) is the signal's OWN uncertainty
     estimate for a state. If the wins are uncertainty detection, the instances the arm
     wins on should have higher g_s than the ones it loses on, and g_s should correlate
     with the log-ratio across instances. If g_s carries no information about where the arm
     helps, then whatever the arm is doing, it is not "helping where the model is
     uncertain" -- which is the claim the whole method rests on.

     Needs a signal json from new_signal_probe.py carrying the `inst` field.

A THIRD READING the tests can produce: the arm wins where g_s is high AND the controls also
win there. That means uncertainty marks instances where the baseline is stuck, but any
perturbation rescues them -- the diagnosis is real and the prescription is not.

Rank correlation is Spearman, computed here to avoid a scipy dependency. Ties get average
ranks. The p-value is a normal approximation, fine at n >= 30 and only used as a rough
guide.

Usage:
  venv/bin/python win_source.py <arm> <ctl> [--controls a,b,c] [--signal json] [--top 20]
  e.g. venv/bin/python win_source.py rov_mul_e040_k0 rov_base \\
         --controls rov_mul_e040_k0_shuf,rov_flat040,rov_abs_t1b1k1_rndm \\
         --signal rov_signal_distinct.json
"""
import re, glob, os, json, math, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("arm")
ap.add_argument("ctl", help="the BASELINE both the arm and the controls are measured against")
ap.add_argument("--controls", default="", help="comma-separated signal-free arms to compare")
ap.add_argument("--signal", default=None, help="new_signal_probe.py json (needs `inst`)")
ap.add_argument("--prefix", default="results")
ap.add_argument("--top", default=20, type=int)
ap.add_argument("--tau", default=1.0, type=float)
A_ = ap.parse_args()


def load(d):
    """{instance: expansions} for instances that were SOLVED."""
    out = {}
    for f in glob.glob(f"{A_.prefix}/{d}/*.out"):
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e and "Found a solution" in s:
            out[os.path.basename(f)[:-4]] = int(e.group(1))
    return out


def ranks(xs):
    """Average ranks, so ties do not distort the correlation."""
    order = sorted(range(len(xs)), key=lambda i: xs[i])
    r = [0.0] * len(xs)
    i = 0
    while i < len(order):
        j = i
        while j + 1 < len(order) and xs[order[j + 1]] == xs[order[i]]:
            j += 1
        avg = (i + j) / 2.0 + 1.0
        for k in range(i, j + 1):
            r[order[k]] = avg
        i = j + 1
    return r


def spearman(xs, ys):
    """(rho, approximate two-sided p). Returns (nan, nan) below n=4."""
    n = len(xs)
    if n < 4:
        return float("nan"), float("nan")
    rx, ry = ranks(xs), ranks(ys)
    mx, my = st.mean(rx), st.mean(ry)
    num = sum((a - mx) * (b - my) for a, b in zip(rx, ry))
    den = math.sqrt(sum((a - mx) ** 2 for a in rx) * sum((b - my) ** 2 for b in ry))
    if den == 0:
        return float("nan"), float("nan")
    rho = num / den
    z = abs(rho) * math.sqrt(n - 1)
    p = math.erfc(z / math.sqrt(2))
    return rho, p


base = load(A_.ctl)
arm = load(A_.arm)
shared = sorted(i for i in arm if i in base and base[i] > 0 and arm[i] > 0)
if not shared:
    raise SystemExit(f"no shared solved instances between {A_.arm} and {A_.ctl}")

# log ratio: negative = the arm expanded FEWER nodes = a win. Log so that halving and
# doubling are symmetric; on raw ratios a win is bounded by 0 and a loss is unbounded,
# which would let a handful of blow-ups dominate any correlation.
lr = {i: math.log(arm[i] / base[i]) for i in shared}
ordered = sorted(shared, key=lambda i: lr[i])          # best wins first
top = ordered[:A_.top]
rest = ordered[A_.top:]

print(f"### {A_.arm} vs {A_.ctl}")
print(f"{len(shared)} shared solved instances; TOP {len(top)} = the arm's biggest wins\n")

tot_b, tot_a = sum(base[i] for i in shared), sum(arm[i] for i in shared)
print(f"whole set   net {100*(1-tot_a/tot_b):+6.1f}%   median ratio "
      f"{st.median(math.exp(lr[i]) for i in shared):.3f}")
for label, grp in (("top", top), ("rest", rest)):
    if not grp:
        continue
    b, a = sum(base[i] for i in grp), sum(arm[i] for i in grp)
    print(f"{label:>10}   net {100*(1-a/b):+6.1f}%   median ratio "
          f"{st.median(math.exp(lr[i]) for i in grp):.3f}   n={len(grp)}")

# --- TEST 1: do the blind controls win on the SAME instances? -------------------------
ctrls = [c for c in A_.controls.split(",") if c.strip()]
if ctrls:
    print("\n--- TEST 1: do SIGNAL-FREE controls win on the same instances? ---")
    print("rho = rank correlation of per-instance log-ratio, arm vs control.")
    print("HIGH rho -> same instances, same magnitude -> the win is not signal content.\n")
    print(f"{'control':<28} {'n':>4} {'rho':>7} {'p':>8}   "
          f"{'ctl net on ARM top':>19}   {'median ratio there':>18}")
    for c in ctrls:
        cd = load(c)
        both = [i for i in shared if i in cd and cd[i] > 0]
        if len(both) < 4:
            print(f"{c:<28} {len(both):>4}   too few shared instances")
            continue
        clr = {i: math.log(cd[i] / base[i]) for i in both}
        rho, p = spearman([lr[i] for i in both], [clr[i] for i in both])
        tt = [i for i in top if i in cd and cd[i] > 0]
        if tt:
            b, a = sum(base[i] for i in tt), sum(cd[i] for i in tt)
            net_s = f"{100*(1-a/b):+6.1f}%"
            med_s = f"{st.median(math.exp(clr[i]) for i in tt):.3f}"
        else:
            net_s = med_s = "-"
        print(f"{c:<28} {len(both):>4} {rho:>7.3f} {p:>8.4f}   {net_s:>19}   {med_s:>18}")
    print("\nFor reference the ARM's own numbers on its top set:")
    b, a = sum(base[i] for i in top), sum(arm[i] for i in top)
    print(f"{A_.arm:<28} {len(top):>4} {1.000:>7.3f} {0.0:>8.4f}   {100*(1-a/b):>18.1f}%   "
          f"{st.median(math.exp(lr[i]) for i in top):>18.3f}")

# --- TEST 2: does g_s predict where the arm wins? -------------------------------------
if A_.signal:
    data = json.load(open(A_.signal))
    recs = [r for v in data.values() for r in v] if isinstance(data, dict) else data
    if not recs or "inst" not in recs[0]:
        raise SystemExit(f"{A_.signal} has no `inst` field -- regenerate it with the "
                         f"current new_signal_probe.py, which records the source probe.")
    per = {}
    for r in recs:
        g = st.mean(e / (e + A_.tau) for e in r["e"])      # g_s for this state
        per.setdefault(r["inst"], []).append(g)
    gs = {k: st.mean(v) for k, v in per.items()}

    have = [i for i in shared if i in gs]
    print(f"\n--- TEST 2: does g_s predict the win? ---")
    print(f"g_s = mean_a e_a/(e_a+tau), tau={A_.tau} -- the signal's OWN uncertainty measure.")
    print(f"{len(have)}/{len(shared)} shared instances have a g_s measurement.\n")
    if len(have) < 4:
        print("  too few instances with g_s; rerun new_signal_probe.py over the whole "
              "probe set (n_instances = probe count, n_steps = 1) to cover every probe.")
    else:
        rho, p = spearman([gs[i] for i in have], [lr[i] for i in have])
        print(f"  Spearman(g_s, log ratio) = {rho:+.3f}   p = {p:.4f}")
        print("  NEGATIVE rho = higher uncertainty goes with a bigger win = the signal is")
        print("  firing where it claims to. Near zero = g_s does not explain the wins.\n")
        tt = [i for i in top if i in gs]
        rr = [i for i in rest if i in gs]
        if tt and rr:
            print(f"  g_s on the arm's top {len(tt)} wins : median {st.median(gs[i] for i in tt):.4f}")
            print(f"  g_s on the other {len(rr):>4}        : median {st.median(gs[i] for i in rr):.4f}")
        w = [i for i in have if lr[i] < 0]
        l = [i for i in have if lr[i] > 0]
        if w and l:
            print(f"  g_s where the arm WON  (n={len(w):>3}): median {st.median(gs[i] for i in w):.4f}")
            print(f"  g_s where the arm LOST (n={len(l):>3}): median {st.median(gs[i] for i in l):.4f}")

print("\nReading it: if TEST 1 shows high rho and the controls match the arm's net on its "
      "own\ntop set, the wins are perturbation-friendly INSTANCES, not detected uncertainty. "
      "If\nTEST 2 shows rho near zero, the arm is not helping where its own measure says the "
      "model\nis uncertain -- whatever it is doing, it is not what the method claims.")
