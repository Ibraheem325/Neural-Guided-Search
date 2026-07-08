"""
MULTI-STEP Bellman-consistency diagnostic (default: 22 hard Grid instances).

Generalized (supervisor follow-up, July 8): --tier easy/hard/all, and
--plans out to walk plans parsed from baseline search .out files (Goldminer
has no .pddl.plan files; its "plans" are the baseline AlphaZero solutions —
suboptimal, so "mistake node" is noisier there). Supervisor's question: on
HARD instances the error may be large everywhere (coin flip); on EASY
instances the model solves, does the error PINPOINT the problematic states?

  Grid easy : venv/bin/python grid_bellman_multistep.py --tier easy \
                  --out results/grid_bellman_multistep_easy.json
  Goldminer : venv/bin/python grid_bellman_multistep.py --tier all \
                  --dataset example/goldminer_dataset --plans out \
                  --plans_dir results/az_gold_baseline \
                  --policy models/goldminer_sac_policy.pth \
                  --models models/goldminer_iqn.pth \
                  --out results/gold_bellman_multistep.json

Why: the 1-step check failed (AUC 0.53) for a principled reason — training
minimizes exactly the 1-step residual, so the model is locally self-consistent
even where wrong. But training never enforces k-step consistency: if Z(s,a)
claims "12 steps to goal" and after k steps of the model's OWN greedy story it
still claims "12 to go", the accumulated mismatch is visible. And if the
rollout reaches the goal, the target is fully grounded (no model estimate).

At every node s on the optimal plan, for the CHOSEN action a = policy argmax
(and secondaries: plan action at mistake nodes, 2nd-prior competitor at
correct nodes):

  1. z_sa = model's sorted 99-quantile curve for (s,a).
  2. Roll forward: s_0 = a.apply(s); then repeatedly take the model-greedy
     action (argmax mean) — the model's own preferred continuation.
     Stop early on: goal reached, dead end, or LOOP (state revisited).
  3. At checkpoints k in {1,2,4,8}:
         target_k = sum_{i=0..k-1} gamma^i * r  +  gamma^k * Z(s_k, b)
     with r = -1 and, per the supervisor's b* rule, the error is
         err_k = min_{b in B_good(s_k)} W1(z_sa, target_k(b)),
     B_good = actions at s_k whose mean is within eps (=0, training-exact)
     of the best. If the goal was reached at depth m <= k the target is the
     exact grounded return (no bootstrap): sum_{i=0..m-1} gamma^i * r.
  4. Rollout OUTCOME is recorded per node: goal@m / loop@m / deadend@m /
     alive (still going at max k). Loop rate at mistake vs correct nodes is
     itself a candidate signal ("story goes in circles").

Decisive question, per k: is err_k LARGER at mistake nodes than correct
nodes? Reported: mean/median mistake vs correct + rank AUC per k, the
secondary A/B direction checks, and rollout-outcome rates split by node type.

Usage:
  venv/bin/python grid_bellman_multistep.py                      # single IQN
  venv/bin/python grid_bellman_multistep.py --limit 2            # smoke test
  venv/bin/python grid_bellman_multistep.py --models m1 m2 ...   # ensemble
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
from utils import create_device, get_state_key
from train_iqn import _load_model as _load_iqn_model

GAMMA = 0.999
REWARD = -1.0
KS = [1, 2, 4, 8]
EPS = 0.0   # training-exact B_good; the 1-step run showed eps barely matters


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


def canon(s):
    return s.lower().replace(" ", "").replace("(", "").replace(")", "")


def iqn_curves(iqn, state, goal, taus):
    q, actions = iqn.forward([(state, goal)], taus=taus)[0]
    if q.shape[0] == 0:
        return None, []
    qs, _ = torch.sort(q, dim=1)
    return qs, actions


def multistep_errors(z_sa, first_succ, goal, iqn, taus, max_k):
    """Roll the model's own greedy story from first_succ, computing the
    supervisor-style min-W1 error at each checkpoint k.
    Returns (errs: {k: err or None}, outcome: str, outcome_depth: int)."""
    errs = {k: None for k in KS}
    acc = 0.0            # accumulated discounted reward so far
    disc = 1.0           # gamma^m
    cur = first_succ
    visited = {get_state_key(cur)}
    outcome, outcome_depth = "alive", max_k

    for m in range(1, max_k + 1):
        acc += disc * REWARD     # the step that got us to `cur` costs -1
        disc *= GAMMA
        if goal.holds(cur):
            # grounded: exact return, no bootstrap, for ALL k >= m
            target = torch.full_like(z_sa, acc)
            err = (z_sa - target).abs().mean().item()
            for k in KS:
                if k >= m:
                    errs[k] = err
            return errs, "goal", m
        qs, actions = iqn_curves(iqn, cur, goal, taus)
        if qs is None:
            return errs, "deadend", m
        scores = qs.mean(dim=1)
        if m in KS:
            # err at checkpoint m: acc + disc * Z(cur, b), b in B_good
            targets = acc + disc * qs
            w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)
            mask = scores >= scores.max() - EPS
            errs[m] = w1[mask].min().item()
        # continue the story: model-greedy action
        best_i = int(scores.argmax())
        cur = actions[best_i].apply(cur)
        key = get_state_key(cur)
        if key in visited:
            return errs, "loop", m
        visited.add(key)

    return errs, outcome, outcome_depth


def rank_auc(pos, neg):
    if not pos or not neg:
        return float("nan")
    comb = sorted([(v, 1) for v in pos] + [(v, 0) for v in neg])
    rs, i = 0.0, 0
    while i < len(comb):
        j = i
        while j < len(comb) and comb[j][0] == comb[i][0]:
            j += 1
        rs += (i + j + 1) / 2.0 * sum(1 for t in range(i, j) if comb[t][1] == 1)
        i = j
    return (rs - len(pos) * (len(pos) + 1) / 2.0) / (len(pos) * len(neg))


def read_plan_from_out(path):
    lines = []
    for l in path.read_text().splitlines():
        m = re.match(r"\s*\d+:\s*(\(.*\))\s*$", l)
        if m:
            lines.append(m.group(1))
    return lines


def expansions_from_out(path):
    m = re.search(r"\[Final\] Expanded: (\d+)", path.read_text())
    return int(m.group(1)) if m else None


def resolve_pddl(dataset, split, inst):
    """Match an .out file's stem to its .pddl file. Usually identical; some
    domains (e.g. the external Rovers instance pool) have .out files with a
    numeric ordering prefix ("000_p-...") that isn't part of the actual pddl
    filename ("p-...") -> strip a leading "NNN_" and retry."""
    direct = dataset / split / f"{inst}.pddl"
    if direct.exists():
        return direct, inst
    stripped = re.sub(r"^\d+_", "", inst)
    alt = dataset / split / f"{stripped}.pddl"
    if alt.exists():
        return alt, stripped
    return direct, inst   # let the caller's error surface the real path


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--models", nargs="+", type=Path,
                    default=[Path("models/grid_iqn.pth")])
    ap.add_argument("--policy", type=Path, default=Path("models/grid_sac_policy.pth"))
    ap.add_argument("--dataset", type=Path, default=Path("example/grid_dataset"))
    ap.add_argument("--split", default="val",
                    help="Dataset subdirectory the plans refer to (val/test)")
    ap.add_argument("--tier", choices=["hard", "easy", "all"], default="hard",
                    help="hard: baseline >=300 expansions; easy: <300 (solved)")
    ap.add_argument("--plans", choices=["planfile", "planglob", "out"], default="planfile",
                    help="planfile: <inst>.pddl.plan chosen via --ref json (Grid); "
                         "planglob: every <split>/*.pddl.plan (OPTIMAL plans, no ref "
                         "needed; difficulty proxied by plan length); "
                         "out: numbered plan parsed from <inst>.out in --plans_dir")
    ap.add_argument("--plans_dir", type=Path, default=None,
                    help="Directory of baseline .out files (required for --plans out; "
                         "also supplies per-instance expansions for tier selection)")
    ap.add_argument("--ref", type=Path,
                    default=Path("results/grid_decoupled_comparison.json"),
                    help="Baseline-comparison json for tier selection (planfile mode)")
    ap.add_argument("--limit", type=int, default=None,
                    help="Only the first N instances (smoke test)")
    ap.add_argument("--out", type=Path,
                    default=Path("results/grid_bellman_multistep.json"))
    args = ap.parse_args()
    max_k = max(KS)

    def in_tier(exp):
        if args.tier == "all":
            return True
        return exp >= 300 if args.tier == "hard" else exp < 300

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.dataset / "domain.pddl"))
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy, device)
    policy = ModelWrapper(pol_raw, "policy")
    models = []
    for p in args.models:
        m, _, _ = _load_iqn_model(domain, p, device)
        m.eval()
        models.append(m)
    print(f"Loaded {len(models)} IQN model(s); ks={KS} gamma={GAMMA} r={REWARD} eps={EPS}")

    # instance list: (name, plan_lines, baseline_expansions), tier-filtered
    instances = []
    if args.plans == "out":
        assert args.plans_dir is not None, "--plans out requires --plans_dir"
        for f in sorted(args.plans_dir.glob("*.out")):
            plan_lines = read_plan_from_out(f)
            exp = expansions_from_out(f)
            if plan_lines and exp is not None and in_tier(exp):
                instances.append((f.stem, plan_lines, exp))
    elif args.plans == "planglob":
        # OPTIMAL plans straight from the dataset: <split>/<inst>.pddl.plan.
        # No baseline ref -> difficulty proxied by plan length (base_exp field).
        suffix = ".pddl.plan"
        for f in sorted((args.dataset / args.split).glob(f"*{suffix}")):
            inst = f.name[:-len(suffix)]
            plan_lines = [l.strip() for l in f.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]
            if plan_lines:   # tier=all only (length is a proxy, not an expansion count)
                instances.append((inst, plan_lines, len(plan_lines)))
    else:
        with open(args.ref) as f:
            ref = json.load(f)
        names = sorted([k for k in ref
                        if ref[k].get("baseline", {}).get("solved")
                        and in_tier(ref[k]["baseline"].get("expanded") or 0)],
                       key=lambda k: -(ref[k]["baseline"].get("expanded") or 0))
        for inst in names:
            pddl_path, resolved = resolve_pddl(args.dataset, args.split, inst)
            planf = pddl_path.with_suffix(pddl_path.suffix + ".plan")
            plan_lines = [l.strip() for l in planf.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]
            instances.append((inst, plan_lines,
                              ref[inst]["baseline"].get("expanded") or 0))
    if args.limit:
        instances = instances[:args.limit]
    print(f"{len(instances)} instances (tier={args.tier}, plans={args.plans})\n")

    records = []
    with torch.no_grad():
        for inst, plan_lines, base_exp in instances:
            pddl, _ = resolve_pddl(args.dataset, args.split, inst)
            problem = mm.Problem(domain, str(pddl))
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()
            n_inst = 0

            for step_idx, plan_str in enumerate(plan_lines):
                logits, actions = policy.forward([(state, goal)])[0]
                if not actions:
                    break
                probs = torch.softmax(logits, dim=0).tolist()
                pairs = sorted(zip(probs, actions), key=lambda x: -x[0])
                dom_a = pairs[0][1]
                t = canon(plan_str)
                plan_a = next((a for _, a in pairs if canon(str(a)) == t), None)
                if plan_a is None:
                    an = plan_str.strip("()").split()[0]
                    plan_a = next((a for _, a in pairs if an in str(a).lower()), dom_a)
                is_mistake = plan_a != dom_a
                alt_a = pairs[1][1] if (not is_mistake and len(pairs) > 1) else None

                per_model = {"err": [], "err_sec": [], "outcome": []}
                for iqn in models:
                    qs, iacts = iqn_curves(iqn, state, goal, taus)
                    if qs is None:
                        break
                    amap = {canon(str(a)): i for i, a in enumerate(iacts)}
                    di = amap.get(canon(str(dom_a)))
                    if di is None:
                        break
                    e_dom, outc, od = multistep_errors(
                        qs[di], dom_a.apply(state), goal, iqn, taus, max_k)
                    per_model["err"].append(e_dom)
                    per_model["outcome"].append((outc, od))
                    sec_a = plan_a if is_mistake else alt_a
                    if sec_a is not None:
                        si = amap.get(canon(str(sec_a)))
                        if si is not None:
                            e_sec, _, _ = multistep_errors(
                                qs[si], sec_a.apply(state), goal, iqn, taus, max_k)
                            per_model["err_sec"].append(e_sec)

                if per_model["err"]:
                    def agg(dicts):
                        out = {}
                        for k in KS:
                            vals = [d[k] for d in dicts if d[k] is not None]
                            out[str(k)] = statistics.mean(vals) if vals else None
                        return out
                    outc, od = per_model["outcome"][0]
                    records.append({
                        "inst": inst, "base_exp": base_exp,
                        "step": step_idx, "mistake": is_mistake,
                        "err": agg(per_model["err"]),
                        "err_sec": agg(per_model["err_sec"]) if per_model["err_sec"] else None,
                        "outcome": outc, "outcome_depth": od,
                    })
                    n_inst += 1
                state = plan_a.apply(state)
            print(f"{inst:<40} {n_inst:>4} nodes", flush=True)

    mist = [r for r in records if r["mistake"]]
    corr = [r for r in records if not r["mistake"]]
    print(f"\nTOTAL {len(records)} nodes: {len(mist)} mistake / {len(corr)} correct\n")

    print(f"{'k':>3} {'mean_mist':>10} {'mean_corr':>10} {'med_mist':>9} {'med_corr':>9} "
          f"{'AUC':>6} {'n_m':>5} {'n_c':>5}")
    for k in KS:
        pm = [r["err"][str(k)] for r in mist if r["err"][str(k)] is not None]
        pc = [r["err"][str(k)] for r in corr if r["err"][str(k)] is not None]
        if not pm or not pc:
            continue
        print(f"{k:>3} {statistics.mean(pm):>10.3f} {statistics.mean(pc):>10.3f} "
              f"{statistics.median(pm):>9.3f} {statistics.median(pc):>9.3f} "
              f"{rank_auc(pm, pc):>6.3f} {len(pm):>5} {len(pc):>5}")

    print("\nRollout outcomes of the model's own greedy story (from the chosen action):")
    for tag, group in [("mistake", mist), ("correct", corr)]:
        n = len(group)
        if not n:
            continue
        cnt = {}
        for r in group:
            cnt[r["outcome"]] = cnt.get(r["outcome"], 0) + 1
        parts = ", ".join(f"{o}: {c} ({100*c/n:.0f}%)" for o, c in sorted(cnt.items()))
        print(f"  {tag:>8} ({n:>4}): {parts}")

    for k in KS:
        both = [r for r in mist if r["err_sec"] and r["err_sec"][str(k)] is not None
                and r["err"][str(k)] is not None]
        if both:
            wins = sum(1 for r in both if r["err"][str(k)] > r["err_sec"][str(k)])
            print(f"\nA (k={k}): wrong-action err > plan-action err at "
                  f"{wins}/{len(both)} ({100*wins/len(both):.0f}%) mistake nodes")
            break
    for k in KS[::-1]:
        both = [r for r in mist if r["err_sec"] and r["err_sec"][str(k)] is not None
                and r["err"][str(k)] is not None]
        if both:
            wins = sum(1 for r in both if r["err"][str(k)] > r["err_sec"][str(k)])
            print(f"A (k={k}): wrong-action err > plan-action err at "
                  f"{wins}/{len(both)} ({100*wins/len(both):.0f}%) mistake nodes")
            ctrl = [r for r in corr if r["err_sec"] and r["err_sec"][str(k)] is not None
                    and r["err"][str(k)] is not None]
            if ctrl:
                mis = sum(1 for r in ctrl if r["err"][str(k)] > r["err_sec"][str(k)])
                print(f"B (k={k}): misfire (chosen err > competitor err) at "
                      f"{mis}/{len(ctrl)} ({100*mis/len(ctrl):.0f}%) correct nodes")
            break

    args.out.parent.mkdir(exist_ok=True)
    with open(args.out, "w") as f:
        json.dump({"models": [str(p) for p in args.models], "ks": KS,
                   "gamma": GAMMA, "reward": REWARD, "eps": EPS,
                   "tier": args.tier, "dataset": str(args.dataset),
                   "plans": args.plans, "records": records}, f, indent=1)
    print(f"\nPer-node records -> {args.out}")


if __name__ == "__main__":
    main()
