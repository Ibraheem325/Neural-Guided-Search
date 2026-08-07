"""Goldminer additive + multiplicative tables with PLAN LENGTH over commonly-solved
instances, against the optimal length.

WHY. If the baseline already returns optimal or near-optimal plans there is no quality
headroom, so an arm cannot look good by finding better plans -- and any expansion
reduction has to come from searching more efficiently for the same answer. If instead an
arm returns SHORTER plans while losing coverage, the expansion drop is partly explained by
it committing to a better path on the instances it does solve, and coverage and quality
have to be read together rather than separately.

COMMON SET. Every plan-length column is computed on the instances solved by the BASELINE
and by EVERY arm in that table, so the rows are directly comparable. This set is small
when one arm has poor coverage -- 'common' is printed so you can see what the averages
rest on.

OPTIMAL LENGTH. The probe name encodes a distance (246_d13_... -> d=13) and make_probes.py
built each probe by walking a source plan backwards, so d is the remaining suffix length.
That equals the true optimal distance ONLY IF the source plans were optimal. All 480
goldminer .plan files have length exactly d, which is consistent but not proof -- it is
the same number by construction. Run verify_optimal.py (Fast Downward astar(lmcut()))
before treating the 'opt' column as ground truth.

Usage: venv/bin/python table_plan_len.py [--prefix results] [--probe example/probeGold_near_goal_d5-20]
"""
import re, glob, os, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("--prefix", default="results")
ap.add_argument("--probe", default="example/probeGold_near_goal_d5-20")
ap.add_argument("--optlen", default="optlen_goldminer.json",
                help="json from collect_fd.py mapping probe -> FD plan length. Used in "
                     "place of the distance encoded in the probe name where available; "
                     "falls back to the encoded d for probes FD did not solve.")
A_ = ap.parse_args()

BASE = "gm_base"
TABLES = [
    ("ADDITIVE", [
        ("beta=1 kappa=1",          "gm_abs_t1b1k1"),
        ("beta=1 kappa=0 (prior)",  "gm_abs_t1b1k0"),
        ("beta=2 kappa=1",          "gm_abs_t1b2k1"),
        ("beta=0 kappa=1 (c(s))",   "gm_abs_t1b0k1"),
        ("shuffle",                 "gm_abs_t1b1k1_shuf"),
        ("random",                  "gm_abs_t1b1k1_rndm"),
    ]),
    ("MULTIPLICATIVE", [
        ("eps=0.001 kappa=0",       "gm_mul_e001_k0"),
        ("eps=0.001 kappa=1",       "gm_mul_e001_k1"),
        ("eps=0.28 kappa=0",        "gm_mul_e028_k0"),
        ("eps=0.40 kappa=0",        "gm_mul_e040_k0"),
        ("eps=0.60 kappa=0",        "gm_mul_e060_k0"),
        ("eps=0.28 shuffle",        "gm_mul_e028_k0_shuf"),
    ]),
]

DEPTH = re.compile(r"^\d+_d(\d+)_")


def load(d):
    """{instance: (expansions, plan_len, solved)}"""
    out = {}
    for f in glob.glob(f"{A_.prefix}/{d}/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        L = re.search(r"Found a solution of length (\d+)", s)
        if e:
            out[n] = (int(e.group(1)), int(L.group(1)) if L else None, L is not None)
    return out


# optimal length per probe: FD's answer where we have it, else the encoded distance.
OPT, SRC = {}, "encoded distance d (NOT verified -- run run_fd_optimal.sh + collect_fd.py)"
for p in glob.glob(A_.probe + "/*.pddl"):
    n = os.path.basename(p)[:-5]
    m = DEPTH.match(n)
    if m:
        OPT[n] = int(m.group(1))
if os.path.exists(A_.optlen):
    import json
    fd = json.load(open(A_.optlen))
    n_fd = sum(1 for k in fd if k in OPT)
    n_diff = sum(1 for k, v in fd.items() if k in OPT and v != OPT[k])
    OPT.update({k: v for k, v in fd.items() if k in OPT})
    SRC = (f"Fast Downward ({A_.optlen}), {n_fd} probes; {len(OPT)-n_fd} fall back to d"
           + (f"; {n_diff} differ from d" if n_diff else "; identical to d everywhere"))

base = load(BASE)
if not base:
    raise SystemExit(f"baseline not found: {A_.prefix}/{BASE}")
ntot = len(base)

for title, rows in TABLES:
    arms = [(lbl, d, load(d)) for lbl, d in rows]
    present = [(lbl, d, a) for lbl, d, a in arms if a]
    missing = [d for lbl, d, a in arms if not a]

    # common set: solved by baseline AND every present arm, and with a known optimal
    common = {i for i, v in base.items() if v[2] and i in OPT}
    for _, _, a in present:
        common &= {i for i, v in a.items() if v[2]}
    common = sorted(common)

    print(f"\n### GOLDMINER {title} ###")
    if not common:
        print("  empty common set -- one arm solves nothing the others do")
        if missing:
            print("  missing dirs: " + ", ".join(missing))
        continue

    opt_mean = st.mean(OPT[i] for i in common)
    print(f"net% / mean / improved / regressed: each arm's OWN shared-solved set with the")
    print(f"  baseline (this is what the existing tables report, so the numbers match).")
    print(f"plan len / vs opt: the COMMON set of {len(common)} instances solved by the")
    print(f"  baseline AND all {len(present)} arms, so plan lengths are comparable row to row.")
    print(f"  optimal on that set: mean {opt_mean:.2f} "
          f"(min {min(OPT[i] for i in common)}, max {max(OPT[i] for i in common)})\n")

    print("| arm | solved | cov% | net% | mean | improved | regressed | plan len | opt | vs opt |")
    print("| --- | ------ | ---- | ---- | ---- | -------- | --------- | -------- | --- | ------ |")

    def row(lbl, a, is_base=False):
        ns = sum(1 for v in a.values() if v[2])
        # arm's own shared-solved set with the baseline -- matches the existing tables
        k = [i for i in a if i in base and a[i][2] and base[i][2] and base[i][0] > 0]
        tb = sum(base[i][0] for i in k); ta = sum(a[i][0] for i in k)
        r = [a[i][0] / base[i][0] for i in k]
        imp = sum(1 for i in k if a[i][0] < base[i][0])
        reg = sum(1 for i in k if a[i][0] > base[i][0])
        net = 100.0 * (tb - ta) / tb if tb else 0.0
        # plan length on the COMMON set, so rows share a denominator
        pl = st.mean(a[i][1] for i in common)
        cells = ("|    — |    — |     — |      — " if is_base
                 else f"| {net:+.1f}% | {st.mean(r):.3f} | {imp} | {reg} ")
        print(f"| {lbl} | {ns} | {100.0*ns/ntot:.1f}% {cells}"
              f"| {pl:.2f} | {opt_mean:.2f} | {pl/opt_mean:.3f} |")

    row("BASELINE", base, is_base=True)
    for lbl, d, a in present:
        row(lbl, a)
    if missing:
        print("\nmissing dirs: " + ", ".join(missing))

    # Reference: the baseline over ALL the instances it solved, not just the common set.
    # This is the number people expect ("the baseline solved 337, what were its plans?"),
    # but it CANNOT be compared to the arm rows -- it is measured on different instances.
    # The gap between it and the BASELINE row above is a property of which instances the
    # common set drops, i.e. how much harder the excluded ones were.
    own = [i for i, v in base.items() if v[2] and i in OPT]
    bpl, bopt = st.mean(base[i][1] for i in own), st.mean(OPT[i] for i in own)
    print(f"\nreference -- BASELINE over all {len(own)} instances it solved: "
          f"plan {bpl:.2f}, opt {bopt:.2f}, vs opt {bpl/bopt:.3f}")
    dropped = [i for i in own if i not in set(common)]
    if dropped:
        dpl, dopt = st.mean(base[i][1] for i in dropped), st.mean(OPT[i] for i in dropped)
        print(f"  the {len(dropped)} instances the common set DROPS: baseline plan "
              f"{dpl:.2f}, opt {dopt:.2f}, vs opt {dpl/dopt:.3f}")
        print(f"  (dropped because at least one arm failed them -- this is why the "
              f"BASELINE row above\n   differs between the additive and multiplicative "
              f"tables despite being the same runs)")

print("\n'vs opt' = mean plan length / mean optimal length on the common set. 1.000 means")
print("the arm returns optimal-length plans there, i.e. no quality headroom to win back.")
print(f"optimal source: {SRC}")
print("Within a table every arm shares the same denominator, so if the optimal lengths are")
print("an upper bound, all ratios shift together and the RANKING is unaffected.")
