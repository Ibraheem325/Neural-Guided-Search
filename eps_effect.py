"""What does eps_p actually do to the exploration term? Measured on real states.

    u(a) = c_puct * P(a) * sqrt(N) / (1 + n_a)

P(a) MULTIPLIES the count bonus rather than adding to it, so an action the policy scores at
1e-5 has its exploration bonus scaled by 1e-5 too. It is not deprioritised, it is
UNREACHABLE: sqrt(N) would have to reach ~1e5 for it to compete with a q_norm gap of 1.

Flattening puts a floor under that:

    P0(a) = (1 - eps) P(a) + eps/K        so  P0(a) >= eps/K

and u then grows without bound in N. This script quantifies the change on the on-plan states
already recorded by new_signal_probe.py -- no search required, because everything here is a
property of the prior and the pUCT formula, not of any particular rollout.

Per eps it reports:

  P(a*)         the prior on the action the reference plan takes, median across states.
  unreachable   share of states with P(a*) < 1e-3, the threshold prior_peak.py uses for
                "numerically unreachable by the exploration term".
  sims to try   N at which the plan action's u first matches a q_norm gap of --qgap, for an
                UNVISITED action (n_a = 0):
                      c * P0(a*) * sqrt(N) = qgap   =>   N = (qgap / (c P0))^2
                Reported as a median over states. This is the honest form of "the count
                bonus can now surface it": not whether it is possible, but when.
  spread        median (max_a P0 - min_a P0). u at n_a = 0 is c*sqrt(N) times this, so it is
                DeltaU up to a factor common to every action -- which is why raising eps
                shrinks DeltaU while raising c_puct grows it. The two pull opposite ways.

Usage:
  venv/bin/python eps_effect.py <signal.json> [--eps 0.001,0.26,0.4,0.6] [--c 1.5] [--qgap 1.0]
  e.g. venv/bin/python eps_effect.py sat_signal_distinct.json
"""
import json, math, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("json")
ap.add_argument("--eps", default="0.001,0.26,0.40,0.60")
ap.add_argument("--c", default=1.5, type=float, help="c_puct")
ap.add_argument("--qgap", default=1.0, type=float,
                help="q_norm gap the exploration term must overcome. The measured DeltaQ "
                     "medians are 0.95-1.65 depending on domain, so 1.0 is representative.")
A_ = ap.parse_args()

EPS = [float(e) for e in A_.eps.split(",")]
data = json.load(open(A_.json))
sets = data if isinstance(data, dict) else {"(unnamed)": data}

for name, recs in sets.items():
    on_plan = [r for r in recs if r.get("plan", -1) >= 0 and len(r["p"]) >= 2]
    if not on_plan:
        print(f"### {name}: no on-plan states")
        continue

    ks = [len(r["p"]) for r in on_plan]
    print(f"### {name}   {len(on_plan)} on-plan states   K: median {st.median(ks):.0f} "
          f"(min {min(ks)}, max {max(ks)})   c_puct={A_.c}  qgap={A_.qgap}")
    print(f"  {'eps':>6}  {'floor eps/K':>12}  {'P(a*) med':>10}  {'<1e-3':>7}  "
          f"{'sims to try a*':>16}  {'spread(P0)':>11}")

    for eps in EPS:
        pstar, unreach, sims, spread = [], 0, [], []
        for r in on_plan:
            K = len(r["p"])
            p0 = [(1.0 - eps) * p + eps / K for p in r["p"]]
            ps = p0[r["plan"]]
            pstar.append(ps)
            if ps < 1e-3:
                unreach += 1
            # N at which c * P0(a*) * sqrt(N) reaches qgap, for an unvisited action
            sims.append((A_.qgap / (A_.c * ps)) ** 2 if ps > 0 else float("inf"))
            spread.append(max(p0) - min(p0))
        fin = [s for s in sims if s != float("inf")]
        med_sims = st.median(fin) if fin else float("inf")
        print(f"  {eps:>6.3f}  {eps/st.median(ks):>12.5f}  {st.median(pstar):>10.5f}  "
              f"{100.0*unreach/len(on_plan):>6.1f}%  {med_sims:>16,.0f}  "
              f"{st.median(spread):>11.4f}")

    print("  (sims to try a* is the median over states of the simulation count at which the")
    print("   plan action's exploration term first matches a q_norm gap of "
          f"{A_.qgap}. At eps=0.001 this")
    print("   is the number that makes the action unreachable in practice.)\n")
