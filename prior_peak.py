"""How good, and how overconfident, is a SAC policy prior — measured on the model itself.

WHY NOT READ THE TRAINING LOG. Training logs get lost, misattributed, or belong to a
different domain entirely (three logs in logs/ turned out to be July barman runs, not the
August rovers/satellite ones). The prior is what actually enters pUCT, so measure it.

For every probe, walk its plan. At each state the plan's action a* is known, and we ask:

  rank(a*)   1 = the policy's top choice. pUCT's exploration term is c*P(a)*sqrt(N)/(1+n),
             so a routinely low-ranked a* means search is steered away from the good path.
  P(a*)      prior mass on a*. Below ~1e-3 makes it numerically unreachable until its Q
             dominates -- but Q needs a visit first, which is the deadlock that produced
             logistics' 12x-optimal plans.
  P_max      mass on the policy's favourite. High P_max with low top-1 accuracy is the
             CONFIDENTLY WRONG regime where prior flattening wins (goldminer: P_max 0.939,
             top-1 81.3%, and flattening took coverage 337 -> 478).

Usage: venv/bin/python prior_peak.py <probe_dir> <policy.pth> [n_probes]
   e.g. venv/bin/python prior_peak.py example/probeRov_val_d5-75 models/rovers_r18_sac_policy_best.pth 60
"""
import sys, glob, os, statistics as st, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device

PROBE, POLICY = sys.argv[1], sys.argv[2]
N = int(sys.argv[3]) if len(sys.argv) > 3 else 60

dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")
dom = mm.Domain(PROBE + "/domain.pddl")
pol, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(POLICY), dev)

files = sorted(f for f in glob.glob(PROBE + "/*.pddl") if "domain" not in os.path.basename(f))
files = files[:: max(1, len(files) // N)][:N]
print(f"probe set: {PROBE}\npolicy:    {POLICY}\nsampling {len(files)} probes", flush=True)

ranks, pstar, pmax, nact = [], [], [], []
with torch.no_grad():
    for k, pf in enumerate(files, 1):
        planf = pf + ".plan"
        if not os.path.exists(planf):
            continue
        plan = [l.strip() for l in open(planf) if l.strip().startswith("(")]
        prob = mm.Problem(dom, pf)
        s, g = prob.get_initial_state(), prob.get_goal_condition()
        for line in plan:
            acts = list(s.generate_applicable_actions())
            if len(acts) < 2:
                break
            logits = pol.forward([(s, acts, g)]).readout("policy")[0]
            P = torch.softmax(logits, dim=0)
            j = next((i for i, a in enumerate(acts) if canon(a) == canon(line)), None)
            if j is None:
                break
            order = torch.argsort(P, descending=True).tolist()
            ranks.append(order.index(j) + 1)
            pstar.append(P[j].item())
            pmax.append(P.max().item())
            nact.append(len(acts))
            s = acts[j].apply(s)
        if k % 20 == 0:
            print(f"  ...{k}/{len(files)} probes, {len(ranks)} states", flush=True)

if not ranks:
    raise SystemExit("no states measured -- do the probes have .plan files?")

q = lambda v, f: sorted(v)[int(f * (len(v) - 1))]
n = len(ranks)
print(f"\n{n} on-plan states, median {st.median(nact):.0f} applicable actions\n")
print(f"  top-1 accuracy   {100.0*sum(1 for r in ranks if r == 1)/n:5.1f}%   "
      f"(uniform would be {100.0*st.mean(1.0/a for a in nact):.1f}%)")
print(f"  median rank(a*)  {st.median(ranks):5.1f}   p90 {q(ranks,.9):.0f}   worst {max(ranks)}")
print(f"  mean P(a*)       {st.mean(pstar):.4f}   median {st.median(pstar):.4f}   "
      f"p10 {q(pstar,.1):.5f}")
print(f"  mean P_max       {st.mean(pmax):.4f}   median {st.median(pmax):.4f}")
print(f"  P(a*) < 1e-3 on  {100.0*sum(1 for p in pstar if p < 1e-3)/n:5.1f}% of states "
      f"(numerically unreachable by the exploration term)")
print(f"  P_max >= 0.9 on  {100.0*sum(1 for p in pmax if p >= 0.9)/n:5.1f}% of states")
conf_wrong = sum(1 for p, r in zip(pmax, ranks) if p >= 0.9 and r > 1)
print(f"  CONFIDENTLY WRONG (P_max>=0.9 and a* not top-1): {100.0*conf_wrong/n:.1f}%")
print("\nReference -- goldminer: top-1 81.3%, mean P(a*) 0.810, P_max 0.939, conf-wrong 11.0%")
print("             grid:      top-1 59.8%, mean P(a*) 0.604, P_max 0.900, conf-wrong 20.8%")
print("High P_max with low top-1 = the regime where signal-free prior flattening wins.")
