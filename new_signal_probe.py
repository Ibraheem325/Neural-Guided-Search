"""Collect RAW per-action Bellman residuals + SAC priors for the new (absolute)
signal formulation.

The old signal divided by the sibling mean (rel = e_a / mean_b e_b), which throws
away the absolute scale. The new one keeps e_a and squashes it:
    x_a = e_a / (e_a + tau_step),   g_s = mean_a x_a,   c(s) = c0 (1 + kappa g_s)
so the report has to be computed from RAW e_a. This script dumps them; all the
tau/beta/kappa arithmetic lives in new_signal_report.py so sweeps are free.

Usage:
  venv/bin/python new_signal_probe.py [n_instances] [max_plan_steps]        # grid+goldminer
  venv/bin/python new_signal_probe.py --set NAME:PROBE_DIR:IQN:POLICY [...] [-o OUT]
Writes new_signal_data.json (or -o).

If a probe directory has no .plan files the walk falls back to the INITIAL state only,
which is all that is needed for the g_s / matched-w measurement.
"""
import json, glob, os, sys, time, torch, pymimir as mm
from pathlib import Path
from utils import create_device
from train_iqn import _load_model as _load_iqn
import pymimir_rgnn as rgnn

GAMMA, REWARD = 0.999, -1.0      # matches every other probe script in the repo
OUT_PATH = "new_signal_data.json"
if "-o" in sys.argv:
    OUT_PATH = sys.argv[sys.argv.index("-o") + 1]
_custom = [sys.argv[i + 1] for i, a in enumerate(sys.argv) if a == "--set"]
_pos = [a for a in sys.argv[1:] if a.isdigit()]
N_INST = int(_pos[0]) if _pos else 90
N_STEP = int(_pos[1]) if len(_pos) > 1 else 6

if _custom:
    SETS = [tuple(c.split(":")) for c in _custom]
    for c in SETS:
        assert len(c) == 4, f"--set needs NAME:PROBE_DIR:IQN:POLICY, got {c}"
else:
    SETS = [("grid", "example/probe_near_goal_d5-20",
             "models/grid_iqn_qrdqn_best.pth", "models/grid_sac_policy.pth"),
            ("goldminer", "example/probeGold_near_goal_d5-20",
             "models/goldminer_iqn.pth", "models/goldminer_sac_policy.pth")]

dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")
out = {}

for name, PROBE, IQN_M, POL_M in SETS:
    dom = mm.Domain(PROBE + "/domain.pddl")
    iqn, _, _ = _load_iqn(dom, Path(IQN_M), dev); iqn.eval()
    pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(POL_M), dev)
    TAUS = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)

    @torch.no_grad()
    def curves(state, goal):
        q, acts = iqn.forward([(state, goal)], taus=TAUS)[0]
        if q.shape[0] == 0:
            return None, None
        qs, _ = torch.sort(q, dim=1)
        return qs, acts

    @torch.no_grad()
    def prior(state, goal, acts):
        """SAC policy softmax, aligned to `acts` by canonical action string."""
        logits = pol_raw.forward([(state, list(acts), goal)]).readout("policy")[0]
        return torch.softmax(logits, dim=0).tolist()

    @torch.no_grad()
    def record(state, goal, plan_line):
        qs, acts = curves(state, goal)
        if qs is None or len(acts) < 2:
            return None
        es, keep = [], []
        for i, a in enumerate(acts):
            z = qs[i]; nxt = a.apply(state)
            if goal.holds(nxt):
                # target is a Dirac at the step reward -> W1 = mean |z - r|
                es.append((z - torch.full_like(z, REWARD)).abs().mean().item())
                keep.append(i); continue
            cqs, _ = curves(nxt, goal)
            if cqs is None:
                continue
            tgt = REWARD + GAMMA * cqs           # target rows, one per child action b
            sc = cqs.mean(dim=1)                 # E[Z(s',b)] -> picks b*
            w1 = (z.unsqueeze(0) - tgt).abs().mean(dim=1)
            es.append(w1[sc >= sc.max()].min().item())   # b* = argmax mean, det. tie-break
            keep.append(i)
        if len(es) < 2:
            return None
        kacts = [acts[i] for i in keep]
        P = prior(state, goal, acts)
        P = [P[i] for i in keep]
        tot = sum(P)
        P = [p / tot for p in P] if tot > 1e-12 else [1.0 / len(P)] * len(P)
        pidx = -1
        if plan_line is not None:
            pidx = next((j for j, a in enumerate(kacts) if canon(a) == canon(plan_line)), -1)
        return dict(e=[round(v, 5) for v in es], p=[round(v, 6) for v in P], plan=pidx)

    recs = []
    files = sorted(f for f in glob.glob(PROBE + "/*.pddl") if "domain" not in os.path.basename(f))
    if not files:                                  # dataset layout: probe dir has splits
        for sub in ("val", "test", "train"):
            files = sorted(f for f in glob.glob(f"{PROBE}/{sub}/*.pddl")
                           if "domain" not in os.path.basename(f))
            if files:
                print(f"  ({name}: no instances at top level, using {sub}/)", flush=True)
                break
    files = files[:: max(1, len(files) // N_INST)][:N_INST]
    # Progress matters here: record() does one IQN forward per APPLICABLE ACTION per state,
    # so on a domain with wide branching (satellite: satellites x instruments x directions)
    # this is tens of thousands of CPU forwards and used to print nothing until finished,
    # which is indistinguishable from a hang.
    print(f"{name}: {len(files)} instances x up to {N_STEP} plan steps "
          f"(lower these with positional args: new_signal_probe.py <n_inst> <n_steps> ...)",
          flush=True)
    _t0 = time.time()
    for _i, pf in enumerate(files, 1):
        # Every instance, not every tenth: on satellite one instance can take minutes, and a
        # gap from instance 1 to instance 10 is indistinguishable from a hang. The elapsed
        # time and the running edge count are what tell you whether to wait or to cut N_INST.
        _ed = sum(len(r["e"]) for r in recs)
        print(f"  {name}: instance {_i}/{len(files)}, {len(recs)} states, {_ed} edges, "
              f"{time.time() - _t0:.0f}s elapsed", flush=True)
        prob = mm.Problem(dom, pf)
        s = prob.get_initial_state(); g = prob.get_goal_condition()
        # No plan file -> measure the initial state only. Enough for g_s / matched w.
        plan = ([l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
                if os.path.exists(pf + ".plan") else [])
        if not plan:
            r = record(s, g, None)
            if r is not None:
                r["plan"] = -1
                recs.append(r)
            continue
        for t in range(min(N_STEP, len(plan))):
            r = record(s, g, plan[t])
            if r is not None and r["plan"] >= 0:
                recs.append(r)
            nxt = next((a for a in s.generate_applicable_actions()
                        if canon(a) == canon(plan[t])), None)
            if nxt is None:
                break
            s = nxt.apply(s)
    out[name] = recs
    print(f"{name}: {len(recs)} states from {len(files)} instances", flush=True)

json.dump(out, open(OUT_PATH, "w"))
print(f"wrote {OUT_PATH}")
