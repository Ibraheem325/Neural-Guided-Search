"""
Diagnose whether the IQN W1 signal is DISCRIMINATIVE ACROSS SUCCESSORS in Logistics.

The offline check shows high-W1 states have high error (globally), but for search
guidance what matters is: at a given parent node, does W1 differ meaningfully
between the correct and wrong successors?

This script expands the root state of a logistics instance, prints the W1 from
root to each child alongside the policy prior, and shows the coefficient of
variation of W1 across siblings. Low CV = undiscriminating signal = the boost
will spread exploration roughly equally = cannot focus on the right child.
"""
import argparse
import math
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
    q_values, actions = iqn_model.forward([(state, goal)], taus=taus)[0]
    if q_values.shape[0] == 0:
        return None, None
    qs, _ = torch.sort(q_values, dim=1)
    means = qs.mean(dim=1)
    best = int(means.argmax().item())
    return qs[best].detach(), means[best].item()


def edge_w1(c1, c2):
    if c1 is None or c2 is None:
        return None
    return torch.mean(torch.abs(c1 - c2)).item()


def analyze_node(state, goal, policy_model, iqn_model, taus, label="root"):
    logits, actions = policy_model.forward([(state, goal)])[0]
    probs = torch.softmax(logits, dim=0).tolist()
    parent_curve, parent_mean = best_curve(iqn_model, state, goal, taus)

    mean_str = f"{parent_mean:.3f}" if parent_mean is not None else "N/A"
    print(f"\n=== {label} | {len(actions)} successors | IQN mean={mean_str} ===")
    print(f"{'Prior':>8}  {'W1':>8}  {'ChildMean':>10}  Action")

    w1_vals = []
    rows = []
    for i, (action, p) in enumerate(zip(actions, probs)):
        succ = action.apply(state)
        child_curve, child_mean = best_curve(iqn_model, succ, goal, taus)
        w1 = edge_w1(parent_curve, child_curve)
        w1_vals.append(w1 if w1 is not None else float('nan'))
        rows.append((p, w1, child_mean, str(action)))

    rows.sort(key=lambda r: r[0], reverse=True)
    for p, w1, cm, act in rows:
        w1_str = f"{w1:.4f}" if w1 is not None else "  N/A"
        cm_str = f"{cm:.3f}" if cm is not None else "    N/A"
        print(f"{p:>8.4f}  {w1_str:>8}  {cm_str:>10}  {act}")

    valid = [v for v in w1_vals if not math.isnan(v)]
    if len(valid) > 1:
        mean_w1 = sum(valid) / len(valid)
        std_w1 = math.sqrt(sum((v - mean_w1) ** 2 for v in valid) / len(valid))
        cv = std_w1 / mean_w1 if mean_w1 > 0 else 0.0
        print(f"\nW1 stats: mean={mean_w1:.4f}  std={std_w1:.4f}  CV={cv:.3f}")
        print(f"  CV < 0.2 → signal is nearly uniform across successors (cannot discriminate)")
        print(f"  CV > 0.5 → signal discriminates between successors (could guide search)")
    return actions, probs, parent_curve


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--domain", required=True, type=Path)
    p.add_argument("--problem", required=True, type=Path)
    p.add_argument("--policy_model", required=True, type=Path)
    p.add_argument("--iqn_model", required=True, type=Path)
    p.add_argument("--depth", default=1, type=int, help="How many plies deep to expand")
    args = p.parse_args()

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)

    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    goal = problem.get_goal_condition()
    state = problem.get_initial_state()

    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy_model = ModelWrapper(policy_raw, "policy")

    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()

    with torch.no_grad():
        actions, probs, parent_curve = analyze_node(
            state, goal, policy_model, iqn_raw, taus, label="root"
        )

        if args.depth >= 2:
            # Expand the top-prior child one level deeper
            top_action = max(zip(actions, probs), key=lambda x: x[1])[0]
            child_state = top_action.apply(state)
            print(f"\n--- Following top-prior action: {top_action} ---")
            analyze_node(child_state, goal, policy_model, iqn_raw, taus, label="depth-1 (best prior)")


if __name__ == "__main__":
    main()
