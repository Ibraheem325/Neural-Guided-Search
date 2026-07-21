"""
Does the width signal fire where the model is UNCERTAIN, on the states SEARCH
ACTUALLY VISITS?  (July 2026)

Separates the two variables the width-channel result confounds:
  (b) SIGNAL: is low cv (=channel says "confident") really low ensemble-disagreement
      (=truly certain) on SEARCH-VISITED states? The offline AUC (0.6-0.95) was on
      SAMPLED / optimal-plan states; search visits a different distribution.
  (a) INTEGRATION: handled separately -- if the signal here is GOOD but the sweep
      effect was tiny, the pUCT exploration-scaling is the limiter, not the signal.

Runs the REAL AlphaZero search (alphaZero_bellman) with the width channel on + a SAC
ensemble attached, so every EXPANDED node logs (cv, width, disagreement, dist_est).
Then: banded AUC = P(disagreement higher at a HIGH-cv node than a LOW-cv node), binned
by dist_est to control the scale confound. High AUC => the channel's cv tracks real
uncertainty in search. ~0.5 => it does not transfer to the search distribution.

Run: venv/bin/python width_signal_in_search.py
"""
import glob, statistics
from pathlib import Path
import torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import rank_auc

dev = create_device(False); dom = mm.Domain("example/grid_dataset/domain.pddl")
policy = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_policy.pth"), dev)[0], "policy")
q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q1.pth"), dev)[0], "q")
q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path("models/grid_sac_q2.pth"), dev)[0], "q")
iqn, _, _ = _load_iqn(dom, Path("models/grid_iqn_qrdqn_best.pth"), dev); iqn.eval()
ens = []
for i in range(1, 6):
    e1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q1_best.pth"), dev)[0], "q")
    e2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom, Path(f"models/grid_sac_ens_{i}_q2_best.pth"), dev)[0], "q")
    ens.append((e1, e2))

AZ._SIG.iqn = iqn
AZ._SIG.taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
AZ._SIG.width_beta = 0.6
AZ._SIG.diag_ens = ens

class A: pass
args = A(); args.max_simulations = 4000; args.max_time = 60.0
args.c_puct = 1.5; args.dead_end_value = -1000.0; args.keep_searching = False

# a few HARDER instances (where exploration matters)
insts = sorted(glob.glob("example/grid_dataset/test/*H2*.pddl"))[:5]
with torch.no_grad():
    for f in insts:
        p = mm.Problem(dom, f)
        AZ._plan(p, policy, q1, q2, args)
        print(f"  ran {Path(f).name}, cumulative diag nodes: {len(AZ._SIG.diag_records)}", flush=True)

rec = AZ._SIG.diag_records
print(f"\n{len(rec)} expanded nodes logged across {len(insts)} searches.")
print("AUC = P(ensemble disagreement higher at HIGH-cv than LOW-cv node); binned by dist_est.")
print("High => width cv tracks real uncertainty IN SEARCH. ~0.5 => does not transfer.\n")
bands = [(0,20),(20,40),(40,80),(80,1e9)]
print(f"{'dist band':>12}{'n':>7}{'AUC(cv->disagree)':>20}")
allc=[r[0] for r in rec]; alld=[r[2] for r in rec]
for lo,hi in bands:
    g=[r for r in rec if lo<=r[3]<hi]
    if len(g)<30: continue
    cs=sorted(r[0] for r in g); loq,hiq=cs[len(cs)//3],cs[2*len(cs)//3]
    hi_d=[r[2] for r in g if r[0]>=hiq]; lo_d=[r[2] for r in g if r[0]<=loq]
    a=rank_auc(hi_d,lo_d) if len(hi_d)>5 and len(lo_d)>5 else None
    lab = f"{lo}-{hi}" if hi<1e9 else f"{lo}+"
    astr = f"{a:.3f}" if a is not None else "-"
    print(f"{lab:>12}{len(g):>7}{astr:>20}")
# overall spearman cv vs disagreement
import numpy as np
cr=np.corrcoef(np.argsort(np.argsort(allc)), np.argsort(np.argsort(alld)))[0,1]
print(f"\noverall Spearman(cv, disagreement) = {cr:+.3f} (confounded by distance; bands above are clean)")

# --- WHY does it work near goal? Check dynamic range of BOTH width and the
#     disagreement LABEL, near vs far. If disagreement collapses far out, the far
#     'failure' is the LABEL degrading, not the signal. CV = std/mean = dynamic range. ---
def stats(vals):
    m=statistics.mean(vals); sd=statistics.pstdev(vals)
    return m, sd, sd/abs(m) if m else 0.0
print("\nDynamic range near vs far (search-visited nodes):")
print(f"{'band':>10}{'n':>6}{'width mean':>11}{'width CV':>10}{'disagree mean':>15}{'disagree CV':>13}")
for lab,lo,hi in (("near d<20",0,20),("far d>40",40,1e9)):
    g=[r for r in rec if lo<=r[3]<hi]
    if len(g)<20: continue
    wm,wsd,wcv=stats([r[1] for r in g]); dm,dsd,dcv=stats([r[2] for r in g])
    print(f"{lab:>10}{len(g):>6}{wm:>11.2f}{wcv:>10.3f}{dm:>15.2f}{dcv:>13.3f}")
print("\n(if disagreement CV collapses far out -> the LABEL is uninformative there,")
print(" so the far-field AUC can't be trusted; width might not actually be failing.)")
