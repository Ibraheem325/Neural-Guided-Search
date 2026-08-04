"""Is the SAC policy prior actually bad on goldminer, or is search just misusing it?

Two measurements, because the obvious one has a confound.

(A) AGREEMENT with the reference plan, walking each instance's optimal plan:
      rank of the plan action under P, P(plan action), P_max, argmax==plan.
    CONFOUND: goldminer has symmetric moves, so several distinct actions can be
    equally optimal. The policy picking a different optimal action is scored "wrong"
    here. So a low top-1 here is an UPPER BOUND on badness, not proof of it.

(B) GREEDY ROLLOUT from the initial state, following argmax P with a closed set,
    up to 4x the optimal plan length. This has NO multi-optimal-plan confound: either
    the policy reaches the goal on its own or it does not, and the length it takes is
    directly comparable to the optimal length. This is the honest measure.

Usage: venv/bin/python policy_quality_gold.py [domain_key ...]     (default: both)
"""
import sys, glob, os, statistics as st, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device, get_state_key

SETS = {"goldminer": ("example/probeGold_near_goal_d5-20", "models/goldminer_sac_policy.pth"),
        "grid":      ("example/probe_near_goal_d5-20",     "models/grid_sac_policy.pth")}
KEYS = sys.argv[1:] or list(SETS)
dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")

for key in KEYS:
    PROBE, POL = SETS[key]
    dom = mm.Domain(PROBE + "/domain.pddl")
    pol, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(POL), dev)

    @torch.no_grad()
    def probs(state, goal):
        acts = state.generate_applicable_actions()
        if len(acts) == 0:
            return None, None
        lg = pol.forward([(state, list(acts), goal)]).readout("policy")[0]
        return torch.softmax(lg, dim=0), acts

    ranks, pstar, pmaxs, ks, top1 = [], [], [], [], []
    confwrong = 0
    solved, lens, opt_lens, dead = 0, [], [], 0
    files = sorted(f for f in glob.glob(PROBE + "/*.pddl") if "domain" not in os.path.basename(f))
    for pf in files:
        if not os.path.exists(pf + ".plan"):
            continue
        prob = mm.Problem(dom, pf)
        goal = prob.get_goal_condition()
        plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
        if not plan:
            continue
        opt_lens.append(len(plan))

        # (A) agreement along the reference plan
        s = prob.get_initial_state()
        for line in plan:
            p, acts = probs(s, goal)
            if p is None:
                break
            i = next((j for j, a in enumerate(acts) if canon(a) == canon(line)), None)
            if i is None:
                break
            if len(acts) > 1:
                order = sorted(range(len(acts)), key=lambda j: -p[j].item())
                ranks.append(order.index(i) + 1)
                pstar.append(p[i].item())
                pmaxs.append(p.max().item())
                ks.append(len(acts))
                hit = int(order[0] == i)
                top1.append(hit)
                if not hit and p.max().item() >= 0.9:
                    confwrong += 1
            s = acts[i].apply(s)

        # (B) greedy rollout, closed set, budget 4x optimal
        s = prob.get_initial_state()
        seen = {get_state_key(s)}
        ok = False
        for step in range(4 * len(plan)):
            if goal.holds(s):
                ok = True; break
            p, acts = probs(s, goal)
            if p is None:
                dead += 1; break
            order = sorted(range(len(acts)), key=lambda j: -p[j].item())
            nxt = None
            for j in order:                       # first unvisited successor
                c = acts[j].apply(s)
                if get_state_key(c) not in seen:
                    nxt = c; break
            if nxt is None:
                break
            seen.add(get_state_key(nxt)); s = nxt
        else:
            ok = goal.holds(s)
        if ok:
            solved += 1; lens.append(len(seen) - 1)

    n = len(files)
    print(f"\n================ {key.upper()}  ({n} instances, {len(ranks)} plan states) ================")
    print("(A) agreement with the reference plan   [multi-optimal-plan confound: upper bound on badness]")
    print(f"    top-1 = plan action        {100*st.mean(top1):>6.1f}%      "
          f"(uniform would give {100*st.mean([1/k for k in ks]):.1f}%)")
    print(f"    median rank of plan action {st.median(ranks):>6.1f}        of median {st.median(ks):.0f} applicable")
    print(f"    mean P(plan action)        {st.mean(pstar):>6.3f}        (uniform {st.mean([1/k for k in ks]):.3f})")
    print(f"    mean P_max                 {st.mean(pmaxs):>6.3f}")
    print(f"    CONFIDENTLY WRONG (P_max>=0.9 and top-1 != plan action): "
          f"{100*confwrong/len(ranks):.1f}% of states")
    print("(B) greedy rollout from the initial state   [no confound]")
    print(f"    reaches the goal           {solved}/{n} = {100*solved/n:.1f}%")
    if lens:
        rat = [l/o for l, o in zip(lens, opt_lens[:len(lens)])]
        print(f"    steps taken vs optimal     median ratio {st.median(rat):.2f}")
