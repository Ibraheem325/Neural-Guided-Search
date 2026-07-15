"""
CROSS-MODEL Bellman-consistency offline check (July 2026).

WHY. The single-model Bellman check is near-chance far from the goal because
the parent value and the k-step-ahead (grandchild) value come from the SAME
IQN. Training forces  Z(parent) ~ cost + Z(grandchild)  for that one network,
and the network is smooth, so the two agree by construction whether or not the
model is correct. A confidently-wrong model is wrong SMOOTHLY (20,19,18,...),
so its lookahead agrees with itself and the residual stays ~0 exactly where we
wanted it to spike. The check measures self-consistency (guaranteed by
training), not uncertainty (what we want).

FIX (user's idea). Use INDEPENDENTLY trained IQNs. Read the parent with model i
and the grandchild with model j != i. Training never forced model i's parent to
match model j's grandchild, so a genuine disagreement can appear where a model
is confidently wrong.

    err(i->j) = min_{b in Bgood_j(s_k)} W1( Z_i(s,a),  cost + Z_j(s_k, b) )

    within-model err = mean over i of err(i->i)     <- the OLD broken check (control)
    cross-model  err = mean over i!=j of err(i->j)  <- the NEW signal

CLEAN ISOLATION. The k-step rollout path s_1..s_k is computed ONCE, by the
ENSEMBLE-MEAN greedy action, and shared by every (i,j). So within vs cross
differ ONLY in which model reads the parent and the endpoint -- nothing else.
If the rollout reaches the goal the target is the real accumulated cost (a
constant, model-free): there within==cross by construction (the grounded
regime), which is the expected control.

LABELS + STATES: ground truth via mm.StateSpaceSampler (approach 2). A
transition is CORRECT iff it decreases steps_to_goal. States sampled uniformly
across goal-distance. AUC = P(err at INCORRECT > err at CORRECT); 0.5 = no
signal, <0.5 = inverted. Sliced by distance to goal -- the decisive question is
whether cross-model rescues the FAR-FROM-GOAL regime where within-model is dead.

Small instances only (StateSpaceSampler must expand the space).

Usage:
  venv/bin/python bellman_ensemble_crosscheck.py \
    --domain_file "$D/Domains2/grid/domain.pddl" \
    --instances   "$D/Domains2/grid/instances" \
    --policy_model models/grid_sac_policy.pth \
    --iqn_models models/grid_iqn.pth models/grid_iqn_ens_1_best.pth ... \
    --max_instances 50 --states_per_instance 40 --out results/xcheck_grid.json
"""
import argparse
import json
import random
import statistics
from itertools import product
from pathlib import Path

import torch
import pymimir as mm
import pymimir_rgnn as rgnn

from utils import create_device, get_state_key
from train_iqn import _load_model as _load_iqn_model
from bellman_epsilon_label import ModelWrapper, iqn_curves, rank_auc
from bellman_statespace_label import screen, sample_states

GAMMA = 0.999
REWARD = -1.0


def curves_all(models, state, goal, taus):
    """Per-model sorted curves + shared action list at `state`.
    Returns (list_of_[A,99] per model, actions) or (None, []) at a dead end."""
    per = []
    actions = None
    for m in models:
        qs, acts = iqn_curves(m, state, goal, taus)
        if qs is None:
            return None, []
        per.append(qs)
        actions = acts
    return per, actions


def cross_errors(models, s, a, goal, taus, k):
    """within-model and cross-model k-step Bellman err for action `a` at `s`,
    over a SHARED ensemble-mean-greedy rollout. Returns (within, cross, outcome)
    or (None, None, 'deadend')."""
    n = len(models)
    # parent curves Z_i(s,a) for every model
    par, actions = curves_all(models, s, goal, taus)
    if par is None:
        return None, None, "deadend"
    ai = next((idx for idx, x in enumerate(actions) if x == a), None)
    if ai is None:
        return None, None, "deadend"
    z_par = [par[i][ai] for i in range(n)]        # list of [99]

    # shared rollout from a.apply(s), ensemble-mean greedy
    cur = a.apply(s)
    visited = {get_state_key(cur)}
    acc, disc = 0.0, 1.0
    for step in range(1, k + 1):
        acc += disc * REWARD
        disc *= GAMMA
        if goal.holds(cur):
            # grounded target = constant acc (model-free) -> within==cross
            e = statistics.mean((z_par[i] - torch.full_like(z_par[i], acc))
                                .abs().mean().item() for i in range(n))
            return e, e, "goal"
        cq, cact = curves_all(models, cur, goal, taus)
        if cq is None:
            return None, None, "deadend"
        mean_scores = torch.stack([cq[i].mean(dim=1) for i in range(n)]).mean(0)
        if step == k:
            # endpoint: err(i->j) = min over Bgood_j of W1(z_par[i], acc+disc*cq[j])
            within, cross = [], []
            for i in range(n):
                for j in range(n):
                    tgt = acc + disc * cq[j]                       # [A,99]
                    w1 = (z_par[i].unsqueeze(0) - tgt).abs().mean(dim=1)
                    sc = cq[j].mean(dim=1)
                    e = w1[sc >= sc.max()].min().item()
                    (within if i == j else cross).append(e)
            return statistics.mean(within), statistics.mean(cross), "alive"
        nxt = cact[int(mean_scores.argmax())].apply(cur)
        key = get_state_key(nxt)
        if key in visited:
            within, cross = [], []
            for i in range(n):
                for j in range(n):
                    tgt = acc + disc * cq[j]
                    w1 = (z_par[i].unsqueeze(0) - tgt).abs().mean(dim=1)
                    sc = cq[j].mean(dim=1)
                    e = w1[sc >= sc.max()].min().item()
                    (within if i == j else cross).append(e)
            return statistics.mean(within), statistics.mean(cross), "loop"
        visited.add(key)
        cur = nxt
    return None, None, "deadend"


def slice_auc(recs, key, pred):
    inc = [r[key] for r in recs if not r["correct"] and pred(r["d"]) and r[key] is not None]
    cor = [r[key] for r in recs if r["correct"] and pred(r["d"]) and r[key] is not None]
    a = rank_auc(inc, cor)
    return a, len(inc) + len(cor)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain_file", required=True, type=Path)
    ap.add_argument("--instances", required=True, type=Path)
    ap.add_argument("--policy_model", required=True, type=Path)
    ap.add_argument("--iqn_models", nargs="+", required=True, type=Path)
    ap.add_argument("--policy_readout", default="policy")
    ap.add_argument("--k", default=4, type=int)
    ap.add_argument("--max_instances", default=50, type=int)
    ap.add_argument("--states_per_instance", default=40, type=int)
    ap.add_argument("--max_states", default=200_000, type=int)
    ap.add_argument("--timeout", default=10.0, type=float)
    ap.add_argument("--seed", default=0, type=int)
    ap.add_argument("--limit", default=None, type=int)
    ap.add_argument("--out", required=True, type=Path)
    args = ap.parse_args()

    rng = random.Random(args.seed)
    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.domain_file))
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy = ModelWrapper(pol_raw, args.policy_readout)
    models = []
    for p in args.iqn_models:
        m, _, _ = _load_iqn_model(domain, p, device)
        m.eval()
        models.append(m)
    print(f"{len(models)} IQN models: {[p.name for p in args.iqn_models]}", flush=True)

    cands = sorted(p for p in args.instances.glob("*.pddl") if "domain" not in p.name)
    rng.shuffle(cands)
    if args.limit:
        cands = cands[:args.limit]
    canon = lambda x: str(x).lower().replace(" ", "").replace("(", "").replace(")", "")

    recs, nodes = [], []
    used = skipped = 0
    with torch.no_grad():
        for f in cands:
            if used >= args.max_instances:
                break
            sc = screen(args.domain_file, f, args.max_states, args.timeout)
            if sc is None or sc[1] < 1:
                skipped += 1
                continue
            problem = mm.Problem(domain, str(f))
            goal = problem.get_goal_condition()
            ss = mm.StateSpaceSampler.new(problem, args.max_states)
            if ss is None:
                skipped += 1
                continue
            ss.set_seed(args.seed)
            for s in sample_states(ss, ss.max_steps_to_goal(), args.states_per_instance, rng):
                lab = ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end:
                    continue
                d = lab.steps_to_goal
                actions = s.generate_applicable_actions()
                if len(actions) < 2:
                    continue
                act_correct = {}
                for a in actions:
                    l2 = ss.get_state_label(a.apply(s))
                    act_correct[canon(a)] = (not l2.is_dead_end) and l2.steps_to_goal < d
                if not any(act_correct.values()):
                    continue
                per_action = {}
                for a in actions:
                    win, cro, _o = cross_errors(models, s, a, goal, taus, args.k)
                    if win is None:
                        continue
                    per_action[canon(a)] = (win, cro)
                    recs.append({"within": win, "cross": cro,
                                 "correct": bool(act_correct[canon(a)]), "d": d})
                # node level: the policy's argmax action
                logits, pol_actions = policy.forward([(s, goal)])[0]
                pol_a = canon(pol_actions[int(torch.argmax(logits))])
                if pol_a in per_action:
                    w, c = per_action[pol_a]
                    nodes.append({"within": w, "cross": c,
                                  "correct": bool(act_correct.get(pol_a, False)), "d": d})
            used += 1
            if used % 10 == 0:
                print(f"  {used}/{args.max_instances} inst ({len(recs)} trans)", flush=True)

    print(f"\nused {used}, skipped {skipped}. {len(recs)} transitions, {len(nodes)} nodes\n")

    def report(tag, data):
        print(f"=== {tag} ===")
        for key in ("within", "cross"):
            inc = [r[key] for r in data if not r["correct"] and r[key] is not None]
            cor = [r[key] for r in data if r["correct"] and r[key] is not None]
            a = rank_auc(inc, cor)
            mi = statistics.median(inc) if inc else float('nan')
            mc = statistics.median(cor) if cor else float('nan')
            print(f"  {key:<7} overall AUC {a if a is None else round(a,3)}  "
                  f"(median err: incorrect {mi:.3f}, correct {mc:.3f})")
        print(f"  {'':7} {'d<=k(<=' + str(args.k) + ')':>12} {'d in k+1..10':>14} {'d>=11':>10}")
        for key in ("within", "cross"):
            cells = []
            for pred in (lambda d: d <= args.k, lambda d: args.k < d <= 10, lambda d: d >= 11):
                a, n = slice_auc(data, key, pred)
                cells.append(f"{a:.3f}(n{n})" if a is not None else "  -   ")
            print(f"  {key:<7} {cells[0]:>12} {cells[1]:>14} {cells[2]:>10}")
        print()

    report("TRANSITION (all actions)", recs)
    report("NODE (policy argmax only)", nodes)

    args.out.parent.mkdir(exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump({"domain_file": str(args.domain_file), "k": args.k,
                   "n_models": len(models), "instances_used": used,
                   "transitions": recs, "nodes": nodes}, fh)
    print(f"-> {args.out}")


if __name__ == "__main__":
    import multiprocessing as mp
    mp.set_start_method("spawn", force=True)
    main()
