"""
Offline Bellman-consistency check, SUPERVISOR'S SECOND APPROACH (July 2026).

    "There might be several paths that are equally good according to the policy,
     and argmax is mostly a tiebreaking mechanism. I expect the policy to be more
     or less optimal for small instances. Try to fully expand the state space and
     label each transition as correct if it decreases the distance, otherwise
     incorrect. The issue with this approach is that we're limited to small
     instances that can be fully expanded."

Implementation: mm.StateSpaceSampler.new(problem, cap) fully expands the state
space and gives an exact label per state (steps_to_goal / is_dead_end / is_goal).
A transition (s,a) is then

    CORRECT   iff  s'=T(s,a) is not a dead end  and  steps_to_goal(s') < steps_to_goal(s)
    INCORRECT otherwise

This is the same criterion as bellman_epsilon_label.py (with unit costs,
"decreases the distance" == "is an optimal action"), but it fixes the thing that
approach 1 could not: the STATE DISTRIBUTION. Instead of walking one optimal plan
(~50 states) or one policy rollout, we sample states uniformly across every
goal-distance in the fully expanded space. That matters because, exactly as he
says, the policy is near-optimal on small instances, so policy/plan trajectories
yield almost no mistake nodes (Grid: 25) and the node-level AUC is unusable.

Signal per transition: the k-step Bellman inconsistency of action a (identical
definition to grid_bellman_multistep.py / alphaZero_bellman.py).

Reported:
  TRANSITION AUC : does err separate INCORRECT from CORRECT actions?
  NODE AUC       : take the policy's argmax; a state is a "mistake" iff that
                   action is incorrect. Does err at the chosen action separate
                   mistake states from correct ones? (what the search uses)
  ...also sliced by goal-distance, to see whether the signal only works near the goal.

AUC = P(err at INCORRECT > err at CORRECT).  0.5 = no signal, <0.5 = INVERTED.

Limited to instances whose state space expands within --max_states / --timeout.

Usage:
  venv/bin/python bellman_statespace_label.py \
      --domain_file "$D/Domains2/grid/domain.pddl" \
      --instances   "$D/Domains2/grid/instances" \
      --policy_model models/grid_sac_policy.pth --iqn_model models/grid_iqn.pth \
      --max_instances 60 --states_per_instance 40 --out results/ss_grid.json
"""
import argparse
import json
import multiprocessing as mp
import random
import statistics
from pathlib import Path

import torch
import pymimir as mm
import pymimir_rgnn as rgnn

from utils import create_device
from train_iqn import _load_model as _load_iqn_model
from bellman_epsilon_label import ModelWrapper, iqn_curves, bellman_err, rank_auc


def _probe(domain_file, prob_file, cap, q):
    import pymimir as _mm
    d = _mm.Domain(domain_file)
    p = _mm.Problem(d, prob_file)
    ss = _mm.StateSpaceSampler.new(p, cap)
    q.put(None if ss is None else (ss.num_states(), ss.max_steps_to_goal()))


def screen(domain_file, prob_file, cap, timeout):
    """(num_states, max_steps_to_goal) or None if too big / too slow."""
    q = mp.Queue()
    pr = mp.Process(target=_probe, args=(str(domain_file), str(prob_file), cap, q))
    pr.start()
    pr.join(timeout)
    if pr.is_alive():
        pr.terminate()
        pr.join()
        return None
    return q.get() if not q.empty() else None


def sample_states(ss, maxd, want, rng):
    """Uniformly across goal-distances 1..maxd (skip goals and dead ends)."""
    if maxd < 1:
        return []
    per = max(1, want // maxd)
    out = []
    for d in range(1, maxd + 1):
        try:
            got = list(ss.sample_states_n_steps_from_goal(d, per))
        except Exception:
            continue
        out.extend(got)
    rng.shuffle(out)
    return out[:want]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain_file", required=True, type=Path)
    ap.add_argument("--instances", required=True, type=Path)
    ap.add_argument("--policy_model", required=True, type=Path)
    ap.add_argument("--iqn_model", required=True, type=Path)
    ap.add_argument("--policy_readout", default="policy")
    ap.add_argument("--k", default=4, type=int)
    ap.add_argument("--max_instances", default=60, type=int)
    ap.add_argument("--states_per_instance", default=40, type=int)
    ap.add_argument("--max_states", default=200_000, type=int, help="state-space cap")
    ap.add_argument("--timeout", default=10.0, type=float, help="expansion screen (s)")
    ap.add_argument("--seed", default=0, type=int)
    ap.add_argument("--out", required=True, type=Path)
    args = ap.parse_args()

    rng = random.Random(args.seed)
    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain(str(args.domain_file))
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    policy = ModelWrapper(pol_raw, args.policy_readout)
    iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
    iqn.eval()

    cands = sorted(p for p in args.instances.glob("*.pddl") if "domain" not in p.name)
    rng.shuffle(cands)
    print(f"{len(cands)} candidates; expanding state spaces "
          f"(cap {args.max_states}, timeout {args.timeout}s)", flush=True)

    trans, nodes = [], []
    used = skipped = 0
    canon = lambda x: str(x).lower().replace(" ", "").replace("(", "").replace(")", "")

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
            maxd = ss.max_steps_to_goal()

            for s in sample_states(ss, maxd, args.states_per_instance, rng):
                lab = ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end:
                    continue
                d = lab.steps_to_goal
                actions = s.generate_applicable_actions()
                if len(actions) < 2:
                    continue

                labels = []
                for a in actions:
                    l2 = ss.get_state_label(a.apply(s))
                    labels.append((not l2.is_dead_end) and l2.steps_to_goal < d)
                if not any(labels):
                    continue          # no optimal action reachable: nothing to rank

                qs, iqn_actions = iqn_curves(iqn, s, goal, taus)
                if qs is None:
                    continue
                amap = {canon(a): i for i, a in enumerate(iqn_actions)}

                errs = {}
                for i, a in enumerate(actions):
                    ai = amap.get(canon(a))
                    if ai is None:
                        continue
                    e = bellman_err(qs[ai], a.apply(s), goal, iqn, taus, args.k)
                    if e is None:
                        continue
                    errs[i] = e
                    trans.append({"err": e, "correct": bool(labels[i]), "d": d})

                logits, pol_actions = policy.forward([(s, goal)])[0]
                pol_a = pol_actions[int(torch.argmax(logits))]
                pj = next((i for i, a in enumerate(actions) if canon(a) == canon(pol_a)), None)
                if pj is not None and pj in errs:
                    nodes.append({"err": errs[pj], "policy_correct": bool(labels[pj]), "d": d})

            used += 1
            if used % 10 == 0:
                print(f"  {used}/{args.max_instances} instances "
                      f"({len(trans)} transitions, {len(nodes)} nodes)", flush=True)

    print(f"\nused {used} instances, skipped {skipped} (too big / too slow)\n")

    inc = [t["err"] for t in trans if not t["correct"]]
    cor = [t["err"] for t in trans if t["correct"]]
    mist = [n["err"] for n in nodes if not n["policy_correct"]]
    good = [n["err"] for n in nodes if n["policy_correct"]]

    auc_t, auc_n = rank_auc(inc, cor), rank_auc(mist, good)
    print(f"TRANSITIONS {len(trans):>6}  ({100*len(inc)/max(1,len(trans)):.0f}% incorrect)")
    print(f"  median err: incorrect {statistics.median(inc) if inc else None:.4f}  "
          f"correct {statistics.median(cor) if cor else None:.4f}")
    print(f"  TRANSITION AUC = {auc_t if auc_t is None else round(auc_t,3)}")
    print(f"\nNODES       {len(nodes):>6}  (policy wrong at "
          f"{100*len(mist)/max(1,len(nodes)):.0f}%; {len(mist)} mistake / {len(good)} correct)")
    print(f"  NODE AUC       = {auc_n if auc_n is None else round(auc_n,3)}")

    print("\nsliced by goal-distance (transition AUC):")
    bins = [(1, 2), (3, 5), (6, 10), (11, 10**6)]
    for lo, hi in bins:
        i = [t["err"] for t in trans if not t["correct"] and lo <= t["d"] <= hi]
        c = [t["err"] for t in trans if t["correct"] and lo <= t["d"] <= hi]
        a = rank_auc(i, c)
        if a is not None:
            print(f"  d in [{lo},{hi if hi < 10**6 else 'inf'}]: n={len(i)+len(c):>5}  AUC={a:.3f}")

    args.out.parent.mkdir(exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump({"domain_file": str(args.domain_file), "k": args.k,
                   "instances_used": used, "skipped": skipped,
                   "auc_transition": auc_t, "auc_node": auc_n,
                   "n_trans": len(trans), "n_incorrect": len(inc),
                   "n_nodes": len(nodes), "n_mistake": len(mist),
                   "med_err_incorrect": statistics.median(inc) if inc else None,
                   "med_err_correct": statistics.median(cor) if cor else None,
                   "records": trans}, fh)
    print(f"\n-> {args.out}")


if __name__ == "__main__":
    mp.set_start_method("spawn", force=True)
    main()
