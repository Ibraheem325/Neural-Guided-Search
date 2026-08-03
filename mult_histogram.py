"""Empirical distribution of mult(a) = max(0.1, 1 + beta*(rel-1)) on real probe states.

rel(a) = binc(a) / mean_over_siblings(binc), where binc is the 1-step min-W1
Bellman inconsistency -- exactly as computed in alphaZero_bellman._compute_binc_mult.

Usage:  venv/bin/python mult_histogram.py <probe_dir> <qrdqn.pth> [n_states]
"""
import sys, glob, os, statistics as st, torch, pymimir as mm
from pathlib import Path
from utils import create_device
from train_iqn import _load_model as _load_iqn

PROBE = sys.argv[1]; MODEL = sys.argv[2]
NMAX = int(sys.argv[3]) if len(sys.argv) > 3 else 400
GAMMA, REWARD, EPS = 0.999, -1.0, 0.0
BETAS = [1.0, 2.0, 4.0, 6.0, 8.0, 12.0]

dev = create_device(False)
dom = mm.Domain(PROBE + "/domain.pddl")
iqn, _, _ = _load_iqn(dom, Path(MODEL), dev); iqn.eval()
TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
canon = lambda x: str(x).lower().replace(" ", "")


@torch.no_grad()
def curves(state, goal):
    q, acts = iqn.forward([(state, goal)], taus=TAUS)[0]
    if q.shape[0] == 0: return None, None
    qs, _ = torch.sort(q, dim=1)
    return qs, acts


@torch.no_grad()
def rels_at(state, goal):
    qs, acts = curves(state, goal)
    if qs is None or len(acts) < 2: return []
    amap = {canon(str(a)): i for i, a in enumerate(acts)}
    w1s = []
    for a in acts:
        ai = amap.get(canon(str(a)))
        z = qs[ai]; cur = a.apply(state)
        if goal.holds(cur):
            w1s.append((z - torch.full_like(z, REWARD)).abs().mean().item()); continue
        cqs, _ = curves(cur, goal)
        if cqs is None: continue
        tgt = REWARD + GAMMA * cqs
        sc = cqs.mean(dim=1)
        w1 = (z.unsqueeze(0) - tgt).abs().mean(dim=1)
        w1s.append(w1[sc >= sc.max() - EPS].min().item())
    if len(w1s) < 2: return []
    m = sum(w1s) / len(w1s)
    return [w / m for w in w1s] if m > 1e-9 else []


files = sorted(f for f in glob.glob(PROBE + "/*.pddl") if "domain" not in os.path.basename(f))
files = files[:: max(1, len(files) // 80)]
REL = []
for pf in files:
    prob = mm.Problem(dom, pf); s = prob.get_initial_state(); g = prob.get_goal_condition()
    plan = [l.strip() for l in open(pf + ".plan")] if os.path.exists(pf + ".plan") else []
    plan = [l for l in plan if l.startswith("(")]
    for line in [None] + plan[:6]:
        if line is not None:
            nxt = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
            if nxt is None: break
            s = nxt.apply(s)
        REL += rels_at(s, g)
        if len(REL) >= NMAX * 4: break
    if len(REL) >= NMAX * 4: break

print(f"probe set: {PROBE}\nmodel: {MODEL}\nsibling edges sampled: {len(REL)}\n")
def q(v, p): v = sorted(v); return v[min(int(p * len(v)), len(v) - 1)]
print(f"rel(a):  min {min(REL):.3f}  p50 {q(REL,.5):.3f}  p90 {q(REL,.9):.3f}  "
      f"p99 {q(REL,.99):.3f}  MAX {max(REL):.3f}")
print()
hdr = f"{'beta':>5}{'min':>8}{'p50':>8}{'p90':>8}{'p99':>8}{'MAX':>10}{'mean':>8}{'%at floor':>11}{'%>2':>7}{'%>5':>7}{'%>10':>7}"
print(hdr); print("-" * len(hdr))
for b in BETAS:
    M = [max(0.1, 1.0 + b * (r - 1.0)) for r in REL]
    print(f"{b:>5}{min(M):>8.2f}{q(M,.5):>8.2f}{q(M,.9):>8.2f}{q(M,.99):>8.2f}{max(M):>10.2f}"
          f"{sum(M)/len(M):>8.2f}{100*sum(1 for x in M if x<=0.1001)/len(M):>10.1f}%"
          f"{100*sum(1 for x in M if x>2)/len(M):>6.1f}%{100*sum(1 for x in M if x>5)/len(M):>6.1f}%"
          f"{100*sum(1 for x in M if x>10)/len(M):>6.1f}%")

print("\nHISTOGRAM of mult(a)")
edges = [0.1, 0.5, 0.9, 1.0, 1.1, 1.5, 2, 3, 5, 10, 20, 50, 1e9]
lbl = ["=0.10 (floor)", "0.1-0.5", "0.5-0.9", "0.9-1.0", "1.0-1.1", "1.1-1.5",
       "1.5-2", "2-3", "3-5", "5-10", "10-20", "20-50", ">50"]
for b in [2.0, 8.0, 12.0]:
    M = [max(0.1, 1.0 + b * (r - 1.0)) for r in REL]
    print(f"\n  beta={b}")
    for i, name in enumerate(lbl):
        lo = -1 if i == 0 else edges[i - 1]
        hi = edges[i] if i < len(edges) else 1e9
        c = sum(1 for x in M if (x <= 0.1001 if i == 0 else lo < x <= hi))
        pct = 100 * c / len(M)
        print(f"    {name:<14} {c:>6}  {pct:>5.1f}%  {'#' * int(pct / 2)}")
