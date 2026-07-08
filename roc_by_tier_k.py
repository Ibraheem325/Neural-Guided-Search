"""ROC/AUC of the multi-step Bellman-consistency error (mistake vs correct
nodes) per domain, split into easy/hard instances, across k in {1,2,4,8}.

Tier split: Grid uses its pre-split files (baseline >=300 expansions = hard,
<300 = easy). Every other domain is split at its OWN median baseline-search
expansion count. n = surviving (mistake,correct) node counts at that k
(rollouts that reached goal/loop/deadend before k drop out => AUC@k for large
k is over fewer nodes; watch the n column).
"""
import json, statistics, os

def auc(pos, neg):
    if not pos or not neg: return None
    comb = sorted([(v,1) for v in pos]+[(v,0) for v in neg]); rs,i=0.0,0
    while i < len(comb):
        j=i
        while j<len(comb) and comb[j][0]==comb[i][0]: j+=1
        rs+=(i+j+1)/2.0*sum(1 for t in range(i,j) if comb[t][1]==1); i=j
    return (rs-len(pos)*(len(pos)+1)/2.0)/(len(pos)*len(neg))

KS=["1","2","4","8"]

def row(label, recs):
    mist=[r for r in recs if r["mistake"]]; corr=[r for r in recs if not r["mistake"]]
    cells=[]
    for k in KS:
        pm=[r["err"][k] for r in mist if r["err"].get(k) is not None]
        pc=[r["err"][k] for r in corr if r["err"].get(k) is not None]
        a=auc(pm,pc)
        cells.append((f"{a:.3f}" if a is not None else "  -  ", len(pm)+len(pc)))
    aucs=" ".join(f"{c:>6}" for c,_ in cells)
    ns  =" ".join(f"{n:>6}" for _,n in cells)
    print(f"{label:<18} {len(mist):>5} {len(corr):>5} | {aucs} | {ns}")

print(f"{'domain / tier':<18} {'nMst':>5} {'nCor':>5} | "
      f"{'AUC@1':>6} {'AUC@2':>6} {'AUC@4':>6} {'AUC@8':>6} | "
      f"{'n@1':>6} {'n@2':>6} {'n@4':>6} {'n@8':>6}")
print("-"*104)

# Grid: pre-split files
for lab,path in [("Grid  easy","results/grid_bellman_multistep_easy.json"),
                 ("Grid  hard","results/grid_bellman_multistep.json")]:
    row(lab, json.load(open(path))["records"])
print()

# Other domains: split at own median baseline expansions
for name,path in [("Goldminer","results/gold_bellman_multistep.json"),
                  ("Logistics","results/logi_bellman_multistep.json"),
                  ("Rovers","results/rovers_bellman_multistep.json"),
                  ("Satellite","results/sat_bellman_multistep.json")]:
    recs=json.load(open(path))["records"]
    med=statistics.median([r["base_exp"] for r in recs])
    row(f"{name} easy", [r for r in recs if r["base_exp"]<med])
    row(f"{name} hard", [r for r in recs if r["base_exp"]>=med])
    print()
