"""
Offline Bellman-consistency check with SUPERVISOR'S EPSILON LABELS (July 2026).

Replaces the flawed `.pddl.plan` reference labeling. Old scheme: walk the optimal
plan and call a node a "mistake" iff policy-argmax != plan action. Two flaws he
raised: (1) when several actions are equally optimal, the non-plan ones were
wrongly labeled bad; (2) the policy never visits the plan's states anyway.

NEW LABEL (ground truth, no plan needed):
    Q*(s,a) = -(1 + h*(T(s,a)))                 # unit costs; h* = mm.PerfectHeuristic
    a is CORRECT   iff  Q*(s,a) >= max_b Q*(s,b) - eps
    a is INCORRECT otherwise
With unit costs the Q* gaps are integers, so eps=0.33 admits exactly the optimal
actions (all ties included) and nothing worse. Dead-end successors (h*=inf) are
always incorrect.

Because Q* is defined at EVERY state, we can evaluate on either distribution:
    --states policy : states the greedy policy actually visits  (his objection)
    --states plan   : states on the stored optimal plan         (old comparison)
    --states both

SIGNAL measured per transition: the k-step Bellman inconsistency of action a,
    err(s,a) = min_{b in B_good(s_k)} W1( Z(s,a), sum_i gamma^i r + gamma^k Z(s_k,b) )
where s_k is reached by rolling the IQN's OWN greedy story k steps from T(s,a)
(identical definition to grid_bellman_multistep.py / alphaZero_bellman.py).

Two AUCs are reported:
  TRANSITION-level: does err separate INCORRECT from CORRECT actions?
                    (can the signal rank actions by quality?)
  NODE-level      : take the policy's argmax a_pi; a state is a "mistake" iff
                    a_pi is incorrect. Does err(s,a_pi) separate mistake states
                    from correct states? (directly comparable to the old numbers,
                    and it is exactly what the search variant uses.)

AUC = P(err on a random INCORRECT > err on a random CORRECT); 0.5 = no signal.

NOTE mm.PerfectHeuristic builds the full state space: it is instant on small
instances and hangs on large ones. Instances are screened in a child process and
skipped on timeout, so only feasible ones are used.

Usage:
  venv/bin/python bellman_epsilon_label.py \
      --domain_file "$D/Domains2/grid/domain.pddl" \
      --instances   "$D/Domains2/grid/instances" \
      --policy_model models/grid_sac_policy.pth --iqn_model models/grid_iqn.pth \
      --states both --max_instances 40 --out results/eps_grid.json
"""
import argparse
import json
import math
import multiprocessing as mp
import random
import statistics
from pathlib import Path

import torch
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl

from utils import create_device, get_state_key
from train_iqn import _load_model as _load_iqn_model

GAMMA = 0.999
REWARD = -1.0
INF = float("inf")


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


# ---------------- feasibility screen (PerfectHeuristic can hang) ----------------

def _probe(domain_file, prob_file, q):
    import pymimir as _mm
    d = _mm.Domain(domain_file)
    p = _mm.Problem(d, prob_file)
    h = _mm.PerfectHeuristic(p)
    s = p.get_initial_state()
    q.put((float(h.compute_value(s, False)), len(s.generate_applicable_actions())))


def screen(domain_file, prob_file, timeout):
    """Returns (h*_init, n_actions) or None if PerfectHeuristic is too slow."""
    q = mp.Queue()
    pr = mp.Process(target=_probe, args=(str(domain_file), str(prob_file), q))
    pr.start()
    pr.join(timeout)
    if pr.is_alive():
        pr.terminate()
        pr.join()
        return None
    return q.get() if not q.empty() else None


# ---------------- the signal ----------------

def iqn_curves(iqn, state, goal, taus):
    q, actions = iqn.forward([(state, goal)], taus=taus)[0]
    if q.shape[0] == 0:
        return None, []
    qs, _ = torch.sort(q, dim=1)
    return qs, actions


def bellman_err(z_sa, first_succ, goal, iqn, taus, k):
    """k-step min-W1 inconsistency of the action whose curve is z_sa."""
    cur = first_succ
    visited = {get_state_key(cur)}
    acc, disc = 0.0, 1.0
    for m in range(1, k + 1):
        acc += disc * REWARD
        disc *= GAMMA
        if goal.holds(cur):
            return (z_sa - torch.full_like(z_sa, acc)).abs().mean().item()
        qs, actions = iqn_curves(iqn, cur, goal, taus)
        if qs is None:
            return None                       # dead end inside the rollout
        scores = qs.mean(dim=1)
        if m == k:
            targets = acc + disc * qs
            w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)
            return w1[scores >= scores.max()].min().item()
        nxt = actions[int(scores.argmax())].apply(cur)
        key = get_state_key(nxt)
        if key in visited:                    # looped: score against where we are
            targets = acc + disc * qs
            w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)
            return w1[scores >= scores.max()].min().item()
        visited.add(key)
        cur = nxt
    return None


def rank_auc(pos, neg):
    if not pos or not neg:
        return None
    comb = sorted([(v, 1) for v in pos] + [(v, 0) for v in neg])
    rs, i = 0.0, 0
    while i < len(comb):
        j = i
        while j < len(comb) and comb[j][0] == comb[i][0]:
            j += 1
        rs += (i + j + 1) / 2.0 * sum(1 for t in range(i, j) if comb[t][1] == 1)
        i = j
    return (rs - len(pos) * (len(pos) + 1) / 2.0) / (len(pos) * len(neg))


# ---------------- state distributions ----------------

def policy_states(policy, problem, goal, horizon):
    """States the greedy policy actually visits (the supervisor's objection)."""
    s = problem.get_initial_state()
    out, seen = [], set()
    for _ in range(horizon):
        if goal.holds(s):
            break
        key = get_state_key(s)
        if key in seen:
            break                              # policy looped
        seen.add(key)
        logits, actions = policy.forward([(s, goal)])[0]
        if not actions:
            break
        out.append(s)
        s = actions[int(torch.argmax(logits))].apply(s)
    return out


def plan_states(problem, goal, plan_file):
    lines = [l.strip() for l in plan_file.read_text().splitlines()
             if l.strip() and not l.startswith(";")]
    canon = lambda x: x.lower().replace(" ", "").replace("(", "").replace(")", "")
    s = problem.get_initial_state()
    out = []
    for line in lines:
        actions = s.generate_applicable_actions()
        if not actions:
            break
        out.append(s)
        tgt = canon(line)
        nxt = next((a for a in actions if canon(str(a)) == tgt), None)
        if nxt is None:
            name = line.strip("()").split()[0]
            nxt = next((a for a in actions if name in str(a).lower()), None)
        if nxt is None:
            break
        s = nxt.apply(s)
    return out


# ---------------- per-instance evaluation ----------------

def eval_states(states, h, goal, policy, iqn, taus, k, eps):
    """Returns list of transition records and list of node records."""
    trans, nodes = [], []
    for s in states:
        actions = s.generate_applicable_actions()
        if len(actions) < 2:
            continue
        # ground-truth Q* per action
        qstar = []
        for a in actions:
            hs = float(h.compute_value(a.apply(s), False))
            qstar.append(-INF if (math.isinf(hs) or hs > 1e6) else -(1.0 + hs))
        best = max(qstar)
        if best == -INF:
            continue                            # every successor is a dead end
        correct = [q >= best - eps for q in qstar]
        if all(correct):
            continue                            # no discrimination possible here

        qs, iqn_actions = iqn_curves(iqn, s, goal, taus)
        if qs is None:
            continue
        canon = lambda x: str(x).lower().replace(" ", "").replace("(", "").replace(")", "")
        amap = {canon(a): i for i, a in enumerate(iqn_actions)}

        errs = {}
        for i, a in enumerate(actions):
            ai = amap.get(canon(a))
            if ai is None:
                continue
            e = bellman_err(qs[ai], a.apply(s), goal, iqn, taus, k)
            if e is None:
                continue
            errs[i] = e
            trans.append({"err": e, "correct": bool(correct[i])})

        # node-level: the policy's chosen action
        logits, pol_actions = policy.forward([(s, goal)])[0]
        pi = int(torch.argmax(logits))
        pol_a = pol_actions[pi]
        pj = next((i for i, a in enumerate(actions) if canon(a) == canon(pol_a)), None)
        if pj is not None and pj in errs:
            nodes.append({"err": errs[pj], "policy_correct": bool(correct[pj])})
    return trans, nodes


def summarize(tag, trans, nodes):
    out = {"tag": tag}
    inc = [t["err"] for t in trans if not t["correct"]]
    cor = [t["err"] for t in trans if t["correct"]]
    out["n_trans"] = len(trans)
    out["frac_incorrect"] = (len(inc) / len(trans)) if trans else None
    out["auc_transition"] = rank_auc(inc, cor)
    out["med_err_incorrect"] = statistics.median(inc) if inc else None
    out["med_err_correct"] = statistics.median(cor) if cor else None

    mist = [n["err"] for n in nodes if not n["policy_correct"]]
    good = [n["err"] for n in nodes if n["policy_correct"]]
    out["n_nodes"] = len(nodes)
    out["policy_mistake_rate"] = (len(mist) / len(nodes)) if nodes else None
    out["auc_node"] = rank_auc(mist, good)
    out["n_mistake_nodes"], out["n_correct_nodes"] = len(mist), len(good)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain_file", required=True, type=Path)
    ap.add_argument("--instances", required=True, type=Path, help="directory of .pddl")
    ap.add_argument("--policy_model", required=True, type=Path)
    ap.add_argument("--iqn_model", required=True, type=Path)
    ap.add_argument("--policy_readout", default="policy")
    ap.add_argument("--k", default=4, type=int)
    ap.add_argument("--eps", default=0.33, type=float)
    ap.add_argument("--states", default="both", choices=["policy", "plan", "both"])
    ap.add_argument("--max_instances", default=40, type=int)
    ap.add_argument("--min_hstar", default=3.0, type=float, help="skip trivial instances")
    ap.add_argument("--timeout", default=8.0, type=float, help="PerfectHeuristic screen (s)")
    ap.add_argument("--seed", default=0, type=int)
    ap.add_argument("--out", required=True, type=Path)
    args = ap.parse_args()

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.domain_file))
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy = ModelWrapper(pol_raw, args.policy_readout)
    iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn.eval()

    cands = sorted(p for p in args.instances.glob("*.pddl") if "domain" not in p.name)
    random.Random(args.seed).shuffle(cands)
    print(f"{len(cands)} candidate instances; screening (timeout {args.timeout}s, "
          f"min h*={args.min_hstar})", flush=True)

    pol_tr, pol_nd, pl_tr, pl_nd = [], [], [], []
    used = skipped_slow = skipped_trivial = 0

    with torch.no_grad():
        for f in cands:
            if used >= args.max_instances:
                break
            sc = screen(args.domain_file, f, args.timeout)
            if sc is None:
                skipped_slow += 1
                continue
            h0, nact = sc
            if math.isinf(h0) or h0 < args.min_hstar or nact < 2:
                skipped_trivial += 1
                continue

            problem = mm.Problem(domain, str(f))
            goal = problem.get_goal_condition()
            h = mm.PerfectHeuristic(problem)

            if args.states in ("policy", "both"):
                st = policy_states(policy, problem, goal, horizon=int(min(3 * h0 + 10, 100)))
                t, n = eval_states(st, h, goal, policy, iqn, taus, args.k, args.eps)
                pol_tr += t
                pol_nd += n
            if args.states in ("plan", "both"):
                pf = f.with_suffix(f.suffix + ".plan")
                if pf.exists():
                    st = plan_states(problem, goal, pf)
                    t, n = eval_states(st, h, goal, policy, iqn, taus, args.k, args.eps)
                    pl_tr += t
                    pl_nd += n
            used += 1
            if used % 5 == 0:
                print(f"  {used}/{args.max_instances} instances "
                      f"(policy: {len(pol_tr)} transitions, plan: {len(pl_tr)})", flush=True)

    print(f"\nused {used}, skipped {skipped_slow} slow (PerfectHeuristic), "
          f"{skipped_trivial} trivial\n")

    res = {"domain_file": str(args.domain_file), "k": args.k, "eps": args.eps,
           "instances_used": used, "skipped_slow": skipped_slow,
           "skipped_trivial": skipped_trivial, "summaries": []}
    for tag, tr, nd in [("policy-visited states", pol_tr, pol_nd),
                        ("optimal-plan states", pl_tr, pl_nd)]:
        if tr or nd:
            s = summarize(tag, tr, nd)
            res["summaries"].append(s)
            print(f"--- {tag} ---")
            print(f"  transitions {s['n_trans']:>6}  ({100*(s['frac_incorrect'] or 0):.0f}% incorrect)"
                  f"   TRANSITION AUC = {s['auc_transition'] if s['auc_transition'] is None else round(s['auc_transition'],3)}")
            print(f"    median err: incorrect {s['med_err_incorrect']}, correct {s['med_err_correct']}")
            print(f"  nodes       {s['n_nodes']:>6}  (policy wrong at {100*(s['policy_mistake_rate'] or 0):.0f}%)"
                  f"   NODE AUC       = {s['auc_node'] if s['auc_node'] is None else round(s['auc_node'],3)}")
            print(f"    mistake nodes {s['n_mistake_nodes']}, correct nodes {s['n_correct_nodes']}\n")

    args.out.parent.mkdir(exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump(res, fh, indent=1)
    print(f"-> {args.out}")


if __name__ == "__main__":
    mp.set_start_method("spawn", force=True)
    main()
