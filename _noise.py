import glob, random, statistics, numpy as np, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from utils import create_device
import alphaZero_bellman as AZ
dev=create_device(False); dom=mm.Domain("../Domains/Domains2/grid/domain.pddl")
dqn=AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(dom,Path("models/grid_dqn.pth"),dev)[0],"q")
V=lambda s,g: dqn.forward([(s,g)])[0][0].max().item()
rng=random.Random(0)
files=[p for p in sorted(glob.glob("../Domains/Domains2/grid/instances/*.pddl")) if "domain" not in p]
rng.shuffle(files)
rows=[]; used=0
with torch.no_grad():
    for f in files:
        if used>=60: break
        p=mm.Problem(dom,f); ss=mm.StateSpaceSampler.new(p,200_000)
        if ss is None or ss.max_steps_to_goal()<4: continue
        ss.set_seed(0); g=p.get_goal_condition()
        for d in range(1, ss.max_steps_to_goal()+1):
            try: sts=list(ss.sample_states_n_steps_from_goal(d,6))
            except Exception: continue
            for s in sts:
                lab=ss.get_state_label(s)
                if lab.is_goal or lab.is_dead_end: continue
                rows.append((lab.steps_to_goal, V(s,g)))
        used+=1
print("\nStates at the SAME true distance should all get the SAME value.")
print("Spread among them = the noise. (grid DQN, exact distances)\n")
print(f"{'true dist':>10}{'n':>6}{'mean V':>10}{'sd of V':>10}{'min V':>9}{'max V':>9}")
sds=[]
for d in range(1,19):
    g=[r[1] for r in rows if r[0]==d]
    if len(g)<8: continue
    sd=statistics.stdev(g); sds.append(sd)
    print(f"{d:>10}{len(g):>6}{statistics.mean(g):>10.2f}{sd:>10.2f}{min(g):>9.2f}{max(g):>9.2f}")
print(f"\ntypical sd at a fixed distance = {statistics.mean(sds):.2f}")
print(f"one step of true progress is worth  1.00")
print(f"=> the model's random state-to-state variation is ~{statistics.mean(sds):.1f}x a whole step")
