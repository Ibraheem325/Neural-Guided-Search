"""Does the signal's tilt move prior mass ONTO the plan action, or away from it?

WHY THIS AND NOT g_s. win_source.py tests whether g_s -- the state's mean uncertainty --
predicts which instances an arm wins on. It came back null on rovers (rho +0.079) and
non-significant on satellite (-0.089). But g_s is the MEAN of x_a over a state's actions,
and the tilt

    P_x(a) = P0(a) * (1 + beta * x_a)   /  Z          (multiplicative)
    P_+(a) = (P0(a) + beta*x_a/K) / (1 + beta*g_s)    (additive)

acts on DIFFERENCES BETWEEN ACTIONS WITHIN a state. Averaging them away is exactly the
wrong summary: a state where every action has x_a = 0.4 and a state where the plan action
has 0.9 and the rest 0.1 have similar g_s and completely different tilts. g_s measures the
LEVEL of uncertainty; what the method needs is its DISCRIMINATION.

WHAT THIS MEASURES. On the on-plan states in a residual json (which record the index of the
action the reference plan takes), it asks the only question that matters for the mechanism:

    does the tilt RAISE the probability of the plan action, or lower it?

Three numbers per domain:

  PRECISION   fraction of states where P_tilted(a*) > P_untilted(a*). 50% is a coin flip,
              i.e. the tilt is uninformative about which action is right. Below 50% is worse
              than uninformative -- the signal is systematically pointing away from the plan.

  LIFT        median of P_tilted(a*) / P_untilted(a*). How much mass it actually moves.

  RANK        does the tilt improve a*'s rank among the actions? Reported as improved /
              worsened / unchanged. Rank is what pUCT's exploration term actually consumes,
              so this is closer to the search's experience than the raw probability is.

A domain where the search result is positive but precision sits at 50% would mean the arm
helps for a reason other than the one claimed -- e.g. it perturbs the prior with a
heavy-tailed, state-varying magnitude, which is a real intervention but not "detecting
uncertainty". That is the distinction the whole thesis rests on, and no search result can
settle it: only the tilt's own arithmetic can.

Baseline for comparison: a SHUFFLED tilt, x_a permuted among the same state's actions. It
holds the magnitude distribution fixed and destroys only the placement -- the same contrast
the shuffle search arm makes, computed here directly and without a search. Precision should
sit at chance for the shuffle; how far the real tilt beats it IS the signal's discriminative
content.

Usage:
  venv/bin/python tilt_precision.py <signal.json> [--beta 1.0] [--tau 1.0] [--eps 0.001]
                                    [--mode mul|add] [--seed 0]
  e.g. venv/bin/python tilt_precision.py sat_signal_distinct.json --beta 1.0 --eps 0.25
"""
import json, math, random, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("json")
ap.add_argument("--beta", default=1.0, type=float)
ap.add_argument("--tau", default=1.0, type=float)
ap.add_argument("--eps", default=0.001, type=float, help="eps_p prior floor applied first")
ap.add_argument("--mode", default="mul", choices=["mul", "add"])
ap.add_argument("--seed", default=0, type=int)
A_ = ap.parse_args()

rng = random.Random(A_.seed)
data = json.load(open(A_.json))
sets = data if isinstance(data, dict) else {"(unnamed)": data}


def tilt(P0, x, mode, beta):
    K = len(P0)
    if mode == "mul":
        q = [p * (1.0 + beta * xa) for p, xa in zip(P0, x)]
    else:
        g = sum(x) / K
        q = [(p + beta * xa / K) / (1.0 + beta * g) for p, xa in zip(P0, x)]
    z = sum(q)
    return [v / z for v in q] if z > 0 else list(P0)


for name, recs in sets.items():
    on_plan = [r for r in recs if r.get("plan", -1) >= 0 and len(r["e"]) >= 2]
    if not on_plan:
        print(f"### {name}: no on-plan states in {A_.json}")
        continue

    hit = shuf_hit = 0
    lifts, rank_up, rank_dn, rank_eq = [], 0, 0, 0
    for r in on_plan:
        i = r["plan"]
        K = len(r["e"])
        x = [e / (e + A_.tau) for e in r["e"]]
        P0 = [(1.0 - A_.eps) * p + A_.eps / K for p in r["p"]]

        q = tilt(P0, x, A_.mode, A_.beta)
        if q[i] > P0[i]:
            hit += 1
        if P0[i] > 0:
            lifts.append(q[i] / P0[i])

        # rank of a* before and after (1 = best); ties broken pessimistically both times
        r0 = sum(1 for v in P0 if v > P0[i])
        r1 = sum(1 for v in q if v > q[i])
        if r1 < r0:
            rank_up += 1
        elif r1 > r0:
            rank_dn += 1
        else:
            rank_eq += 1

        xs = list(x)
        rng.shuffle(xs)
        if tilt(P0, xs, A_.mode, A_.beta)[i] > P0[i]:
            shuf_hit += 1

    n = len(on_plan)
    print(f"### {name}   {n} on-plan states   "
          f"mode={A_.mode} beta={A_.beta} tau={A_.tau} eps={A_.eps}")
    print(f"  PRECISION   tilt raises P(a*) on {100.0*hit/n:5.1f}% of states "
          f"(shuffled tilt: {100.0*shuf_hit/n:5.1f}%)")
    if lifts:
        print(f"  LIFT        median P_tilt(a*)/P0(a*) = {st.median(lifts):.4f}   "
              f"p25 {st.quantiles(lifts, n=4)[0]:.4f}  p75 {st.quantiles(lifts, n=4)[2]:.4f}"
              if len(lifts) >= 4 else
              f"  LIFT        median P_tilt(a*)/P0(a*) = {st.median(lifts):.4f}")
    print(f"  RANK(a*)    improved {rank_up}  worsened {rank_dn}  unchanged {rank_eq}")
    edge = 100.0 * (hit - shuf_hit) / n
    print(f"  -> discriminative content = precision - shuffled precision = {edge:+.1f} pp")
    if abs(edge) < 2.0:
        print("     (at chance: the tilt carries no information about WHICH action is right;")
        print("      whatever the search gains comes from the perturbation's magnitude, not")
        print("      from where it points)")
