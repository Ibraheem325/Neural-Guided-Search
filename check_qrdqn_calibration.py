"""THE GATE: did the newly-trained QR-DQN actually de-saturate?

The whole point of the QR-DQN retrain is that the value must carry DISTANCE information.
On the near-goal probe sets we know the exact distance d of every probe's initial state,
so we can measure the calibration slope dV/dd directly:

    slope ~ -1.0  = perfectly calibrated (one step away = one unit more negative)
    slope ~  0.0  = FLAT/saturated: the value says the same thing at d=5 and d=20 -> useless

Reference points already measured:
    goldminer old IQN  -1.213   (excellent)
    grid QR-DQN        -0.464   (compressed but alive)
    logistics old IQN  +0.012   (COMPLETELY FLAT - this is what we are trying to fix)

Usage:
    venv/bin/python check_qrdqn_calibration.py <probe_dir> <model.pth> [more_models.pth ...]
Example:
    venv/bin/python check_qrdqn_calibration.py example/probeLog_near_goal_d5-20 \
        models/logistics_iqn.pth models/logistics_iqn_qrdqn_best.pth
"""
import sys, glob, os, csv, io, statistics as st, torch, pymimir as mm
from pathlib import Path
from collections import defaultdict
from utils import create_device
from train_iqn import _load_model as _load_iqn

PROBE = sys.argv[1]
MODELS = sys.argv[2:]
N = int(os.environ.get("NPROBES", "120"))
dev = create_device(False)
dom = mm.Domain(f"{PROBE}/domain.pddl")

txt = open(f"{PROBE}/labels.csv", newline="").read().replace("\r", "")
lab = {r["file"][:-5]: int(r["distance_to_goal"]) for r in csv.DictReader(io.StringIO(txt))}
files = sorted(f for f in glob.glob(f"{PROBE}/*.pddl") if "domain" not in os.path.basename(f))
files = files[:: max(1, len(files) // N)][:N]
print(f"probe set: {PROBE}   ({len(files)} probes sampled)\n")

for mp in MODELS:
    try:
        iqn, _, _ = _load_iqn(dom, Path(mp), dev)
    except Exception as e:
        print(f"{mp}: LOAD FAILED ({type(e).__name__}: {e})\n")
        continue
    iqn.eval()
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
    # what kind of model is this?
    ck = torch.load(mp, map_location="cpu", weights_only=False)
    iw = ck.get("extras", {}).get("iqn_wrapper", {})
    kind = iw.get("tau_conditioning", "multiply (ORIGINAL IQN)")
    octx = iw.get("use_object_context", "absent")

    byd = defaultdict(list)
    with torch.no_grad():
        for pf in files:
            nm = os.path.basename(pf)[:-5]
            if nm not in lab:
                continue
            p = mm.Problem(dom, pf)
            q, _ = iqn.forward([(p.get_initial_state(), p.get_goal_condition())], taus=taus)[0]
            if q.shape[0] == 0:
                continue
            byd[lab[nm]].append(q.mean(dim=1).max().item())
    ds = sorted(byd)
    xs = [d for d in ds for _ in byd[d]]
    ys = [v for d in ds for v in byd[d]]
    mx = sum(xs) / len(xs); my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs)
    slope = (sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / sxx) if sxx else 0.0
    span = st.mean(byd[ds[-1]]) - st.mean(byd[ds[0]])

    print(f"=== {os.path.basename(mp)} ===")
    print(f"    tau_conditioning = {kind} | use_object_context = {octx}")
    print(f"    {'d':>4} {'mean V':>9}")
    for d in ds[:: max(1, len(ds) // 6)]:
        print(f"    {d:>4} {st.mean(byd[d]):>9.2f}")
    verdict = ("FLAT / SATURATED -> unusable" if abs(slope) < 0.15 else
               "weak but alive" if abs(slope) < 0.4 else "GOOD - tracks distance")
    print(f"    slope dV/dd = {slope:+.3f}   (V moves {span:+.2f} from d={ds[0]} to d={ds[-1]})")
    print(f"    VERDICT: {verdict}\n")
