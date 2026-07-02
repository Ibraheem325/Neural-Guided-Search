"""Run ramp-formula configs on the 22 hard Grid instances and compare
against the baseline / w1-multiplicative numbers in grid_decoupled_comparison.json."""
import argparse
import json
import re
import subprocess
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

DOMAIN = "example/grid_dataset/domain.pddl"
POLICY = "models/grid_sac_policy.pth"
Q1 = "models/grid_sac_q1.pth"
Q2 = "models/grid_sac_q2.pth"
IQN = "models/grid_iqn.pth"


def run_one(cfg_name, extra_args, problem):
    cmd = ["venv/bin/python", "alphaZero_w1_ramp.py",
           "--domain", DOMAIN, "--problem", str(problem),
           "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
           "--iqn_model", IQN, "--max_time", "60"] + extra_args
    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, timeout=150)
        out = proc.stdout + proc.stderr
        solved = "Found a solution" in out
        m = re.search(r"\[Final\] Expanded: (\d+)", out)
        exp = int(m.group(1)) if m else None
        m = re.search(r"Found a solution of length (\d+)", out)
        length = int(m.group(1)) if m else None
        return cfg_name, problem.stem, solved, exp, length
    except Exception:
        return cfg_name, problem.stem, False, None, None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--configs", required=True,
                    help="semicolon-separated name=args, e.g. "
                         "'ramp_l15_b025_n256=--w1_lambda 1.5 --w1_beta 0.25 --w1_n0 256'")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--out", default="results/grid_ramp_hard.json")
    args = ap.parse_args()

    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    hard = sorted([k for k in ref
                   if ref[k].get("baseline", {}).get("solved")
                   and (ref[k]["baseline"].get("expanded") or 0) >= 300],
                  key=lambda k: -ref[k]["baseline"]["expanded"])

    configs = {}
    for spec in args.configs.split(";"):
        name, cfg_args = spec.split("=", 1)
        configs[name.strip()] = cfg_args.strip().split()

    val = Path("example/grid_dataset/val")
    tasks = [(n, a, val / f"{k}.pddl") for k in hard for n, a in configs.items()]

    results = {}
    if Path(args.out).exists():
        with open(args.out) as f:
            results = json.load(f)

    with ProcessPoolExecutor(max_workers=args.workers) as ex:
        futs = {ex.submit(run_one, n, a, p): (n, p.stem) for n, a, p in tasks}
        done = 0
        for fut in as_completed(futs):
            cfg, stem, solved, exp, length = fut.result()
            results.setdefault(stem, {})[cfg] = {
                "solved": solved, "expanded": exp, "length": length}
            done += 1
            print(f"[{done}/{len(tasks)}] {stem[:38]:38s} {cfg:24s} "
                  f"{'SOLVED' if solved else 'FAIL':6s} exp={exp}", flush=True)

    with open(args.out, "w") as f:
        json.dump(results, f, indent=2)

    print(f"\n{'instance':<38} {'base':>6} {'mult1.5':>8}", end="")
    for cfg in configs:
        print(f" {cfg[:16]:>16}", end="")
    print()
    for k in hard:
        b = ref[k]["baseline"]["expanded"]
        w = ref[k].get("w1_lambda1.5", {})
        ws = str(w.get("expanded")) if w.get("solved") else "FAIL"
        print(f"{k[:38]:<38} {b:>6} {ws:>8}", end="")
        for cfg in configs:
            r = results.get(k, {}).get(cfg, {})
            s = str(r.get("expanded")) if r.get("solved") else "FAIL"
            print(f" {s:>16}", end="")
        print()

    for cfg in configs:
        solved = [k for k in hard if results.get(k, {}).get(cfg, {}).get("solved")]
        common = [k for k in solved if ref[k]["baseline"].get("expanded")]
        tb = sum(ref[k]["baseline"]["expanded"] for k in common)
        tc = sum(results[k][cfg]["expanded"] for k in common)
        print(f"\n{cfg}: solved {len(solved)}/22 hard; on its solved set "
              f"base={tb} cfg={tc} ratio={tc/tb:.3f}")


if __name__ == "__main__":
    main()
