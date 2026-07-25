"""Does the width signal detect uncertainty AMONG SIBLINGS, on search-visited nodes?

This decouples "detects uncertainty" from "reduces expansions". At each node the
sibling channel fires on, it ranks the node's applicable actions by QR-DQN width and
boosts the widest. The clean question: does that width ranking match the TRUE
uncertainty ranking (SAC-ensemble disagreement) among those same siblings?

For each search-visited node with >=2 actions, at the PARENT state s:
    width(a)    = q90 - q10 of QR-DQN Z(s,a)
    disagree(a) = pstdev over 5 SAC members of min(q1_i,q2_i)(s,a)          (uncertainty label)
Then measure within-node agreement of the two rankings (pairwise concordance = AUC,
and Spearman). Aggregate over nodes, sliced by the node's estimated distance
(-mean QR-DQN value). Search-visited nodes come from running the BASELINE search.

Run: venv/bin/python sibling_uncertainty_auc.py
"""
import glob, os, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from collections import defaultdict
from utils import create_device, get_state_key
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn

PROBE = "example/probe_near_goal_d5-20"
NODES_PER_INST = 70
N_INST = 12
dev = create_device(False)
dom = mm.Domain(f"{PROBE}/domain.pddl")
policy = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_policy.pth"), dev)[0], "policy")
q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q1.pth"), dev)[0], "q")
q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q2.pth"), dev)[0], "q")
iqn, _, _ = _load_iqn(dom, Path("models/grid_iqn_qrdqn_best.pth"), dev); iqn.eval()
TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
ens = []
for i in range(1, 6):
    e1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q1_best.pth"), dev)[0], "q")
    e2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q2_best.pth"), dev)[0], "q")
    ens.append((e1, e2))
canon = lambda x: str(x).lower().replace(" ", "")


@torch.no_grad()
def per_action(state, goal):
    """Return dict action_canon -> (width, disagreement, qrdqn_mean) at this state."""
    q, actions = iqn.forward([(state, goal)], taus=TAUS)[0]
    if q.shape[0] < 2:
        return None
    qs, _ = torch.sort(q, dim=1)
    width = {canon(str(a)): (qs[i][89] - qs[i][9]).item() for i, a in enumerate(actions)}
    qmean = {canon(str(a)): qs[i].mean().item() for i, a in enumerate(actions)}
    # ensemble per-action value min(q1,q2) for each member
    per_member = []
    for e1, e2 in ens:
        v1, acts1 = e1.forward([(state, goal)])[0]
        v2, _ = e2.forward([(state, goal)])[0]
        vm = torch.minimum(v1, v2)
        per_member.append({canon(str(a)): vm[i].item() for i, a in enumerate(acts1)})
    disagree = {}
    for ac in width:
        vals = [m[ac] for m in per_member if ac in m]
        disagree[ac] = statistics.pstdev(vals) if len(vals) >= 2 else 0.0
    return width, disagree, qmean


def pairwise_auc(order_vals, label_vals):
    """Within-node: P(label higher for the higher-order item), over all sibling pairs."""
    keys = list(order_vals)
    wins = tot = 0.0
    for i in range(len(keys)):
        for j in range(i + 1, len(keys)):
            a, b = keys[i], keys[j]
            do, dl = order_vals[a] - order_vals[b], label_vals[a] - label_vals[b]
            if do == 0:
                continue
            tot += 1
            hi = a if do > 0 else b
            lo = b if do > 0 else a
            wins += (label_vals[hi] > label_vals[lo]) + 0.5 * (label_vals[hi] == label_vals[lo])
    return wins, tot


# ---- collect search-visited parent states from the BASELINE search ----
files = sorted(f for f in glob.glob(f"{PROBE}/*.pddl") if "domain" not in os.path.basename(f))
# spread across distances & take bushy ones (deepest-per-source gives distinct trajectories)
deepest = {}
for f in files:
    p = os.path.basename(f)[:-5].split("_"); src = "_".join(p[2:]); d = int(p[1][1:])
    if src not in deepest or d > deepest[src][0]:
        deepest[src] = (d, f)
sample = [v[1] for _, v in sorted(deepest.items())][:N_INST]

visited = []  # list of (state, goal)
orig_expand = AZ._expand
def hook(node, tt, pol, m1, m2, goal, dev_):
    if len(visited) < hook.cap and not node.is_goal:
        visited.append((node.state, goal))
    return orig_expand(node, tt, pol, m1, m2, goal, dev_)

for pf in sample:
    prob = mm.Problem(dom, pf); g = prob.get_goal_condition(); s = prob.get_initial_state()
    AZ._SIG.__init__()
    hook.cap = len(visited) + NODES_PER_INST
    AZ._expand = hook
    with torch.no_grad():
        AZ._search(s, get_state_key(s), policy, q1, q2, g, 10**9, 30.0, 1.5, -1000.0, True)
    AZ._expand = orig_expand
print(f"collected {len(visited)} search-visited nodes from {len(sample)} instances", flush=True)

# ---- measure width-ranking vs disagreement-ranking among siblings (single pass) ----
bands = defaultdict(lambda: [0.0, 0.0])       # dist-band -> [wins, tot]
overall = [0.0, 0.0]
cw = [0.0, 0.0]; cd = [0.0, 0.0]              # value controls
n_used = 0
for k, (s, g) in enumerate(visited):
    r = per_action(s, g)
    if r is None:
        continue
    width, disagree, qmean = r
    if len(width) < 2:
        continue
    n_used += 1
    w, t = pairwise_auc(width, disagree)
    overall[0] += w; overall[1] += t
    dist = -statistics.mean(qmean.values())          # proxy distance
    band = "d0-5" if dist <= 5 else "d5-10" if dist <= 10 else "d10-15" if dist <= 15 else "d15-20" if dist <= 20 else "d20+"
    bands[band][0] += w; bands[band][1] += t
    negq = {a: -v for a, v in qmean.items()}
    w2, t2 = pairwise_auc(width, negq); cw[0] += w2; cw[1] += t2
    w3, t3 = pairwise_auc(disagree, negq); cd[0] += w3; cd[1] += t3
    if (k + 1) % 200 == 0:
        print(f"  ...{k+1}/{len(visited)}", flush=True)

print(f"\nSIBLING uncertainty-detection AUC (width-order vs ensemble-disagreement), {n_used} nodes")
print(f"  OVERALL: {overall[0]/overall[1]:.3f}  (0.5 = width ranks siblings no better than chance)")
print(f"\n  {'band(proxy d)':>14}{'nodes*pairs':>13}{'AUC':>8}")
for band in ["d0-5", "d5-10", "d10-15", "d15-20", "d20+"]:
    w, t = bands[band]
    if t >= 20:
        print(f"  {band:>14}{int(t):>13}{w/t:>8.3f}")
print("\n(control) do the rankings just track distance/value rather than uncertainty?")
print(f"  width    vs -value AUC:  {cw[0]/cw[1]:.3f}")
print(f"  disagree vs -value AUC:  {cd[0]/cd[1]:.3f}")
