"""Dump rel(a) and mult(a) distributions for grid / goldminer / logistics to JSON."""
import json, glob, os, torch, pymimir as mm
from pathlib import Path
from utils import create_device
from train_iqn import _load_model as _load_iqn

GAMMA, REWARD, EPS = 0.999, -1.0, 0.0
BETAS = [1.0, 2.0, 4.0, 8.0, 12.0]
SETS = [("grid", "example/probe_near_goal_d5-20", "models/grid_iqn_qrdqn_best.pth"),
        ("goldminer", "example/probeGold_near_goal_d5-20", "models/goldminer_iqn.pth"),
        ("logistics", "example/probeLog_multiloc_d5-20", "models/logistics_topo_frozen.pth")]
dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")
out = {}

for name, PROBE, MODEL in SETS:
    dom = mm.Domain(PROBE + "/domain.pddl")
    iqn, _, _ = _load_iqn(dom, Path(MODEL), dev); iqn.eval()
    TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    @torch.no_grad()
    def curves(state, goal):
        q, acts = iqn.forward([(state, goal)], taus=TAUS)[0]
        if q.shape[0] == 0: return None, None
        qs, _ = torch.sort(q, dim=1)
        return qs, acts

    @torch.no_grad()
    def rels_at(state, goal):
        qs, acts = curves(state, goal)
        if qs is None or len(acts) < 2: return [], 0
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
        if len(w1s) < 2: return [], 0
        m = sum(w1s) / len(w1s)
        return ([w / m for w in w1s] if m > 1e-9 else []), len(w1s)

    files = sorted(f for f in glob.glob(PROBE + "/*.pddl") if "domain" not in os.path.basename(f))
    files = files[:: max(1, len(files) // 90)]
    REL = []; NS = []
    for pf in files:
        prob = mm.Problem(dom, pf); s = prob.get_initial_state(); g = prob.get_goal_condition()
        plan = [l.strip() for l in open(pf + ".plan")] if os.path.exists(pf + ".plan") else []
        plan = [l for l in plan if l.startswith("(")]
        for line in [None] + plan[:6]:
            if line is not None:
                nxt = next((a for a in s.generate_applicable_actions() if canon(a) == canon(line)), None)
                if nxt is None: break
                s = nxt.apply(s)
            r, n = rels_at(s, g)
            REL += r
            if n: NS.append(n)
        if len(REL) >= 2000: break
    out[name] = {"rel": [round(x, 4) for x in REL], "n_siblings": NS}
    print(f"{name}: {len(REL)} edges, median siblings {sorted(NS)[len(NS)//2]}", flush=True)

json.dump(out, open("mult_hist_data.json", "w"))
print("wrote mult_hist_data.json")
