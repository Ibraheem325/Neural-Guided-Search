import glob, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves, rank_auc
dev=create_device(False); dom=mm.Domain("example/grid_dataset/domain.pddl")
taus=torch.linspace(0.01,0.99,99,device=dev).unsqueeze(0)
sig,_,_=_load_iqn(dom,Path("models/grid_iqn_qrdqn_best.pth"),dev); sig.eval()
ens=[]
for i in range(1,6):
    q1=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path(f"models/grid_sac_ens_{i}_q1_best.pth"),dev)[0],"q")
    q2=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path(f"models/grid_sac_ens_{i}_q2_best.pth"),dev)[0],"q")
    ens.append((q1,q2))
def disagree(s,g):
    vs=[]
    for q1,q2 in ens:
        v1,_=q1.forward([(s,g)])[0]; v2,_=q2.forward([(s,g)])[0]
        vs.append(torch.minimum(v1,v2).max().item())
    return statistics.pstdev(vs)
rows=[]
with torch.no_grad():
    for f in sorted(glob.glob("example/grid_dataset/test/*.pddl"))[:80]:
        p=mm.Problem(dom,f); g=p.get_goal_condition(); s=p.get_initial_state()
        for _ in range(25):
            if g.holds(s): break
            qs,acts=iqn_curves(sig,s,g,taus)
            if qs is None or not acts: break
            ai=int(qs.mean(1).argmax()); curve=qs[ai]
            width=(curve.quantile(0.9)-curve.quantile(0.1)).item()
            vmean=curve.mean().item()          # qrdqn calibrated value = distance proxy
            rows.append((vmean,disagree(s,g),width))
            s=acts[ai].apply(s)
# bins on the qrdqn value (proxy for distance). More negative = further.
bins=[(-40,-20),(-70,-40),(-110,-70),(-1e9,-110)]
labels=["~20-40","~40-70","~70-110","110+ (far)"]
print(f"\nFAR-FIELD width-vs-uncertainty AUC, binned by QR-DQN value (distance proxy).")
print(f"Controls the confound WITHOUT an oracle. 0.5 = no signal.  n={len(rows)}\n")
print(f"{'value band':>12}{'~true dist':>12}{'n':>6}{'width AUC':>11}")
for (lo,hi),lab in zip(bins,labels):
    g=[r for r in rows if lo<=r[0]<hi]
    if len(g)<30: print(f"{lab:>12}{'':>12}{len(g):>6}{'(too few)':>11}"); continue
    ds=sorted(r[1] for r in g); loq,hiq=ds[len(ds)//3],ds[2*len(ds)//3]
    hw=[r[2] for r in g if r[1]>=hiq]; lw=[r[2] for r in g if r[1]<=loq]
    auc=rank_auc(hw,lw) if len(hw)>5 and len(lw)>5 else None
    dd=f"{-statistics.mean(r[0] for r in g):.0f}"
    print(f"{lab:>12}{dd:>12}{len(g):>6}{auc:>11.3f}")
