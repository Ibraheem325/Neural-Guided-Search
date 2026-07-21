"""
Does BETTER CALIBRATION make the IQN's distributional signals work? (July 2026)

THE CONFOUND THIS RESOLVES. The uncertainty signal scores AUC ~0.74 near the goal and
~0.5 far away. Two explanations were tangled together:
  (a) GROUNDING  -- near the goal the k-step rollout reaches the goal, so one side of the
      comparison is real reward instead of the model's own estimate.
  (b) SATURATION -- near the goal the IQN is calibrated (slope -0.98 at d<=10); far away it
      is flat/inverted, so its distribution is degenerate and W1/width read noise.
Both are true near the goal, so nothing measured so far separates them.

THE NATURAL EXPERIMENT. models/grid_iqn.pth (hard target clamp) and
models/grid_iqn_nobounds_best.pth (clamp removed) share architecture, data and rollout
grounding, and differ ONLY in calibration (measured d=10-22 slope -0.421 vs -0.683,
see iqn_vs_dqn_calibration.py). So comparing the two isolates (b) from (a):
  signal improves with the better-calibrated model -> SATURATION is causal (fix the model)
  signal unchanged                                 -> calibration is NOT the bottleneck

METHOD. Small pool -> exact distance. For each state: value_error = |V_IQN(s) - (-d_true)|
is the ground-truth "is the model wrong here". Signals tested, both read off the
distribution: WIDTH (q90-q10 of the best action's curve) and 1-step W1 Bellman residual
W1(Z(s,a*), -1 + gamma*Z(s',b*)). AUC = P(signal higher at a HIGH-error state than at a
LOW-error state), high/low = top/bottom tercile of value_error. 0.5 = no signal.

Run: venv/bin/python iqn_calibration_vs_signal.py \
       --domain_file ../Domains/Domains2/grid/domain.pddl \
       --instances ../Domains/Domains2/grid/instances --max_instances 40
"""
import argparse, glob, random, statistics
from pathlib import Path
import torch, pymimir as mm
from utils import create_device
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves, rank_auc
from bellman_statespace_label import sample_states

GAMMA = 0.999

def w1(a, b):
    return (a.sort().values - b.sort().values).abs().mean().item()

def collect(model, taus, domain, files, a):
    rng = random.Random(a.seed); rows = []; used = 0
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
                d = lab.steps_to_goal
                qs, acts = iqn_curves(model, s, goal, taus)
                if qs is None or not acts: continue
                means = qs.mean(dim=1); ai = int(means.argmax())
                V = means[ai].item()
                err = abs(V - (-float(d)))                      # ground-truth model error
                cur = qs[ai]
                width = (cur.quantile(0.9) - cur.quantile(0.1)).item()
                s2 = acts[ai].apply(s)
                l2 = ss.get_state_label(s2)
                res = None
                if not l2.is_dead_end:
                    q2, a2 = iqn_curves(model, s2, goal, taus)
                    if q2 is not None and a2:
                        bi = int(q2.mean(dim=1).argmax())
                        res = w1(cur, -1 + GAMMA * q2[bi])
                rows.append((d, err, width, res))
            used += 1
    return rows

def auc_by_band(rows, idx, bands):
    out = []
    for lo, hi in bands:
        g = [r for r in rows if lo <= r[0] <= hi and r[idx] is not None]
        if len(g) < 30: out.append(None); continue
        errs = sorted(r[1] for r in g)
        loq, hiq = errs[len(errs)//3], errs[2*len(errs)//3]
        hi_e = [r[idx] for r in g if r[1] >= hiq]
        lo_e = [r[idx] for r in g if r[1] <= loq]
        out.append(rank_auc(hi_e, lo_e) if len(hi_e) > 5 and len(lo_e) > 5 else None)
    return out

ap = argparse.ArgumentParser()
ap.add_argument("--domain_file", required=True, type=Path)
ap.add_argument("--instances", required=True, type=Path)
ap.add_argument("--max_instances", default=40, type=int)
ap.add_argument("--max_states", default=200_000, type=int)
ap.add_argument("--score_states", default=45, type=int)
ap.add_argument("--seed", default=0, type=int)
a = ap.parse_args()

dev = create_device(False); domain = mm.Domain(str(a.domain_file))
taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
files = [p for p in sorted(glob.glob(str(a.instances / "*.pddl"))) if "domain" not in p]
random.Random(a.seed).shuffle(files)
BANDS = [(1, 10), (11, 22)]

print("\nDoes better calibration improve the DISTRIBUTIONAL signal?")
print("AUC = P(signal higher where the model is actually MORE wrong). 0.5 = no signal.\n")
print(f"{'model':<26}{'signal':<9}{'d 1-10':>9}{'d 11-22':>10}{'mean |err|':>12}")
for name, path in (("grid_iqn (old, saturated)", "models/grid_iqn.pth"),
                   ("fix_noctx (FiLM)", "models/grid_iqn_fix_noctx_best.pth"),
                   ("fix_full (FiLM+ctx)", "models/grid_iqn_fix_full_best.pth"),
                   ("qrdqn (+ctx) WINNER", "models/grid_iqn_qrdqn_best.pth")):
    m, _, _ = _load_iqn(domain, Path(path), dev); m.eval()
    rows = collect(m, taus, domain, files, a)
    me = statistics.mean(r[1] for r in rows)
    for sig, idx in (("width", 2), ("W1 resid", 3)):
        vals = auc_by_band(rows, idx, BANDS)
        cells = "".join(f"{v:>9.3f}" if v is not None else f"{'-':>9}" for v in vals)
        print(f"{name:<26}{sig:<9}{cells:>19}{me:>12.2f}")
print("\nIf nobounds (better calibrated) scores HIGHER -> saturation is causal.")
print("If the two are the same -> calibration is NOT the bottleneck; skip the architecture work.")
