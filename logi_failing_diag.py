"""
Diagnostic for the 8 Logistics instances where baseline AlphaZero fails.

For each instance, expand the root (and optionally a few plies deep) and ask:
  - Does the dominant prior action also have the HIGHEST W1?  (→ signal useless)
  - Or does an alternative have higher W1?                    (→ signal could help)

We also report the CV of W1 across siblings and the IQN child-mean for each action,
so we can see whether the W1 signal at failing instances looks different from the
passing instance (000) we already diagnosed.

Run from the project root:
  venv/bin/python logi_failing_diag.py \
    --domain  example/logistics_dataset/domain.pddl \
    --test_dir example/logistics_dataset/test \
    --policy_model models/logistics_sac_policy.pth \
    --iqn_model    models/logistics_iqn.pth \
    --instances 003 008 017 036 050 064 073 092
"""
import argparse
import math
import torch
from pathlib import Path
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
from utils import create_device
from train_iqn import _load_model as _load_iqn_model


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model, readout_name):
        super().__init__()
        self.model = model
        self.readout_name = readout_name

    def forward(self, state_goals):
        input_list, actions_list = [], []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        values_list = self.model.forward(input_list).readout(self.readout_name)
        return list(zip(values_list, actions_list))


def best_curve_and_mean(iqn_model, state, goal, taus):
    q_values, actions = iqn_model.forward([(state, goal)], taus=taus)[0]
    if q_values.shape[0] == 0:
        return None, None
    qs, _ = torch.sort(q_values, dim=1)
    means = qs.mean(dim=1)
    best = int(means.argmax().item())
    return qs[best].detach(), means[best].item()


def edge_w1_signed(parent_curve, child_curve):
    if parent_curve is None or child_curve is None:
        return None, None
    mag = torch.mean(torch.abs(parent_curve - child_curve)).item()
    sign = 1.0 if child_curve.mean().item() > parent_curve.mean().item() else -1.0
    return sign * mag, mag


def analyze_root(problem_path, domain, policy_model, iqn_model, taus):
    problem = mm.Problem(domain, str(problem_path))
    goal = problem.get_goal_condition()
    state = problem.get_initial_state()

    logits, actions = policy_model.forward([(state, goal)])[0]
    probs = torch.softmax(logits, dim=0).tolist()
    parent_curve, parent_mean = best_curve_and_mean(iqn_model, state, goal, taus)

    rows = []
    unsigned_w1s = []
    for action, p in zip(actions, probs):
        succ = action.apply(state)
        child_curve, child_mean = best_curve_and_mean(iqn_model, succ, goal, taus)
        signed, mag = edge_w1_signed(parent_curve, child_curve)
        unsigned_w1s.append(mag if mag is not None else 0.0)
        rows.append({
            "prior": p,
            "w1_signed": signed,
            "w1_mag": mag,
            "child_mean": child_mean,
            "action": str(action),
        })

    rows.sort(key=lambda r: r["prior"], reverse=True)
    dominant = rows[0]
    dom_w1 = dominant["w1_mag"] or 0.0
    max_alt_w1 = max((r["w1_mag"] or 0.0) for r in rows[1:]) if len(rows) > 1 else 0.0

    # CV of unsigned W1 across all siblings
    valid = [v for v in unsigned_w1s if v > 0]
    if len(valid) > 1:
        mu = sum(valid) / len(valid)
        std = math.sqrt(sum((v - mu) ** 2 for v in valid) / len(valid))
        cv = std / mu if mu > 0 else 0.0
    else:
        cv = 0.0

    signal_helps = dom_w1 < max_alt_w1  # True → W1 points AWAY from dominant action

    return {
        "n_actions": len(rows),
        "parent_mean": parent_mean,
        "dominant_prior": dominant["prior"],
        "dominant_w1": dom_w1,
        "dominant_child_mean": dominant["child_mean"],
        "max_alt_w1": max_alt_w1,
        "cv": cv,
        "signal_helps": signal_helps,
        "top5": rows[:5],
    }


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--domain", required=True, type=Path)
    p.add_argument("--test_dir", required=True, type=Path)
    p.add_argument("--policy_model", required=True, type=Path)
    p.add_argument("--iqn_model", required=True, type=Path)
    p.add_argument("--instances", nargs="+", required=True,
                   help="Instance prefixes, e.g. 003 008 017")
    args = p.parse_args()

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)

    domain = mm.Domain(str(args.domain))

    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy_model = ModelWrapper(policy_raw, "policy")

    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()

    signal_can_help = []
    signal_cannot_help = []

    with torch.no_grad():
        for prefix in args.instances:
            matches = sorted(args.test_dir.glob(f"{prefix}_*.pddl"))
            if not matches:
                print(f"[WARN] No file found for prefix {prefix}")
                continue
            path = matches[0]

            r = analyze_root(path, domain, policy_model, iqn_raw, taus)

            verdict = "SIGNAL CAN HELP" if r["signal_helps"] else "signal dominated by prior"
            print(f"\n{'='*70}")
            print(f"Instance {prefix}: {path.name}")
            print(f"  {r['n_actions']} successors | parent IQN mean: {r['parent_mean']:.3f}")
            print(f"  Dominant action: prior={r['dominant_prior']:.4f}, "
                  f"W1={r['dominant_w1']:.4f}, child_mean={r['dominant_child_mean']:.3f}")
            print(f"  Max alternative W1: {r['max_alt_w1']:.4f}   CV={r['cv']:.3f}")
            print(f"  --> {verdict}")
            print(f"  Top-5 by prior:")
            for row in r["top5"]:
                s = row['w1_signed']
                m = row['w1_mag']
                cm = row['child_mean']
                s_str = f"{s:+.4f}" if s is not None else "  N/A"
                m_str = f"{m:.4f}" if m is not None else " N/A"
                cm_str = f"{cm:.3f}" if cm is not None else " N/A"
                print(f"    prior={row['prior']:.4f}  W1(signed)={s_str}  W1(mag)={m_str}"
                      f"  child_mean={cm_str}  {row['action']}")

            if r["signal_helps"]:
                signal_can_help.append(prefix)
            else:
                signal_cannot_help.append(prefix)

    print(f"\n{'='*70}")
    print(f"SUMMARY across {len(args.instances)} failing instances:")
    print(f"  Signal CAN help  (alt W1 > dominant W1): {signal_can_help}")
    print(f"  Signal dominated (dominant W1 >= max alt): {signal_cannot_help}")
    if signal_can_help:
        print(f"\n  These {len(signal_can_help)} instances are candidates for threshold/top-k W1 boost.")
    else:
        print(f"\n  Dominant action has highest (or equal) W1 at ALL failing roots.")
        print(f"  W1 signal cannot redirect search away from the dominant wrong action.")
