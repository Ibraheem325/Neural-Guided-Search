"""REAL vs SHUFFLE vs RANDOM on grid and goldminer.

Usage: venv/bin/python analyze_three_way.py [rand|rndm]
  rand = uniform draws  (CV ~0.55 -- UNDER-disperses vs the real signal)
  rndm = lognormal, per-domain sigma (CV matched to the real signal exactly)

  real     signal values, real placement
  shuffle  signal values, permuted        -> same spread, placement scrambled
  random   fresh U(0,1) draws per child   -> spread destroyed too

If real beats shuffle, placement carries information.
If shuffle beats random, the signal's SPREAD carries information even when misplaced.
"""
import re, glob, os, statistics as st, random

DOMS = [("GRID", "results/az_probe_qrval_base", "results/az_probe_qrval_binc%s%s"),
        ("GOLDMINER", "results/gm_base", "results/gm_binc%s%s")]
BETAS = [("10", "1.0"), ("20", "2.0"), ("40", "4.0"), ("60", "6.0"), ("80", "8.0"), ("120", "12.0")]

def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e: o[n] = (int(e.group(1)), "Found a solution" in s)
    return o

def boot(v, n=4000):
    if not v: return (0, 0)
    random.seed(0); m = []
    for _ in range(n):
        s = [v[random.randrange(len(v))] for _ in v]; m.append(sum(s)/len(s))
    m.sort(); return m[int(.025*n)], m[int(.975*n)]

for name, base, pat in DOMS:
    B = load(base); bs = {x for x in B if B[x][1]}
    if not B: print(f"{name}: missing {base}"); continue
    print(f"\n################ {name} ################")
    print(f"baseline: {len(bs)}/{len(B)} solved, median {st.median([B[x][0] for x in bs]):.0f} expansions\n")
    hdr = (f"{'beta':>5}{'':>3}{'cov':>8}{'net%':>9}{'medRatio':>10}{'win%':>7}"
           f"{'   |':>4}{'vs shuffle':>12}{'win%':>7}{'   |':>4}{'vs random':>11}{'win%':>7}")
    print(hdr); print("-" * len(hdr))
    for t, b in BETAS:
        arms = {}
        import sys as _s
        SUF = _s.argv[1] if len(_s.argv) > 1 else "rand"   # "rand" (uniform) or "rndm" (matched CV)
        for tag, suf in [("real", ""), ("shuf", "shuf"), ("rand", SUF)]:
            arms[tag] = load(pat % (t, suf))
        if not all(arms.values()): continue
        R, S, N = arms["real"], arms["shuf"], arms["rand"]
        for tag, A in [("real", R), ("shuf", S), ("rand", N)]:
            sv = {x for x in A if A[x][1]}; k = sorted(sv & bs)
            if not k: continue
            tb = sum(B[x][0] for x in k); ta = sum(A[x][0] for x in k)
            r = [A[x][0]/B[x][0] for x in k]
            imp = sum(1 for x in k if A[x][0] < B[x][0]); reg = sum(1 for x in k if A[x][0] > B[x][0])
            cell = ""
            if tag == "real":
                for other, oname in [(S, "shuf"), (N, "rand")]:
                    kk = sorted({x for x in R if R[x][1]} & {x for x in other if other[x][1]})
                    rr = [R[x][0]/other[x][0] for x in kk]
                    w = sum(1 for x in kk if R[x][0] < other[x][0])
                    l = sum(1 for x in kk if R[x][0] > other[x][0])
                    cell += f"{'   |':>4}{(st.median(rr) if rr else 0):>12.3f}{(100*w/(w+l) if w+l else 0):>6.0f}%"
            print(f"{b if tag=='real' else '':>5}{tag:>5}{100*len(sv)/len(A):>7.1f}%"
                  f"{100*(tb-ta)/tb:>+8.1f}%{st.median(r):>10.3f}"
                  f"{(100*imp/(imp+reg) if imp+reg else 0):>6.0f}%{cell}")
        print()
