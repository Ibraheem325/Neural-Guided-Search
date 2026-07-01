import os, re

configs = {
    'baseline' : 'results/az_grid_w1_baseline',
    'lam10'    : 'results/az_grid_w1_lam10',
    'lam20'    : 'results/az_grid_w1_lam20',
}

def parse_dir(d):
    out = {}
    if not os.path.isdir(d): return out
    for fn in os.listdir(d):
        if not fn.endswith('.out'): continue
        name = fn[:-4]
        c = open(os.path.join(d, fn), errors='ignore').read()
        mlen = re.search(r'Found a solution of length (\d+)', c)
        mexp = re.search(r'\[Final\] Expanded: (\d+)', c)
        out[name] = (mlen is not None,
                     int(mexp.group(1)) if mexp else None,
                     int(mlen.group(1)) if mlen else None)
    return out

data = {k: parse_dir(v) for k, v in configs.items()}

print("=== coverage ===")
for k in configs:
    d = data[k]; n=len(d); s=sum(1 for v in d.values() if v[0])
    print(f"  {k:10s}: {s}/{n} ({100*s/max(1,n):.1f}%)")

common = None
for k in configs:
    s = {n for n,v in data[k].items() if v[0]}
    common = s if common is None else (common & s)
common = sorted(common) if common else []
print(f"\n=== matched set (solved by ALL) = {len(common)} ===")
print(f"\n{'config':10s} {'avg_expanded':>13} {'avg_length':>11}")
for k in configs:
    d=data[k]
    exps=[d[n][1] for n in common if d[n][1] is not None]
    lens=[d[n][2] for n in common if d[n][2] is not None]
    print(f"{k:10s} {sum(exps)/len(exps) if exps else 0:13.1f} {sum(lens)/len(lens) if lens else 0:11.1f}")

print("\n=== per-instance delta vs baseline (matched) ===")
base=data['baseline']
for k in configs:
    if k=='baseline': continue
    d=data[k]; better=worse=same=0; net=0
    for n in common:
        be,ke=base[n][1],d[n][1]
        if be is None or ke is None: continue
        delta=ke-be; net+=delta
        if delta<0: better+=1
        elif delta>0: worse+=1
        else: same+=1
    print(f"  {k}: fewer={better} more={worse} equal={same} net_delta={net:+d} (neg=improvement)")
