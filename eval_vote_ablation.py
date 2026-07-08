"""Q2b: does the ENSEMBLE (6 models, 28% value-wrong) beat a SINGLE model
(41% value-wrong) when its value vote drives the search? Same ramp config,
same budget, 22 hard Grid instances."""
import json
import re
import subprocess
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

DOMAIN = "example/grid_dataset/domain.pddl"
VAL = Path("example/grid_dataset/val")
POLICY = "models/grid_sac_policy.pth"
Q1 = "models/grid_sac_q1.pth"
Q2 = "models/grid_sac_q2.pth"
ORIG = ["models/grid_iqn.pth"]
ENS = ["models/grid_iqn_ens_1_best.pth", "models/grid_iqn_ens_2_best.pth",
       "models/grid_iqn_ens_3_best.pth", "models/grid_iqn_ens_4_best.pth",
       "models/grid_iqn_ens_5_best.pth", "models/grid_iqn.pth"]

# ramp-only config (the 25.7% variant), single vs six models
CONFIGS = {
    "vote1_ramp": ORIG,   # single-model value vote
    "vote6_ramp": ENS,    # six-model value vote
}
RAMP = ["--v_lambda", "0", "--v_beta", "0.25", "--v_n0", "256"]


def run_one(name, models, stem):
    cmd = ["venv/bin/python", "alphaZero_ensemble.py",
           "--domain", DOMAIN, "--problem", str(VAL / f"{stem}.pddl"),
           "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
           "--iqn_models", *models, *RAMP, "--max_time", "120"]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=260)
        out = p.stdout + p.stderr
        m = re.search(r"\[Final\] Expanded: (\d+)", out)
        return name, stem, ("Found a solution" in out), int(m.group(1)) if m else None
    except Exception:
        return name, stem, False, None


def main():
    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    base = {k: v["baseline"] for k, v in ref.items()}
    hard = sorted([k for k in base if base[k].get("solved") and (base[k].get("expanded") or 0) >= 300],
                  key=lambda k: -base[k]["expanded"])

    tasks = [(n, m, s) for s in hard for n, m in CONFIGS.items()]
    results = {}
    with ProcessPoolExecutor(max_workers=2) as ex:
        futs = {ex.submit(run_one, n, m, s): (n, s) for n, m, s in tasks}
        done = 0
        for fut in as_completed(futs):
            n, s, solved, exp = fut.result()
            results.setdefault(s, {})[n] = (solved, exp)
            done += 1
            print(f"[{done}/{len(tasks)}] {s[:30]:30s} {n:12s} {'OK' if solved else 'FAIL':4s} {exp}", flush=True)
    with open("results/grid_vote_ablation.json", "w") as f:
        json.dump({s: {n: list(v) for n, v in d.items()} for s, d in results.items()}, f, indent=2)

    print(f"\n{'instance':<34} {'base':>5} {'vote1':>7} {'vote6':>7}")
    for k in hard:
        r = results.get(k, {})
        def fmt(n):
            s, e = r.get(n, (False, None))
            return str(e) if s else "FAIL"
        print(f"{k[:34]:<34} {base[k]['expanded']:>5} {fmt('vote1_ramp'):>7} {fmt('vote6_ramp'):>7}")
    for n in CONFIGS:
        common = [k for k in hard if results.get(k, {}).get(n, (0, 0))[0] and results[k][n][1]]
        tb = sum(base[k]["expanded"] for k in common)
        tc = sum(results[k][n][1] for k in common)
        solved = sum(1 for k in hard if results.get(k, {}).get(n, (0, 0))[0])
        print(f"\n{n}: solved {solved}/{len(hard)}, on its solved set ratio={tc/tb:.3f}" if tb else f"{n}: -")


if __name__ == "__main__":
    main()
