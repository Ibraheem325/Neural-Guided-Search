"""Ensemble-vote configs on the 22 hard Grid instances + a sample of easy
instances, to measure the easy-tax / hard-gain tradeoff of the warmup gate."""
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
ENS = ["models/grid_iqn_ens_1_best.pth", "models/grid_iqn_ens_2_best.pth",
       "models/grid_iqn_ens_3_best.pth", "models/grid_iqn_ens_4_best.pth",
       "models/grid_iqn_ens_5_best.pth", "models/grid_iqn.pth"]

CONFIGS = {
    # name: (v_lambda, v_beta, v_n0, v_warmup, v_floor_thresh, v_floor_disagree)
    "comb_nogate":    (1.5, 0.25, 256, 0, 0.0, False),   # mult + floor, no gate (reference)
    "disagree_b25":   (1.5, 0.25, 256, 0, 0.0, True),    # floor only where ensemble != policy
    "disagree_b40":   (1.5, 0.40, 256, 0, 0.0, True),    # same gate, stronger floor
    "mult_only":      (1.5, 0.0,  256, 0, 0.0, False),   # safe reference (no floor)
}


def run_one(name, cfg, stem):
    vl, vb, vn0, vw, vft, vdis = cfg
    cmd = ["venv/bin/python", "alphaZero_ensemble.py",
           "--domain", DOMAIN, "--problem", str(VAL / f"{stem}.pddl"),
           "--policy_model", POLICY, "--q1_model", Q1, "--q2_model", Q2,
           "--iqn_models", *ENS,
           "--v_lambda", str(vl), "--v_beta", str(vb), "--v_n0", str(vn0),
           "--v_warmup", str(vw), "--v_floor_thresh", str(vft), "--max_time", "120"]
    if vdis:
        cmd.append("--v_floor_disagree")
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
    easy = sorted([k for k in base if base[k].get("solved") and 150 <= (base[k].get("expanded") or 0) < 300],
                  key=lambda k: -base[k]["expanded"])[:10]
    insts = hard + easy

    tasks = [(n, c, s) for s in insts for n, c in CONFIGS.items()]
    results = {}
    with ProcessPoolExecutor(max_workers=3) as ex:
        futs = {ex.submit(run_one, n, c, s): (n, s) for n, c, s in tasks}
        done = 0
        for fut in as_completed(futs):
            n, s, solved, exp = fut.result()
            results.setdefault(s, {})[n] = (solved, exp)
            done += 1
            print(f"[{done}/{len(tasks)}] {s[:30]:30s} {n:14s} {'OK' if solved else 'FAIL':4s} {exp}", flush=True)
    with open("results/grid_ens_disagree.json", "w") as f:
        json.dump({s: {n: list(v) for n, v in d.items()} for s, d in results.items()}, f, indent=2)

    names = list(CONFIGS)
    for tier, group in [("HARD", hard), ("EASY", easy)]:
        print(f"\n=== {tier} ===")
        print(f"{'instance':<34} {'base':>5} " + " ".join(f"{n:>13}" for n in names))
        for k in group:
            row = f"{k[:34]:<34} {base[k]['expanded']:>5} "
            for n in names:
                solved, exp = results.get(k, {}).get(n, (False, None))
                row += f"{(str(exp) if solved else 'FAIL'):>13} " if False else f"{(str(exp) if solved else 'FAIL'):>13} "
            print(row)
        for n in names:
            common = [k for k in group if results.get(k, {}).get(n, (0,0))[0] and results[k][n][1]]
            tb = sum(base[k]["expanded"] for k in common)
            tc = sum(results[k][n][1] for k in common)
            solved = sum(1 for k in group if results.get(k, {}).get(n, (0,0))[0])
            print(f"  {n:14s}: solved {solved}/{len(group)}  ratio={tc/tb:.3f}" if tb else f"  {n}: -")


if __name__ == "__main__":
    main()
