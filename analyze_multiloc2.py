"""Separate the selection effect: matched-subset comparison of multiloc arms."""
import re, glob, os, csv, io, statistics as st, random

P = "example/probeLog_multiloc_d5-20"
ARMS = [("baseline(old pol)", "results/multiloc_base_new"),
        ("new policy",        "results/multiloc_base_topopolicy"),
        ("new policy g=0.5",  "results/multiloc_topopolicy_g05")]
txt = open(f"{P}/labels.csv", newline="").read().replace("\r", "")
L = {r["file"][:-5]: int(r["distance_to_goal"]) for r in csv.DictReader(io.StringIO(txt))}

def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]; s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        p = re.search(r"Found a solution of length (\d+)!", s)
        o[n] = (int(e.group(1)) if e else None, int(p.group(1)) if p else None, L.get(n))
    return o

A = {n: load(d) for n, d in ARMS}
B = A["baseline(old pol)"]
bsolved = {x for x in B if B[x][1]}
print(f"baseline solved {len(bsolved)} of {len(B)}\n")

print("=== (1) ON THE 232 PROBES THE BASELINE SOLVED (matched subset) ===")
h = f"{'arm':<20}{'solved':>8}{'plan/opt':>10}{'exact':>7}{'medExp':>9}{'planR':>8}{'short':>7}{'long':>7}{'expR':>8}"
print(h); print("-"*len(h))
for n, _ in ARMS:
    X = A[n]; k = [x for x in bsolved if X.get(x, (None,None,None))[1]]
    pr = [X[x][1]/B[x][1] for x in k]; er = [X[x][0]/B[x][0] for x in k]
    print(f"{n:<20}{len(k):>8}{st.median([X[x][1]/X[x][2] for x in k]):>9.2f}x"
          f"{sum(1 for x in k if X[x][1]==X[x][2]):>7}{st.median([X[x][0] for x in k]):>9.0f}"
          f"{st.median(pr):>8.3f}{sum(1 for x in k if X[x][1]<B[x][1]):>7}"
          f"{sum(1 for x in k if X[x][1]>B[x][1]):>7}{st.median(er):>8.3f}")

print("\n=== (2) THE PROBES THE BASELINE COULD NOT SOLVE (n=%d) ===" % (len(B)-len(bsolved)))
hard = [x for x in B if x not in bsolved]
h2 = f"{'arm':<20}{'now solved':>12}{'cov of hard':>13}{'plan/opt':>10}{'exact':>7}{'medExp':>9}"
print(h2); print("-"*len(h2))
for n, _ in ARMS:
    X = A[n]; k = [x for x in hard if X.get(x,(None,None,None))[1]]
    if not k: print(f"{n:<20}{0:>12}{'0%':>13}"); continue
    print(f"{n:<20}{len(k):>12}{100*len(k)/len(hard):>12.0f}%"
          f"{st.median([X[x][1]/X[x][2] for x in k]):>9.2f}x"
          f"{sum(1 for x in k if X[x][1]==X[x][2]):>7}{st.median([X[x][0] for x in k]):>9.0f}")

print("\n=== (3) COVERAGE BY DISTANCE ===")
ds = sorted({B[x][2] for x in B})
print(f"{'arm':<20}" + "".join(f"{d:>5}" for d in ds))
for n, _ in ARMS:
    X = A[n]; row = ""
    for d in ds:
        g = [x for x in X if X[x][2] == d]
        row += f"{round(100*sum(1 for x in g if X[x][1])/len(g)):>5}"
    print(f"{n:<20}{row}")
