"""Every domain-specific constant the OPTION 9 controls need, fitted from one
new_signal_probe.py dump.

These are NOT constants across domains and must not be copied between them:

  lognormal:SIGMA:MU  the RANDOM control's draw. OPTION 9 consumes RAW residuals e (no
                      sibling division), so the draw has to match that marginal or g_s
                      lands at the wrong level. Fitted per domain: goldminer -0.585/1.003,
                      logistics -0.461/0.992.
  mean g_s            sets the c(s) matched control's c_puct = 1.5*(1 + kappa*mean g_s).
                      Without it, a c(s) arm cannot be told apart from a global c_puct bump.
  W = b*g/(1+b*g)     the prior mass P_+ injects at beta=b. Use it as eps_p to make a
                      flattening arm mass-matched, so the only remaining difference is the
                      tilt. goldminer 0.28, grid 0.27, logistics 0.29.

Also reports how well the drawn g_s reproduces the real one. The control is valid when the
LEVEL matches (mean g_s within ~0.01) and the STRUCTURE does not (lower sd) -- that gap is
precisely what the control removes, so if the real arm beats it, the per-state magnitude of
the residual carries information.

Usage: venv/bin/python fit_random_control.py <signal_data.json> [--tau 1.0] [--seed 0]
"""
import json, math, random, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("json")
ap.add_argument("--tau", default=1.0, type=float)
ap.add_argument("--seed", default=0, type=int)
ap.add_argument("--c_puct", default=1.5, type=float)
A_ = ap.parse_args()

data = json.load(open(A_.json))
for name, recs in data.items():
    es = [v for r in recs for v in r["e"] if v > 0]
    if len(es) < 50:
        print(f"{name}: only {len(es)} positive residuals -- too few to fit")
        continue
    lg = [math.log(v) for v in es]
    mu, sd = st.mean(lg), st.pstdev(lg)

    g_real = [sum(v / (v + A_.tau) for v in r["e"]) / len(r["p"])
              for r in recs if len(r["p"]) >= 2]
    rng = random.Random(A_.seed)
    g_drawn = [sum(x / (x + A_.tau)
                   for x in (rng.lognormvariate(mu, sd) for _ in r["e"])) / len(r["p"])
               for r in recs if len(r["p"]) >= 2]

    gm = st.mean(g_real)
    print(f"\n=== {name} ===  ({len(recs)} states, {len(es)} edges, tau={A_.tau})")
    print(f"  raw e:      median {st.median(es):.3f}   mu {mu:.3f}   sigma {sd:.3f}")
    print(f"  RANDOM control spec:   lognormal:{sd:.3f}:{mu:.3f}")
    print(f"    level  mean g_s  real {gm:.4f}  drawn {st.mean(g_drawn):.4f}   "
          f"(want these EQUAL)")
    print(f"    struct sd   g_s  real {st.pstdev(g_real):.4f}  "
          f"drawn {st.pstdev(g_drawn):.4f}   (want drawn LOWER)")
    print(f"  mean g_s = {gm:.4f}")
    for k in (1, 3, 5):
        print(f"    c(s) matched control at kappa={k}: "
              f"c_puct = {A_.c_puct}*(1+{k}*{gm:.4f}) = {A_.c_puct*(1+k*gm):.2f}")
    for b in (1.0, 2.0):
        w = b * gm / (1 + b * gm)
        print(f"    mass injected at beta={b}:  W = {w:.3f}   "
              f"(use as eps_p for a mass-matched flattening control)")
