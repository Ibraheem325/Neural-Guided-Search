"""Is the distance encoded in a probe's name actually the OPTIMAL plan length?

make_probes.py builds each probe by walking a source plan backwards and emitting the state
whose remaining suffix has length d, then names it <idx>_d<d>_<inst>_<problem>. So d is the
optimal distance ONLY IF the source plan was optimal. If the source dataset was solved with
a satisficing planner, d is an UPPER BOUND and every "vs opt" ratio computed from it is
wrong in the same direction.

This runs Fast Downward on a stratified sample of probes and compares:
  --mode opt   astar(lmcut())        exact optimal cost. Ground truth; may time out.
  --mode lama  seq-sat-lama-2011     satisficing upper bound. Use when opt times out --
                                     if LAMA already returns a plan SHORTER than d, that
                                     alone proves d is not optimal, without needing opt.

Usage:
  venv/bin/python verify_optimal.py <fast-downward.py> [--probe DIR] [--n 60]
                                    [--mode opt|lama] [--timeout 300]

Reports per-depth agreement and lists every probe where FD beat d. Any such probe means the
source plans were suboptimal and the 'opt' column in table_plan_len.py is an upper bound.
"""
import sys, os, glob, re, argparse, subprocess, tempfile, shutil, collections, random

ap = argparse.ArgumentParser()
ap.add_argument("fd", help="path to fast-downward.py")
ap.add_argument("--probe", default="example/probeGold_near_goal_d5-20")
ap.add_argument("--n", default=60, type=int, help="probes to sample (stratified by depth)")
ap.add_argument("--mode", default="opt", choices=["opt", "lama"])
ap.add_argument("--timeout", default=300, type=int)
ap.add_argument("--seed", default=0, type=int)
A_ = ap.parse_args()

DEPTH = re.compile(r"^\d+_d(\d+)_")
DOM = os.path.abspath(os.path.join(A_.probe, "domain.pddl"))

files = [f for f in sorted(glob.glob(A_.probe + "/*.pddl"))
         if os.path.basename(f) != "domain.pddl"]
by_d = collections.defaultdict(list)
for f in files:
    m = DEPTH.match(os.path.basename(f)[:-5])
    if m:
        by_d[int(m.group(1))].append(f)

# stratified sample: spread the budget evenly over depths
rng = random.Random(A_.seed)
per = max(1, A_.n // max(1, len(by_d)))
sample = []
for d in sorted(by_d):
    pool = by_d[d][:]
    rng.shuffle(pool)
    sample += [(d, f) for f in pool[:per]]
print(f"domain: {DOM}")
print(f"sampled {len(sample)} probes across depths {min(by_d)}-{max(by_d)} "
      f"({per} per depth), mode={A_.mode}, timeout={A_.timeout}s\n")

agree = worse = better = fail = 0
beaten, rows = [], []
for k, (d, pf) in enumerate(sample, 1):
    tmp = tempfile.mkdtemp()
    plan = os.path.join(tmp, "sas_plan")
    cmd = [A_.fd, "--plan-file", plan]
    if A_.mode == "opt":
        cmd += [DOM, os.path.abspath(pf), "--search", "astar(lmcut())"]
    else:
        cmd += ["--alias", "seq-sat-lama-2011", DOM, os.path.abspath(pf)]
    n = None
    try:
        subprocess.run(cmd, capture_output=True, text=True,
                       timeout=A_.timeout, cwd=tmp)
        # lama writes sas_plan.1, .2, ... -- the highest suffix is the best plan found
        cands = sorted(glob.glob(plan + "*"))
        if cands:
            n = sum(1 for l in open(cands[-1])
                    if l.strip().startswith("(") and ";" not in l.split(";")[0][:1])
    except subprocess.TimeoutExpired:
        pass
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    name = os.path.basename(pf)[:-5]
    if n is None:
        fail += 1
        status = "TIMEOUT/FAIL"
    elif n == d:
        agree += 1
        status = "="
    elif n < d:
        better += 1
        beaten.append((name, d, n))
        status = f"FD SHORTER by {d-n}"
    else:
        worse += 1
        status = f"FD longer by {n-d}"
    rows.append((d, name, n, status))
    if k % 10 == 0 or k == len(sample):
        print(f"  ...{k}/{len(sample)}", flush=True)

print(f"\n{'depth':>6} {'probe':<34} {'FD':>5} {'d':>4}  status")
for d, name, n, status in sorted(rows):
    print(f"{d:>6} {name:<34} {str(n):>5} {d:>4}  {status}")

tot = agree + worse + better
print(f"\nFD == d          : {agree}")
print(f"FD SHORTER than d: {better}   <- any of these means d is NOT optimal")
print(f"FD longer than d : {worse}" + ("   (expected in --mode lama; it is satisficing)"
                                       if A_.mode == "lama" else "   <- unexpected in opt mode"))
print(f"timeout/failed   : {fail}")

if better:
    print("\nprobes where FD beat the encoded distance:")
    for name, d, n in beaten:
        print(f"  {name}  d={d}  FD={n}")
    print("\nCONCLUSION: the source plans were NOT optimal, so d is an upper bound and the")
    print("'opt' column in table_plan_len.py must be relabelled (or recomputed with FD).")
elif A_.mode == "opt" and agree and not worse:
    print("\nCONCLUSION: d matches optimal on every solved sample -- safe to use d as optimal.")
