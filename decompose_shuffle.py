"""EXACTLY why does the (shuffled) width multiplier reduce expansions?

Decompose the per-node multiplier multiset into MEAN vs DISPERSION vs the 0.1 FLOOR,
by monkeypatching the sibling-mult computation with controlled variants and measuring
expansions-to-solution on the SAME probes (deterministic, so local == cluster).

Variants (all signal-BLIND except 'real'):
  baseline        : mult = 1 everywhere (no channel)
  real            : mult = max(0.1, 1+b*(w/mean-1))              width -> child (real signal)
  shuffle         : same multiset, permuted onto random children
  const_mean      : every child gets the node's MEAN real-mult   (dispersion OFF, mean ON)
  meannorm_shuf   : shuffle then divide by node mean -> mean=1    (dispersion ON, mean OFF)
  nofloor_shuf    : shuffle, mult=1+b*(w/mean-1) clamped>0 (NO 0.1 floor)
  uniform_rand    : mult ~ iid uniform on [0.1, 1+b], not from widths (pure random dispersion)

Reads: total expansions on the common-solved set for each variant -> which feature carries
the reduction. Run: venv/bin/python decompose_shuffle.py
"""
import glob, os, random, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device, get_state_key
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn

PROBE = "example/probe_near_goal_d5-20"
BETA = 2.0
MT = 120.0
dev = create_device(False)
dom = mm.Domain(f"{PROBE}/domain.pddl")
policy = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_policy.pth"), dev)[0], "policy")
q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q1.pth"), dev)[0], "q")
q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q2.pth"), dev)[0], "q")
iqn, _, _ = _load_iqn(dom, Path("models/grid_iqn_qrdqn_best.pth"), dev); iqn.eval()
TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
canon = AZ._canon

# high-room sample: bushy deep probes (baseline expands a lot)
want = ["453_d20_008_p-L9-9", "478_d20_101_p-H2-41", "280_d14_031_p-L7-8", "393_d18_008_p-L9-9",
        "423_d19_008_p-L9-9", "363_d17_008_p-L9-9", "418_d18_101_p-H2-41", "448_d19_101_p-H2-41",
        "333_d16_008_p-L9-9", "303_d15_008_p-L9-9", "243_d13_008_p-L9-9", "273_d14_008_p-L9-9",
        "458_d20_024_p-L8-7", "456_d20_016_p-L8-5", "390_d18_005_p-L6-3", "300_d15_005_p-L6-3"]
files = [f"{PROBE}/{w}.pddl" for w in want if os.path.exists(f"{PROBE}/{w}.pddl")]


def widths_of(node, goal):
    qs, actions = AZ._iqn_curves(node.state, goal)
    if qs is None:
        return None
    amap = {canon(str(a)): i for i, a in enumerate(actions)}
    w = {}
    for a in node.children:
        ai = amap.get(canon(str(a)))
        if ai is not None:
            w[a] = (qs[ai][89] - qs[ai][9]).item()
    return w if len(w) >= 2 else None


def make_variant(kind):
    def compute(node, goal):
        if len(node.prior) <= 1:
            return
        w = widths_of(node, goal)
        if w is None:
            return
        keys = list(w.keys()); vals = [w[k] for k in keys]
        mean_w = sum(vals) / len(vals)
        rng = random.Random(hash(node.state_key) & 0x7fffffff)
        if kind == "real":
            mult = {k: max(0.1, 1 + BETA * (w[k] / mean_w - 1)) for k in keys}
        elif kind == "shuffle":
            sv = vals[:]; rng.shuffle(sv)
            mult = {k: max(0.1, 1 + BETA * (sv[i] / mean_w - 1)) for i, k in enumerate(keys)}
        elif kind == "const_mean":
            m = {k: max(0.1, 1 + BETA * (w[k] / mean_w - 1)) for k in keys}
            avg = sum(m.values()) / len(m)
            mult = {k: avg for k in keys}
        elif kind == "meannorm_shuf":
            sv = vals[:]; rng.shuffle(sv)
            m = {k: max(0.1, 1 + BETA * (sv[i] / mean_w - 1)) for i, k in enumerate(keys)}
            avg = sum(m.values()) / len(m)
            mult = {k: m[k] / avg for k in keys}           # force per-node mean to 1
        elif kind == "nofloor_shuf":
            sv = vals[:]; rng.shuffle(sv)
            mult = {k: max(1e-3, 1 + BETA * (sv[i] / mean_w - 1)) for i, k in enumerate(keys)}
        elif kind == "uniform_rand":
            mult = {k: rng.uniform(0.1, 1 + BETA) for k in keys}
        for k, mv in mult.items():
            node.sib_mult[k] = mv
    return compute


def run(problem_file, kind):
    p = mm.Problem(dom, problem_file); s = p.get_initial_state(); g = p.get_goal_condition()
    AZ._SIG.__init__()
    if kind != "baseline":
        AZ._SIG.iqn = iqn; AZ._SIG.taus = TAUS; AZ._SIG.sib_beta = BETA
        AZ._compute_sib_mult = make_variant(kind)
    else:
        AZ._compute_sib_mult = orig_compute
    with torch.no_grad():
        plan, sims, gen = AZ._search(s, get_state_key(s), policy, q1, q2, g, 10**9, MT, 1.5, -1000.0, True)
    AZ._compute_sib_mult = orig_compute
    return gen, plan is not None


orig_compute = AZ._compute_sib_mult
variants = ["baseline", "real", "shuffle", "const_mean", "meannorm_shuf", "nofloor_shuf", "uniform_rand"]
res = {v: {} for v in variants}
for pf in files:
    name = os.path.basename(pf)[:-5]
    for v in variants:
        g, solved = run(pf, v)
        res[v][name] = (g, solved)
    print(f"{name:26} " + " ".join(f"{v[:5]}:{res[v][name][0]}{'' if res[v][name][1] else 'F'}" for v in variants), flush=True)

common = [n for n in res["baseline"] if all(res[v][n][1] for v in variants)]
print(f"\ncommon-solved by ALL variants: {len(common)}/{len(files)}")
print(f"{'variant':>15}{'total exp':>11}{'vs baseline':>13}")
tb = sum(res["baseline"][n][0] for n in common)
for v in variants:
    tv = sum(res[v][n][0] for n in common)
    print(f"{v:>15}{tv:>11}{(100*(tb-tv)/tb):>+12.1f}%")
