import os, re
configs = {
    'baseline': 'results/az_logiv2_w1_baseline',
    'top1'    : 'results/az_logiv2_w1_top1',
    'all'     : 'results/az_logiv2_w1_all',
}
def parse(d):
    o={}
    if not os.path.isdir(d): return o
    for fn in os.listdir(d):
        if not fn.endswith('.out'): continue
        c=open(os.path.join(d,fn),errors='ignore').read()
        ml=re.search(r'Found a solution of length (\d+)',c)
        me=re.search(r'\[Final\] Expanded: (\d+)',c)
        o[fn[:-4]]=(ml is not None, int(me.group(1)) if me else None, int(ml.group(1)) if ml else None)
    return o
data={k:parse(v) for k,v in configs.items()}
print("coverage:")
for k in configs:
    d=data[k]; n=len(d); s=sum(1 for v in d.values() if v[0])
    print(f"  {k:9s}: {s}/{n} ({100*s/max(1,n):.1f}%)")
common=None
for k in configs:
    s={n for n,v in data[k].items() if v[0]}
    common=s if common is None else common&s
common=sorted(common) if common else []
print(f"\nmatched (all solved) = {len(common)}")
print(f"{'config':9s} {'avg_exp':>10} {'avg_len':>8}")
for k in configs:
    d=data[k]; e=[d[n][1] for n in common if d[n][1] is not None]; l=[d[n][2] for n in common if d[n][2] is not None]
    print(f"{k:9s} {sum(e)/len(e) if e else 0:10.1f} {sum(l)/len(l) if l else 0:8.1f}")
base=data['baseline']
print("\nvs baseline (matched):")
for k in ('top1','all'):
    d=data[k]; b=w=0; net=0
    for n in common:
        if base[n][1] is None or d[n][1] is None: continue
        dl=d[n][1]-base[n][1]; net+=dl
        if dl<0: b+=1
        elif dl>0: w+=1
    print(f"  {k}: fewer={b} more={w} net={net:+d}")
