"""
Diagnostic for Logistics instances where baseline AlphaZero fails.

Key question at each root: does the dominant (high-prior) action also have the
highest W1 shift? If yes -> W1 signal cannot redirect search. If no -> signal
could potentially help.

Usage:
  venv/bin/python logi_failing_diag.py \
    --domain  example/logistics_dataset/domain.pddl \
    --policy_model models/logistics_sac_policy.pth \
    --iqn_model    models/logistics_iqn.pth \
    --problems example/logistics_dataset/test/003_p-VAL-c4s2p7-18.pddl \
               example/logistics_dataset/test/008_p-VAL-c4s3p8-22.pddl \
               ...
"""
import argparse
import math
import sys
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


_LO, _HI = 8, 90  # quantile indices for width: q[90] - q[8]


def curve_and_mean(iqn_model, state, goal, taus):
    q_values, _ = iqn_model.forward([(state, goal)], taus=taus.expand(1, taus.shape[1]))[0]
    if q_values.shape[0] == 0:
        return None, None, None
    qs, _ = torch.sort(q_values, dim=1)
    means = qs.mean(dim=1)
    best = int(means.argmax())
    best_curve = qs[best].detach()
    width = (best_curve[_HI] - best_curve[_LO]).item()
    return best_curve, means[best].item(), width


def w1(c1, c2):
    if c1 is None or c2 is None:
        return None
    return torch.mean(torch.abs(c1 - c2)).item()


def analyze(problem_path, domain, policy_model, iqn_model, taus):
    problem = mm.Problem(domain, str(problem_path))
    goal = problem.get_goal_condition()
    state = problem.get_initial_state()

    logits, actions = policy_model.forward([(state, goal)])[0]
    probs = torch.softmax(logits, dim=0).tolist()
    pcurve, pmean, pwidth = curve_and_mean(iqn_model, state, goal, taus)

    rows = []
    for action, p in zip(actions, probs):
        succ = action.apply(state)
        ccurve, cmean, cwidth = curve_and_mean(iqn_model, succ, goal, taus)
        mag = w1(pcurve, ccurve)
        sign = (1.0 if (cmean is not None and pmean is not None and cmean > pmean) else -1.0)
        rows.append(dict(prior=p, mag=mag or 0.0, signed=(sign * (mag or 0.0)),
                         cmean=cmean, cwidth=cwidth, action=str(action)))

    rows.sort(key=lambda r: r["prior"], reverse=True)
    dom = rows[0]
    alts = rows[1:]
    max_alt_mag = max(r["mag"] for r in alts) if alts else 0.0
    max_alt_signed = max(r["signed"] for r in alts) if alts else 0.0
    max_alt_width = max((r["cwidth"] or 0.0) for r in alts) if alts else 0.0

    mags = [r["mag"] for r in rows if r["mag"] > 0]
    cv = 0.0
    if len(mags) > 1:
        mu = sum(mags) / len(mags)
        std = math.sqrt(sum((v - mu)**2 for v in mags) / len(mags))
        cv = std / mu if mu > 0 else 0.0

    return dict(
        n=len(rows), pmean=pmean, pwidth=pwidth,
        dom_prior=dom["prior"], dom_mag=dom["mag"], dom_signed=dom["signed"],
        dom_cmean=dom["cmean"], dom_cwidth=dom["cwidth"],
        dom_action=dom["action"],
        max_alt_mag=max_alt_mag, max_alt_signed=max_alt_signed,
        max_alt_width=max_alt_width,
        cv=cv, rows=rows,
    )


def main():
    print("logi_failing_diag.py starting...", flush=True)

    parser = argparse.ArgumentParser()
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--iqn_model", required=True, type=Path)
    parser.add_argument("--problems", nargs="+", required=True, type=Path,
                        help="Full paths to the failing PDDL instances.")
    args = parser.parse_args()

    print(f"Loading models...", flush=True)
    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)

    domain = mm.Domain(str(args.domain))
    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy_model = ModelWrapper(policy_raw, "policy")
    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()
    print("Models loaded.\n", flush=True)

    can_help, cannot_help = [], []

    with torch.no_grad():
        for prob_path in args.problems:
            if not prob_path.exists():
                print(f"[WARN] Not found: {prob_path}", flush=True)
                continue

            name = prob_path.stem
            print(f"{'='*65}", flush=True)
            print(f"Instance: {name}", flush=True)

            try:
                r = analyze(prob_path, domain, policy_model, iqn_raw, taus)
            except Exception as e:
                print(f"  ERROR: {e}", flush=True)
                continue

            w1_verdict = ("ALT > DOM" if r["max_alt_mag"] > r["dom_mag"]
                          else "DOM highest")
            width_verdict = ("ALT > DOM  <- width could redirect"
                             if r["max_alt_width"] > r["dom_cwidth"]
                             else "DOM highest  <- width cannot redirect")
            print(f"  {r['n']} successors | parent IQN mean={r['pmean']:.3f}"
                  f"  parent width={r['pwidth']:.4f}", flush=True)
            print(f"  Dominant: prior={r['dom_prior']:.4f}  W1={r['dom_mag']:.4f}"
                  f"  width={r['dom_cwidth']:.4f}  child_mean={r['dom_cmean']:.3f}", flush=True)
            print(f"  Max-alt: W1(unsigned)={r['max_alt_mag']:.4f}"
                  f"  W1(signed)={r['max_alt_signed']:.4f}"
                  f"  width={r['max_alt_width']:.4f}", flush=True)
            print(f"  W1  --> {w1_verdict}", flush=True)
            print(f"  Width --> {width_verdict}", flush=True)

            print(f"  Top-5 by prior:", flush=True)
            for row in r["rows"][:5]:
                cm = f"{row['cmean']:.3f}" if row["cmean"] is not None else " N/A"
                cw = f"{row['cwidth']:.4f}" if row["cwidth"] is not None else "  N/A"
                print(f"    p={row['prior']:.4f}  W1={row['mag']:.4f}"
                      f"  signed={row['signed']:+.4f}  width={cw}"
                      f"  child_mean={cm}  {row['action']}", flush=True)

            if r["max_alt_width"] > r["dom_cwidth"]:
                can_help.append(name)
            else:
                cannot_help.append(name)

    print(f"\n{'='*65}", flush=True)
    print(f"SUMMARY ({len(can_help)+len(cannot_help)} instances analysed):", flush=True)
    print(f"  Alt width > Dom width (could redirect): {can_help or 'none'}", flush=True)
    print(f"  Dom W1 highest  (signal cannot redirect): {cannot_help or 'none'}", flush=True)
    if not can_help:
        print("\n  Dominant action has highest W1 at all failing roots.", flush=True)
        print("  A W1 threshold cannot redirect search at these instances.", flush=True)
    else:
        print(f"\n  {len(can_help)} instances are candidates for threshold/top-k boost.", flush=True)


if __name__ == "__main__":
    main()
