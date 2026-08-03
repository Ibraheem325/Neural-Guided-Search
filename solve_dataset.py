"""Solve a PDDL dataset with Fast Downward: verify solvability and (optionally) write .plan files.

  check    -- satisficing (lama-first), fast; answers "are these solvable?"
  optimal  -- A* + LM-cut; needed if the plans will be used as distance labels for probes

Usage:
  venv/bin/python solve_dataset.py <fast-downward.py> <dataset_dir> <split> \
        [--mode check|optimal] [--sample N] [--timeout SEC] [--write-plans]
"""
import sys, os, glob, subprocess, statistics as st, tempfile, shutil, collections, re

FD, DS, SPLIT = sys.argv[1], sys.argv[2], sys.argv[3]
def opt(flag, default):
    return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else default
MODE = opt("--mode", "check")
SAMPLE = int(opt("--sample", "0"))
TIMEOUT = int(opt("--timeout", "60"))
WRITE = "--write-plans" in sys.argv

dom = os.path.join(DS, "domain.pddl")
fs = sorted(f for f in glob.glob(os.path.join(DS, SPLIT, "*.pddl"))
            if "domain" not in os.path.basename(f))
if SAMPLE and SAMPLE < len(fs):
    fs = fs[:: max(1, len(fs) // SAMPLE)][:SAMPLE]

lens, solved, unsolv, timeout, err = [], 0, 0, 0, 0
by_rov = collections.defaultdict(list)
for i, pf in enumerate(fs, 1):
    tmp = tempfile.mkdtemp()
    plan = os.path.join(tmp, "sas_plan")
    cmd = [FD, "--plan-file", plan]
    if MODE == "optimal":
        cmd += [dom, pf, "--search", "astar(lmcut())"]
    else:
        cmd += ["--alias", "lama-first", dom, pf]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=TIMEOUT, cwd=tmp)
        out = p.stdout
        if os.path.exists(plan):
            steps = [l for l in open(plan) if l.strip().startswith("(")]
            lens.append(len(steps)); solved += 1
            m = re.search(r"-r(\d+)w", os.path.basename(pf))
            if m: by_rov[int(m.group(1))].append(len(steps))
            if WRITE:
                shutil.copy(plan, pf + ".plan")
        elif "unsolvable" in out.lower() or "Search stopped without finding a solution" in out:
            unsolv += 1
        else:
            err += 1
    except subprocess.TimeoutExpired:
        timeout += 1
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if i % 25 == 0:
        print(f"  ... {i}/{len(fs)}  solved={solved} unsolvable={unsolv} timeout={timeout}",
              flush=True)

print(f"\n{DS}/{SPLIT}  mode={MODE}  n={len(fs)}")
print(f"  solved={solved}  UNSOLVABLE={unsolv}  timeout={timeout}  error={err}")
if lens:
    lens.sort()
    print(f"  plan length: min={lens[0]} q25={lens[len(lens)//4]} median={st.median(lens):.0f} "
          f"q75={lens[3*len(lens)//4]} max={lens[-1]}")
    print("  median plan length by rover count:")
    for r in sorted(by_rov):
        v = by_rov[r]
        print(f"     r={r}: n={len(v):>3} median={st.median(v):.0f}")
