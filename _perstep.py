import glob, statistics, numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ
dev=create_device(False); dom=mm.Domain("example/grid_dataset/domain.pddl")
dqn=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_dqn.pth"),dev)[0],"q")
V=lambda s,g: dqn.forward([(s,g)])[0][0].max().item()
canon=lambda x: str(x).lower().replace(" ","").replace("(","").replace(")","")

bands={"25-50":[], "50-100":[], "100-200":[], "200+":[]}
def band(L):
    return "25-50" if L<50 else "50-100" if L<100 else "100-200" if L<200 else "200+"

with torch.no_grad():
    for pf in sorted(glob.glob("example/grid_dataset/*/*.pddl.plan")):
        inst=pf[:-5]
        plan=[l.strip() for l in open(pf) if l.strip().startswith("(")]
        L=len(plan)
        if L<25: continue
        b=band(L)
        if len(bands[b])>=900: continue
        p=mm.Problem(dom,inst); g=p.get_goal_condition(); s=p.get_initial_state()
        prev=V(s,g)
        for line in plan[:60]:
            nxt=next((a for a in s.generate_applicable_actions() if canon(a)==canon(line)),None)
            if nxt is None: break
            s=nxt.apply(s); cur=V(s,g)
            bands[b].append(prev-cur); prev=cur

print("\nPER-STEP VALUE DROP of the DQN along real solution paths on LARGE grid instances.")
print("Each step should drop the value by 1.00 if calibrated. No ground truth needed:")
print("this is just V(s) - V(s') on consecutive states of a plan.\n")
print(f"{'plan length':>13}{'n steps':>9}{'mean drop':>11}{'sd':>8}{'|mean|/sd':>11}{'wrong sign':>12}")
for b,v in bands.items():
    if len(v)<30: continue
    e=np.array(v)
    print(f"{b:>13}{len(e):>9}{e.mean():>11.3f}{e.std():>8.3f}{abs(e.mean())/e.std():>11.3f}{(e<0).mean()*100:>11.0f}%")
print("\n(small pool, d<=22, for reference: mean 0.703, sd 1.109, |mean|/sd 0.63)")
