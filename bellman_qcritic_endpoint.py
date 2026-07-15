"""
Q-CRITIC-ENDPOINT Bellman check (July 2026) -- the final independence test.

The cross-IQN check (bellman_ensemble_crosscheck.py) un-inverted the far-from-
goal regime (AUC 0.419 -> 0.507) but only reached chance, because the 6 IQNs
are seed-diverse and thus too correlated. This tries a MORE independent endpoint
model: the SAC Q-critic, trained on a different objective/architecture than the
IQN. Value scales match (both ~ -steps_to_go; verified corr 0.98).

Everything is held fixed except WHO reads the endpoint value:
  parent value  = mean of IQN's Z(s,a)                       (same in both)
  rollout        = IQN-greedy, k steps, shared                (same in both)
  err_within = | Vpar - (cost + gamma^k * max_b V_IQN(s_k,b)) |   <- self (broken)
  err_qend   = | Vpar - (cost + gamma^k * max_b V_Q  (s_k,b)) |   <- independent endpoint
where V_Q(s,b) = min(q1,q2)(s,b) (the AlphaZero leaf critic).

Scalar residuals (not W1) because the Q-critic is scalar; the parent is reduced
to its mean so within/qend are compared apples-to-apples. If the rollout reaches
the goal the target is grounded (constant cost), so within==qend there.

Labels + states + AUC + distance slicing: same ground-truth machinery as
bellman_statespace_label.py. Decisive question: does the independent endpoint
lift the FAR-FROM-GOAL AUC past chance where cross-IQN could not?

Usage:
  venv/bin/python bellman_qcritic_endpoint.py \
    --domain_file "$D/Domains2/grid/domain.pddl" --instances "$D/Domains2/grid/instances" \
    --policy_model models/grid_sac_policy.pth --iqn_model models/grid_iqn.pth \
    --q1_model models/grid_sac_q1.pth --q2_model models/grid_sac_q2.pth \
    --max_instances 60 --states_per_instance 45 --out results/qend_grid.json
"""
import argparse
import json
import random
import statistics
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


def q_values(q1, q2, state, goal):
    """min(q1,q2) per applicable action: (tensor[A], actions)."""
    v1, acts = q1.forward([(state, goal)])[0]
    v2, _ = q2.forward([(state, goal)])[0]
    return torch.minimum(v1, v2), acts


VARIANTS = ("within", "qend", "dqn", "cons")   # cons = mean(Q-critic, DQN)


def _endpoint_errs(v_par, acc, disc, cur, goal, iqn_scores, cq, q1, q2, dqn):
    """Bellman residual |v_par - (acc + disc*V_end)| for each endpoint model."""
    v_iqn = iqn_scores.max().item()
    qv, _ = q_values(q1, q2, cur, goal)
    q_per = qv                                   # [A] min(q1,q2) per action
    v_q = q_per.max().item()
    out = {"within": abs(v_par - (acc + disc * v_iqn)),
           "qend":   abs(v_par - (acc + disc * v_q))}
    if dqn is not None:
        dv, _ = dqn.forward([(cur, goal)])[0]    # [A]
        v_d = dv.max().item()
        cons_per = 0.5 * (q_per + dv)            # consensus per action, then greedy
        v_c = cons_per.max().item()
        out["dqn"] = abs(v_par - (acc + disc * v_d))
        out["cons"] = abs(v_par - (acc + disc * v_c))
    return out


def errs_for_action(iqn, q1, q2, dqn, s, a, goal, taus, k):
    """(errs dict over VARIANTS, outcome). Shared IQN-greedy rollout; parent =
    mean IQN value of (s,a). Only the ENDPOINT model differs across variants."""
    qs, actions = iqn_curves(iqn, s, goal, taus)
    if qs is None:
        return None, "deadend"
    ai = next((i for i, x in enumerate(actions) if x == a), None)
    if ai is None:
        return None, "deadend"
    v_par = qs[ai].mean().item()

    cur = a.apply(s)
    visited = {get_state_key(cur)}
    acc, disc = 0.0, 1.0
    for step in range(1, k + 1):
        acc += disc * REWARD
        disc *= GAMMA
        if goal.holds(cur):
            e = abs(v_par - acc)                 # grounded: all variants equal
            return {v: e for v in VARIANTS}, "goal"
        cq, cact = iqn_curves(iqn, cur, goal, taus)
        if cq is None:
            return None, "deadend"
        iqn_scores = cq.mean(dim=1)
        if step == k:
            return _endpoint_errs(v_par, acc, disc, cur, goal, iqn_scores, cq, q1, q2, dqn), "alive"
        nxt = cact[int(iqn_scores.argmax())].apply(cur)
        key = get_state_key(nxt)
        if key in visited:
            return _endpoint_errs(v_par, acc, disc, cur, goal, iqn_scores, cq, q1, q2, dqn), "loop"
        visited.add(key)
        cur = nxt
    return None, "deadend"


def report(tag, data, k, keys):
    print(f"=== {tag} ===")
    for key in keys:
        inc = [r[key] for r in data if not r["correct"] and r.get(key) is not None]
        cor = [r[key] for r in data if r["correct"] and r.get(key) is not None]
        a = rank_auc(inc, cor)
        print(f"  {key:<7} overall AUC {a if a is None else round(a,3)}")
    print(f"  {'':7} {'d<=' + str(k):>13} {'d..10':>13} {'d>=11':>13}   (endpoint model)")
    labels = {"within": "IQN (self)", "qend": "Q-critic", "dqn": "DQN",
              "cons": "Q+DQN consensus"}
    for key in keys:
        cells = []
        for pred in (lambda d: d <= k, lambda d: k < d <= 10, lambda d: d >= 11):
            inc = [r[key] for r in data if not r["correct"] and pred(r["d"]) and r.get(key) is not None]
            cor = [r[key] for r in data if r["correct"] and pred(r["d"]) and r.get(key) is not None]
            a = rank_auc(inc, cor)
            cells.append(f"{a:.3f}(n{len(inc)+len(cor)})" if a is not None else "  -  ")
        print(f"  {key:<7} {cells[0]:>13} {cells[1]:>13} {cells[2]:>13}   {labels.get(key,'')}")
    print()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain_file", required=True, type=Path)
    ap.add_argument("--instances", required=True, type=Path)
    ap.add_argument("--policy_model", required=True, type=Path)
    ap.add_argument("--iqn_model", required=True, type=Path)
    ap.add_argument("--q1_model", required=True, type=Path)
    ap.add_argument("--q2_model", required=True, type=Path)
    ap.add_argument("--dqn_model", default=None, type=Path,
                    help="Optional DQN endpoint model; enables 'dqn' and 'cons' variants.")
    ap.add_argument("--k", default=4, type=int)
    ap.add_argument("--max_instances", default=60, type=int)
    ap.add_argument("--states_per_instance", default=45, type=int)
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
    policy = ModelWrapper(pol_raw, "policy")
    iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device); iqn.eval()
    q1r, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    q2r, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
    q1, q2 = ModelWrapper(q1r, "q"), ModelWrapper(q2r, "q")
    dqn = None
    if args.dqn_model is not None:
        dqnr, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.dqn_model, device)
        dqn = ModelWrapper(dqnr, "q")
    keys = list(VARIANTS) if dqn is not None else ["within", "qend"]

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
                corr = {}
                for a in actions:
                    l2 = ss.get_state_label(a.apply(s))
                    corr[canon(a)] = (not l2.is_dead_end) and l2.steps_to_goal < d
                if not any(corr.values()):
                    continue
                per = {}
                for a in actions:
                    errs, _o = errs_for_action(iqn, q1, q2, dqn, s, a, goal, taus, args.k)
                    if errs is None:
                        continue
                    per[canon(a)] = errs
                    recs.append({**errs, "correct": bool(corr[canon(a)]), "d": d})
                logits, pol_actions = policy.forward([(s, goal)])[0]
                pa = canon(pol_actions[int(torch.argmax(logits))])
                if pa in per:
                    nodes.append({**per[pa], "correct": bool(corr.get(pa, False)), "d": d})
            used += 1
            if used % 10 == 0:
                print(f"  {used}/{args.max_instances} inst ({len(recs)} trans)", flush=True)

    print(f"\nused {used}, skipped {skipped}. {len(recs)} transitions, {len(nodes)} nodes\n")
    report("TRANSITION (all actions)", recs, args.k, keys)
    report("NODE (policy argmax)", nodes, args.k, keys)

    args.out.parent.mkdir(exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump({"k": args.k, "instances_used": used,
                   "transitions": recs, "nodes": nodes}, fh)
    print(f"-> {args.out}")


if __name__ == "__main__":
    import multiprocessing as mp
    mp.set_start_method("spawn", force=True)
    main()
