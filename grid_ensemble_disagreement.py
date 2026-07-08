"""
Ensemble-disagreement diagnostic at the mistake nodes of the 22 hard Grid
instances (supervisor's test: "if all models are always confidently wrong at
the same time, there's little we can do; if not, ensemble variance is a
usable signal").

A MISTAKE node is a state on the optimal plan where the policy's argmax
action differs from the plan's action. At each such node, for every IQN
model m, we compute:

    V_m(dom_child)  = mean of best-action sorted quantile curve at the
                      successor of the policy's (wrong) dominant action
    V_m(plan_child) = same at the successor of the plan's (correct) action

Model m "dissents" at the node if V_m(plan_child) > V_m(dom_child), i.e.
its value estimate alone would prefer the correct action.

Per instance we report:
    mist        number of mistake nodes
    all_wrong   nodes where EVERY model prefers the wrong child
    dissent>=1  nodes where at least one model prefers the correct child
    dissent>=2  ... at least two models
    mean_k      average number of dissenting models per node (of N models)
    gapstd      mean over nodes of std across models of
                [V(plan_child) - V(dom_child)]  (ensemble disagreement size)

Usage:
  venv/bin/python grid_ensemble_disagreement.py \
      --models models/grid_iqn_ens_1_best.pth models/grid_iqn_ens_2_best.pth ... \
      [--include_original]
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


def state_value(iqn, state, goal, taus):
    """Mean of the best action's sorted quantile curve; None at dead ends."""
    q, _ = iqn.forward([(state, goal)], taus=taus)[0]
    if q.shape[0] == 0:
        return None
    qs, _ = torch.sort(q, dim=1)
    return qs.mean(dim=1).max().item()


def canon(s):
    return s.lower().replace(" ", "").replace("(", "").replace(")", "")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--models", nargs="+", required=True, type=Path)
    ap.add_argument("--include_original", action="store_true",
                    help="Also include models/grid_iqn.pth as a member")
    args = ap.parse_args()

    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain("example/grid_dataset/domain.pddl")
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(
        domain, Path("models/grid_sac_policy.pth"), device)
    policy = ModelWrapper(pol_raw, "policy")

    model_paths = list(args.models)
    if args.include_original:
        model_paths.append(Path("models/grid_iqn.pth"))
    models = []
    for p in model_paths:
        m, _, _ = _load_iqn_model(domain, p, device)
        m.eval()
        models.append(m)
    n_models = len(models)
    print(f"Loaded {n_models} IQN models: {[p.name for p in model_paths]}\n")

    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    hard = sorted([k for k in ref
                   if ref[k].get("baseline", {}).get("solved")
                   and (ref[k]["baseline"].get("expanded") or 0) >= 300],
                  key=lambda k: -ref[k]["baseline"]["expanded"])

    print(f"{'instance':<36} {'mist':>4} {'all_wrong':>9} {'dis>=1':>6} "
          f"{'dis>=2':>6} {'mean_k':>6} {'gapstd':>7}")
    print("-" * 82)

    tot_mist = tot_allwrong = tot_d1 = tot_d2 = 0
    all_ks, all_gapstds = [], []
    all_ctrl_ks, all_ctrl_gapstds = [], []
    k_hist = [0]*(len(models)+1)          # k = # models preferring CORRECT child
    per_model_wrong = [0]*len(models)     # each model prefers WRONG child
    per_model_total = [0]*len(models)

    with torch.no_grad():
        for inst in hard:
            pddl = Path(f"example/grid_dataset/val/{inst}.pddl")
            planf = Path(f"example/grid_dataset/val/{inst}.pddl.plan")
            plan_lines = [l.strip() for l in planf.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]

            problem = mm.Problem(domain, str(pddl))
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()

            mist = allwrong = d1 = d2 = 0
            ks, gapstds = [], []
            ctrl_ks, ctrl_gapstds = [], []
            step_idx = -1

            for plan_str in plan_lines:
                logits, actions = policy.forward([(state, goal)])[0]
                if not actions:
                    break
                probs = torch.softmax(logits, dim=0).tolist()
                pairs = sorted(zip(probs, actions), key=lambda x: -x[0])
                dom_a = pairs[0][1]

                target = canon(plan_str)
                plan_a = None
                for _, a in pairs:
                    if canon(str(a)) == target:
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

                step_idx += 1
                if plan_a == dom_a and len(pairs) > 1 and step_idx % 4 == 0:
                    # CONTROL: policy is correct here. Compare the correct
                    # (dominant=plan) child against the strongest competitor
                    # (2nd-highest prior). A model "dissents" if it values the
                    # competitor child above the correct child.
                    corr_succ = dom_a.apply(state)
                    alt_succ = pairs[1][1].apply(state)
                    gaps = []
                    k = 0
                    for m in models:
                        v_corr = state_value(m, corr_succ, goal, taus)
                        v_alt = state_value(m, alt_succ, goal, taus)
                        if v_corr is None or v_alt is None:
                            continue
                        gaps.append(v_alt - v_corr)
                        if v_alt > v_corr:
                            k += 1
                    if gaps:
                        ctrl_ks.append(k)
                        if len(gaps) > 1:
                            ctrl_gapstds.append(statistics.stdev(gaps))

                if plan_a != dom_a:
                    dom_succ = dom_a.apply(state)
                    plan_succ = plan_a.apply(state)
                    gaps = []
                    k = 0
                    for mi, m in enumerate(models):
                        v_dom = state_value(m, dom_succ, goal, taus)
                        v_plan = state_value(m, plan_succ, goal, taus)
                        if v_dom is None or v_plan is None:
                            continue
                        gaps.append(v_plan - v_dom)
                        per_model_total[mi] += 1
                        if v_plan > v_dom:
                            k += 1
                        else:
                            per_model_wrong[mi] += 1
                    if gaps:
                        mist += 1
                        k_hist[k] += 1
                        ks.append(k)
                        if len(gaps) > 1:
                            gapstds.append(statistics.stdev(gaps))
                        if k == 0:
                            allwrong += 1
                        if k >= 1:
                            d1 += 1
                        if k >= 2:
                            d2 += 1

                state = plan_a.apply(state)

            tot_mist += mist
            tot_allwrong += allwrong
            tot_d1 += d1
            tot_d2 += d2
            all_ks.extend(ks)
            all_gapstds.extend(gapstds)
            all_ctrl_ks.extend(ctrl_ks)
            all_ctrl_gapstds.extend(ctrl_gapstds)
            mk = f"{sum(ks)/len(ks):.1f}" if ks else "-"
            gs = f"{statistics.mean(gapstds):.3f}" if gapstds else "-"
            print(f"{inst:<36} {mist:>4} {allwrong:>9} {d1:>6} {d2:>6} "
                  f"{mk:>6} {gs:>7}")

    print("-" * 82)
    if tot_mist:
        print(f"\nTOTAL: {tot_mist} mistake nodes across {len(hard)} instances")
        print(f"  all {n_models} models prefer the wrong child : "
              f"{tot_allwrong} ({100*tot_allwrong/tot_mist:.0f}%)")
        print(f"  >=1 model prefers the correct child   : "
              f"{tot_d1} ({100*tot_d1/tot_mist:.0f}%)")
        print(f"  >=2 models prefer the correct child   : "
              f"{tot_d2} ({100*tot_d2/tot_mist:.0f}%)")
        print(f"  mean dissenting models per node       : "
              f"{sum(all_ks)/len(all_ks):.2f} / {n_models}")
        if all_gapstds:
            print(f"  mean ensemble std of value gap        : "
                  f"{statistics.mean(all_gapstds):.4f}")
    if all_ctrl_ks:
        n = len(all_ctrl_ks)
        print(f"\nCONTROL ({n} correct nodes, policy right; competitor = 2nd prior):")
        print(f"  mean models preferring the WRONG (competitor) child: "
              f"{sum(all_ctrl_ks)/n:.2f} / {n_models}")
        d1c = sum(1 for k in all_ctrl_ks if k >= 1)
        d2c = sum(1 for k in all_ctrl_ks if k >= 2)
        print(f"  >=1 model prefers competitor : {d1c} ({100*d1c/n:.0f}%)")
        print(f"  >=2 models prefer competitor : {d2c} ({100*d2c/n:.0f}%)")
        if all_ctrl_gapstds:
            print(f"  mean ensemble std of value gap: "
                  f"{statistics.mean(all_ctrl_gapstds):.4f}")
        print("Discrimination requires: dissent HIGH at mistakes, LOW here.")
    M = len(models)
    if sum(k_hist):
        n = sum(k_hist)
        print(f"\nDistribution of k (# of {M} models preferring the CORRECT child) "
              f"over {n} mistake nodes:")
        for k in range(M+1):
            print(f"  k={k}: {k_hist[k]:4d} ({100*k_hist[k]/n:4.0f}%)")
        maj_wrong = sum(k_hist[k] for k in range(M+1) if k < (M/2.0))
        maj_corr = sum(k_hist[k] for k in range(M+1) if k > (M/2.0))
        tie = n - maj_wrong - maj_corr
        print(f"\n  ENSEMBLE MAJORITY prefers WRONG child : {maj_wrong} ({100*maj_wrong/n:.0f}%)")
        print(f"  ENSEMBLE MAJORITY prefers CORRECT child: {maj_corr} ({100*maj_corr/n:.0f}%)")
        print(f"  tie (k=M/2)                            : {tie} ({100*tie/n:.0f}%)")
        print(f"\n  Per-model 'confidently wrong' rate (prefers wrong child) at mistake nodes:")
        for mi in range(M):
            tot = per_model_total[mi] or 1
            tag = " (original)" if mi == M-1 else ""
            print(f"    model {mi+1}{tag}: {per_model_wrong[mi]}/{per_model_total[mi]} "
                  f"= {100*per_model_wrong[mi]/tot:.0f}%")
        avg = sum(per_model_wrong)/max(1,sum(per_model_total))
        print(f"    AVERAGE single model wrong rate       : {100*avg:.0f}%")
    print("\nInterpretation: high all_wrong % => models fail together, ensemble "
          "variance is blind here.\nHigh dis>=1 % => disagreement exists at the "
          "mistakes; ensemble variance is a candidate signal.")


if __name__ == "__main__":
    main()
