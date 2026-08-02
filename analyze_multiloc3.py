"""Interventions measured against the RETRAINED-POLICY baseline (the correct reference)."""
import re, glob, os, csv, io, statistics as st, random

P = "example/probeLog_multiloc_d5-20"
REF_NAME, REF_DIR = "BASELINE new policy", "results/multiloc_base_topopolicy"
ARMS = [("gamma=0.5",        "results/multiloc_topopolicy_g05"),
        ("(old policy ref)", "results/multiloc_base_new")]
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

def boot(v, n=4000):
    random.seed(0); m = []
    for _ in range(n):
        s = [v[random.randrange(len(v))] for _ in v]; m.append(sum(s)/len(s))
    m.sort(); return m[int(.025*n)], m[int(.975*n)]

R = load(REF_DIR); rs = {x for x in R if R[x][1]}
print(f"REFERENCE = {REF_NAME}: solved {len(rs)}/{len(R)} = {100*len(rs)/len(R):.1f}%, "
      f"median exp {st.median([R[x][0] for x in rs]):.0f}, exactly-opt {sum(1 for x in rs if R[x][1]==R[x][2])}\n")
h = f"{'arm':<20}{'cov':>8}{'d cov':>8}{'expR':>8}{'95% CI':>16}{'fewer':>7}{'more':>6}{'planR':>8}{'short':>7}{'long':>6}"
print(h); print("-"*len(h))
for n, d in ARMS:
    X = load(d); k = [x for x in rs if X.get(x,(None,None,None))[1]]
    er = [X[x][0]/R[x][0] for x in k]; pr = [X[x][1]/R[x][1] for x in k]
    lo, hi = boot(er); xs = {x for x in X if X[x][1]}
    print(f"{n:<20}{100*len(xs)/len(X):>7.1f}%{100*(len(xs)-len(rs))/len(X):>+7.1f}%"
          f"{st.median(er):>8.3f}{f'[{lo:.3f},{hi:.3f}]':>16}"
          f"{sum(1 for x in k if X[x][0]<R[x][0]):>7}{sum(1 for x in k if X[x][0]>R[x][0]):>6}"
          f"{st.median(pr):>8.3f}{sum(1 for x in k if X[x][1]<R[x][1]):>7}{sum(1 for x in k if X[x][1]>R[x][1]):>6}")
