"""Does the Bellman signal still lose to shuffle on probes the arms could AFFORD?

Restricts real-vs-shuffle to probes whose BASELINE search is small enough that the
signal arm was not starved. If real still loses there, starvation was not the cause and
fixing c4s3p8 will not rescue the channel. If real ties or wins, the earlier negative
was a compute artifact and the sweep is worth redoing on a lighter probe set.

Usage: venv/bin/python affordable_subset.py <baseline_dir> <real_dir> <shuf_dir> [cap]
"""
import sys, re, glob, os, statistics as st, random

BASE, REAL, SHUF = sys.argv[1], sys.argv[2], sys.argv[3]
CAPS = [int(sys.argv[4])] if len(sys.argv) > 4 else [5000, 10000, 20000, 50000, 10**9]

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

B, R, S = load(BASE), load(REAL), load(SHUF)
print(f"baseline {len(B)} probes, real {len(R)}, shuffle {len(S)}\n")
hdr = (f"{'cap on baseline exp':>21}{'probes':>8}{'base cov':>10}{'real cov':>10}"
       f"{'shuf cov':>10}{'real<shuf':>11}{'real>shuf':>11}{'win%':>7}{'mean R/S':>10}{'95% CI':>18}")
print(hdr); print("-" * len(hdr))
for cap in CAPS:
    sub = [n for n in B if B[n][1] and B[n][0] <= cap]
    if len(sub) < 10: continue
    rc = sum(1 for n in sub if n in R and R[n][1])
    sc = sum(1 for n in sub if n in S and S[n][1])
    both = [n for n in sub if n in R and R[n][1] and n in S and S[n][1]]
    rr = [R[n][0]/S[n][0] for n in both]
    w = sum(1 for n in both if R[n][0] < S[n][0]); l = sum(1 for n in both if R[n][0] > S[n][0])
    lo, hi = boot(rr)
    lab = "no cap" if cap > 10**8 else f"<= {cap:,}"
    print(f"{lab:>21}{len(sub):>8}{'100%':>10}{100*rc/len(sub):>9.1f}%{100*sc/len(sub):>9.1f}%"
          f"{w:>11}{l:>11}{(100*w/(w+l) if w+l else 0):>6.0f}%"
          f"{(sum(rr)/len(rr) if rr else 0):>10.3f}{f'[{lo:.2f},{hi:.2f}]':>18}")
