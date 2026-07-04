"""
Evaluate baseline, W1, and decoupled AlphaZero on Grid val instances.
Runs all three algorithms on every instance in parallel (one process per instance).
"""
import argparse
import csv
import json
import re
import subprocess
import sys
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

DOMAIN = "example/grid_dataset/domain.pddl"
POLICY  = "models/grid_sac_policy.pth"
Q1      = "models/grid_sac_q1.pth"
Q2      = "models/grid_sac_q2.pth"
IQN     = "models/grid_iqn.pth"

ALGORITHMS = {
    "baseline": [
        "venv/bin/python", "alphaZero.py",
        "--domain", DOMAIN,
        "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
        "--max_time", "60",
    ],
    "w1_lambda1.5": [
        "venv/bin/python", "alphaZero_w1.py",
        "--domain", DOMAIN,
        "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
        "--iqn_model", IQN, "--w1_lambda", "1.5",
        "--max_time", "60",
    ],
    "decoupled_c2_0.5": [
        "venv/bin/python", "alphaZero_decoupled.py",
        "--domain", DOMAIN,
        "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
        "--c1", "1.5", "--c2", "0.5",
        "--max_time", "60",
    ],
    "widthmult_l15": [
        "venv/bin/python", "alphaZero_w1_ramp.py",
        "--domain", DOMAIN,
        "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
        "--iqn_model", IQN, "--signal", "width", "--w1_lambda", "1.5", "--w1_beta", "0",
        "--max_time", "60",
    ],
    "decoupled_c2_1.5": [
        "venv/bin/python", "alphaZero_decoupled.py",
        "--domain", DOMAIN,
        "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
        "--c1", "1.5", "--c2", "1.5",
        "--max_time", "60",
    ],
}


def parse_output(text):
    solved = "Found a solution" in text
    length, expanded = None, None
    m = re.search(r"Found a solution of length (\d+)", text)
    if m:
        length = int(m.group(1))
    # baseline format
    m = re.search(r"\[Final\] Expanded: (\d+)", text)
    if m:
        expanded = int(m.group(1))
    # also try simulations
    m = re.search(r"simulations=(\d+)", text)
    if m and expanded is None:
        expanded = int(m.group(1))
    return solved, length, expanded


def run_one(alg_name, cmd, problem):
    full_cmd = cmd + ["--problem", str(problem)]
    try:
        proc = subprocess.run(full_cmd, capture_output=True, text=True, timeout=90)
        out = proc.stdout + proc.stderr
        solved, length, expanded = parse_output(out)
        return alg_name, str(problem.stem), solved, length, expanded
    except subprocess.TimeoutExpired:
        return alg_name, str(problem.stem), False, None, None
    except Exception as e:
        return alg_name, str(problem.stem), False, None, None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--val_dir", default="example/grid_dataset/val")
    ap.add_argument("--limit", type=int, default=None)
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--algs", default=None, help="Comma-separated subset of algorithms")
    ap.add_argument("--out", default="results/grid_decoupled_comparison.json")
    args = ap.parse_args()

    algs = ALGORITHMS
    if args.algs:
        keep = {a.strip() for a in args.algs.split(",")}
        algs = {k: v for k, v in ALGORITHMS.items() if k in keep}

    val_dir = Path(args.val_dir)
    problems = sorted(val_dir.glob("*.pddl"))
    if args.limit:
        problems = problems[:args.limit]
    print(f"{len(problems)} instances × {len(algs)} algorithms = {len(problems)*len(algs)} runs", flush=True)

    # Build all tasks
    tasks = [(alg_name, cmd, p) for p in problems for alg_name, cmd in algs.items()]

    results = {}  # instance_stem -> {alg_name -> {solved, length, expanded}}
    done = 0
    total = len(tasks)

    with ProcessPoolExecutor(max_workers=args.workers) as ex:
        futures = {ex.submit(run_one, alg_name, cmd, p): (alg_name, p.stem) for alg_name, cmd, p in tasks}
        for fut in as_completed(futures):
            alg_name, stem, solved, length, expanded = fut.result()
            if stem not in results:
                results[stem] = {}
            results[stem][alg_name] = {"solved": solved, "length": length, "expanded": expanded}
            done += 1
            status = "✓" if solved else "✗"
            exp_str = str(expanded) if expanded else "?"
            print(f"[{done}/{total}] {stem[:40]:40s}  {alg_name:20s}  {status}  exp={exp_str}", flush=True)

    # Summary
    print(f"\n{'='*80}", flush=True)
    print(f"{'Instance':45s}", end="")
    for alg in algs:
        print(f"  {alg[:16]:>16s}", end="")
    print()
    print("-" * 80, flush=True)

    counts = {alg: {"solved": 0, "expanded": 0, "n": 0} for alg in algs}
    # instances where baseline passes but decoupled fails or vice versa
    regressions = []
    improvements = []

    for stem in sorted(results):
        row = results[stem]
        print(f"{stem[:45]:45s}", end="")
        for alg in algs:
            if alg in row:
                r = row[alg]
                mark = "✓" if r["solved"] else "✗"
                exp = str(r["expanded"]) if r["expanded"] else "?"
                print(f"  {mark} {exp:>10s}", end="")
                if r["solved"]:
                    counts[alg]["solved"] += 1
                    if r["expanded"]:
                        counts[alg]["expanded"] += r["expanded"]
                        counts[alg]["n"] += 1
            else:
                print(f"  {'?':>12s}", end="")
        print()

        # check regressions/improvements vs baseline
        if "baseline" in row and row["baseline"]["solved"]:
            for alg in algs:
                if alg == "baseline":
                    continue
                if alg in row:
                    if not row[alg]["solved"]:
                        regressions.append((stem, alg))
                    elif row[alg]["expanded"] and row["baseline"]["expanded"]:
                        ratio = row[alg]["expanded"] / row["baseline"]["expanded"]
                        if ratio < 0.7:
                            improvements.append((stem, alg, ratio))

    print(f"\n{'='*80}", flush=True)
    print(f"COVERAGE SUMMARY:", flush=True)
    for alg in algs:
        c = counts[alg]
        avg_exp = c["expanded"] / c["n"] if c["n"] > 0 else 0
        print(f"  {alg:25s}: {c['solved']:3d}/{len(problems)} solved  avg_expanded={avg_exp:.0f}", flush=True)

    if regressions:
        print(f"\nREGRESSIONS vs baseline (baseline solves, variant fails):", flush=True)
        for stem, alg in regressions:
            print(f"  {alg}: {stem}", flush=True)

    if improvements:
        print(f"\nIMPROVEMENTS vs baseline (>30% fewer expansions):", flush=True)
        for stem, alg, ratio in improvements:
            print(f"  {alg}: {stem}  ({ratio:.2f}x)", flush=True)

    Path(args.out).parent.mkdir(exist_ok=True)
    with open(args.out, "w") as f:
        json.dump(results, f, indent=2)
    print(f"\nFull results → {args.out}", flush=True)


if __name__ == "__main__":
    main()
