import os, re
def parse_dir(d):
    out={}
    for fn in os.listdir(d):
        if not fn.endswith('.out'): continue
        c=open(os.path.join(d,fn),errors='ignore').read()
        mexp=re.search(r'\[Final\] Expanded: (\d+)',c)
        mlen=re.search(r'Found a solution of length (\d+)',c)
        out[fn[:-4]]=(mlen is not None, int(mexp.group(1)) if mexp else None)
    return out
base=parse_dir('results/az_logi_baseline')
lam=parse_dir('results/az_logi_lam10')
common=[n for n in base if base[n][0] and lam.get(n,(False,))[0]]
# sort by baseline expansions, split into terciles
common.sort(key=lambda n: base[n][1])
k=len(common)//3
bands=[('easy',common[:k]),('medium',common[k:2*k]),('hard',common[2*k:])]
print(f"matched={len(common)}")
for name,band in bands:
    bexp=[base[n][1] for n in band]; lexp=[lam[n][1] for n in band]
    better=sum(1 for n in band if lam[n][1]<base[n][1])
    worse =sum(1 for n in band if lam[n][1]>base[n][1])
    print(f"\n{name} (baseline exp range {min(bexp)}-{max(bexp)}):")
    print(f"  avg baseline exp={sum(bexp)/len(bexp):.0f}  avg lam10 exp={sum(lexp)/len(lexp):.0f}  "
          f"({100*(sum(lexp)-sum(bexp))/sum(bexp):+.0f}%)")
    print(f"  lam10 better on {better}, worse on {worse}")
