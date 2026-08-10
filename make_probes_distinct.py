"""Build a probe set with ONE probe per source problem -- maximising independent units.

WHY THIS EXISTS. make_probes.py fills a quota per DEPTH (30 per depth over d5-20 = 480
probes), and to do that it takes up to 16 probes from the same problem. Those are not
independent samples: same map, same objects, same goal, entered at different points. The
real sample size is the number of distinct source problems, and it came out at 29-44:

    goldminer 480 probes / 30 problems     satellite (test) 480 / 38
    grid      480 / 30                     rovers    (test) 480 / 37
    logistics 288 / 18

Every count-based statistic then has to be aggregated back down (cluster_contrib.py) before
it means anything, and the aggregation is what killed two apparent positives -- goldminer's
tilt read 73/27 per probe and 14/15 per problem.

This script takes ONE probe from each problem instead, so every probe IS an independent
unit and no aggregation is needed. On rovers' 120-instance test split that is 120 units
against the current 37 -- more than three times the statistical power, from a QUARTER of the
searches (120 arms per sweep instead of 480).

DEPTH ASSIGNMENT. Each problem gets one depth in [dmin, dmax], chosen greedily to keep the
depth histogram flat while respecting that a problem can only supply a depth its plan is
long enough to reach. Problems with short plans are assigned first, since they have the
fewest eligible depths.

Probe names keep the `<idx>_d<dd>_<source>` format the analysis tools parse, so
cluster_contrib.py and table_by_base.py still group correctly (they will simply find one
probe per group).

Usage: venv/bin/python make_probes_distinct.py <src_split_dir> <out_dir> <dmin> <dmax>
   e.g. venv/bin/python make_probes_distinct.py example/rovers_dataset_small/test \\
                                                example/probeRov_distinct_d5-22 5 22
"""
import sys, os, re, glob, csv, shutil, collections, pymimir as mm

SRC, OUT = sys.argv[1], sys.argv[2]
DMIN, DMAX = int(sys.argv[3]), int(sys.argv[4])
DOMAIN = os.path.join(os.path.dirname(SRC.rstrip("/")), "domain.pddl")
if not os.path.exists(DOMAIN):
    DOMAIN = os.path.join(SRC, "domain.pddl")
canon = lambda x: str(x).lower().replace(" ", "")

os.makedirs(OUT, exist_ok=True)
shutil.copy(DOMAIN, os.path.join(OUT, "domain.pddl"))
dom = mm.Domain(DOMAIN)
_m = re.search(r"\(:types\s+([^)]*)\)", open(DOMAIN).read(), re.I)
# typed domains: pymimir emits type-membership atoms like (rover rover0) from the :objects
# typing. They are not real init literals -- drop them, or the regenerated problem fails to
# parse ("predicate object is undefined").
TYPES = {t.lower() for t in (_m.group(1).split() if _m else []) if t != "-"} | {"object"}
PREDS = {str(p.get_name()) for p in dom.get_predicates()} - TYPES

srcs = sorted(f for f in glob.glob(SRC + "/*.pddl") if "domain" not in os.path.basename(f))
print(f"{len(srcs)} instances in {SRC}")

# --- pass 1: replay each plan, record which depths the problem can supply ---------------
cand = []
skipped = collections.Counter()
for pf in srcs:
    planf = pf + ".plan"
    if not os.path.exists(planf):
        skipped["no .plan"] += 1; continue
    plan = [l.strip() for l in open(planf) if l.strip().startswith("(")]
    if len(plan) < DMIN:
        skipped[f"plan shorter than dmin={DMIN}"] += 1; continue
    prob = mm.Problem(dom, pf)
    goal = prob.get_goal_condition()
    s = prob.get_initial_state()
    states = [s]
    ok = True
    for line in plan:
        nxt = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
        if nxt is None:
            ok = False; break
        s = nxt.apply(s); states.append(s)
    if not ok or not goal.holds(states[-1]):
        skipped["plan does not replay to the goal"] += 1; continue
    cand.append(dict(pf=pf, plan=plan, states=states, prob=prob,
                     depths=list(range(DMIN, min(DMAX, len(plan)) + 1))))

print(f"{len(cand)} usable" + (f"   skipped: {dict(skipped)}" if skipped else ""))
if not cand:
    raise SystemExit("nothing to build from")

# --- pass 2: assign one depth per problem, keeping the histogram flat -------------------
# Fewest-options-first: a problem whose plan only reaches d7 must be placed before one that
# could take any depth, or the shallow slots fill up and it gets dropped.
cand.sort(key=lambda c: len(c["depths"]))
hist = collections.Counter()
for c in cand:
    c["d"] = min(c["depths"], key=lambda d: (hist[d], d))
    hist[c["d"]] += 1
cand.sort(key=lambda c: c["pf"])

# --- pass 3: emit ----------------------------------------------------------------------
rows = []
for idx, c in enumerate(cand):
    pf, plan, states, d = c["pf"], c["plan"], c["states"], c["d"]
    base = os.path.basename(pf)[:-5]
    src_tag = base.split("_", 1)[1] if "_" in base else base
    st = states[len(plan) - d]
    name = f"{idx:03d}_d{d:02d}_{src_tag}"

    src_txt = open(pf).read()
    i = src_txt.index("(:init")
    j, depth = i, 0
    while j < len(src_txt):
        if src_txt[j] == "(": depth += 1
        elif src_txt[j] == ")":
            depth -= 1
            if depth == 0: break
        j += 1
    init = "\n".join(str(a) for a in st.get_atoms()
                     if str(a).lstrip("(").split()[0].rstrip(")") in PREDS)
    txt = src_txt[:i] + "(:init\n" + init + "\n)" + src_txt[j + 1:]
    # PDDL problem names cannot start with a digit
    txt = re.sub(r"\(define\s*\(problem\s+[^)]*\)", f"(define (problem prb-{name})", txt, count=1)
    open(os.path.join(OUT, name + ".pddl"), "w").write(txt)
    open(os.path.join(OUT, name + ".pddl.plan"), "w").write("\n".join(plan[len(plan) - d:]) + "\n")
    rows.append(dict(file=name + ".pddl", distance_to_goal=d,
                     source_split=os.path.basename(SRC.rstrip("/")),
                     source_problem=os.path.basename(pf),
                     source_plan_len=len(plan),
                     num_objects=len(list(c["prob"].get_objects()))))

with open(os.path.join(OUT, "labels.csv"), "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["file", "distance_to_goal", "source_split",
                                       "source_problem", "source_plan_len", "num_objects"])
    w.writeheader(); w.writerows(rows)

nsrc = len({r["source_problem"] for r in rows})
print(f"\nwrote {len(rows)} probes to {OUT}")
print(f"distinct source problems: {nsrc}   probes per problem: {len(rows)/nsrc:.2f}")
print("per-distance:", dict(sorted(collections.Counter(r['distance_to_goal'] for r in rows).items())))
o = [r["num_objects"] for r in rows]
print(f"objects: {min(o)}-{max(o)}")
print("\nNOTE: the encoded d is the remaining length of the SOURCE plan, which is optimal only")
print("if that plan was. Run run_fd_optimal.sh + collect_fd.py to get FD-verified lengths.")
