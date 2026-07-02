"""Controlled local comparison on a Logistics subset: baseline pUCT vs
ramp-formula configs, all with the same local max_time budget."""
import argparse
import json
import re
import subprocess
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

DOMAIN = "example/logistics_dataset/domain.pddl"
TEST_DIR = Path("example/logistics_dataset/test")
POLICY = "models/logistics_sac_policy.pth"
Q1 = "models/logistics_sac_q1.pth"
Q2 = "models/logistics_sac_q2.pth"
IQN = "models/logistics_iqn.pth"

# 8 cluster-baseline failures + 10 mid-tier solvable + 4 easiest, chosen for
# family coverage (c4s2/c3s3 like the failures, plus the VAL3 c2s1 family).
INSTANCES = [
    # cluster fails
    "003_p-VAL-c4s2p7-18", "008_p-VAL-c4s3p8-22", "017_p-VAL-c4s2p7-28",
    "036_p-VAL-c4s3p8-13", "050_p-VAL-c4s3p8-23", "064_p-VAL-c4s3p8-2",
    "073_p-VAL-c4s2p7-30", "092_p-L5-10",
    # mid-tier solvable
    "042_p-VAL-c3s3p6-13", "028_p-VAL-c3s3p6-27", "000_p-VAL-c3s3p6-11",
    "001_p-VAL-c4s2p6-21", "015_p-VAL-c4s2p6-5",
    "055_p-VAL3-n35-c2s1p27a2-2", "101_p-L4-4", "041_p-VAL3-n35-c2s1p26a3-6",
    "025_p-VAL3-n33-c2s1p25a2-4", "007_p-VAL3-n29-c2s1p21a2-5",
    # easy sanity
    "030_p-TR3-n24-c2s1p15a3-1", "044_p-TR3-n24-c2s1p17a1-1",
    "058_p-VAL2-n24-c2s1p16a2-4", "043_p-VAL2-n23-c2s1p14a3-4",
]

MAX_TIME = "120"

BASE_ALG = {
    "base_local": ["venv/bin/python", "alphaZero.py",
                   "--domain", DOMAIN, "--policy_model", POLICY,
                   "--q1_model", Q1, "--q2_model", Q2, "--max_time", MAX_TIME],
}


def ramp_alg(extra):
    return ["venv/bin/python", "alphaZero_w1_ramp.py",
            "--domain", DOMAIN, "--policy_model", POLICY,
            "--q1_model", Q1, "--q2_model", Q2, "--iqn_model", IQN,
            "--max_time", MAX_TIME] + extra


def run_one(alg_name, cmd, stem):
    full = cmd + ["--problem", str(TEST_DIR / f"{stem}.pddl")]
    try:
        proc = subprocess.run(full, capture_output=True, text=True, timeout=260)
        out = proc.stdout + proc.stderr
        solved = "Found a solution" in out
        m = re.search(r"\[Final\] Expanded: (\d+)", out)
        exp = int(m.group(1)) if m else None
        m = re.search(r"Found a solution of length (\d+)", out)
        length = int(m.group(1)) if m else None
        return alg_name, stem, solved, exp, length
    except Exception:
        return alg_name, stem, False, None, None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--configs", default="",
                    help="semicolon-separated name=ramp-args (baseline always runs "
                         "unless --skip_baseline)")
    ap.add_argument("--skip_baseline", action="store_true")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--out", default="results/logi_ramp_local.json")
    args = ap.parse_args()

    algs = {} if args.skip_baseline else dict(BASE_ALG)
    if args.configs:
        for spec in args.configs.split(";"):
            name, cfg = spec.split("=", 1)
            algs[name.strip()] = ramp_alg(cfg.strip().split())

    results = {}
    if Path(args.out).exists():
        with open(args.out) as f:
            results = json.load(f)

    tasks = [(n, c, s) for s in INSTANCES for n, c in algs.items()]
    with ProcessPoolExecutor(max_workers=args.workers) as ex:
        futs = {ex.submit(run_one, n, c, s): (n, s) for n, c, s in tasks}
        done = 0
        for fut in as_completed(futs):
            alg, stem, solved, exp, length = fut.result()
            results.setdefault(stem, {})[alg] = {
                "solved": solved, "expanded": exp, "length": length}
            done += 1
            print(f"[{done}/{len(tasks)}] {stem[:34]:34s} {alg:22s} "
                  f"{'SOLVED' if solved else 'FAIL':6s} exp={exp}", flush=True)
            with open(args.out, "w") as f:
                json.dump(results, f, indent=2)

    all_algs = sorted({a for r in results.values() for a in r})
    print(f"\n{'instance':<34}", end="")
    for a in all_algs:
        print(f" {a[:18]:>18}", end="")
    print()
    for stem in INSTANCES:
        r = results.get(stem, {})
        print(f"{stem[:34]:<34}", end="")
        for a in all_algs:
            v = r.get(a, {})
            s = str(v.get("expanded")) if v.get("solved") else ("FAIL" if v else "-")
            print(f" {s:>18}", end="")
        print()

    for a in all_algs:
        solved = [s for s in INSTANCES if results.get(s, {}).get(a, {}).get("solved")]
        exp = sum(results[s][a]["expanded"] for s in solved
                  if results[s][a]["expanded"])
        print(f"\n{a}: solved {len(solved)}/{len(INSTANCES)}, total_exp(solved)={exp}")


if __name__ == "__main__":
    main()
