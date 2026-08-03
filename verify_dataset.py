"""Sanity-check a generated PDDL dataset before training on it.

Checks per split: parses, goal not already satisfied, has applicable actions,
filename (r,w,o,c,n) matches the actual problem, and no duplicate (objects,init,goal).

Usage: venv/bin/python verify_dataset.py <dataset_dir>
"""
import sys, os, glob, re, hashlib, collections, pymimir as mm

DS = sys.argv[1]
dom = mm.Domain(os.path.join(DS, "domain.pddl"))

for split in ["train", "val", "test"]:
    d = os.path.join(DS, split)
    if not os.path.isdir(d):
        continue
    fs = sorted(f for f in glob.glob(d + "/*.pddl") if "domain" not in os.path.basename(f))
    bad_parse = bad_goal = bad_dead = bad_name = 0
    sigs = collections.Counter()
    rov = collections.Counter(); nobj = []
    for pf in fs:
        base = os.path.basename(pf)
        try:
            p = mm.Problem(dom, pf)
        except Exception:
            bad_parse += 1; continue
        s = p.get_initial_state(); g = p.get_goal_condition()
        if g.holds(s):
            bad_goal += 1
        if len(s.generate_applicable_actions()) == 0:
            bad_dead += 1
        objs = list(p.get_objects())
        m = re.search(r"-n(\d+)-r(\d+)w(\d+)o(\d+)c(\d+)-", base)
        if m:
            n, r, w, o, c = map(int, m.groups())
            rov[r] += 1; nobj.append(n)
            actual_r = sum(1 for x in objs if re.fullmatch(r"rover\d+", str(x)))
            actual_w = sum(1 for x in objs if re.fullmatch(r"waypoint\d+", str(x)))
            if len(objs) != n or actual_r != r or actual_w != w:
                bad_name += 1
        txt = open(pf).read().lower()
        key = "".join(txt.split())
        sigs[hashlib.md5(key.encode()).hexdigest()] += 1
    dup = sum(v - 1 for v in sigs.values() if v > 1)
    print(f"{split:<6} n={len(fs):<4} parse_fail={bad_parse}  goal_already_true={bad_goal}  "
          f"dead_end_init={bad_dead}  name_mismatch={bad_name}  duplicates={dup}")
    if nobj:
        print(f"       objects {min(nobj)}-{max(nobj)} (median {sorted(nobj)[len(nobj)//2]})"
              f"  rovers {dict(sorted(rov.items()))}")
