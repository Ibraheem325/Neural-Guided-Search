import glob, os, re, statistics
arms=[("b0","az_grid_width_b0"),("b03","az_grid_width_b03"),("b06","az_grid_width_b06"),("b09","az_grid_width_b09")]
def parse(d):
    per={}
    for f in glob.glob(f"results/{d}/*.out"):
        t=open(f,errors='ignore').read(); n=os.path.basename(f)[:-4]
        solved="Found a solution" in t
        me=re.findall(r"Expanded:\s*(\d+)",t); exp=int(me[-1]) if me else None
        ml=re.search(r"solution of length (\d+)",t); ln=int(ml.group(1)) if ml else None
        mm_=re.search(r"mean explore_mult:\s*([0-9.]+)",t); mult=float(mm_.group(1)) if mm_ else None
        per[n]=(solved,exp,ln,mult)
    return per
data={k:parse(d) for k,d in arms}
names=sorted(set().union(*[set(v) for v in data.values()]))
print(f"total instances: {len(names)}\n")
print(f"{'arm':<6}{'solved':>9}{'cov%':>7}{'mean_mult':>11}")
for k,_ in arms:
    s=sum(1 for n in names if data[k].get(n,(False,))[0]); tot=len(names)
    mults=[data[k][n][3] for n in names if data[k].get(n,(0,0,0,None))[3] is not None]
    mm_=statistics.mean(mults) if mults else float('nan')
    print(f"{k:<6}{s:>6}/{tot:<3}{100*s/tot:>6.1f}{mm_:>11.3f}")
# common-solved set (all four arms solved)
common=[n for n in names if all(data[k].get(n,(False,))[0] for k,_ in arms)]
print(f"\ncommon-solved by ALL arms: {len(common)}")
print(f"{'arm':<6}{'med exp':>10}{'sum exp':>10}{'ratio vs b0':>13}{'med len':>9}")
base_med={n:data['b0'][n][1] for n in common}
b0sum=sum(base_med[n] for n in common)
for k,_ in arms:
    exps=[data[k][n][1] for n in common]; lens=[data[k][n][2] for n in common]
    ssum=sum(exps)
    # per-instance ratio median
    ratios=[data[k][n][1]/base_med[n] for n in common if base_med[n]>0]
    print(f"{k:<6}{statistics.median(exps):>10.0f}{ssum:>10}{statistics.median(ratios):>12.3f}{'':1}{statistics.median(lens):>9.0f}")
print("\n(ratio = per-instance expansions / baseline; <1.0 means fewer expansions than baseline)")
