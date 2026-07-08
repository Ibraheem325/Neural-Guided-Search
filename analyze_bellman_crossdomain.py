import json, statistics, sys, os

def auc(pos, neg):
    if not pos or not neg: return float("nan")
    comb = sorted([(v,1) for v in pos]+[(v,0) for v in neg])
    rs,i=0.0,0
    while i<len(comb):
        j=i
        while j<len(comb) and comb[j][0]==comb[i][0]: j+=1
        rs+=(i+j+1)/2.0*sum(1 for t in range(i,j) if comb[t][1]==1); i=j
    return (rs-len(pos)*(len(pos)+1)/2.0)/(len(pos)*len(neg))

# Composite outcome-aware score, full-sample (no survivor bias):
#  goal reached  -> trusted (low score)
#  loop@depth m  -> distrusted, stronger the sooner it loops
#  else (alive/deadend) -> use last available err
def composite(r):
    if r["outcome"] == "goal":
        return -10.0 + (r["outcome_depth"] / 100.0)
    last = None
    for k in ["8","4","2","1"]:
        if r["err"].get(k) is not None:
            last = r["err"][k]; break
    e = last if last is not None else 0.0
    if r["outcome"] == "loop":
        return 20.0 / r["outcome_depth"] + e
    return e

DOMAINS = [
    ("Grid HARD",   "results/grid_bellman_multistep.json"),
    ("Grid EASY",   "results/grid_bellman_multistep_easy.json"),
    ("Goldminer",   "results/gold_bellman_multistep.json"),
    ("Logistics",   "results/logi_bellman_multistep.json"),
    ("Rovers",      "results/rovers_bellman_multistep.json"),
    ("Satellite",   "results/sat_bellman_multistep.json"),
]

print(f"{'domain':<12} {'nodes':>6} {'mist%':>6} | "
      f"{'AUC@1':>6} {'AUC@2':>6} {'AUC@4':>6} {'AUC@8':>6} | "
      f"{'goalMst':>7} {'goalCor':>7} {'AUCcomp':>7}")
print("-"*90)
for name, path in DOMAINS:
    if not os.path.exists(path):
        print(f"{name:<12}  (pending)")
        continue
    recs = json.load(open(path))["records"]
    mist=[r for r in recs if r["mistake"]]; corr=[r for r in recs if not r["mistake"]]
    row=f"{name:<12} {len(recs):>6} {100*len(mist)/len(recs):>5.0f}% | "
    for k in ["1","2","4","8"]:
        pm=[r["err"][k] for r in mist if r["err"].get(k) is not None]
        pc=[r["err"][k] for r in corr if r["err"].get(k) is not None]
        a=auc(pm,pc)
        row+=f"{a:>6.3f} " if a==a else f"{'-':>6} "
    def goalrate(g):
        return 100*sum(1 for r in g if r["outcome"]=="goal")/len(g)
    ac = auc([composite(r) for r in mist],[composite(r) for r in corr])
    row+=f"| {goalrate(mist):>6.0f}% {goalrate(corr):>6.0f}% {ac:>7.3f}"
    print(row)
