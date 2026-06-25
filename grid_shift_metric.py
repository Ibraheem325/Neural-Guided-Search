#!/usr/bin/env python3
"""
grid_shift_metric.py
============================================================================
Supervisor's reformulation (Phase II):

  The decision-relevant signal is not absolute width, but how much the value
  DISTRIBUTION changes shape between a state's best action and the best action
  at the successor it leads to. If they look the same -> model is consistent /
  certain there -> no need to explore. If the shape SHIFTS -> belief is unstable
  -> that's where search effort should go. (Uncertainty propagates backward, so
  depth-correlation of width is partly expected, not purely a confound.)

  Claim to test on GRID: grid's expressivity issue is LOCALIZED (key / lock /
  key-shape matching). So the distributional shift should (a) predict model
  error, and (b) be CONCENTRATED at a small set of states -- specifically the
  unlock-decision states -- rather than spread out everywhere (contrast: rovers,
  where the issue is non-localized).

Two passes, both for grid only:

  PASS A (domain-agnostic metric):
    Per state s (greedy-best action a*), and its greedy-best successor s'
    (greedy-best action a*'):
      - W1   = 1-Wasserstein between the two sorted quantile curves
               (avg shift in value units; captures full shape change)
      - dW   = signed width change  width(s') - width(s)   (spread change only)
    Report:
      - Spearman(W1, model_error)         : does shift flag error?
      - Spearman(|dW|, model_error)
      - localization: Gini concentration of W1 across states
        (high Gini => shift concentrated in few states => "localized")

  PASS B (grid-specific ground truth):
    Label each state as UNLOCK-CRITICAL if the robot is holding a key AND a
    locked cell is reachable whose shape match/mismatch with the held key
    decides progress (i.e. an unlock is applicable, OR robot holds a key and an
    adjacent locked cell has a DIFFERENT shape -> "holding wrong key" trap).
    Test: is W1 (and width) higher at unlock-critical states than elsewhere?
    This checks the shift fires at the RIGHT places, not just somewhere.

Usage:
  venv/bin/python grid_shift_metric.py \
      --domain example/grid_dataset/domain.pddl \
      --instances example/grid_dataset/train \
      --model models/grid_iqn.pth \
      [--seeds 42 43 44] [--state-cap 200000] [--max-instances 60]
============================================================================
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model

# ---- helpers ----
def gini(x):
    x = np.sort(np.asarray(x, float))
    n = len(x)
    if n == 0 or x.sum() == 0: return float('nan')
    cum = np.cumsum(x)
    return (n + 1 - 2 * (cum / cum[-1]).sum() / 1) / n  # standard Gini

def gini_coeff(x):
    x = np.sort(np.asarray(x, float))
    n = len(x)
    if n == 0 or x.sum() == 0: return float('nan')
    idx = np.arange(1, n + 1)
    return (2 * (idx * x).sum() / (n * x.sum())) - (n + 1) / n

def spearman(a, b):
    a, b = np.asarray(a, float), np.asarray(b, float)
    if len(a) < 3 or a.std() == 0 or b.std() == 0: return float('nan')
    ra = np.argsort(np.argsort(a)); rb = np.argsort(np.argsort(b))
    return float(np.corrcoef(ra, rb)[0, 1])

def wasserstein1(q1, q2):
    # both are sorted quantile vectors on the same tau grid -> W1 = mean |q1-q2|
    return float(np.mean(np.abs(q1 - q2)))

# ---- grid-specific state labeling ----
def atoms_by_pred(state):
    d = {}
    for atom in state.get_atoms():
        name = atom.get_predicate().get_name()
        d.setdefault(name, []).append([str(o) for o in atom.get_objects()])
    return d

def is_unlock_critical(state):
    """
    Robot holds a key, and a locked cell is reachable from the robot's cell.
    If the held key's shape matches that lock -> unlock applicable (decision point).
    If it does NOT match -> 'holding wrong key' trap (also a decision point where
    the model must represent shape-matching to know it's stuck).
    Returns (is_critical, matches) where matches indicates a shape match exists.
    """
    a = atoms_by_pred(state)
    holding = a.get('holding', [])
    if not holding:
        return False, False
    held_keys = {h[0] for h in holding}
    keyshape = {k[0]: k[1] for k in a.get('key-shape', [])}        # key -> shape
    lockshape = {l[0]: l[1] for l in a.get('lock-shape', [])}      # lockpos -> shape
    locked = {l[0] for l in a.get('locked', [])}
    robot = [r[0] for r in a.get('at-robot', [])]
    if not robot:
        return False, False
    rpos = robot[0]
    conn = a.get('conn', [])
    adj = {c[1] for c in conn if c[0] == rpos} | {c[0] for c in conn if c[1] == rpos}
    # reachable locked cells adjacent to robot
    crit = False; match = False
    for lp in locked:
        if lp in adj:
            crit = True
            for hk in held_keys:
                if keyshape.get(hk) == lockshape.get(lp):
                    match = True
    return crit, match


def collect(domain, model, instances, taus, seed, state_cap, max_instances, states_per):
    random.seed(seed)
    files = sorted(f for f in Path(instances).glob('*.pddl') if f.name != 'domain.pddl')
    rows = []  # dict per state
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, state_cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(seed)
            goal = p.get_goal_condition()
            used += 1
            states = ss.get_states(); random.shuffle(states)
            taken = 0
            for s in states:
                if taken >= states_per: break
                ls = ss.get_state_label(s)
                if ls.is_goal: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 1: continue
                # distribution at s for all actions
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                qs, _ = torch.sort(qv, dim=1)
                means = qs.mean(dim=1)
                best = int(means.argmax().item())
                q_s = qs[best].cpu().numpy()
                width_s = q_s[90] - q_s[8]
                # greedy-best successor
                s2 = acts[best].apply(s)
                ls2 = ss.get_state_label(s2)
                # successor's best action distribution
                if ls2 is not None and ls2.is_goal:
                    # successor is goal: define a degenerate "certain" distribution shift = 0
                    W1 = 0.0; width_s2 = width_s
                else:
                    acts2 = s2.generate_applicable_actions()
                    if len(acts2) < 1:
                        # dead-ish; skip shift but keep error
                        W1 = float('nan'); width_s2 = float('nan')
                    else:
                        qv2, _ = model.forward([(s2, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                        qs2, _ = torch.sort(qv2, dim=1)
                        means2 = qs2.mean(dim=1)
                        best2 = int(means2.argmax().item())
                        q_s2 = qs2[best2].cpu().numpy()
                        width_s2 = q_s2[90] - q_s2[8]
                        W1 = wasserstein1(q_s, q_s2)
                err = abs(means[best].item() - (-float(ls.steps_to_goal)))
                crit, match = is_unlock_critical(s)
                rows.append(dict(
                    W1=W1, dW=abs(width_s2 - width_s) if width_s2==width_s2 else float('nan'),
                    width=width_s, err=err, depth=float(ls.steps_to_goal),
                    crit=crit, match=match))
                taken += 1
            if used >= max_instances: break
    return rows


def report(tag, rows):
    R = [r for r in rows if r['W1'] == r['W1']]   # drop nan W1
    W1 = np.array([r['W1'] for r in R])
    dW = np.array([r['dW'] for r in R])
    err = np.array([r['err'] for r in R])
    crit = np.array([r['crit'] for r in R])
    print(f"\n================  {tag}  ================")
    print(f"states (valid shift): {len(R)}   unlock-critical: {int(crit.sum())}")

    print("\n-- PASS A: does distributional SHIFT predict error? --")
    print(f"   Spearman(W1, error)   = {spearman(W1, err):+.3f}   (full shape-shift vs error)")
    print(f"   Spearman(|dW|, error) = {spearman(dW, err):+.3f}   (width-change only vs error)")
    print(f"   localization (Gini of W1) = {gini_coeff(W1):.3f}   (high => shift concentrated in few states)")
    print(f"   W1: median={np.median(W1):.3f} mean={W1.mean():.3f} max={W1.max():.3f}")

    print("\n-- PASS B: is shift higher at UNLOCK-CRITICAL states? --")
    if crit.sum() >= 5 and (~crit).sum() >= 5:
        print(f"   W1   at unlock-critical = {W1[crit].mean():.3f}  | elsewhere = {W1[~crit].mean():.3f}")
        print(f"   |dW| at unlock-critical = {dW[crit].mean():.3f}  | elsewhere = {dW[~crit].mean():.3f}")
        # split critical into shape-match vs mismatch (the 'wrong key' trap)
        m = np.array([r['match'] for r in R])
        cm = crit & m; cx = crit & (~m)
        if cm.sum() >= 5: print(f"   W1 critical+shapematch  (n={int(cm.sum())}) = {W1[cm].mean():.3f}")
        if cx.sum() >= 5: print(f"   W1 critical+mismatch    (n={int(cx.sum())}) = {W1[cx].mean():.3f}  (wrong-key trap)")
    else:
        print(f"   too few unlock-critical states (n={int(crit.sum())}) for a split")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True)
    ap.add_argument('--instances', required=True)
    ap.add_argument('--model', required=True)
    ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=200_000)
    ap.add_argument('--max-instances', type=int, default=60)
    ap.add_argument('--states-per-instance', type=int, default=40)
    ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()

    dev = torch.device('cpu')
    domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev)
    model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)

    print("="*76)
    print("GRID DISTRIBUTIONAL-SHIFT METRIC (best s-a -> best successor s-a)")
    print(f"model: {args.model}   seeds: {args.seeds}")
    print("="*76)
    allrows = []
    for sd in args.seeds:
        rows = collect(domain, model, args.instances, taus, sd,
                       args.state_cap, args.max_instances, args.states_per_instance)
        report(f"SEED {sd}", rows)
        allrows += rows
    if len(args.seeds) > 1:
        report("POOLED", allrows)

    print("\nInterpretation:")
    print("  PASS A Spearman(W1,error) > 0  -> distributional shift flags error.")
    print("  high Gini                      -> shift is LOCALIZED (grid prediction).")
    print("  PASS B W1(critical) > W1(else) -> shift fires at the RIGHT (unlock) states.")
    print("  wrong-key trap > shapematch    -> shift highest where model must represent")
    print("                                    shape-matching (the C2-hard decision).")


if __name__ == '__main__':
    main()