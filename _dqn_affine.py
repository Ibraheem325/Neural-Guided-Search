import torch, glob, os, re, statistics
import numpy as np
import pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ
dev=create_device(False)
domain=mm.Domain("example/grid_dataset/domain.pddl")
dqnr,_=rgnn.RelationalGraphNeuralNetwork.load(domain, Path("models/grid_dqn.pth"), dev)
q1r,_=rgnn.RelationalGraphNeuralNetwork.load(domain, Path("models/grid_sac_q1.pth"), dev)
q2r,_=rgnn.RelationalGraphNeuralNetwork.load(domain, Path("models/grid_sac_q2.pth"), dev)
dqn=AZ.ModelWrapper(dqnr,"q"); q1=AZ.ModelWrapper(q1r,"q"); q2=AZ.ModelWrapper(q2r,"q")
canon=lambda x: str(x).lower().replace(" ","").replace("(","").replace(")","")
print("HOW WELL WOULD THE AFFINE FIX WORK ON DQN vs SAC?  (per instance, regress V on true -d)")
print("R^2 ~1 => V is affine in distance => a single w,b recovers it. Lower => nonlinear, fix is partial.\n")
print(f"{'instance':<15} {'N':>3} | {'DQN R^2':>8} {'w':>6} {'med|err|':>9} | {'SAC R^2':>8} {'w':>6} {'med|err|':>9}")
print("-"*76)
RD=[];RS=[];ED=[];ES=[]
for f in sorted(glob.glob("results/az_grid_v1val0_1800/*.out")):
    if len(RD)>=10: break
    t=open(f).read()
    if "Found a solution of length" not in t: continue
    name=f.split("/")[-1][:-4]
    acts=re.findall(r"^\s*\d+: (\(.*\))\s*$", t, re.M)
    if len(acts)<200: continue
    pf=f"example/grid_dataset/test/{name}.pddl"
    if not os.path.exists(pf): continue
    p=mm.Problem(domain,pf); goal=p.get_goal_condition(); s=p.get_initial_state()
    D=[];VD=[];VS=[]
    with torch.no_grad():
        for i,line in enumerate(acts):
            rem=len(acts)-i
            if rem%10==0:
                dv,_=dqn.forward([(s,goal)])[0]; VD.append(dv.max().item())
                a1,_=q1.forward([(s,goal)])[0]; a2,_=q2.forward([(s,goal)])[0]
                VS.append(torch.minimum(a1,a2).max().item()); D.append(-float(rem))
            avail=s.generate_applicable_actions()
            nxt=next((x for x in avail if canon(x)==canon(line)), None)
            if nxt is None: break
            s=nxt.apply(s)
    if len(D)<15: continue
    D=np.array(D)
    def fit(V):
        V=np.array(V); A=np.stack([V,np.ones_like(V)],axis=1)
        sol,_,_,_=np.linalg.lstsq(A,D,rcond=None); w,b=sol
        pred=w*V+b
        r2=1-((D-pred)**2).sum()/((D-D.mean())**2).sum()
        return r2,w,np.median(np.abs(pred-D))
    r2d,wd,ed=fit(VD); r2s,ws,es=fit(VS)
    RD.append(r2d);RS.append(r2s);ED.append(ed);ES.append(es)
    print(f"{name[:15]:<15} {len(D):>3} | {r2d:>8.3f} {wd:>6.2f} {ed:>9.1f} | {r2s:>8.3f} {ws:>6.2f} {es:>9.1f}")
if RD:
    print(f"\nmedian R^2 :  DQN {statistics.median(RD):.3f}   SAC {statistics.median(RS):.3f}")
    print(f"median |err| after fix (steps):  DQN {statistics.median(ED):.1f}   SAC {statistics.median(ES):.1f}")
    print("\n(true distances span ~10-780 steps)")
