"""What would the new (absolute) exploration bonus actually do on grid / goldminer?

Reads new_signal_data.json (raw per-action Bellman residuals e_a + SAC priors) and
applies the supervisor's formulation:

    x_a  = e_a / (e_a + tau_step)                      per-action, NO sibling division
    g_s  = (1/K) sum_a x_a                             state-level inconsistency
    c(s) = c0 (1 + kappa g_s)                          exploration-constant channel
    P0   = (1-eps_p) P + eps_p/K                       prior floor
    Pmul = P0 (1+beta x_a) / sum_b P0 (1+beta x_b)
    Padd = (P0 + beta x_a/K) / (1 + beta g_s)

and compares against the OLD one:  rel = e_a/mean_b(e_b),  mult = max(0.1, 1+beta(rel-1)).

Usage: venv/bin/python new_signal_report.py [tau] [beta] [kappa]
"""
import json, sys, statistics as st

TAU = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
BETA = float(sys.argv[2]) if len(sys.argv) > 2 else 1.0
KAPPA = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
EPS_P, C0 = 0.001, 1.5

D = json.load(open("new_signal_data.json"))


def pct(v, q):
    v = sorted(v)
    return v[min(len(v) - 1, int(q * len(v)))]


def auc(pos, neg):
    """P(score(pos) > score(neg)), ties half."""
    if not pos or not neg:
        return float("nan")
    allv = sorted(pos + neg)
    rank = {}
    i = 0
    while i < len(allv):
        j = i
        while j + 1 < len(allv) and allv[j + 1] == allv[i]:
            j += 1
        r = (i + j) / 2.0 + 1
        rank[allv[i]] = r
        i = j + 1
    s = sum(rank[v] for v in pos)
    n1, n2 = len(pos), len(neg)
    return (s - n1 * (n1 + 1) / 2) / (n1 * n2)


def tv(p, q):
    return 0.5 * sum(abs(a - b) for a, b in zip(p, q))


def derive(r):
    e, P, plan = r["e"], r["p"], r["plan"]
    K = len(e)
    x = [v / (v + TAU) for v in e]
    g = sum(x) / K
    P0 = [(1 - EPS_P) * p + EPS_P / K for p in P]
    zm = [P0[i] * (1 + BETA * x[i]) for i in range(K)]
    sm = sum(zm)
    Pm = [v / sm for v in zm]
    Pa = [(P0[i] + BETA * x[i] / K) / (1 + BETA * g) for i in range(K)]
    me = sum(e) / K
    rel = [v / me for v in e] if me > 1e-9 else [1.0] * K
    old = [max(0.1, 1 + BETA * (rv - 1)) for rv in rel]
    return dict(K=K, e=e, x=x, g=g, P0=P0, Pm=Pm, Pa=Pa, old=old, rel=rel, plan=plan,
                scale=me, sac=max(range(K), key=lambda i: P[i]),
                argx=max(range(K), key=lambda i: x[i]))


for dom, recs in D.items():
    R = [derive(r) for r in recs]
    n = len(R)
    mis = [r for r in R if r["sac"] != r["plan"]]     # policy is wrong here
    cor = [r for r in R if r["sac"] == r["plan"]]
    print(f"\n{'='*78}\n{dom.upper()}   n={n} states   "
          f"mistake nodes={len(mis)} ({100*len(mis)/n:.0f}%)   "
          f"median |A|={st.median([r['K'] for r in R]):.0f}   "
          f"[tau={TAU} beta={BETA} kappa={KAPPA}]\n{'='*78}")

    # ---- 1. absolute scale: what e_a actually looks like -------------------
    alle = [v for r in R for v in r["e"]]
    print("\n1. RAW Bellman residual e_a (in reward units; 1.0 = one action)")
    print(f"   p10={pct(alle,.10):.3f}  p25={pct(alle,.25):.3f}  median={pct(alle,.50):.3f}  "
          f"p75={pct(alle,.75):.3f}  p90={pct(alle,.90):.3f}  max={max(alle):.2f}")
    print(f"   -> x_a: p10={pct(alle,.10)/(pct(alle,.10)+TAU):.3f}  "
          f"median={pct(alle,.50)/(pct(alle,.50)+TAU):.3f}  "
          f"p90={pct(alle,.90)/(pct(alle,.90)+TAU):.3f}")

    # ---- 2. the supervisor's objection, measured --------------------------
    print("\n2. DOES THE BONUS STILL FIRE WHERE THERE IS NOTHING TO FIND?")
    print("   states bucketed by absolute scale mean_a(e_a); boost = max_a of the prior multiplier")
    Rs = sorted(R, key=lambda r: r["scale"])
    qs = [Rs[i * n // 4:(i + 1) * n // 4] for i in range(4)]
    print(f"   {'scale quartile':<16}{'n':>5}{'med mean e':>12}{'OLD max boost':>15}"
          f"{'NEW max boost':>15}{'med g_s':>10}{'c(s)/c0':>10}")
    for i, q in enumerate(qs):
        if not q:
            continue
        print(f"   Q{i+1} {'(cleanest)' if i==0 else '(dirtiest)' if i==3 else '':<12}"
              f"{len(q):>5}{st.median([r['scale'] for r in q]):>12.3f}"
              f"{st.median([max(r['old']) for r in q]):>15.2f}"
              f"{st.median([1+BETA*max(r['x']) for r in q]):>15.2f}"
              f"{st.median([r['g'] for r in q]):>10.3f}"
              f"{st.median([1+KAPPA*r['g'] for r in q]):>10.2f}")

    # states where the siblings are genuinely indistinguishable
    conf = [r for r in R if max(r["e"]) - min(r["e"]) < 0.25]
    if conf:
        ob = [max(r["old"]) for r in conf]
        nb = [1 + BETA * max(r["x"]) for r in conf]
        print(f"\n   'nothing to choose' states (max e - min e < 0.25): {len(conf)}/{n} "
              f"({100*len(conf)/n:.0f}%)")
        print(f"     OLD boosts them >2x in {100*sum(1 for v in ob if v>2)/len(conf):>3.0f}% of them "
              f"(median boost {st.median(ob):.2f})")
        print(f"     NEW boosts them >2x in {100*sum(1 for v in nb if v>2)/len(conf):>3.0f}% of them "
              f"(median boost {st.median(nb):.2f})")

    # ---- 3. state-level channel g_s ---------------------------------------
    print("\n3. STATE CHANNEL  g_s -> c(s)=c0(1+kappa g_s)   [new; the old rel could not do this]")
    print(f"   g_s at mistake nodes  median={st.median([r['g'] for r in mis]):.3f}   "
          f"at correct nodes median={st.median([r['g'] for r in cor]):.3f}")
    print(f"   AUC(g_s separates mistake from correct nodes) = "
          f"{auc([r['g'] for r in mis], [r['g'] for r in cor]):.3f}   (0.5 = useless)")
    allg = [r["g"] for r in R]
    print(f"   c(s)/c0: p10={1+KAPPA*pct(allg,.10):.2f}  median={1+KAPPA*pct(allg,.50):.2f}  "
          f"p90={1+KAPPA*pct(allg,.90):.2f}")

    # ---- 4. which arm --------------------------------------------------------
    chance = st.mean([1.0 / r["K"] for r in R])
    print("\n4. WHICH ARM  (ranking by x_a == ranking by e_a == ranking by rel: UNCHANGED)")
    print(f"   top-1 arm = plan action, at mistake nodes: "
          f"{100*sum(1 for r in mis if r['argx']==r['plan'])/max(1,len(mis)):.0f}%   "
          f"(chance {100*chance:.0f}%)")
    print(f"   misfires at correct nodes (top-1 arm != policy's pick): "
          f"{100*sum(1 for r in cor if r['argx']!=r['sac'])/max(1,len(cor)):.0f}%")

    # ---- 5. what the prior actually becomes ---------------------------------
    print("\n5. PRIOR PERTURBATION (multiplicative vs additive)")
    print(f"   {'':<22}{'med TV(P0,P)':>14}{'p90 TV':>10}{'argmax flips':>14}"
          f"{'med P(plan) @ mistake':>24}{'x vs P0':>10}")
    p0plan = st.median([r["P0"][r["plan"]] for r in mis]) if mis else float("nan")
    for lbl, key in [("multiplicative", "Pm"), ("additive", "Pa")]:
        flips = sum(1 for r in R if max(range(r["K"]), key=lambda i: r[key][i]) != r["sac"])
        pl = st.median([r[key][r["plan"]] for r in mis]) if mis else float("nan")
        tvs = [tv(r["P0"], r[key]) for r in R]
        print(f"   {lbl:<22}{st.median(tvs):>14.4f}{pct(tvs,.90):>10.3f}"
              f"{100*flips/n:>13.0f}%{pl:>24.4f}{pl/p0plan if p0plan>0 else float('nan'):>9.1f}x")
    print(f"   {'(baseline P0)':<22}{'-':>14}{'-':>10}{'-':>14}{p0plan:>24.4f}{'1.0x':>10}")

    # how dead is the plan action's prior at mistake nodes? decides mult vs add
    if mis:
        dead = sum(1 for r in mis if r["P0"][r["plan"]] < 0.01)
        print(f"   at mistake nodes the plan action has P0 < 0.01 in "
              f"{100*dead/len(mis):.0f}% of them -> multiplicative cannot lift it")
