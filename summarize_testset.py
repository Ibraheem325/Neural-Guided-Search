"""Summarise a test set against the training split it is meant to match.

Answers, in one place, the questions that decide whether a set is worth sweeping on:
  - how big are its instances, next to train and val
  - is any instance IDENTICAL to one the model trained on (canonical objects+init+goal)
  - how far from the goal are they, using FD-verified optimal length

The last one matters here because the in-distribution sets have NO distance-to-goal
control -- unlike the probe sets, which stratify d 5-22 by construction. Difficulty is
whatever the generator produced, so it has to be measured rather than assumed.

Usage: venv/bin/python summarize_testset.py <test_dir> <train_dir> <val_dir> <optlen.json>
"""
import json, glob, os, re, sys, csv, hashlib, collections, statistics as st

TEST, TRAIN, VAL, OPTLEN = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

def canon(p):
    t = open(p, errors="ignore").read().lower(); out = []
    for sec in (":objects", ":init", ":goal"):
        i = t.find("(" + sec)
        if i < 0: out.append(""); continue
        j, d = i, 0
        while j < len(t):
            if t[j] == "(": d += 1
            elif t[j] == ")":
                d -= 1
                if d == 0: break
            j += 1
        out.append("|".join(sorted(a.strip() for a in re.findall(r"\(([^()]*)\)", t[i:j+1]) if a.strip())))
    return hashlib.sha1("||".join(out).encode()).hexdigest()

def nobj(p):
    t = open(p, errors="ignore").read()
    m = re.search(r"\(:objects(.*?)\n\)", t, re.S)
    if not m: return None
    return sum(len(l.rsplit("-", 1)[0].split()) for l in m.group(1).strip().splitlines() if "-" in l)

def files(d):
    return [f for f in sorted(glob.glob(d + "/*.pddl")) if os.path.basename(f) != "domain.pddl"]

def line(lab, v):
    if not v: return
    q = st.quantiles(v, n=4) if len(v) >= 4 else [float('nan')]*3
    print(f"  {lab:26} n={len(v):3}  min {min(v):3}  p25 {q[0]:5.1f}  median {st.median(v):5.1f}"
          f"  p75 {q[2]:5.1f}  max {max(v):3}")

print("OBJECT COUNTS")
for lab, d in (("TEST (new set)", TEST), ("train", TRAIN), ("val", VAL)):
    line(lab, [n for n in (nobj(f) for f in files(d)) if n])

print("\nOVERLAP WITH TRAINING")
tf, vf = {canon(f) for f in files(TRAIN)}, {canon(f) for f in files(VAL)}
te = [canon(f) for f in files(TEST)]
print(f"  test instances                 {len(te)}   distinct: {len(set(te))}")
print(f"  identical to a TRAIN instance  {sum(1 for h in te if h in tf)}")
print(f"  identical to a VAL instance    {sum(1 for h in te if h in vf)}")

print("\nDISTANCE TO GOAL (FD-verified optimal plan length)")
o = json.load(open(OPTLEN))
v = sorted(x if isinstance(x, int) else x.get("len") for x in o.values()
           if isinstance(x, int) or (isinstance(x, dict) and x.get("len")))
line("TEST (new set)", v)
h = collections.Counter(v)
print("  histogram:", " ".join(f"{k}:{h[k]}" for k in sorted(h)))
