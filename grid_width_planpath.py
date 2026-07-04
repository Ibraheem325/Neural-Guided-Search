"""
Per-instance width analysis on the 22 hard Grid instances.

Walks the optimal plan. At two kinds of nodes, computes the width
(q[90]-q[8] of the best-action sorted IQN curve) of every child state:

  MISTAKE nodes: policy argmax != plan action (any peakedness) --
    the nodes where a redirect would actually help. Question: does the
    plan action's child carry the highest width (signal fires correctly)?

  CORRECT decision nodes: policy argmax == plan action AND dom prior < 0.9 --
    the nodes where the boost can act but shouldn't. Question: does some
    alternative child out-width the plan/dominant child (signal misfires)?

Prints per-instance: counts, fire-rate at mistakes, misfire-rate at correct
nodes, plus the width-multiplicative result for context.
"""
import json
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


def child_width(iqn, state, goal, taus):
    q, _ = iqn.forward([(state, goal)], taus=taus)[0]
    if q.shape[0] == 0:
        return None
    qs, _ = torch.sort(q, dim=1)
    best = int(qs.mean(dim=1).argmax())
    return (qs[best, 90] - qs[best, 8]).item()


def canon(s):
    return s.lower().replace(" ", "").replace("(", "").replace(")", "")


def main():
    device = create_device(False)
    taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
    domain = mm.Domain("example/grid_dataset/domain.pddl")
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(
        domain, Path("models/grid_sac_policy.pth"), device)
    policy = ModelWrapper(pol_raw, "policy")
    iqn, _, _ = _load_iqn_model(domain, Path("models/grid_iqn.pth"), device)
    iqn.eval()

    with open("results/grid_decoupled_comparison.json") as f:
        ref = json.load(f)
    with open("results/grid_width_hard.json") as f:
        width_res = json.load(f)

    hard = sorted([k for k in ref
                   if ref[k].get("baseline", {}).get("solved")
                   and (ref[k]["baseline"].get("expanded") or 0) >= 300],
                  key=lambda k: -ref[k]["baseline"]["expanded"])

    print(f"{'instance':<36} {'wm_ratio':>8} {'steps':>5} {'mist':>4} "
          f"{'fire@mist':>9} {'corr_dec':>8} {'misfire':>8} {'mfr_mag':>7}")
    print("-" * 92)

    with torch.no_grad():
        for inst in hard:
            pddl = Path(f"example/grid_dataset/val/{inst}.pddl")
            planf = Path(f"example/grid_dataset/val/{inst}.pddl.plan")
            plan_lines = [l.strip() for l in planf.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]

            problem = mm.Problem(domain, str(pddl))
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()

            n_steps = 0
            mistakes = []       # (plan_width_rank_ok, detail)
            fires = 0
            correct_dec = 0
            misfires = 0
            misfire_mags = []

            for plan_str in plan_lines:
                logits, actions = policy.forward([(state, goal)])[0]
                if not actions:
                    break
                n_steps += 1
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

                is_mistake = (plan_a != dom_a)
                is_corr_dec = (plan_a == dom_a and dom_p < 0.9 and len(pairs) > 1)

                if is_mistake or is_corr_dec:
                    widths = {}
                    for _, a in pairs:
                        w = child_width(iqn, a.apply(state), goal, taus)
                        widths[a] = w if w is not None else 0.0
                    if is_mistake:
                        mistakes.append(inst)
                        mx = max(widths.values())
                        if widths[plan_a] >= mx - 1e-9:
                            fires += 1
                    else:
                        correct_dec += 1
                        alt_max = max((w for a, w in widths.items() if a != plan_a),
                                      default=0.0)
                        if alt_max > widths[plan_a]:
                            misfires += 1
                            if widths[plan_a] > 0:
                                misfire_mags.append(alt_max / widths[plan_a])

                state = plan_a.apply(state)

            wm = width_res.get(inst, {}).get("widthmult_l15", {})
            b_exp = ref[inst]["baseline"]["expanded"]
            wm_r = f"{wm['expanded']/b_exp:.2f}" if wm.get("solved") else "FAIL"
            fire_s = f"{fires}/{len(mistakes)}" if mistakes else "-"
            mis_s = f"{misfires}/{correct_dec}" if correct_dec else "-"
            mag = (f"{sum(misfire_mags)/len(misfire_mags):.1f}x"
                   if misfire_mags else "-")
            print(f"{inst:<36} {wm_r:>8} {n_steps:>5} {len(mistakes):>4} "
                  f"{fire_s:>9} {correct_dec:>8} {mis_s:>8} {mag:>7}")


if __name__ == "__main__":
    main()
