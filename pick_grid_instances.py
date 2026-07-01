import os, re

def parse(d):
    o={}
    for fn in os.listdir(d):
        if not fn.endswith('.out'): continue
        c=open(os.path.join(d,fn),errors='ignore').read()
        ml=re.search(r'Found a solution of length (\d+)',c)
        me=re.search(r'\[Final\] Expanded: (\d+)',c)
        if ml and me:
            o[fn[:-4]]=(int(me.group(1)), int(ml.group(1)))
    return o

base=parse('results/az_grid_w1_baseline')
lam10=parse('results/az_grid_w1_lam10')
common=sorted(set(base)&set(lam10))
rows=[]
for n in common:
    be,bl=base[n]; le,ll=lam10[n]
    rows.append((n, be, le, le-be, be))  # name, base_exp, lam_exp, delta, base_exp(for difficulty sort)

# hard tercile = top third by baseline expansions
rows_by_diff = sorted(rows, key=lambda r:-r[4])
hard = rows_by_diff[:len(rows_by_diff)//3]

print(f"hard tercile n={len(hard)}")
print("\n--- biggest W1 WINS (delta most negative) ---")
for n,be,le,d,_ in sorted(hard, key=lambda r:r[3])[:5]:
    print(f"  {n}: base={be} lam10={le} delta={d:+d}")
print("\n--- biggest W1 LOSSES (delta most positive) ---")
for n,be,le,d,_ in sorted(hard, key=lambda r:-r[3])[:5]:
    print(f"  {n}: base={be} lam10={le} delta={d:+d}")
