"""Build a near-goal probe set from a dataset split that has .plan files.

Walks each optimal plan backwards, emitting states at exact distance d from the goal,
and writes labels.csv with the columns check_qrdqn_calibration.py expects.

Usage: venv/bin/python make_probes.py <src_split_dir> <out_dir> <dmin> <dmax> <per_distance>
"""
import sys, os, re, glob, csv, shutil, collections, pymimir as mm

SRC, OUT = sys.argv[1], sys.argv[2]
DMIN, DMAX, PER = int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])
DOMAIN = os.path.join(os.path.dirname(SRC.rstrip("/")), "domain.pddl")
canon = lambda x: str(x).lower().replace(" ", "")

os.makedirs(OUT, exist_ok=True)
shutil.copy(DOMAIN, os.path.join(OUT, "domain.pddl"))
dom = mm.Domain(DOMAIN)
import re as _re
_dtxt = open(DOMAIN).read()
_m = _re.search(r"\(:types\s+([^)]*)\)", _dtxt, _re.I)
# typed domains: pymimir emits type-membership atoms like (rover rover0) from
# the :objects typing. They are not real init literals -- drop them, or the
# regenerated problem fails to parse ("predicate object is undefined").
TYPES = {t.lower() for t in (_m.group(1).split() if _m else []) if t != "-"} | {"object"}
PREDS = {str(p.get_name()) for p in dom.get_predicates()} - TYPES

srcs = sorted(f for f in glob.glob(SRC + "/*.pddl") if "domain" not in os.path.basename(f))
want = {d: PER for d in range(DMIN, DMAX + 1)}
rows, idx, used = [], 0, collections.Counter()

for pf in srcs:
    planf = pf + ".plan"
    if not os.path.exists(planf):
        continue
    plan = [l.strip() for l in open(planf) if l.strip().startswith("(")]
    if len(plan) < DMIN:
        continue
    prob = mm.Problem(dom, pf)
    goal = prob.get_goal_condition()
    # replay, recording the state at each remaining-distance
    s = prob.get_initial_state()
    states = [s]
    ok = True
    for line in plan:
        nxt = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
        if nxt is None:
            ok = False; break
        s = nxt.apply(s); states.append(s)
    if not ok or not goal.holds(states[-1]):
        continue
    base = os.path.basename(pf)[:-5]
    src_tag = base.split("_", 1)[1] if "_" in base else base
    for d in range(DMIN, DMAX + 1):
        if want[d] <= 0 or d > len(plan):
            continue
        if used[(src_tag, d)]:
            continue
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
        txt = src_txt[:i] + "(:init\n" + init + "\n)" + src_txt[j+1:]
        txt = re.sub(r"\(define\s*\(problem\s+[^)]*\)", f"(define (problem prb-{name})", txt, count=1)
        with open(os.path.join(OUT, name + ".pddl"), "w") as fh:
            fh.write(txt)
        with open(os.path.join(OUT, name + ".pddl.plan"), "w") as fh:
            fh.write("\n".join(plan[len(plan) - d:]) + "\n")
        rows.append(dict(file=name + ".pddl", distance_to_goal=d,
                         source_split=os.path.basename(SRC.rstrip("/")),
                         source_problem=os.path.basename(pf),
                         source_plan_len=len(plan),
                         num_objects=len(list(prob.get_objects()))))
        want[d] -= 1; used[(src_tag, d)] = 1; idx += 1
    if all(v <= 0 for v in want.values()):
        break

with open(os.path.join(OUT, "labels.csv"), "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["file", "distance_to_goal", "source_split",
                                       "source_problem", "source_plan_len", "num_objects"])
    w.writeheader(); w.writerows(rows)
print(f"wrote {len(rows)} probes to {OUT}")
print("per-distance:", dict(sorted(collections.Counter(r['distance_to_goal'] for r in rows).items())))
print("distinct sources:", len({r['source_problem'] for r in rows}))
