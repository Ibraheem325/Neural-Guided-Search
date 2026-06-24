#!/usr/bin/env python3
"""
iqn_health_check.py
Checks whether an IQN model's quantile head is HEALTHY (alive, varying) vs
DEGENERATE (collapsed / flat / sign-flipped), so we know whether a negative
Test-0 result is about the IDEA or about a bad MODEL.

Usage:
  venv/bin/python iqn_health_check.py \
      --domain example/goldminer_dataset/domain.pddl \
      --instances example/goldminer_dataset/train \
      --model models/goldminer_iqn.pth
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model

ap = argparse.ArgumentParser()
ap.add_argument('--domain', required=True)
ap.add_argument('--instances', required=True)
ap.add_argument('--model', required=True)
ap.add_argument('--n-states', type=int, default=200)
args = ap.parse_args()

dev = torch.device('cpu')
domain = mm.Domain(args.domain)
model, _p, _e = _load_model(domain, Path(args.model), dev)
model.eval()
dense = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

random.seed(0)
files = sorted(f for f in Path(args.instances).glob('*.pddl') if f.name != 'domain.pddl')

# collect a sample of states
samples = []  # (qv: [n_act,99], depth)
for f in files:
    p = mm.Problem(domain, str(f))
    if len(p.get_goal_condition()) == 0: continue
    ss = mm.StateSpaceSampler.new(p, 200_000)
    if ss is None or ss.max_steps_to_goal() < 2: continue
    goal = p.get_goal_condition()
    states = ss.get_states(); random.shuffle(states)
    taken = 0
    with torch.no_grad():
        for s in states:
            if taken >= 8: break
            ls = ss.get_state_label(s)
            if ls.is_goal: continue
            acts = s.generate_applicable_actions()
            if len(acts) < 2: continue
            qv, _ = model.forward([(s, goal)], taus=dense.expand(1, 99))[0]
            samples.append((qv.detach(), float(ls.steps_to_goal)))
            taken += 1
    if len(samples) >= args.n_states: break

print(f"sampled states: {len(samples)}")

# ---- 1. is the head ALIVE? does tau move the output (between calls)? ----
qv0 = samples[0][0]
qs0, _ = torch.sort(qv0, dim=1)
print("\n[1] HEAD ALIVE? (one example action's quantile curve, sorted)")
q = qs0[0]
print(f"    p05={q[4]:.3f} p25={q[24]:.3f} p50={q[49]:.3f} p75={q[74]:.3f} p95={q[94]:.3f}")
print(f"    total range (p99-p01) = {(q[-1]-q[0]).item():.3f}   (≈0 => DEAD/collapsed head)")

# ---- 2. crossing fraction (some is normal; ~0.4 is a lot) ----
cross = []
for qv, _ in samples:
    d = qv[:, 1:] - qv[:, :-1]
    cross.append((d < -1e-4).float().mean().item())
print(f"\n[2] CROSSINGS: mean fraction non-monotone = {np.mean(cross):.3f}  (small=fine, ~0.4=heavy)")

# ---- 3. does WIDTH vary across actions and across states? ----
state_spreads = []
within_state_std = []
for qv, _ in samples:
    qs, _ = torch.sort(qv, dim=1)
    w = (qs[:, 90] - qs[:, 8])           # width per action
    state_spreads.append(w.mean().item())
    if w.numel() > 1:
        within_state_std.append(w.std().item())
ss_arr = np.array(state_spreads)
print(f"\n[3] WIDTH VARIATION")
print(f"    across states: width min={ss_arr.min():.3f} med={np.median(ss_arr):.3f} max={ss_arr.max():.3f}")
print(f"    within state (std of width across sibling actions): mean={np.mean(within_state_std):.3f}")
print(f"    (if across-states range is tiny OR within-state std≈0 => width can't discriminate)")

# ---- 4. SIGN check: does predicted mean track -depth? (best action via argmax) ----
means_best, depths = [], []
for qv, depth in samples:
    qs, _ = torch.sort(qv, dim=1)
    m = qs.mean(dim=1)
    means_best.append(m.max().item())   # argmax = best if higher readout = better
    depths.append(depth)
mb = np.array(means_best); dp = np.array(depths)
def sp(a,b):
    ra=np.argsort(np.argsort(a)).astype(float); rb=np.argsort(np.argsort(b)).astype(float)
    return np.corrcoef(ra,rb)[0,1]
corr_md = sp(mb, dp)
print(f"\n[4] SIGN CHECK: Spearman(best-action mean, true depth) = {corr_md:+.3f}")
print(f"    expect NEGATIVE (deeper => lower value) if readout≈+return and argmax=best.")
print(f"    if POSITIVE and large, the best-action picker is using the wrong sign")
print(f"    (should be argmin not argmax) -> Test-0 'best action' was inverted on this domain.")

print("\nVERDICT GUIDE:")
print("  range≈0 or width doesn't vary  -> DEGENERATE model; negative result is the MODEL.")
print("  healthy width + sign correct   -> model is fine; negative result is the IDEA (domain-dependent).")
print("  sign positive/large            -> fix argmax->argmin and RE-RUN validation before concluding.")