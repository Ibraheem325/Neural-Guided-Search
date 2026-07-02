"""
w1_planpath_analysis.py

Walk a reference solution path for a set of instances and, at every
"decision node" (dom_prior < PEAK_THRESHOLD), characterize:

  - the prior distribution (dom_prior, n_act)
  - the W1 of every child edge (parent IQN curve vs child IQN curve)
  - whether the plan action has the highest W1 (rank of plan action by W1)
  - how many siblings carry a high W1 (>= 0.8 * max W1 at the node)
  - what the multiplicative boost P'(a) = P(a)(1 + lambda*nW1(a))/Z actually
    does: total-variation distance |P' - P|, and whether it flips the argmax
    (and if so, whether the new argmax is the plan action).

Reference paths:
  --plan_source plan   -> read <instance>.pddl.plan next to the pddl file
  --plan_source out    -> parse the numbered plan from a baseline .out file

Usage examples at the bottom of this docstring are in the thesis notes.
"""
import argparse
import json
import re
import statistics
import torch
from pathlib import Path

import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
from utils import create_device
from train_iqn import _load_model as _load_iqn_model

PEAK_THRESHOLD = 0.90


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model, readout_name):
        super().__init__()
        self.model = model
        self.readout_name = readout_name

    def forward(self, state_goals):
        il, al = [], []
        for s, g in state_goals:
            a = s.generate_applicable_actions()
            il.append((s, a, g))
            al.append(a)
        return list(zip(self.model.forward(il).readout(self.readout_name), al))


def best_curve(iqn_model, state, goal, taus):
    q_values, _ = iqn_model.forward([(state, goal)], taus=taus)[0]
    if q_values.shape[0] == 0:
        return None
    qs, _ = torch.sort(q_values, dim=1)
    return qs[int(qs.mean(dim=1).argmax())].detach()


def edge_w1(c1, c2):
    if c1 is None or c2 is None:
        return None
    return torch.mean(torch.abs(c1 - c2)).item()


def canon(s):
    return s.lower().replace(" ", "").replace("(", "").replace(")", "")


def read_plan_from_planfile(path):
    return [l.strip() for l in path.read_text().splitlines()
            if l.strip() and not l.startswith(";")]


def read_plan_from_out(path):
    lines = []
    for l in path.read_text().splitlines():
        m = re.match(r"\s*\d+:\s*(\(.*\))\s*$", l)
        if m:
            lines.append(m.group(1))
    return lines


def match_action(plan_str, pairs):
    """pairs = [(prob, action), ...] sorted by prob desc."""
    target = canon(plan_str)
    for _, a in pairs:
        if canon(str(a)) == target:
            return a
    act_name = plan_str.strip("()").split()[0]
    for _, a in pairs:
        if act_name in str(a).lower():
            return a
    return pairs[0][1]


def analyze_instance(domain, policy, iqn, taus, pddl_path, plan_lines, lam):
    problem = mm.Problem(domain, str(pddl_path))
    goal = problem.get_goal_condition()
    state = problem.get_initial_state()

    node_records = []  # per decision node
    n_steps = 0

    for plan_str in plan_lines:
        logits, actions = policy.forward([(state, goal)])[0]
        if not actions:
            break
        n_steps += 1
        probs = torch.softmax(logits, dim=0).tolist()
        pairs = sorted(zip(probs, actions), key=lambda x: -x[0])
        dom_p = pairs[0][0]
        plan_action = match_action(plan_str, pairs)

        if dom_p < PEAK_THRESHOLD and len(pairs) > 1:
            parent_curve = best_curve(iqn, state, goal, taus)
            rec = {"dom_prior": dom_p, "n_act": len(pairs),
                   "priors": [], "w1s": [], "plan_idx": None}
            for i, (p, a) in enumerate(pairs):
                succ = a.apply(state)
                child_curve = best_curve(iqn, succ, goal, taus)
                w1 = edge_w1(parent_curve, child_curve)
                rec["priors"].append(p)
                rec["w1s"].append(w1 if w1 is not None else 0.0)
                if a == plan_action:
                    rec["plan_idx"] = i
            node_records.append(rec)

        state = plan_action.apply(state)

    # Global min-max normalization of W1 across all decision nodes of this
    # instance (approximates the search's running normalizer).
    all_w1 = [w for r in node_records for w in r["w1s"]]
    lo, hi = (min(all_w1), max(all_w1)) if all_w1 else (0.0, 1.0)
    span = (hi - lo) if hi > lo else 1.0

    ZERO_EPS = 0.005
    stats = {"n_steps": n_steps,
             "n_decision": len(node_records),
             "plan_w1_top": 0,        # plan action has max W1
             "high_w1_sibs": [],       # per node: #children with W1 >= 0.8*max
             "zero_w1_frac": [],       # per node: frac of children with W1 ~ 0
             "filter_nodes": 0,        # plan W1 > 0 while >=1 sibling W1 ~ 0
             "plan_w1_zero": 0,        # plan action itself has W1 ~ 0
             "tv": [],                 # per node TV distance raw vs boosted
             "flips": 0,               # boost changes argmax of prior
             "flips_to_plan": 0,       # ... and new argmax is the plan action
             "flips_away_plan": 0,     # raw argmax was plan action, boost moved it away
             "plan_boost_gain": []}    # P'(plan) - P(plan)

    for r in node_records:
        w1s, priors, pidx = r["w1s"], r["priors"], r["plan_idx"]
        mx = max(w1s)
        if pidx is not None and w1s[pidx] >= mx - 1e-12:
            stats["plan_w1_top"] += 1
        stats["high_w1_sibs"].append(sum(1 for w in w1s if mx > 0 and w >= 0.8 * mx))
        n_zero = sum(1 for w in w1s if w < ZERO_EPS)
        stats["zero_w1_frac"].append(n_zero / len(w1s))
        if pidx is not None:
            if w1s[pidx] < ZERO_EPS:
                stats["plan_w1_zero"] += 1
            elif n_zero >= 1:
                stats["filter_nodes"] += 1

        nw = [(w - lo) / span for w in w1s]
        raw = [p * (1.0 + lam * n) for p, n in zip(priors, nw)]
        tot = sum(raw)
        boosted = [v / tot for v in raw] if tot > 0 else priors
        stats["tv"].append(0.5 * sum(abs(b - p) for b, p in zip(boosted, priors)))

        raw_arg = max(range(len(priors)), key=lambda i: priors[i])
        new_arg = max(range(len(boosted)), key=lambda i: boosted[i])
        if new_arg != raw_arg:
            stats["flips"] += 1
            if pidx is not None and new_arg == pidx:
                stats["flips_to_plan"] += 1
            if pidx is not None and raw_arg == pidx:
                stats["flips_away_plan"] += 1
        if pidx is not None:
            stats["plan_boost_gain"].append(boosted[pidx] - priors[pidx])

    return stats


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain", required=True, type=Path)
    ap.add_argument("--instance_dir", required=True, type=Path)
    ap.add_argument("--policy_model", required=True, type=Path)
    ap.add_argument("--iqn_model", required=True, type=Path)
    ap.add_argument("--lam", type=float, required=True)
    ap.add_argument("--plan_source", choices=["plan", "out"], required=True)
    ap.add_argument("--out_dir", type=Path, default=None,
                    help="Directory with baseline .out files (plan_source=out)")
    ap.add_argument("--instances", required=True,
                    help="Comma-separated instance stems, each optionally "
                         "annotated stem:ratio for display")
    args = ap.parse_args()

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.domain))
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy = ModelWrapper(pol_raw, "policy")
    iqn_raw, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn_raw.eval()

    header = (f"{'instance':<24} {'tag':>7} {'steps':>5} {'dec':>4} "
              f"{'decfrac':>7} {'planW1top':>9} {'hiW1sibs':>8} {'zeroW1':>6} "
              f"{'filter':>6} {'planW1=0':>8} {'TV':>6} "
              f"{'flips':>5} {'to_plan':>7} {'away':>5} {'plan_gain':>9}")
    print(header)
    print("-" * len(header))

    with torch.no_grad():
        for spec in args.instances.split(","):
            spec = spec.strip()
            if ":" in spec:
                stem, tag = spec.split(":", 1)
            else:
                stem, tag = spec, ""
            pddl = args.instance_dir / f"{stem}.pddl"
            if args.plan_source == "plan":
                planf = pddl.with_suffix(".pddl.plan")
                if not planf.exists():
                    print(f"{stem:<24} (no .plan file)")
                    continue
                plan_lines = read_plan_from_planfile(planf)
            else:
                outf = args.out_dir / f"{stem}.out"
                if not outf.exists():
                    print(f"{stem:<24} (no .out file)")
                    continue
                plan_lines = read_plan_from_out(outf)
            if not plan_lines:
                print(f"{stem:<24} (empty plan)")
                continue

            s = analyze_instance(domain, policy, iqn_raw, taus, pddl, plan_lines, args.lam)
            dec = s["n_decision"]
            decfrac = dec / s["n_steps"] if s["n_steps"] else 0.0
            hi = statistics.mean(s["high_w1_sibs"]) if s["high_w1_sibs"] else 0.0
            zf = statistics.mean(s["zero_w1_frac"]) if s["zero_w1_frac"] else 0.0
            tv = statistics.mean(s["tv"]) if s["tv"] else 0.0
            gain = statistics.mean(s["plan_boost_gain"]) if s["plan_boost_gain"] else 0.0
            top = f"{s['plan_w1_top']}/{dec}" if dec else "-"
            filt = f"{s['filter_nodes']}/{dec}" if dec else "-"
            print(f"{stem:<24} {tag:>7} {s['n_steps']:>5} {dec:>4} "
                  f"{decfrac:>7.2f} {top:>9} {hi:>8.2f} {zf:>6.2f} "
                  f"{filt:>6} {s['plan_w1_zero']:>8} {tv:>6.3f} "
                  f"{s['flips']:>5} {s['flips_to_plan']:>7} {s['flips_away_plan']:>5} {gain:>+9.3f}")


if __name__ == "__main__":
    main()
