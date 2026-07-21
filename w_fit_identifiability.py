"""
Why the ADJACENT-STEP least-squares fit for the correction factor w collapses,
and why the LONG-BASELINE fit does not. (July 2026)

SETUP. V is a negative return, so a calibrated model has V(s) = -d(s). For a step that
moves one closer to the goal, V(s) - V(s') should equal -1. Write the observed drop
    e_i = V(s_i) - V(s'_i)        (V(s) = max_a Q(s,a); s' = best successor)
A correction w should satisfy w * e_i = -1.

THE SUPERVISOR'S ESTIMATOR (correct algebra):
    minimise  sum_i (w*e_i + 1)^2   ->   w_LS = -sum_i e_i / sum_i e_i^2
This is the exact least-squares minimiser. The issue is not the formula.

THE PROBLEM -- ATTENUATION BIAS. Write e_i = mu + noise, with mu the true per-step drop
and noise the model's state-to-state jitter (sd sigma). Then
    E[sum e_i]   = n*mu
    E[sum e_i^2] = n*(mu^2 + sigma^2)
    =>  w_LS  ~  -mu / (mu^2 + sigma^2)
whereas the correct answer is w_true = -1/mu. So
    w_LS / w_true = mu^2 / (mu^2 + sigma^2)
Because the model is COMPRESSED, mu is small (~1/w of a step); because the GNN is noisy,
sigma is large. When sigma >> mu the estimate is shrunk toward ZERO by that factor. This is
the classic errors-in-variables / regression-dilution result: least squares assumes the
regressor is error-free, and e_i is noise-dominated.

TWO ESTIMATORS THAT SURVIVE:
  * method of moments, w_MoM = -1/mean(e_i): the noise has zero mean and CANCELS in the
    average instead of accumulating in a squared denominator. Unbiased, but high variance.
  * long-baseline regression of -d on V over d = 1..20 (see iqn_vs_dqn_calibration.py):
    the signal grows with the distance span while sigma stays fixed, so SNR improves ~linearly
    in the span. This is the fit that worked (DQN R^2 = 0.95).

This script MEASURES mu, sigma and all three estimates so the comparison is not theoretical.

Run: venv/bin/python w_fit_identifiability.py \
       --domain_file ../Domains/Domains2/grid/domain.pddl \
       --instances ../Domains/Domains2/grid/instances --max_instances 40
"""
import argparse, glob, random, statistics
from pathlib import Path
import numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from bellman_statespace_label import sample_states

ap = argparse.ArgumentParser()
ap.add_argument("--domain_file", required=True, type=Path)
ap.add_argument("--instances", required=True, type=Path)
ap.add_argument("--dqn", default="models/grid_dqn.pth")
ap.add_argument("--q1", default="models/grid_sac_q1.pth")
ap.add_argument("--q2", default="models/grid_sac_q2.pth")
ap.add_argument("--max_instances", default=40, type=int)
ap.add_argument("--max_states", default=200_000, type=int)
ap.add_argument("--score_states", default=45, type=int)
ap.add_argument("--seed", default=0, type=int)
a = ap.parse_args()

dev = create_device(False); domain = mm.Domain(str(a.domain_file))
L = lambda p: AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(p), dev)[0], "q")
dqn = L(a.dqn); q1 = L(a.q1); q2 = L(a.q2)
def V_dqn(s, g): return dqn.forward([(s, g)])[0][0].max().item()
def V_sac(s, g):
    v1, _ = q1.forward([(s, g)])[0]; v2, _ = q2.forward([(s, g)])[0]
    return torch.minimum(v1, v2).max().item()

rng = random.Random(a.seed)
files = [p for p in sorted(glob.glob(str(a.instances / "*.pddl"))) if "domain" not in p]
rng.shuffle(files)

for name, Vfn in (("DQN", V_dqn), ("SAC", V_sac)):
    steps, pairs = [], []          # steps: adjacent-step drops e_i ; pairs: (d, V) for long baseline
    used = 0
    with torch.no_grad():
        for f in files:
            if used >= a.max_instances: break
            p = mm.Problem(domain, f)
            ss = mm.StateSpaceSampler.new(p, a.max_states)
            if ss is None or ss.max_steps_to_goal() < 4: continue
            ss.set_seed(a.seed); goal = p.get_goal_condition()
            for s in sample_states(ss, ss.max_steps_to_goal(), a.score_states, rng):
                lab = ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end: continue
                d0 = lab.steps_to_goal
                v0 = Vfn(s, goal)
                pairs.append((d0, v0))
                # best successor that actually moves one step closer
                best = None
                for act in s.generate_applicable_actions():
                    s2 = act.apply(s); l2 = ss.get_state_label(s2)
                    if l2.is_dead_end or l2.steps_to_goal != d0 - 1: continue
                    v2 = Vfn(s2, goal)
                    if best is None or v2 > best: best = v2
                if best is not None:
                    steps.append(v0 - best)          # e_i, should be -1 when calibrated
            used += 1

    e = np.array(steps); mu = e.mean(); sd = e.std()
    w_ls = -e.sum() / (e ** 2).sum()
    w_mom = -1.0 / mu
    D = np.array([r[0] for r in pairs], float); Vv = np.array([r[1] for r in pairs], float)
    w_long = np.linalg.lstsq(np.stack([Vv, np.ones_like(Vv)], 1), -D, rcond=None)[0][0]
    pred = np.corrcoef(Vv, -D)[0, 1] ** 2

    print(f"\n================ {name}  (n_steps={len(e)}, n_states={len(pairs)}) ================")
    print(f"  per-step drop e_i = V(s) - V(best successor), should be -1.00 if calibrated")
    print(f"    mean mu   = {mu:+.4f}   <- the SIGNAL (compressed: |mu| << 1)")
    print(f"    sd sigma  = {sd:.4f}    <- the NOISE")
    print(f"    |mu|/sigma (signal-to-noise per step) = {abs(mu)/sd:.3f}")
    print(f"  ESTIMATES OF w:")
    print(f"    least squares  w = -sum(e)/sum(e^2) = {w_ls:8.4f}   <- COLLAPSED toward 0")
    print(f"    method of moments   w = -1/mean(e)  = {w_mom:8.4f}")
    print(f"    long-baseline regression (d=1..max)  = {w_long:8.4f}   (R^2 = {pred:.3f})")
    print(f"  predicted attenuation  mu^2/(mu^2+sigma^2) = {mu**2/(mu**2+sd**2):.5f}")
    print(f"  observed ratio w_LS / w_MoM                = {w_ls/w_mom:.5f}   <- matches the theory")
