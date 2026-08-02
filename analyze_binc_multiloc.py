"""Bellman sweep on multi-location logistics -- same table format as grid/goldminer."""
import re, glob, os, csv, io, statistics as st, random

P = "example/probeLog_multiloc_d5-20"
BASE = "results/multiloc_base_topopolicy"
BETAS = [("20", "2.0"), ("40", "4.0"), ("80", "8.0"), ("120", "12.0")]
txt = open(f"{P}/labels.csv", newline="").read().replace("\r", "")
L = {r["file"][:-5]: int(r["distance_to_goal"]) for r in csv.DictReader(io.StringIO(txt))}

def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        p = re.search(r"Found a solution of length (\d+)!", s)
        if e: o[n] = (int(e.group(1)), int(p.group(1)) if p else None, L.get(n))
    return o

def boot(v, n=4000):
    if not v: return (0, 0)
    random.seed(0); m = []
    for _ in range(n):
        s = [v[random.randrange(len(v))] for _ in v]; m.append(sum(s)/len(s))
    m.sort(); return m[int(.025*n)], m[int(.975*n)]

B = load(BASE); bs = {x for x in B if B[x][1]}
print(f"BASELINE {BASE}: {len(bs)}/{len(B)} = {100*len(bs)/len(B):.1f}% cov, "
      f"total exp {sum(B[x][0] for x in bs)}, median {st.median([B[x][0] for x in bs]):.0f}\n")

def row(tag, d):
    A = load(d)
    if not A: return None
    sv = {x for x in A if A[x][1]}
    k = sorted(sv & bs)
    if not k: return None
    r = [A[x][0]/B[x][0] for x in k]
    tb = sum(B[x][0] for x in k); ta = sum(A[x][0] for x in k)
    imp = sum(1 for x in k if A[x][0] < B[x][0]); reg = sum(1 for x in k if A[x][0] > B[x][0])
    return dict(cov=100*len(sv)/len(A), net=100*(tb-ta)/tb, mean=sum(r)/len(r),
                med=st.median(r), imp=imp, reg=reg, n=len(k),
                win=100*imp/(imp+reg) if imp+reg else 0)

hdr = f"{'beta':>6}{'cov':>8}{'net%':>9}{'mean':>8}{'med':>8}{'imp':>6}{'reg':>6}{'win%':>7}"
print("REAL"); print(hdr); print("-"*len(hdr))
for t, b in BETAS:
    r = row(b, f"results/mlbinc{t}")
    if r: print(f"{b:>6}{r['cov']:>7.1f}%{r['net']:>+8.1f}%{r['mean']:>8.3f}{r['med']:>8.3f}{r['imp']:>6}{r['reg']:>6}{r['win']:>6.0f}%")
print("\nSHUFFLE"); print(hdr); print("-"*len(hdr))
for t, b in BETAS:
    r = row(b, f"results/mlbinc{t}shuf")
    if r: print(f"{b:>6}{r['cov']:>7.1f}%{r['net']:>+8.1f}%{r['mean']:>8.3f}{r['med']:>8.3f}{r['imp']:>6}{r['reg']:>6}{r['win']:>6.0f}%")

print("\nREAL vs SHUFFLE (paired; <1 = real better)")
h2 = f"{'beta':>6}{'n':>6}{'mean':>9}{'med':>9}{'real<shuf':>11}{'real>shuf':>11}{'win%':>7}{'95% CI mean':>18}"
print(h2); print("-"*len(h2))
for t, b in BETAS:
    A = load(f"results/mlbinc{t}"); C = load(f"results/mlbinc{t}shuf")
    if not A or not C: continue
    k = sorted({x for x in A if A[x][1]} & {x for x in C if C[x][1]})
    if not k: continue
    rr = [A[x][0]/C[x][0] for x in k]
    w = sum(1 for x in k if A[x][0] < C[x][0]); l = sum(1 for x in k if A[x][0] > C[x][0])
    lo, hi = boot(rr)
    print(f"{b:>6}{len(k):>6}{sum(rr)/len(rr):>9.3f}{st.median(rr):>9.3f}{w:>11}{l:>11}"
          f"{(100*w/(w+l) if w+l else 0):>6.0f}%{f'[{lo:.3f},{hi:.3f}]':>18}")

print("\nCOST CHECK (expansions reached on UNSOLVED probes -- starvation confound)")
h3 = f"{'arm':>14}{'unsolved':>10}{'med exp reached':>18}"
print(h3); print("-"*len(h3))
for nm, d in [("baseline", BASE)] + [(f"binc{b}", f"results/mlbinc{t}") for t, b in BETAS] \
                                  + [(f"shuf{b}", f"results/mlbinc{t}shuf") for t, b in BETAS]:
    A = load(d)
    if not A: continue
    un = [A[x][0] for x in A if not A[x][1]]
    print(f"{nm:>14}{len(un):>10}{(st.median(un) if un else 0):>18.0f}")
