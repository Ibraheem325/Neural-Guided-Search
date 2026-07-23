import glob, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device, get_state_key
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
dev=create_device(False); dom=mm.Domain("example/grid_dataset/domain.pddl")
policy=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_sac_policy.pth"),dev)[0],"policy")
q1=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_sac_q1.pth"),dev)[0],"q")
q2=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_sac_q2.pth"),dev)[0],"q")
iqn,_,_=_load_iqn(dom,Path("models/grid_iqn_qrdqn_best.pth"),dev); iqn.eval()
canon=lambda x: str(x).lower().replace(" ","")
# pick a few HARD instances (long plans)
hard=[]
for pf in sorted(glob.glob("example/grid_dataset/test/*.pddl.plan")):
    L=len([l for l in open(pf) if l.strip().startswith("(")])
    if L>=120: hard.append((pf[:-5],L))
    if len(hard)>=4: break
def probe(inst, R):
    p=mm.Problem(dom,inst); s=p.get_initial_state(); g=p.get_goal_condition()
    plan=[l.strip() for l in open(inst+".plan") if l.strip().startswith("(")]
    for line in plan[:len(plan)-R]:
        nxt=next((a for a in s.generate_applicable_actions() if canon(a)==canon(line)),None)
        if nxt is None: return None
        s=nxt.apply(s)
    return s,g,len(s.generate_applicable_actions())
def run(s,g,beta):
    AZ._SIG.__init__()
    if beta>0:
        AZ._SIG.iqn=iqn; AZ._SIG.taus=torch.linspace(0.01,0.99,99,device=dev).unsqueeze(0); AZ._SIG.sib_beta=beta
    with torch.no_grad():
        plan,gen,_=AZ._search(s,get_state_key(s),policy,q1,q2,g,100000000,30.0,1.5,-1000.0,True)
    return gen, plan is not None
print("Near-goal probes from HARD instances: is there search room? (baseline 30s)\n")
print(f"{'instance':<16}{'R(~dist)':>9}{'branching':>11}{'base exp':>10}{'solved':>8}{'sib1.0 exp':>12}")
for inst,L in hard:
    for R in (10,15,20):
        pr=probe(inst,R)
        if pr is None: continue
        s,g,br=pr
        be,bs=run(s,g,0.0)
        se,ss=run(s,g,1.0)
        print(f"{Path(inst).name[:16]:<16}{R:>9}{br:>11}{be:>10}{str(bs):>8}{se:>12}")
