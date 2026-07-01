#!/usr/bin/env python3
"""
grid_shift_vs_discovered.py
============================================================================
Follow-up to Level-2 discovery. Level 2 found grid's error is driven mainly by
KEY MULTIPLICITY (num_keys>=3, lift ~2.2) and, sharply but rarely, by the
WRONG-KEY TRAP (holding+lock_adj+mismatch, lift ~1.8).

The deployable trigger is the distributional shift W1 (best s-a -> best
successor s-a). For W1 to be useful it must track the bottleneck that actually
drives error -- i.e. the DISCOVERED one (key multiplicity), not only the assumed
one. This script tests that.

For each state we record: W1, model error, and the discovered descriptors.
Then:
  (1) Spearman(W1, error) overall  -- baseline.
  (2) Does W1 rise with num_keys?   mean W1 by key-count bucket.
  (3) Within high-key states, does W1 still track error? (partial: W1 vs error
      controlling for num_keys, and vice versa) -- separates "W1 just flags
      complex instances" from "W1 flags genuine per-state trouble".
  (4) W1 at wrong-key-trap vs elsewhere (re-confirm the sharp signal).

Usage:
  venv/bin/python grid_shift_vs_discovered.py \
      --domain example/grid_dataset/domain.pddl \
      --instances example/grid_dataset/train \
      --model models/grid_iqn.pth --seeds 42 43 44
============================================================================
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def atoms_by_pred(state):
    d = {}
    for atom in state.get_atoms():
        d.setdefault(atom.get_predicate().get_name(), []).append([str(t) for t in atom.get_terms()])
    return d


def features(state):
    a = atoms_by_pred(state)
    holding = a.get('holding', [])
    keyshape = {k[0]: k[1] for k in a.get('key-shape', [])}
    lockshape = {l[0]: l[1] for l in a.get('lock-shape', [])}
    locked = {l[0] for l in a.get('locked', [])}
    robot = [r[0] for r in a.get('at-robot', [])]
    conn = a.get('conn', [])
    keys = {k[0] for k in a.get('key', [])}
    held = {h[0] for h in holding}
    rpos = robot[0] if robot else None
    adj = ({c[1] for c in conn if c[0] == rpos} | {c[0] for c in conn if c[1] == rpos}) if rpos else set()
    adj_locked = [lp for lp in locked if lp in adj]
    held_shapes = {keyshape.get(h) for h in held}
    adj_lock_shapes = {lockshape.get(lp) for lp in adj_locked}
    match_adj = bool(held_shapes & adj_lock_shapes) if (held and adj_locked) else False
    wrong_key_trap = (len(held) > 0) and len(adj_locked) > 0 and not match_adj
    return len(keys), wrong_key_trap


def spearman(a, b):
    a, b = np.asarray(a, float), np.asarray(b, float)
    if len(a) < 3 or a.std() == 0 or b.std() == 0: return float('nan')
    return float(np.corrcoef(np.argsort(np.argsort(a)), np.argsort(np.argsort(b)))[0, 1])


def partial(a, b, c):
    ra, rb, rc = (np.argsort(np.argsort(x)).astype(float) for x in (a, b, c))
    ra = ra - np.polyval(np.polyfit(rc, ra, 1), rc)
    rb = rb - np.polyval(np.polyfit(rc, rb, 1), rc)
    if ra.std() == 0 or rb.std() == 0: return float('nan')
    return float(np.corrcoef(ra, rb)[0, 1])


def w1(q1, q2): return float(np.mean(np.abs(q1 - q2)))


def collect(domain, model, instances, taus, seed, cap, maxi, sper):
    random.seed(seed)
    files = sorted(f for f in Path(instances).glob('*.pddl') if f.name != 'domain.pddl')
    W, ERR, NKEY, TRAP, DEPTH = [], [], [], [], []
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(seed); goal = p.get_goal_condition(); used += 1
            states = ss.get_states(); random.shuffle(states); taken = 0
            for s in states:
                if taken >= sper: break
                ls = ss.get_state_label(s)
                if ls.is_goal: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 1: continue
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                qs, _ = torch.sort(qv, dim=1); means = qs.mean(dim=1)
                best = int(means.argmax().item()); q_s = qs[best].cpu().numpy()
                s2 = acts[best].apply(s); ls2 = ss.get_state_label(s2)
                if ls2 is not None and ls2.is_goal:
                    wv = 0.0
                else:
                    acts2 = s2.generate_applicable_actions()
                    if len(acts2) < 1:
                        taken += 1; continue
                    qv2, _ = model.forward([(s2, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                    qs2, _ = torch.sort(qv2, dim=1); means2 = qs2.mean(dim=1)
                    b2 = int(means2.argmax().item()); wv = w1(q_s, qs2[b2].cpu().numpy())
                nk, trap = features(s)
                W.append(wv); ERR.append(abs(means[best].item() - (-float(ls.steps_to_goal))))
                NKEY.append(nk); TRAP.append(trap); DEPTH.append(float(ls.steps_to_goal)); taken += 1
            if used >= maxi: break
    return map(np.array, (W, ERR, NKEY, TRAP, DEPTH))


def report(tag, W, ERR, NKEY, TRAP, DEPTH):
    print(f"\n================  {tag}  ================")
    print(f"states={len(W)}")
    print(f"(1) Spearman(W1, error)            = {spearman(W, ERR):+.3f}")
    print(f"    Spearman(W1, num_keys)         = {spearman(W, NKEY):+.3f}")
    print(f"    Spearman(error, num_keys)      = {spearman(ERR, NKEY):+.3f}")
    print(f"    PARTIAL(W1, error | depth)     = {partial(W, ERR, DEPTH):+.3f}  <- depth-controlled, matches the width 0.37 number")
    print(f"(3) PARTIAL(W1, error | num_keys)  = {partial(W, ERR, NKEY):+.3f}  <- W1 flags per-state trouble beyond instance complexity?")
    print(f"    PARTIAL(W1, num_keys | error)  = {partial(W, NKEY, ERR):+.3f}  <- or does W1 just flag complex instances?")
    print("(2) mean W1 by key-count:")
    for k in sorted(set(NKEY.tolist())):
        m = NKEY == k
        if m.sum() >= 10:
            print(f"      num_keys={int(k)}: n={int(m.sum())} meanW1={W[m].mean():.3f}  meanErr={ERR[m].mean():.3f}")
    t = TRAP.astype(bool)
    if t.sum() >= 5:
        print(f"(4) wrong-key-trap: W1={W[t].mean():.3f} (n={int(t.sum())}) vs elsewhere {W[~t].mean():.3f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True); ap.add_argument('--instances', required=True)
    ap.add_argument('--model', required=True); ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=200_000); ap.add_argument('--max-instances', type=int, default=60)
    ap.add_argument('--states-per-instance', type=int, default=40); ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()
    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)
    print("="*70); print("W1 shift vs DISCOVERED bottleneck (key multiplicity) — grid")
    print(f"model: {args.model}  seeds: {args.seeds}"); print("="*70)
    AW, AE, AN, AT, AD = [], [], [], [], []
    for sd in args.seeds:
        W, E, N, T, D = collect(domain, model, args.instances, taus, sd,
                              args.state_cap, args.max_instances, args.states_per_instance)
        report(f"SEED {sd}", W, E, N, T, D)
        AW.append(W); AE.append(E); AN.append(N); AT.append(T); AD.append(D)
    if len(args.seeds) > 1:
        report("POOLED", *[np.concatenate(x) for x in (AW, AE, AN, AT, AD)])
    print("\nRead: if PARTIAL(W1,error|num_keys) stays >0, W1 flags genuine per-state")
    print("trouble beyond just 'complex instance'. If it collapses, W1 mostly tracks")
    print("instance complexity. Both can be true; the partial says how much is per-state.")


if __name__ == '__main__':
    main()