"""
Policy-ensemble disagreement diagnostic on the 22 hard Grid instances.

The value-IQN ensemble reduced confidently-wrong VALUE decisions (41%->28%)
but could not touch the POLICY's peakedness (83% of mistake nodes have the
single policy at prior >0.9 on the WRONG action). This tests the parallel
idea: do independently-trained POLICIES disagree at those mistake nodes, or
are they all confidently wrong together?

We walk each optimal plan with a REFERENCE policy (the original
grid_sac_policy) to define the mistake nodes: states where the reference
policy's argmax != the plan action. At each such node, for the M policies
(5 seed-diverse + original) we report:

  agree_wrong : all M policies put their argmax on the SAME wrong action
                (the "all confidently wrong together" case -> idea is dead)
  some_correct: >=1 policy's argmax is the plan (correct) action
  mean_correct: average # of policies whose argmax is the correct action
  ens_prior_corr : the AVERAGED policy's probability on the correct action
                   (how much a voted/averaged prior de-peaks the mistake)
  ens_peaked  : is the averaged policy still peaked (>0.9 on one action)?

Interpretation: low agree_wrong + meaningful ens_prior_corr => averaging the
policies de-peaks the wrong decision, so the easy-safe MULTIPLICATIVE boost
could act at mistake nodes without the tax-inducing floor.
"""
import json
import statistics
import torch
from pathlib import Path
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
from utils import create_device

POLICIES = [
    "models/grid_sac_ens_1_policy_best.pth",
    "models/grid_sac_ens_2_policy_best.pth",
    "models/grid_sac_ens_3_policy_best.pth",
    "models/grid_sac_ens_4_policy_best.pth",
    "models/grid_sac_ens_5_policy_best.pth",
    "models/grid_sac_policy.pth",          # original (also the reference)
]
REFERENCE = "models/grid_sac_policy.pth"


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


def probs_by_action(policy, state, goal):
    logits, actions = policy.forward([(state, goal)])[0]
    p = torch.softmax(logits, dim=0).tolist()
    return {a: p[i] for i, a in enumerate(actions)}, actions


def main():
    device = create_device(False)
    domain = mm.Domain("example/grid_dataset/domain.pddl")

    def load(path):
        raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, Path(path), device)
        return ModelWrapper(raw, "policy")

    ref = load(REFERENCE)
    policies = [load(p) for p in POLICIES]
    M = len(policies)
    print(f"Reference: {Path(REFERENCE).name}   Ensemble: {M} policies\n")

    with open("results/grid_decoupled_comparison.json") as f:
        refdata = json.load(f)
    hard = sorted([k for k in refdata
                   if refdata[k].get("baseline", {}).get("solved")
                   and (refdata[k]["baseline"].get("expanded") or 0) >= 300],
                  key=lambda k: -refdata[k]["baseline"]["expanded"])

    print(f"{'instance':<36} {'mist':>4} {'agree_wrong':>11} {'some_corr':>9} "
          f"{'mean_k':>6} {'ens_pcorr':>9} {'ens_peak%':>9}")
    print("-" * 90)

    tot_mist = tot_agreewrong = tot_somecorr = 0
    all_k, all_pcorr, all_enspeak = [], [], []
    all_csp, all_cep, all_singpeak = [], [], []

    with torch.no_grad():
        for inst in hard:
            pddl = Path(f"example/grid_dataset/val/{inst}.pddl")
            planf = Path(f"example/grid_dataset/val/{inst}.pddl.plan")
            plan_lines = [l.strip() for l in planf.read_text().splitlines()
                          if l.strip() and not l.startswith(";")]
            problem = mm.Problem(domain, str(pddl))
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()

            mist = agreewrong = somecorr = 0
            ks, pcorrs, enspeaks, singpeak = [], [], [], []
            corr_single_peak, corr_ens_peak, step_i = [], [], -1

            for plan_str in plan_lines:
                rp, actions = probs_by_action(ref, state, goal)
                if not actions:
                    break
                ref_dom = max(rp, key=rp.get)

                target = canon(plan_str)
                plan_a = None
                for a in actions:
                    if canon(str(a)) == target:
                        plan_a = a
                        break
                if plan_a is None:
                    an = plan_str.strip("()").split()[0]
                    for a in actions:
                        if an in str(a).lower():
                            plan_a = a
                            break
                if plan_a is None:
                    plan_a = ref_dom

                step_i += 1
                if plan_a == ref_dom and len(actions) > 1 and step_i % 3 == 0:
                    # CORRECT node: is the AVERAGED policy still peaked here?
                    ens = {a: 0.0 for a in actions}
                    for pol in policies:
                        pp, _ = probs_by_action(pol, state, goal)
                        for a in actions:
                            ens[a] += pp.get(a, 0.0) / M
                    corr_single_peak.append(1.0 if rp[ref_dom] > 0.9 else 0.0)
                    corr_ens_peak.append(1.0 if max(ens.values()) > 0.9 else 0.0)

                if plan_a != ref_dom:  # MISTAKE node (reference policy is wrong)
                    mist += 1
                    argmaxes = []
                    ens = {a: 0.0 for a in actions}
                    for pol in policies:
                        pp, _ = probs_by_action(pol, state, goal)
                        argmaxes.append(max(pp, key=pp.get))
                        for a in actions:
                            ens[a] += pp.get(a, 0.0) / M
                    k_corr = sum(1 for am in argmaxes if am == plan_a)
                    ks.append(k_corr)
                    if k_corr >= 1:
                        somecorr += 1
                    # all policies agree on the SAME wrong action
                    if len(set(map(str, argmaxes))) == 1 and argmaxes[0] != plan_a:
                        agreewrong += 1
                    pcorrs.append(ens.get(plan_a, 0.0))
                    enspeaks.append(1.0 if max(ens.values()) > 0.9 else 0.0)
                    singpeak.append(1.0 if rp[ref_dom] > 0.9 else 0.0)

                state = plan_a.apply(state)

            tot_mist += mist
            tot_agreewrong += agreewrong
            tot_somecorr += somecorr
            all_k += ks
            all_pcorr += pcorrs
            all_enspeak += enspeaks
            all_singpeak += singpeak
            all_csp += corr_single_peak
            all_cep += corr_ens_peak
            aw = f"{agreewrong}/{mist}" if mist else "-"
            sc = f"{somecorr}/{mist}" if mist else "-"
            mk = f"{statistics.mean(ks):.1f}" if ks else "-"
            pc = f"{statistics.mean(pcorrs):.3f}" if pcorrs else "-"
            pk = f"{100*statistics.mean(enspeaks):.0f}%" if enspeaks else "-"
            print(f"{inst:<36} {mist:>4} {aw:>11} {sc:>9} {mk:>6} {pc:>9} {pk:>9}")

    print("-" * 90)
    if tot_mist:
        print(f"\nTOTAL over {tot_mist} mistake nodes ({M} policies):")
        print(f"  all policies agree on SAME wrong action : "
              f"{tot_agreewrong} ({100*tot_agreewrong/tot_mist:.0f}%)  "
              f"<- high => idea dead (fail together)")
        print(f"  >=1 policy's argmax is CORRECT          : "
              f"{tot_somecorr} ({100*tot_somecorr/tot_mist:.0f}%)")
        print(f"  mean # policies correct per node        : "
              f"{statistics.mean(all_k):.2f} / {M}")
        print(f"  avg AVERAGED-policy prob on correct act : "
              f"{statistics.mean(all_pcorr):.3f}  "
              f"(single ref policy ~0 here by definition)")
        print(f"  SINGLE policy peaked (>0.9) at mistakes : "
              f"{100*statistics.mean(all_singpeak):.0f}% of nodes  <- the '83%'")
        print(f"  AVERAGED policy peaked (>0.9) at mistakes: "
              f"{100*statistics.mean(all_enspeak):.0f}% of nodes  <- the '21%'")
    import statistics as st
    if all_csp:
        print(f"\nCONTROL at {len(all_csp)} CORRECT decision nodes (policy is RIGHT):")
        print(f"  single policy peaked (>0.9)   : {100*st.mean(all_csp):.0f}%")
        print(f"  AVERAGED policy peaked (>0.9) : {100*st.mean(all_cep):.0f}%  "
              f"<- if this also drops, averaging de-peaks CORRECT nodes -> over-explores")
        print("\nIf averaged prob on correct is well above ~0 and peaked% drops, "
              "the voted policy de-peaks the mistakes -> multiplicative boost can "
              "act there without the floor (no easy tax).")


if __name__ == "__main__":
    main()
