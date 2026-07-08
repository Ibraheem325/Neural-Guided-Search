"""
Bellman-consistency diagnostic on the 22 hard Grid instances (supervisor's
direction): stop asking the model how sure it is; check whether it OBEYS its
own Bellman equation against the TRUE deterministic transition.

At every node s on the optimal plan, for the CHOSEN action a = policy argmax:

    err(s,a) = min_{b in B_good} W1( Z(s,a),  r + gamma * Z(s', b) )

with s' = a.apply(s) the real successor, r = -1 (ConstantRewardFunction(-1)),
gamma = 0.999 (train_iqn defaults), Z = sorted 99-quantile curve, and

    B_good = { b : score(Z(s',b)) >= best_score - epsilon },  score = mean.

Values are negative discounted returns, so "best" = argmax of mean —
identical to the training target in pymimir_rl.IQNOptimization:
    target = reward + gamma * (1 - is_terminal) * Z(s', argmax_b mean)
If s' satisfies the goal the target is the constant r (terminal, no
bootstrap). Dead-end successors (no applicable actions) are counted and
skipped (training used a -1000 constant there; any W1 against it is
meaningless for discrimination).

Decisive question: is err systematically LARGER at mistake nodes (policy
argmax != plan action) than at correct nodes?  Reported per epsilon:
mean/median at mistake vs correct nodes + rank AUC (P(err_mistake >
err_correct); 0.5 = chance, i.e. no discrimination).

Secondary (both directions, mirrors the ensemble-vote analysis):
- mistake nodes: err(chosen wrong action) vs err(plan action) — a usable
  "distrust the inconsistent action" signal needs wrong > plan here;
- correct nodes: err(chosen correct action) vs err(2nd-prior competitor) —
  and needs chosen < competitor here (else it misfires like W1/width did).

Usage:
  venv/bin/python grid_bellman_consistency.py                      # single IQN
  venv/bin/python grid_bellman_consistency.py --models models/grid_iqn_ens_1_best.pth ...
  venv/bin/python grid_bellman_consistency.py --verbose_nodes 5    # hand-check
"""
import argparse
import json
import statistics
import torch
from pathlib import Path
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
from utils import create_device
from train_iqn import _load_model as _load_iqn_model

GAMMA = 0.999
REWARD = -1.0


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
    """Sorted quantile curves for all applicable actions: ([A,99], actions)."""
    q, actions = iqn.forward([(state, goal)], taus=taus)[0]
    if q.shape[0] == 0:
        return None, []
    qs, _ = torch.sort(q, dim=1)
    return qs, actions


def bellman_error(z_sa, succ_state, goal, iqn, taus, epsilons):
    """err(s,a) per epsilon. Returns (dict eps->err, kind) where kind is
    'terminal' | 'deadend' | 'normal'."""
    if goal.holds(succ_state):
        target = torch.full_like(z_sa, REWARD)
        err = (z_sa - target).abs().mean().item()
        return {e: err for e in epsilons}, "terminal"
    qs, actions = iqn_curves(iqn, succ_state, goal, taus)
    if qs is None:
        return None, "deadend"
    scores = qs.mean(dim=1)                        # [B]
    best = scores.max()
    targets = REWARD + GAMMA * qs                  # [B,99] still sorted
    w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)   # [B]
    out = {}
    for e in epsilons:
        mask = scores >= best - e
        out[e] = w1[mask].min().item()
    return out, "normal"


def rank_auc(pos, neg):
    """P(random pos > random neg) via rank sum; ties get 0.5."""
    if not pos or not neg:
        return float("nan")
    combined = sorted([(v, 1) for v in pos] + [(v, 0) for v in neg])
    rank_sum, i = 0.0, 0
    while i < len(combined):
        j = i
        while j < len(combined) and combined[j][0] == combined[i][0]:
            j += 1
        avg_rank = (i + j + 1) / 2.0               # 1-based average rank of tie block
        rank_sum += avg_rank * sum(1 for k in range(i, j) if combined[k][1] == 1)
        i = j
    n_pos, n_neg = len(pos), len(neg)
    return (rank_sum - n_pos * (n_pos + 1) / 2.0) / (n_pos * n_neg)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--models", nargs="+", type=Path,
                    default=[Path("models/grid_iqn.pth")])
    ap.add_argument("--epsilons", nargs="+", type=float,
                    default=[0.0, 0.1, 0.5, 1.0])
    ap.add_argument("--verbose_nodes", type=int, default=0,
                    help="Print per-node hand-check detail for the first N nodes")
    ap.add_argument("--out", type=Path, default=Path("results/grid_bellman_consistency.json"))
    args = ap.parse_args()
    epsilons = args.epsilons

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain("example/grid_dataset/domain.pddl")
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(
        domain, Path("models/grid_sac_policy.pth"), device)
    policy = ModelWrapper(pol_raw, "policy")

    models = []
    for p in args.models:
        m, _, _ = _load_iqn_model(domain, p, device)
        m.eval()
        models.append(m)
    print(f"Loaded {len(models)} IQN model(s): {[p.name for p in args.models]}")
    print(f"gamma={GAMMA} reward={REWARD} epsilons={epsilons}\n")

    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    hard = sorted([k for k in ref
                   if ref[k].get("baseline", {}).get("solved")
                   and (ref[k]["baseline"].get("expanded") or 0) >= 300],
                  key=lambda k: -ref[k]["baseline"]["expanded"])

    # per-node records: {"inst","step","mistake","err":{eps:...},"err_plan":{eps:...}|None}
    records = []
    deadends = terminals = 0
    verbose_left = args.verbose_nodes

    print(f"{'instance':<36} {'nodes':>5} {'mist':>4} "
          + " ".join(f"{'m/c@'+str(e):>12}" for e in epsilons))
    print("-" * (48 + 13 * len(epsilons)))

    with torch.no_grad():
        for inst in hard:
            pddl = Path(f"example/grid_dataset/val/{inst}.pddl")
            planf = Path(f"example/grid_dataset/val/{inst}.pddl.plan")
            plan_lines = [l.strip() for l in planf.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]

            problem = mm.Problem(domain, str(pddl))
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()
            inst_recs = []

            for step_idx, plan_str in enumerate(plan_lines):
                logits, actions = policy.forward([(state, goal)])[0]
                if not actions:
                    break
                probs = torch.softmax(logits, dim=0).tolist()
                pairs = sorted(zip(probs, actions), key=lambda x: -x[0])
                dom_a = pairs[0][1]

                target_str = canon(plan_str)
                plan_a = None
                for _, a in pairs:
                    if canon(str(a)) == target_str:
                        plan_a = a
                        break
                if plan_a is None:
                    act_name = plan_str.strip("()").split()[0]
                    for _, a in pairs:
                        if act_name in str(a).lower():
                            plan_a = a
                            break
                if plan_a is None:
                    plan_a = dom_a
                is_mistake = plan_a != dom_a

                # accumulate over models (mean across models per node)
                errs = {e: [] for e in epsilons}
                errs_plan = {e: [] for e in epsilons}
                errs_alt = {e: [] for e in epsilons}   # correct-node competitor
                alt_a = pairs[1][1] if (not is_mistake and len(pairs) > 1) else None
                node_kind = None
                for iqn in models:
                    qs, iqn_actions = iqn_curves(iqn, state, goal, taus)
                    if qs is None:
                        break
                    amap = {canon(str(a)): i for i, a in enumerate(iqn_actions)}
                    dom_i = amap.get(canon(str(dom_a)))
                    if dom_i is None:
                        break
                    z_dom = qs[dom_i]
                    e_dom, kind = bellman_error(z_dom, dom_a.apply(state), goal,
                                                iqn, taus, epsilons)
                    node_kind = kind
                    if e_dom is None:
                        continue
                    for e in epsilons:
                        errs[e].append(e_dom[e])
                    if is_mistake:
                        plan_i = amap.get(canon(str(plan_a)))
                        if plan_i is not None:
                            e_pl, _ = bellman_error(qs[plan_i], plan_a.apply(state),
                                                    goal, iqn, taus, epsilons)
                            if e_pl is not None:
                                for e in epsilons:
                                    errs_plan[e].append(e_pl[e])
                    elif alt_a is not None:
                        alt_i = amap.get(canon(str(alt_a)))
                        if alt_i is not None:
                            e_alt, _ = bellman_error(qs[alt_i], alt_a.apply(state),
                                                     goal, iqn, taus, epsilons)
                            if e_alt is not None:
                                for e in epsilons:
                                    errs_alt[e].append(e_alt[e])

                    if verbose_left > 0:
                        succ = dom_a.apply(state)
                        v_sa = z_dom.mean().item()
                        if goal.holds(succ):
                            print(f"[hand-check] {inst} step {step_idx} "
                                  f"mistake={is_mistake} V(s,a)={v_sa:.3f} "
                                  f"successor is GOAL -> target const {REWARD}")
                        else:
                            sq, _ = iqn_curves(iqn, succ, goal, taus)
                            sbest = sq.mean(dim=1).max().item()
                            print(f"[hand-check] {inst} step {step_idx} "
                                  f"mistake={is_mistake} V(s,a)={v_sa:.3f} "
                                  f"bestV(s')={sbest:.3f} "
                                  f"scalar target={REWARD + GAMMA * sbest:.3f} "
                                  f"W1err={ {e: round(v, 3) for e, v in e_dom.items()} }")
                        verbose_left -= 1

                if node_kind == "deadend":
                    deadends += 1
                elif errs[epsilons[0]]:
                    if node_kind == "terminal":
                        terminals += 1
                    rec = {
                        "inst": inst, "step": step_idx, "mistake": is_mistake,
                        "err": {str(e): statistics.mean(errs[e]) for e in epsilons},
                        "err_plan": ({str(e): statistics.mean(errs_plan[e]) for e in epsilons}
                                     if is_mistake and errs_plan[epsilons[0]] else None),
                        "err_alt": ({str(e): statistics.mean(errs_alt[e]) for e in epsilons}
                                    if not is_mistake and errs_alt[epsilons[0]] else None),
                    }
                    records.append(rec)
                    inst_recs.append(rec)

                state = plan_a.apply(state)

            m_recs = [r for r in inst_recs if r["mistake"]]
            c_recs = [r for r in inst_recs if not r["mistake"]]
            cells = []
            for e in epsilons:
                me = (statistics.mean(r["err"][str(e)] for r in m_recs)
                      if m_recs else float("nan"))
                ce = (statistics.mean(r["err"][str(e)] for r in c_recs)
                      if c_recs else float("nan"))
                cells.append(f"{me:5.2f}/{ce:5.2f}")
            print(f"{inst:<36} {len(inst_recs):>5} {len(m_recs):>4} "
                  + " ".join(f"{c:>12}" for c in cells))

    print("-" * (48 + 13 * len(epsilons)))
    mist = [r for r in records if r["mistake"]]
    corr = [r for r in records if not r["mistake"]]
    print(f"\nTOTAL: {len(records)} plan nodes ({len(mist)} mistake, {len(corr)} correct) "
          f"across {len(hard)} instances; {terminals} terminal successors, "
          f"{deadends} dead-end successors skipped.\n")

    print(f"{'eps':>6} {'mean_mist':>10} {'mean_corr':>10} {'med_mist':>9} "
          f"{'med_corr':>9} {'AUC':>6}")
    for e in epsilons:
        pm = [r["err"][str(e)] for r in mist]
        pc = [r["err"][str(e)] for r in corr]
        auc = rank_auc(pm, pc)
        print(f"{e:>6} {statistics.mean(pm):>10.3f} {statistics.mean(pc):>10.3f} "
              f"{statistics.median(pm):>9.3f} {statistics.median(pc):>9.3f} "
              f"{auc:>6.3f}")
    print("\nAUC = P(err at a random mistake node > err at a random correct node)."
          "\n0.5 = no discrimination; the signal needs clearly > 0.5 to be useful.")

    both = [r for r in mist if r["err_plan"]]
    if both:
        print(f"\nSECONDARY A — mistake nodes ({len(both)}): err(chosen wrong action) "
              f"vs err(plan action):")
        for e in epsilons:
            ew = [r["err"][str(e)] for r in both]
            ep = [r["err_plan"][str(e)] for r in both]
            wins = sum(1 for a, b in zip(ew, ep) if a > b)
            print(f"  eps={e}: mean wrong={statistics.mean(ew):.3f} "
                  f"plan={statistics.mean(ep):.3f}; "
                  f"wrong-action error is larger at {wins}/{len(both)} "
                  f"({100 * wins / len(both):.0f}%) nodes")

    ctrl = [r for r in corr if r.get("err_alt")]
    if ctrl:
        print(f"\nSECONDARY B — correct-node CONTROL ({len(ctrl)}): err(chosen correct "
              f"action) vs err(2nd-prior competitor):")
        for e in epsilons:
            ec = [r["err"][str(e)] for r in ctrl]
            ea = [r["err_alt"][str(e)] for r in ctrl]
            misfire = sum(1 for a, b in zip(ec, ea) if a > b)
            print(f"  eps={e}: mean chosen={statistics.mean(ec):.3f} "
                  f"competitor={statistics.mean(ea):.3f}; "
                  f"MISFIRE (chosen error larger) at {misfire}/{len(ctrl)} "
                  f"({100 * misfire / len(ctrl):.0f}%) nodes")
        print("Usable ranking signal needs: A high (wrong > plan at mistakes) AND "
              "B low (chosen < competitor at correct nodes).")

    args.out.parent.mkdir(exist_ok=True)
    with open(args.out, "w") as f:
        json.dump({"models": [str(p) for p in args.models],
                   "gamma": GAMMA, "reward": REWARD, "epsilons": epsilons,
                   "records": records}, f, indent=1)
    print(f"\nPer-node records written to {args.out}")


if __name__ == "__main__":
    main()
