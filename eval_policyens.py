"""
Policy-ensemble comparison on 22 hard + 10 easy Grid instances.

All configs use the AVERAGED 6-policy prior (de-peaks the 83%-confidently-
wrong mistake nodes: peaked 83% -> 21%, avg prob on correct 0 -> 0.248).
The question: with the policy de-peaked, does each boost signal now help,
and does W1 finally work (its leverage problem is gone; its ranking quality
is the remaining test)?

Configs (all with --policy_models = 6 SAC policies):
  pe_none    : averaged prior, NO boost         (does de-peaking alone help?)
  pe_vote    : averaged prior + mult vote boost (value ensemble, no floor)
  pe_w1      : averaged prior + mult W1 boost    (the W1 re-test)
Reference (single policy, from prior runs): baseline, W1 single = 0.822 hard.
"""
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
IQN = "models/grid_iqn.pth"
PENS = ["models/grid_sac_ens_1_policy_best.pth", "models/grid_sac_ens_2_policy_best.pth",
        "models/grid_sac_ens_3_policy_best.pth", "models/grid_sac_ens_4_policy_best.pth",
        "models/grid_sac_ens_5_policy_best.pth", "models/grid_sac_policy.pth"]
IQNENS = ["models/grid_iqn_ens_1_best.pth", "models/grid_iqn_ens_2_best.pth",
          "models/grid_iqn_ens_3_best.pth", "models/grid_iqn_ens_4_best.pth",
          "models/grid_iqn_ens_5_best.pth", "models/grid_iqn.pth"]


def cmd_vote(stem, vlam):
    return ["venv/bin/python", "alphaZero_ensemble.py",
            "--domain", DOMAIN, "--problem", str(VAL / f"{stem}.pddl"),
            "--policy_model", POLICY, "--policy_models", *PENS,
            "--q1_model", Q1, "--q2_model", Q2, "--iqn_models", *IQNENS,
            "--v_lambda", str(vlam), "--v_beta", "0", "--max_time", "120"]


def cmd_w1(stem, wlam):
    return ["venv/bin/python", "alphaZero_w1_ramp.py",
            "--domain", DOMAIN, "--problem", str(VAL / f"{stem}.pddl"),
            "--policy_model", POLICY, "--policy_models", *PENS,
            "--q1_model", Q1, "--q2_model", Q2, "--iqn_model", IQN,
            "--w1_lambda", str(wlam), "--w1_beta", "0", "--max_time", "120"]


CONFIGS = {
    "pe_none": lambda s: cmd_vote(s, 0.0),   # averaged prior, no boost
    "pe_vote": lambda s: cmd_vote(s, 1.5),   # averaged prior + vote boost
    "pe_w1":   lambda s: cmd_w1(s, 1.5),     # averaged prior + W1 boost
}


def run_one(name, stem):
    try:
        p = subprocess.run(CONFIGS[name](stem), capture_output=True, text=True, timeout=260)
        out = p.stdout + p.stderr
        m = re.search(r"\[Final\] Expanded: (\d+)", out)
        return name, stem, ("Found a solution" in out), int(m.group(1)) if m else None
    except Exception:
        return name, stem, False, None


def main():
    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    base = {k: v["baseline"] for k, v in ref.items()}
    w1s = {k: v.get("w1_lambda1.5", {}) for k, v in ref.items()}
    hard = sorted([k for k in base if base[k].get("solved") and (base[k].get("expanded") or 0) >= 300],
                  key=lambda k: -base[k]["expanded"])
    easy = sorted([k for k in base if base[k].get("solved") and 150 <= (base[k].get("expanded") or 0) < 300],
                  key=lambda k: -base[k]["expanded"])[:10]

    tasks = [(n, s) for s in hard + easy for n in CONFIGS]
    results = {}
    with ProcessPoolExecutor(max_workers=3) as ex:
        futs = {ex.submit(run_one, n, s): (n, s) for n, s in tasks}
        done = 0
        for fut in as_completed(futs):
            n, s, solved, exp = fut.result()
            results.setdefault(s, {})[n] = (solved, exp)
            done += 1
            print(f"[{done}/{len(tasks)}] {s[:30]:30s} {n:9s} {'OK' if solved else 'FAIL':4s} {exp}", flush=True)
    with open("results/grid_policyens.json", "w") as f:
        json.dump({s: {n: list(v) for n, v in d.items()} for s, d in results.items()}, f, indent=2)

    names = list(CONFIGS)
    for tier, group in [("HARD", hard), ("EASY", easy)]:
        print(f"\n=== {tier} ===")
        print(f"{'instance':<34} {'base':>5} {'w1_1pol':>7} " + " ".join(f"{n:>8}" for n in names))
        for k in group:
            r = results.get(k, {})
            w1c = str(w1s[k].get("expanded")) if w1s[k].get("solved") else "FAIL"
            row = f"{k[:34]:<34} {base[k]['expanded']:>5} {w1c:>7} "
            for n in names:
                s, e = r.get(n, (False, None))
                row += f"{(str(e) if s else 'FAIL'):>8} "
            print(row)
        for n in names:
            common = [k for k in group if results.get(k, {}).get(n, (0, 0))[0] and results[k][n][1]]
            tb = sum(base[k]["expanded"] for k in common)
            tc = sum(results[k][n][1] for k in common)
            solved = sum(1 for k in group if results.get(k, {}).get(n, (0, 0))[0])
            print(f"  {n:9s}: solved {solved}/{len(group)}  ratio={tc/tb:.3f}" if tb else f"  {n}: -")


if __name__ == "__main__":
    main()
