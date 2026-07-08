"""
Offline check: does the ENSEMBLE rescue W1's ranking on Grid?

Walks the optimal plans of the 22 hard instances. At two node sets --
MISTAKE nodes (policy argmax != plan action) and CORRECT DECISION nodes
(policy argmax == plan action, dominant prior < 0.9) -- computes, per
ensemble member m, the belief shift W1_m(a) = mean|sorted(parent_curve_m) -
sorted(child_curve_m)| for every child, then compares two signals:

  singleW1  : W1 from the original models/grid_iqn.pth alone
  ensW1     : mean over the M ensemble members of W1_m(a)

Reported (same metrics as the width analysis, so all signals comparable):
  fire@mist   : plan action's child has the TOP signal at a mistake node
  misfire@corr: some alternative out-scores the plan/dominant child at a
                correct decision node

Reference points measured earlier on the same nodes:
  width : fire 15% (below ~22% chance), misfire 77%
  vote  : prefers correct child 59% at mistakes, 35% misfire at correct nodes
"""
import json
import statistics
import torch
from pathlib import Path
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
from utils import create_device
from train_iqn import _load_model as _load_iqn_model

ENSEMBLE = [
    "models/grid_iqn_ens_1_best.pth",
    "models/grid_iqn_ens_2_best.pth",
    "models/grid_iqn_ens_3_best.pth",
    "models/grid_iqn_ens_4_best.pth",
    "models/grid_iqn_ens_5_best.pth",
    "models/grid_iqn.pth",          # original; also used alone as singleW1
]
SINGLE_IDX = len(ENSEMBLE) - 1


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


def best_curves(model, states_goals, taus):
    """Sorted best-action curve for each state; None for dead ends."""
    n = len(states_goals)
    out = model.forward(states_goals, taus=taus.expand(n, taus.shape[1]))
    curves = []
    for q, _ in out:
        if q.shape[0] == 0:
            curves.append(None)
            continue
        qs, _ = torch.sort(q, dim=1)
        curves.append(qs[int(qs.mean(dim=1).argmax())].detach())
    return curves


def canon(s):
    return s.lower().replace(" ", "").replace("(", "").replace(")", "")


def main():
    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain("example/grid_dataset/domain.pddl")
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(
        domain, Path("models/grid_sac_policy.pth"), device)
    policy = ModelWrapper(pol_raw, "policy")
    models = []
    for p in ENSEMBLE:
        m, _, _ = _load_iqn_model(domain, Path(p), device)
        m.eval()
        models.append(m)
    M = len(models)
    print(f"Loaded {M} models (singleW1 = {ENSEMBLE[SINGLE_IDX]})\n")

    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    hard = sorted([k for k in ref
                   if ref[k].get("baseline", {}).get("solved")
                   and (ref[k]["baseline"].get("expanded") or 0) >= 300],
                  key=lambda k: -ref[k]["baseline"]["expanded"])

    tot = {"mist": 0, "fire_single": 0, "fire_ens": 0,
           "corr": 0, "mis_single": 0, "mis_ens": 0}

    print(f"{'instance':<36} {'mist':>4} {'fire_sgl':>8} {'fire_ens':>8} "
          f"{'corr':>4} {'mis_sgl':>7} {'mis_ens':>7}")
    print("-" * 82)

    with torch.no_grad():
        for inst in hard:
            pddl = Path(f"example/grid_dataset/val/{inst}.pddl")
            planf = Path(f"example/grid_dataset/val/{inst}.pddl.plan")
            plan_lines = [l.strip() for l in planf.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]
            problem = mm.Problem(domain, str(pddl))
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()

            cnt = {"mist": 0, "fire_single": 0, "fire_ens": 0,
                   "corr": 0, "mis_single": 0, "mis_ens": 0}

            for plan_str in plan_lines:
                logits, actions = policy.forward([(state, goal)])[0]
                if not actions:
                    break
                probs = torch.softmax(logits, dim=0).tolist()
                pairs = sorted(zip(probs, actions), key=lambda x: -x[0])
                dom_p, dom_a = pairs[0]

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

                is_mistake = plan_a != dom_a
                is_corr_dec = (not is_mistake) and dom_p < 0.9 and len(pairs) > 1

                if is_mistake or is_corr_dec:
                    acts = [a for _, a in pairs]
                    succs = [(a.apply(state), goal) for a in acts]
                    # per-model W1 of each child
                    w1_by_model = []
                    for m in models:
                        pc = best_curves(m, [(state, goal)], taus)[0]
                        ccs = best_curves(m, succs, taus)
                        w1s = [torch.mean(torch.abs(pc - c)).item()
                               if (pc is not None and c is not None) else 0.0
                               for c in ccs]
                        w1_by_model.append(w1s)
                    single = w1_by_model[SINGLE_IDX]
                    ens = [statistics.mean(w1_by_model[m][i] for m in range(M))
                           for i in range(len(acts))]
                    pidx = acts.index(plan_a)

                    if is_mistake:
                        cnt["mist"] += 1
                        if single[pidx] >= max(single) - 1e-12:
                            cnt["fire_single"] += 1
                        if ens[pidx] >= max(ens) - 1e-12:
                            cnt["fire_ens"] += 1
                    else:
                        cnt["corr"] += 1
                        alt_s = max(v for i, v in enumerate(single) if i != pidx)
                        alt_e = max(v for i, v in enumerate(ens) if i != pidx)
                        if alt_s > single[pidx]:
                            cnt["mis_single"] += 1
                        if alt_e > ens[pidx]:
                            cnt["mis_ens"] += 1

                state = plan_a.apply(state)

            for k in tot:
                tot[k] += cnt[k]
            fs = f"{cnt['fire_single']}/{cnt['mist']}" if cnt["mist"] else "-"
            fe = f"{cnt['fire_ens']}/{cnt['mist']}" if cnt["mist"] else "-"
            ms = f"{cnt['mis_single']}/{cnt['corr']}" if cnt["corr"] else "-"
            me = f"{cnt['mis_ens']}/{cnt['corr']}" if cnt["corr"] else "-"
            print(f"{inst:<36} {cnt['mist']:>4} {fs:>8} {fe:>8} "
                  f"{cnt['corr']:>4} {ms:>7} {me:>7}")

    print("-" * 82)
    if tot["mist"]:
        print(f"\nTOTAL over {tot['mist']} mistake nodes:")
        print(f"  singleW1 fires at correct action : "
              f"{tot['fire_single']} ({100*tot['fire_single']/tot['mist']:.0f}%)")
        print(f"  ensW1    fires at correct action : "
              f"{tot['fire_ens']} ({100*tot['fire_ens']/tot['mist']:.0f}%)")
    if tot["corr"]:
        print(f"TOTAL over {tot['corr']} correct decision nodes:")
        print(f"  singleW1 misfires : {tot['mis_single']} "
              f"({100*tot['mis_single']/tot['corr']:.0f}%)")
        print(f"  ensW1    misfires : {tot['mis_ens']} "
              f"({100*tot['mis_ens']/tot['corr']:.0f}%)")
    print("\nReference: width fire 15% / misfire 77%; "
          "ensemble VOTE 59% correct at mistakes / 35% misfire.")


if __name__ == "__main__":
    main()
