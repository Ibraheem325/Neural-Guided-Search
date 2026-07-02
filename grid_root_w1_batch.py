"""
Compute root-level W1 stats for a list of Grid instances.
Prints: instance, baseline_exp, w1_exp, dom_prior, dom_W1, max_alt_W1, num_actions
"""
import argparse
import sys
import torch
from pathlib import Path
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
from utils import create_device, get_state_key
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


def best_curve(iqn_model, state, goal, taus):
    q_values, _ = iqn_model.forward([(state, goal)], taus=taus)[0]
    if q_values.shape[0] == 0:
        return None
    qs, _ = torch.sort(q_values, dim=1)
    means = qs.mean(dim=1)
    return qs[int(means.argmax())].detach()


def edge_w1(c1, c2):
    if c1 is None or c2 is None:
        return None
    return torch.mean(torch.abs(c1 - c2)).item()


def analyze_root(prob_path, domain, policy, iqn_model, taus):
    problem = mm.Problem(domain, str(prob_path))
    goal = problem.get_goal_condition()
    state = problem.get_initial_state()

    logits, actions = policy.forward([(state, goal)])[0]
    probs = torch.softmax(logits, dim=0).tolist()
    pcurve = best_curve(iqn_model, state, goal, taus)

    rows = []
    for action, p in zip(actions, probs):
        succ = action.apply(state)
        ccurve = best_curve(iqn_model, succ, goal, taus)
        w1 = edge_w1(pcurve, ccurve)
        rows.append((p, w1 or 0.0))

    rows.sort(key=lambda r: r[0], reverse=True)
    dom_prior, dom_w1 = rows[0]
    max_alt_w1 = max(r[1] for r in rows[1:]) if len(rows) > 1 else 0.0
    return dom_prior, dom_w1, max_alt_w1, len(rows)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--domain", required=True, type=Path)
    p.add_argument("--val_dir", required=True, type=Path)
    p.add_argument("--policy_model", required=True, type=Path)
    p.add_argument("--q1_model", required=True, type=Path)
    p.add_argument("--iqn_model", required=True, type=Path)
    p.add_argument("--results_json", required=True, type=Path)
    args = p.parse_args()

    import json
    with open(args.results_json) as f:
        data = json.load(f)

    coverage_fails = {
        "029_p-VAL2-n30-x2y7t4k3333l2222-2",
        "038_p-VAL2-n24-x2y6t3k333l222-3",
        "088_p-VAL2-n29-x3y7t2k33l11-7",
    }

    targets = []
    for inst, results in data.items():
        b = results.get("baseline", {})
        w = results.get("w1_lambda1.5", {})
        b_exp = b.get("expanded")
        w_exp = w.get("expanded")
        w_solved = w.get("solved", False)

        if inst in coverage_fails:
            targets.append((inst, b_exp or 9999, None, "FAIL"))
            continue
        if not b.get("solved") or not b_exp:
            continue
        if not w_exp:
            continue
        ratio = w_exp / b_exp
        if b_exp >= 300 and ratio >= 0.70:
            targets.append((inst, b_exp, w_exp, ratio))

    targets.sort(key=lambda x: x[1], reverse=True)

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.domain))
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy = ModelWrapper(pol_raw, "policy")
    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()

    print(f"{'Instance':<52} {'base':>6} {'w1':>6} {'ratio':>6} {'dom_prior':>10} {'dom_W1':>8} {'alt_W1':>8} {'n_act':>6}")
    print("-" * 120)

    with torch.no_grad():
        for inst, b_exp, w_exp, tag in targets:
            # find the PDDL file
            matches = list(args.val_dir.glob(f"{inst}.pddl"))
            if not matches:
                # try prefix match
                matches = list(args.val_dir.glob(f"{inst}*.pddl"))
            if not matches:
                print(f"  [SKIP] {inst} — pddl not found")
                continue
            prob_path = matches[0]
            try:
                dom_prior, dom_w1, alt_w1, n_act = analyze_root(
                    prob_path, domain, policy, iqn_raw, taus)
            except Exception as e:
                print(f"  [ERR] {inst}: {e}")
                continue

            w_str = str(w_exp) if w_exp is not None else "FAIL"
            r_str = f"{tag:.2f}" if isinstance(tag, float) else tag
            print(f"{inst:<52} {b_exp:>6} {w_str:>6} {r_str:>6} "
                  f"{dom_prior:>10.4f} {dom_w1:>8.4f} {alt_w1:>8.4f} {n_act:>6}")


if __name__ == "__main__":
    main()
