import glob, statistics, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves
dev=create_device(False); dom=mm.Domain("example/grid_dataset/domain.pddl")
taus=torch.linspace(0.01,0.99,99,device=dev).unsqueeze(0)
models={}
for tag in ["grid_iqn","grid_iqn_fix_full_best","grid_iqn_fix_noctx_best","grid_iqn_qrdqn_best"]:
    m,_,_=_load_iqn(dom,Path(f"models/{tag}.pth"),dev); m.eval(); models[tag]=m
dqn=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_dqn.pth"),dev)[0],"q")
def band(L): return "25-50" if L<50 else "50-100" if L<100 else "100-200" if L<200 else "200+"
data={t:{b:[] for b in ["25-50","50-100","100-200","200+"]} for t in list(models)+["DQN"]}
mins={t:0 for t in data}
with torch.no_grad():
    for pf in sorted(glob.glob("example/grid_dataset/*/*.pddl.plan")):
        inst=pf[:-5]; L=len([l for l in open(pf) if l.strip().startswith("(")])
        if L<25: continue
        b=band(L)
        if len(data["DQN"][b])>=120: continue
        p=mm.Problem(dom,inst); s=p.get_initial_state(); g=p.get_goal_condition()
        for tag,m in models.items():
            v=iqn_curves(m,s,g,taus)[0]
            if v is None: continue
            val=v.mean(dim=1).max().item(); data[tag][b].append(val); mins[tag]=min(mins[tag],val)
        vd=dqn.forward([(s,g)])[0][0].max().item(); data["DQN"][b].append(vd); mins["DQN"]=min(mins["DQN"],vd)
print("\nValue at INITIAL state by plan-length band (LARGE instances, d>>22). Calibrated ~ -(distance).\n")
hdr=["25-50","50-100","100-200","200+"]
print(f"{'model':<26}"+"".join(f"{h:>10}" for h in hdr)+f"{'min V':>9}")
for tag in ["grid_iqn","grid_iqn_fix_noctx_best","grid_iqn_fix_full_best","grid_iqn_qrdqn_best","DQN"]:
    row=""
    for h in hdr:
        v=data[tag][h]; row+=f"{statistics.mean(v):>10.1f}" if v else f"{'-':>10}"
    print(f"{tag:<26}{row}{mins[tag]:>9.1f}")
print("\n(old grid_iqn ceilinged ~ -21; DQN reaches ~ -171. Did qrdqn open up?)")
