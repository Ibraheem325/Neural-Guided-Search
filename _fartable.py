import glob, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves
dev=create_device(False); dom=mm.Domain("example/grid_dataset/domain.pddl")
taus=torch.linspace(0.01,0.99,99,device=dev).unsqueeze(0)
iqn_models={}
for tag,f in [("old_iqn","grid_iqn"),("fix_noctx","grid_iqn_fix_noctx_best"),
              ("fix_full","grid_iqn_fix_full_best"),("QR-DQN","grid_iqn_qrdqn_best")]:
    m,_,_=_load_iqn(dom,Path(f"models/{f}.pth"),dev); m.eval(); iqn_models[tag]=m
dqn=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_dqn.pth"),dev)[0],"q")
cols=["old_iqn","fix_noctx","fix_full","QR-DQN","DQN"]
bands=[(25,50),(50,100),(100,200),(200,400),(400,10**9)]
data={c:{b:[] for b in bands} for c in cols}
with torch.no_grad():
    for pf in sorted(glob.glob("example/grid_dataset/*/*.pddl.plan")):
        inst=pf[:-5]; L=len([l for l in open(pf) if l.strip().startswith("(")])
        if L<25: continue
        b=next((bb for bb in bands if bb[0]<=L<bb[1]),None)
        if b is None or len(data["DQN"][b])>=120: continue
        p=mm.Problem(dom,inst); s=p.get_initial_state(); g=p.get_goal_condition()
        for tag,m in iqn_models.items():
            v=iqn_curves(m,s,g,taus)[0]
            if v is not None: data[tag][b].append(v.mean(1).max().item())
        data["DQN"][b].append(dqn.forward([(s,g)])[0][0].max().item())
print("Mean value at INITIAL state by PLAN LENGTH (proxy for distance-to-goal, up to ~780).")
print("(calibrated ~ -distance; flat across columns = saturated)\n")
hdr=["25-50","50-100","100-200","200-400","400+"]
print(f"{'model':<11}"+"".join(f"{h:>10}" for h in hdr))
for c in cols:
    row=f"{c:<11}"
    for b in bands:
        v=data[c][b]; row+=f"{statistics.mean(v):>10.1f}" if v else f"{'-':>10}"
    print(row)
print(f"\n{'n per band:':<11}"+"".join(f"{len(data['DQN'][b]):>10}" for b in bands))
