"""
SAC-parent + DQN-endpoint cross-model Bellman check, WITH affine correction (July 2026).

Regenerates the number that was previously produced by a throwaway probe
(`bellman_corrected_auc_cross`) which was never committed -- so the old "0.49" was
not reproducible. This is the committed, reproducible version.

WHY CROSS. The same-model residual |V(s,a) - (-1 + g*V(s'))| measures SELF-consistency,
which training enforces, so it is ~chance at ranking actions. Reading the endpoint with a
DIFFERENT model (DQN) that was never trained to agree with SAC's parent should let a real
disagreement appear where a model is confidently wrong.

WHY CORRECTION IS REQUIRED HERE. SAC and DQN are compressed by DIFFERENT factors
(w~5.4 vs w~3.7). A raw cross-model residual is then dominated by that scale MISMATCH,
not by disagreement. So both models are put on the true-distance scale first by fitting
w per model per instance against the ORACLE distance (least squares) -- the best-case
correction. The additive b cancels in the residual and is not needed.

    err_within = | w_s*Q_SAC(s,a) - ( -1 + g * w_s*V_SAC(s') ) |     <- self control
    err_cross  = | w_s*Q_SAC(s,a) - ( -1 + g * w_d*V_DQN(s') ) |     <- cross signal
      Q_SAC(s,a) = min(q1,q2)(s,a);  V_X(s') = max_b Q_X(s',b)

AUC = P(residual at an INCORRECT action > residual at a CORRECT one); 0.5 = no signal.
Sliced near/far by exact distance to goal, since the whole hypothesis is that the signal
only survives where the target is grounded (near the goal).

Usage:
  venv/bin/python bellman_cross_sac_dqn.py \
    --domain_file "../Domains/Domains2/grid/domain.pddl" \
    --instances   "../Domains/Domains2/grid/instances" \
    --q1 models/grid_sac_q1.pth --q2 models/grid_sac_q2.pth --dqn models/grid_dqn.pth \
    --max_instances 60
"""
import argparse, glob, random
from pathlib import Path
import numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from bellman_statespace_label import sample_states
from bellman_epsilon_label import rank_auc

GAMMA = 0.999

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain_file", required=True, type=Path)
    ap.add_argument("--instances", required=True, type=Path)
    ap.add_argument("--q1", required=True, type=Path); ap.add_argument("--q2", required=True, type=Path)
    ap.add_argument("--dqn", required=True, type=Path)
    ap.add_argument("--max_instances", default=60, type=int)
    ap.add_argument("--max_states", default=200_000, type=int)
    ap.add_argument("--fit_states", default=60, type=int)
    ap.add_argument("--score_states", default=40, type=int)
    ap.add_argument("--near", default=10, type=int, help="distance boundary for near/far slice")
    ap.add_argument("--seed", default=0, type=int)
    a = ap.parse_args()

    dev = create_device(False); domain = mm.Domain(str(a.domain_file))
    L = lambda p: AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, p, dev)[0], "q")
    q1, q2, dqn = L(a.q1), L(a.q2), L(a.dqn)
    def Vsac(s, g):
        v1, _ = q1.forward([(s, g)])[0]; v2, _ = q2.forward([(s, g)])[0]
        return torch.minimum(v1, v2)
    def Vdqn(s, g): return dqn.forward([(s, g)])[0][0]

    rng = random.Random(a.seed)
    buckets = {k: {"inc": [], "cor": []} for k in ("within", "cross")}
    sliced = {(k, sl): {"inc": [], "cor": []} for k in ("within", "cross") for sl in ("near", "far")}
    files = [p for p in sorted(glob.glob(str(a.instances / "*.pddl"))) if "domain" not in p]
    rng.shuffle(files); used = 0

    with torch.no_grad():
        for f in files:
            if used >= a.max_instances: break
            p = mm.Problem(domain, f)
            ss = mm.StateSpaceSampler.new(p, a.max_states)
            if ss is None or ss.max_steps_to_goal() < 4: continue
            ss.set_seed(a.seed); goal = p.get_goal_condition()
            # fit w per model against oracle distance
            Xs, Ys, Yd = [], [], []
            for s in sample_states(ss, ss.max_steps_to_goal(), a.fit_states, rng):
                lab = ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end: continue
                Xs.append(-float(lab.steps_to_goal))
                Ys.append(Vsac(s, goal).max().item()); Yd.append(Vdqn(s, goal).max().item())
            if len(Xs) < 15: continue
            fit = lambda Y: np.linalg.lstsq(np.stack([np.array(Y), np.ones(len(Y))], 1), np.array(Xs), rcond=None)[0][0]
            ws, wd = fit(Ys), fit(Yd)
            for s in sample_states(ss, ss.max_steps_to_goal(), a.score_states, rng):
                lab = ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end: continue
                d0 = lab.steps_to_goal
                acts = s.generate_applicable_actions()
                if len(acts) < 2: continue
                qsac = Vsac(s, goal)
                for j, act in enumerate(acts):
                    s2 = act.apply(s); l2 = ss.get_state_label(s2)
                    if l2.is_dead_end: continue
                    correct = l2.steps_to_goal < d0
                    par = ws * qsac[j].item()
                    e_w = abs(par - (-1 + GAMMA * ws * Vsac(s2, goal).max().item()))
                    e_c = abs(par - (-1 + GAMMA * wd * Vdqn(s2, goal).max().item()))
                    sl = "near" if d0 <= a.near else "far"
                    for k, e in (("within", e_w), ("cross", e_c)):
                        buckets[k]["cor" if correct else "inc"].append(e)
                        sliced[(k, sl)]["cor" if correct else "inc"].append(e)
            used += 1

    print(f"\nSAC-parent Bellman residual, affine-corrected. grid, {used} instances.")
    print("AUC = P(err at INCORRECT action > err at CORRECT). 0.5 = no signal.\n")
    print(f"{'endpoint read by':<26}{'ALL':>8}{'near d<=%d'%a.near:>12}{'far d>%d'%a.near:>10}{'n':>9}")
    for k, name in (("within", "SAC (self control)"), ("cross", "DQN (cross)")):
        b = buckets[k]; row = [f"{rank_auc(b['inc'], b['cor']):.3f}"]
        for sl in ("near", "far"):
            t = sliced[(k, sl)]
            row.append(f"{rank_auc(t['inc'], t['cor']):.3f}" if len(t['inc']) > 5 and len(t['cor']) > 5 else "-")
        print(f"{name:<26}{row[0]:>8}{row[1]:>12}{row[2]:>10}{len(b['inc'])+len(b['cor']):>9}")

if __name__ == "__main__":
    main()
