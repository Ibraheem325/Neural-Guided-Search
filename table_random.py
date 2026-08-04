"""Per-arm table in the same format as the shuffle tables:
   coverage (count solved), net%, mean ratio, improved, regressed.

Usage: venv/bin/python table_random.py [suffix]      suffix = rand | rndm | shuf | ""
"""
import sys, re, glob, os, statistics as st

SUF = sys.argv[1] if len(sys.argv) > 1 else "rndm"
DOMS = [("GRID", "results/az_probe_qrval_base", "results/az_probe_qrval_binc%s" + SUF),
        ("GOLDMINER", "results/gm_base", "results/gm_binc%s" + SUF)]
BETAS = [("10", "1.0"), ("20", "2.0"), ("40", "4.0"), ("60", "6.0"), ("80", "8.0"), ("120", "12.0")]

def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e: o[n] = (int(e.group(1)), "Found a solution" in s)
    return o

name = {"": "real", "shuf": "shuf", "rand": "rand(uniform)", "rndm": "rand(matched)"}[SUF]
for dom, base, pat in DOMS:
    B = load(base); bs = {x for x in B if B[x][1]}
    if not B: continue
    print(f"\n### {dom}   arm = {name} ###")
    print(f"| beta | {name} cov | {name} net% | {name} mean | {name} improved | {name} regressed |")
    print("| ---- | -------- | --------- | --------- | ------------- | -------------- |")
    for t, b in BETAS:
        A = load(pat % t)
        if not A: continue
        sv = {x for x in A if A[x][1]}
        k = sorted(sv & bs)
        if not k: continue
        tb = sum(B[x][0] for x in k); ta = sum(A[x][0] for x in k)
        r = [A[x][0] / B[x][0] for x in k]
        imp = sum(1 for x in k if A[x][0] < B[x][0])
        reg = sum(1 for x in k if A[x][0] > B[x][0])
        print(f"| {b} | {len(sv)} | {100*(tb-ta)/tb:+.1f}% | {sum(r)/len(r):.3f} | {imp} | {reg} |")
