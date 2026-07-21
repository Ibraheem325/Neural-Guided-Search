"""
Is the offline>online AUC gap the STATE DISTRIBUTION (greedy-walk vs search-visited),
holding instances FIXED? (July 2026)

Earlier: offline cv-AUC 0.66-0.77 (70 mixed instances, greedy walk) vs online 0.29-0.50
(5 H2 instances, search). TWO confounds: instance set AND distribution. This holds the
SAME ~18 mixed instances and measures cv->disagreement AUC on greedy-walk states vs
search-visited states of those same instances. If greedy >> search here -> genuine
distribution shift. If similar -> the earlier gap was instance selection.
"""
import glob, statistics
from pathlib import Path
import torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves, rank_auc
dev=create_device(False); dom=mm.Domain("example/grid_dataset/domain.pddl")
taus=torch.linspace(0.01,0.99,99,device=dev).unsqueeze(0)
qr,_,_=_load_iqn(dom,Path("models/grid_iqn_qrdqn_best.pth"),dev); qr.eval()
policy=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_sac_policy.pth"),dev)[0],"policy")
q1=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_sac_q1.pth"),dev)[0],"q")
q2=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_sac_q2.pth"),dev)[0],"q")
ens=[]
for i in range(1,6):
    e1=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path(f"models/grid_sac_ens_{i}_q1_best.pth"),dev)[0],"q")
    e2=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path(f"models/grid_sac_ens_{i}_q2_best.pth"),dev)[0],"q")
    ens.append((e1,e2))
def disagree(s,g):
    vs=[]
    for a,b in ens:
        v1,ac=a.forward([(s,g)])[0]
        if len(ac)==0: return None
        v2,_=b.forward([(s,g)])[0]; vs.append(torch.minimum(v1,v2).max().item())
    return statistics.pstdev(vs)
def cvval(s,g):
    qs,acts=iqn_curves(qr,s,g,taus)
    if qs is None or not acts: return None
    ai=int(qs.mean(1).argmax()); curve=qs[ai]; val=-qs.mean(1).max().item()
    cv=(curve[89]-curve[9]).item()/(abs(val)+1.0)
    return cv,val,acts[ai].apply(s)
# mixed instances: every 6th test instance (covers L and H)
allf=sorted(glob.glob("example/grid_dataset/test/*.pddl"))
insts=[f for j,f in enumerate(allf) if j%6==0][:18]
# GREEDY-WALK
gw=[]
with torch.no_grad():
    for f in insts:
        p=mm.Problem(dom,f); g=p.get_goal_condition(); s=p.get_initial_state()
        for _ in range(90):
            if g.holds(s): break
            r=cvval(s,g)
            if r is None: break
            dv=disagree(s,g)
            if dv is not None: gw.append((r[0],dv,r[1]))
            s=r[2]
print(f"greedy-walk states collected: {len(gw)}", flush=True)
# SEARCH-VISITED (same instances)
AZ._SIG.iqn=qr; AZ._SIG.taus=taus; AZ._SIG.width_beta=0.6; AZ._SIG.diag_ens=ens
AZ._SIG.cv_hist=[]; AZ._SIG.diag_records=[]
class A: pass
args=A(); args.max_simulations=200; args.max_time=None
args.c_puct=1.5; args.dead_end_value=-1000.0; args.keep_searching=False
with torch.no_grad():
    for f in insts:
        AZ._plan(mm.Problem(dom,f),policy,q1,q2,args)
sv=[(r[0],r[2],r[3]) for r in AZ._SIG.diag_records]
print(f"search-visited states collected: {len(sv)}", flush=True)
def banded(rows):
    out=[]
    for lo,hi in [(0,20),(20,40),(40,80),(80,1e9)]:
        g=[r for r in rows if lo<=r[2]<hi]
        if len(g)<30: out.append((None,len(g))); continue
        cs=sorted(r[0] for r in g); loq,hiq=cs[len(cs)//3],cs[2*len(cs)//3]
        hi_d=[r[1] for r in g if r[0]>=hiq]; lo_d=[r[1] for r in g if r[0]<=loq]
        out.append((rank_auc(hi_d,lo_d) if len(hi_d)>5 and len(lo_d)>5 else None,len(g)))
    return out
print(f"\nSAME {len(insts)} mixed instances. cv->disagreement AUC.\n")
print(f"{'band':>10}{'greedy AUC (n)':>18}{'search AUC (n)':>18}")
for (lo,hi),(a,na),(b,nb) in zip([(0,20),(20,40),(40,80),(80,1e9)],banded(gw),banded(sv)):
    lab=f"{lo}-{hi}" if hi<1e9 else f"{lo}+"
    astr=f"{a:.3f} ({na})" if a else f"- ({na})"; bstr=f"{b:.3f} ({nb})" if b else f"- ({nb})"
    print(f"{lab:>10}{astr:>18}{bstr:>18}")
