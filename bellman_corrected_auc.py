"""
Does an affine value-correction (w,b) make the 1-step Bellman residual separate
GOOD from BAD actions?  (July 2026)

Context. Every IQN/scalar value model here is miscalibrated far from the goal
(the IQN saturates; SAC/DQN are compressed). The supervisor proposed correcting
per instance with w,b so the values track true distance again. This tests
whether that correction lets the Bellman residual work as an action-quality
signal.

Method (small pool, so mm.StateSpaceSampler gives EXACT distance = ground truth):
  1. Per instance, fit w,b by least squares of  (-true_distance) ~ w*V(s) + b,
     using the ORACLE distance -> the BEST-CASE correction (upper bound).
     V(s) = max_a value(s,a); SAC uses min(q1,q2), DQN uses q.
  2. Label every applicable action: CORRECT iff it strictly decreases the exact
     distance to goal, else INCORRECT.
  3. For each action compute the 1-step Bellman residual, raw and corrected:
        raw  = | V(s,a)      - (-1 + g*V(s')) |
        corr = | w*V(s,a)    - (-1 + g*w*V(s')) |     (b cancels in the difference)
     with V(s') = max_b V(s',b) at the successor.
  4. AUC = P(residual at a random INCORRECT action > residual at a random CORRECT
     action). 0.5 = no signal; >0.5 = residual flags bad actions; <0.5 = inverted.

Result (grid small pool, 40 instances): SAC raw 0.466 -> corr 0.523;
DQN raw 0.520 -> corr 0.532. Both stay at chance even with the oracle-perfect
correction. Reason: Q(s,a) = -1 + g*V(s') holds BY DEFINITION for every action
(good or bad), so the residual measures self-consistency, not action quality;
scaling changes its size, not what it measures. (Cross-model and distributional
variants are equally null -- see bellman_corrected_auc_cross for the cross form.)

This is TRANSITION-level AUC (every action), which is the honest metric; the old
node-level number (policy argmax only) ran ~0.71 but is easier/noisier.

Usage:
  venv/bin/python bellman_corrected_auc.py \
      --domain_file "$D/Domains2/grid/domain.pddl" \
      --instances   "$D/Domains2/grid/instances" \
      --q1 models/grid_sac_q1.pth --q2 models/grid_sac_q2.pth \
      --dqn models/grid_dqn.pth --max_instances 40
"""
import argparse
import glob
import random
import statistics
from pathlib import Path

import numpy as np
import torch
import pymimir as mm
import pymimir_rgnn as rgnn

from utils import create_device
import alphaZero_bellman as AZ
from bellman_statespace_label import sample_states
from bellman_epsilon_label import rank_auc

GAMMA = 0.999


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain_file", required=True, type=Path)
    ap.add_argument("--instances", required=True, type=Path)
    ap.add_argument("--q1", required=True, type=Path)
    ap.add_argument("--q2", required=True, type=Path)
    ap.add_argument("--dqn", default=None, type=Path)
    ap.add_argument("--max_instances", default=40, type=int)
    ap.add_argument("--max_states", default=200_000, type=int)
    ap.add_argument("--fit_states", default=60, type=int)
    ap.add_argument("--score_states", default=40, type=int)
    ap.add_argument("--seed", default=0, type=int)
    args = ap.parse_args()

    dev = create_device(False)
    domain = mm.Domain(str(args.domain_file))
    q1r, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1, dev)
    q2r, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2, dev)
    q1 = AZ.ModelWrapper(q1r, "q"); q2 = AZ.ModelWrapper(q2r, "q")

    def Vsac(s, g):
        v1, a = q1.forward([(s, g)])[0]; v2, _ = q2.forward([(s, g)])[0]
        return torch.minimum(v1, v2), a

    models = [("SAC", Vsac)]
    if args.dqn is not None:
        dqnr, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.dqn, dev)
        dqn = AZ.ModelWrapper(dqnr, "q")
        models.append(("DQN", lambda s, g: dqn.forward([(s, g)])[0]))

    rng = random.Random(args.seed)

    def run(Vfn):
        raw_i, raw_c, cor_i, cor_c = [], [], [], []
        files = [p for p in sorted(glob.glob(str(args.instances / "*.pddl"))) if "domain" not in p]
        rng.shuffle(files)
        used = 0
        with torch.no_grad():
            for f in files:
                if used >= args.max_instances:
                    break
                p = mm.Problem(domain, f)
                ss = mm.StateSpaceSampler.new(p, args.max_states)
                if ss is None or ss.max_steps_to_goal() < 4:
                    continue
                ss.set_seed(args.seed)
                goal = p.get_goal_condition()
                # --- fit w,b: (-dist) ~ w*V + b, oracle distance ---
                X, Y = [], []
                for s in sample_states(ss, ss.max_steps_to_goal(), args.fit_states, rng):
                    lab = ss.get_state_label(s)
                    if lab.is_goal or lab.is_dead_end:
                        continue
                    v, _ = Vfn(s, goal)
                    X.append(-float(lab.steps_to_goal)); Y.append(v.max().item())
                if len(X) < 15:
                    continue
                Ya = np.array(Y); A = np.stack([Ya, np.ones_like(Ya)], 1)
                (w, b), *_ = np.linalg.lstsq(A, np.array(X), rcond=None)
                # --- score every action ---
                for s in sample_states(ss, ss.max_steps_to_goal(), args.score_states, rng):
                    lab = ss.get_state_label(s)
                    if lab.is_goal or lab.is_dead_end:
                        continue
                    d0 = lab.steps_to_goal
                    acts = s.generate_applicable_actions()
                    if len(acts) < 2:
                        continue
                    v, _ = Vfn(s, goal)
                    for j, a in enumerate(acts):
                        l2 = ss.get_state_label(a.apply(s))
                        if l2.is_dead_end:
                            continue
                        correct = l2.steps_to_goal < d0
                        m = Vfn(a.apply(s), goal)[0].max().item()
                        raw = abs(v[j].item() - (-1 + GAMMA * m))
                        cor = abs(w * v[j].item() - (-1 + GAMMA * w * m))
                        (raw_c if correct else raw_i).append(raw)
                        (cor_c if correct else cor_i).append(cor)
                used += 1
        return rank_auc(raw_i, raw_c), rank_auc(cor_i, cor_c), len(raw_i) + len(raw_c), used

    print("TRANSITION-level Bellman-residual AUC  (P(err incorrect > err correct); 0.5 = no signal)")
    print("w,b fit per instance against the ORACLE distance = best-case correction.\n")
    print(f"{'model':<6} {'AUC raw':>9} {'AUC corrected':>15} {'n_actions':>11} {'instances':>10}")
    for name, Vfn in models:
        ar, ac, n, u = run(Vfn)
        print(f"{name:<6} {ar:>9.3f} {ac:>15.3f} {n:>11} {u:>10}")


if __name__ == "__main__":
    main()
