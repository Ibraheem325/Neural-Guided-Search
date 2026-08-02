"""Compare multi-location logistics arms against the baseline.

Run on a compute node:
    venv/bin/python analyze_multiloc.py
Prints a compact table; paste the output back.
"""
import re, glob, os, csv, io, statistics as st

P = "example/probeLog_multiloc_d5-20"
ARMS = [("BASELINE (old policy)", "results/multiloc_base_new"),
        ("NEW policy",            "results/multiloc_base_topopolicy"),
        ("NEW policy + g=0.5",    "results/multiloc_topopolicy_g05")]

txt = open(f"{P}/labels.csv", newline="").read().replace("\r", "")
L = {r["file"][:-5]: int(r["distance_to_goal"]) for r in csv.DictReader(io.StringIO(txt))}


def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        p = re.search(r"Found a solution of length (\d+)!", s)
        o[n] = (int(e.group(1)) if e else None,
                int(p.group(1)) if p else None, L.get(n))
    return o


B = load(ARMS[0][1])
hdr = f"{'arm':<24}{'n':>5}{'cov':>8}{'plan/opt':>10}{'exact':>7}{'medExp':>9}{'planR':>8}{'short':>7}{'long':>7}"
print(hdr); print("-" * len(hdr))
for name, d in ARMS:
    A = load(d)
    if not A:
        print(f"{name:<24}  MISSING {d}"); continue
    sv = [x for x in A if A[x][1]]
    both = [x for x in sv if x in B and B[x][1]]
    pr = [A[x][1] / B[x][1] for x in both]
    print(f"{name:<24}{len(A):>5}{100*len(sv)/len(A):>7.1f}%"
          f"{st.median([A[x][1]/A[x][2] for x in sv]):>9.2f}x"
          f"{sum(1 for x in sv if A[x][1]==A[x][2]):>7}"
          f"{st.median([A[x][0] for x in sv]):>9.0f}"
          f"{(st.median(pr) if pr else 0):>8.3f}"
          f"{sum(1 for x in both if A[x][1]<B[x][1]):>7}"
          f"{sum(1 for x in both if A[x][1]>B[x][1]):>7}")

print("\nby topology (coverage / median plan-to-optimal):")
tops = sorted({re.search(r"-(c\d+s\d+p\d+)", x).group(1) for x in B})
print(f"{'arm':<24}" + "".join(f"{t:>16}" for t in tops))
for name, d in ARMS:
    A = load(d)
    if not A: continue
    row = ""
    for t in tops:
        g = [x for x in A if t in x]
        s2 = [x for x in g if A[x][1]]
        row += f"{f'{100*len(s2)/len(g):.0f}% {st.median([A[x][1]/A[x][2] for x in s2]):.1f}x' if s2 else '--':>16}"
    print(f"{name:<24}{row}")
