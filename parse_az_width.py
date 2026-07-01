import os, re

configs = {
    'baseline'    : 'results/az_grid_baseline',
    't90_g10'     : 'results/az_grid_t90_g10',
    't85_g10'     : 'results/az_grid_t85_g10',
}

def parse_dir(d):
    """Return {instance_name: (solved_bool, expanded, length)}."""
    out = {}
    if not os.path.isdir(d):
        return out
    for fn in os.listdir(d):
        if not fn.endswith('.out'): continue
        name = fn[:-4]
        c = open(os.path.join(d, fn), errors='ignore').read()
        mlen = re.search(r'Found a solution of length (\d+)', c)
        mexp = re.search(r'\[Final\] Expanded: (\d+)', c)
        solved = mlen is not None
        length = int(mlen.group(1)) if mlen else None
        expanded = int(mexp.group(1)) if mexp else None
        out[name] = (solved, expanded, length)
    return out

data = {k: parse_dir(v) for k, v in configs.items()}

# per-config coverage
print("=== coverage (out of total .out files) ===")
for k in configs:
    d = data[k]
    n = len(d); solved = sum(1 for v in d.values() if v[0])
    print(f"  {k:12s}: {solved}/{n} solved ({100*solved/max(1,n):.1f}%)")

# instances solved by ALL configs -> matched comparison
common = None
for k in configs:
    s = {name for name,v in data[k].items() if v[0]}
    common = s if common is None else (common & s)
common = sorted(common) if common else []
print(f"\n=== matched set: solved by ALL configs = {len(common)} instances ===")

print(f"\n{'config':12s} {'avg_expanded':>13} {'avg_length':>11}  (over matched set)")
for k in configs:
    d = data[k]
    exps = [d[n][1] for n in common if d[n][1] is not None]
    lens = [d[n][2] for n in common if d[n][2] is not None]
    ae = sum(exps)/len(exps) if exps else 0
    al = sum(lens)/len(lens) if lens else 0
    print(f"{k:12s} {ae:13.1f} {al:11.1f}")

# head-to-head vs baseline on matched set
print("\n=== per-instance delta vs baseline (matched set) ===")
base = data['baseline']
for k in configs:
    if k == 'baseline': continue
    d = data[k]
    better=worse=same=0; tot_delta=0
    for n in common:
        be, ke = base[n][1], d[n][1]
        if be is None or ke is None: continue
        delta = ke - be
        tot_delta += delta
        if delta < 0: better+=1
        elif delta > 0: worse+=1
        else: same+=1
    print(f"  {k}: fewer_expansions={better}  more={worse}  equal={same}  "
          f"net_delta={tot_delta:+d} (negative = improvement)")
