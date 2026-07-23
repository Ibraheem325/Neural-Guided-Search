"""Three-way signal comparison on the probe dataset, exact distance labels.

Measures, on the SAME states, three candidate per-state signals from the QR-DQN:
    width       = q90 - q10 of the best action's quantile curve      (within-state spread)
    edge_w1     = W1( Z_best(s), Z_best(s') )                        (RAW parent-child shift)
    bellman_w1  = W1( Z_best(s), -1 + gamma*Z_best(s') )             (Bellman inconsistency)
where s' is the greedy (best-action) successor.

Label = SAC-ensemble disagreement  D(s) = pstdev over 5 members of max_a min(q1_i,q2_i)(s,a)
(the "model is uncertain here" ground truth; needs no oracle).

AUC = P(signal higher at a HIGH-disagreement state than at a LOW-disagreement state),
tercile split, computed WITHIN each exact distance-to-goal (so distance cannot confound).

States: every state on each probe's optimal plan tail, so the exact remaining distance is
known at every step. Run: venv/bin/python probe_signal_auc.py
"""
import glob, os, csv, io, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from collections import defaultdict
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn

PROBE = "example/probe_near_goal_d5-20"
GAMMA = 0.999
BATCH = 32
dev = create_device(False)
dom = mm.Domain(f"{PROBE}/domain.pddl")

iqn, _, _ = _load_iqn(dom, Path("models/grid_iqn_qrdqn_best.pth"), dev); iqn.eval()
TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
ens = []
for i in range(1, 6):
    q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q1_best.pth"), dev)[0], "q")
    q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q2_best.pth"), dev)[0], "q")
    ens.append((q1, q2))
canon = lambda x: str(x).lower().replace(" ", "")


@torch.no_grad()
def best_curve(state, goal):
    """Sorted best-action quantile curve + its width, or None at a dead end."""
    q, actions = iqn.forward([(state, goal)], taus=TAUS)[0]
    if q.shape[0] == 0:
        return None, None, None
    qs, _ = torch.sort(q, dim=1)
    bi = int(qs.mean(dim=1).argmax())
    return qs[bi], (qs[bi][89] - qs[bi][9]).item(), actions[bi]


@torch.no_grad()
def disagreement_batch(pairs):
    """D(s) for a batch of (state, goal); one forward per member per batch."""
    per_member = []
    for q1, q2 in ens:
        v1 = q1.forward(pairs); v2 = q2.forward(pairs)
        per_member.append([torch.minimum(a[0], b[0]).max().item() for a, b in zip(v1, v2)])
    return [statistics.pstdev([m[i] for m in per_member]) for i in range(len(pairs))]


# ---- collect states along every probe's optimal plan tail (exact remaining distance) ----
rows = []           # (dist, width, edge_w1, bellman_w1, state, goal)
# IMPORTANT: probes carved from the SAME source problem are nested on ONE optimal
# trajectory (the d=5 probe's init is the state 5 steps from goal on the d=20 probe's
# path). Walking all 480 tails would therefore re-walk each path ~16x and produce
# duplicated states with zero within-distance variance. Take the DEEPEST probe per
# source problem only -> 30 distinct trajectories, 30 distinct states per exact distance.
_all = sorted(f for f in glob.glob(f"{PROBE}/*.pddl") if "domain" not in os.path.basename(f))
_deepest = {}
for f in _all:
    parts = os.path.basename(f)[:-5].split("_")
    src = "_".join(parts[2:]); dist = int(parts[1][1:])
    if src not in _deepest or dist > _deepest[src][0]:
        _deepest[src] = (dist, f)
files = [v[1] for _, v in sorted(_deepest.items())]
_lim = int(os.environ.get("LIMIT", "0"))
if _lim:
    files = files[:_lim]
print(f"{len(files)} source problems (deepest probe each); walking their optimal paths", flush=True)
for n, pf in enumerate(files):
    plan_lines = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
    prob = mm.Problem(dom, pf)
    s = prob.get_initial_state(); g = prob.get_goal_condition()
    for i, line in enumerate(plan_lines):
        d = len(plan_lines) - i                      # exact remaining distance at s
        cs, width, best_a = best_curve(s, g)
        if cs is not None:
            nxt = best_a.apply(s)                    # GREEDY successor (model's own choice)
            cn, _, _ = best_curve(nxt, g)
            if cn is not None:
                e_w1 = (cs - cn).abs().mean().item()
                b_w1 = (cs - (-1.0 + GAMMA * cn)).abs().mean().item()
                rows.append([d, width, e_w1, b_w1, s, g])
        # advance along the OPTIMAL plan
        nxt_a = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
        if nxt_a is None:
            break
        s = nxt_a.apply(s)
    if (n + 1) % 40 == 0:
        print(f"  ...{n+1}/{len(files)} probes, {len(rows)} states", flush=True)

print(f"collected {len(rows)} states; computing ensemble disagreement...", flush=True)
dis = []
for i in range(0, len(rows), BATCH):
    chunk = rows[i:i + BATCH]
    dis.extend(disagreement_batch([(r[4], r[5]) for r in chunk]))
    if (i // BATCH) % 20 == 0:
        print(f"  ...{i}/{len(rows)}", flush=True)


def auc(sig_hi, sig_lo):
    """P(signal higher in HIGH-disagreement group), ties=0.5."""
    if not sig_hi or not sig_lo:
        return float("nan")
    wins = sum((a > b) + 0.5 * (a == b) for a in sig_hi for b in sig_lo)
    return wins / (len(sig_hi) * len(sig_lo))


by_d = defaultdict(list)
for r, dv in zip(rows, dis):
    by_d[r[0]].append((dv, r[1], r[2], r[3]))

print(f"\n{'dist':>5}{'n':>6}{'width':>9}{'edge_W1':>10}{'bellman_W1':>12}")
allrows = []
for d in sorted(by_d):
    v = by_d[d]
    if len(v) < 12:
        continue
    v.sort(key=lambda t: t[0])                       # sort by disagreement
    k = len(v) // 3
    lo, hi = v[:k], v[-k:]                           # tercile split
    a_w = auc([x[1] for x in hi], [x[1] for x in lo])
    a_e = auc([x[2] for x in hi], [x[2] for x in lo])
    a_b = auc([x[3] for x in hi], [x[3] for x in lo])
    print(f"{d:>5}{len(v):>6}{a_w:>9.3f}{a_e:>10.3f}{a_b:>12.3f}")
    allrows.append((d, len(v), a_w, a_e, a_b))

# pooled over distance bands
print(f"\n{'band':>10}{'n':>7}{'width':>9}{'edge_W1':>10}{'bellman_W1':>12}")
for name, lo_d, hi_d in [("d1-4", 1, 4), ("d5-8", 5, 8), ("d9-12", 9, 12),
                         ("d13-16", 13, 16), ("d17-20", 17, 20)]:
    v = [t for d in by_d if lo_d <= d <= hi_d for t in by_d[d]]
    if len(v) < 12:
        continue
    v.sort(key=lambda t: t[0]); k = len(v) // 3
    lo, hi = v[:k], v[-k:]
    print(f"{name:>10}{len(v):>7}"
          f"{auc([x[1] for x in hi],[x[1] for x in lo]):>9.3f}"
          f"{auc([x[2] for x in hi],[x[2] for x in lo]):>10.3f}"
          f"{auc([x[3] for x in hi],[x[3] for x in lo]):>12.3f}")

# dynamic range: is each signal near-constant among comparable states?
print("\nDYNAMIC RANGE (coefficient of variation within each exact distance, median over d):")
for idx, nm in [(1, "width"), (2, "edge_W1"), (3, "bellman_W1")]:
    cvs = []
    for d in by_d:
        xs = [t[idx] for t in by_d[d]]
        if len(xs) >= 12 and statistics.mean(xs) != 0:
            cvs.append(statistics.pstdev(xs) / abs(statistics.mean(xs)))
    if cvs:
        print(f"  {nm:>11}: CV = {statistics.median(cvs):.3f}")
