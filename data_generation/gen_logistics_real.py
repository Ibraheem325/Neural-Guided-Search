"""Logistics instances from the REAL generator (AI-Planning/pddl-generators/logistics).

WHY THE REAL GENERATOR. My hand-written satellite reconstruction came out off-distribution
in a way that changed the headline number -- median instruments 5 against training's 4, and
confidently-wrong 16.3% where the real generator gives 9.8%. So nothing here is
reconstructed: this drives the shipped binary and only chooses its parameters.

THE PARAMETERS ARE RECOVERABLE EXACTLY, which makes logistics the cleanest of the domains.
Each training instance carries the generator's own header, `logistics-c4-s1-p16-a1`, so
(airplanes, cities, size, packages) is read straight off it rather than inferred. Verified
across all 400 training instances:

    trucks   == cities      (ratio exactly 1.0, never anything else)
    locations == cities*size (difference exactly 0, never anything else)

so trucks and locations are not free parameters at all -- the generator places one truck per
city and `size` locations per city. Only (a, c, s, p) are sampled, from the training
split's own joint histogram, which keeps the shape distribution matched by construction.
Training ranges: a 1-3, c 2-4, s 1-3, p 2-26 (median 5); objects 10-36 (median 20).

THE -t FLAG IS AUTO-CALIBRATED rather than assumed. Different builds of this generator read
-t as trucks-per-city or as total trucks, and guessing wrong would silently produce instances
with the wrong truck count. At startup the script generates one instance with -t 1 at a known
city count and counts the trucks it got back, then reports which convention this build uses.
Every generated instance is then re-parsed and REJECTED if its actual (a,c,s,p,trucks) does
not match what was asked for, so a wrong flag cannot leak into the test set silently.

OVERLAP IS THE POINT OF THIS SET, and it is the real risk here. The shipped splits used
disjoint object ranges, which is what makes every result so far a size-extrapolation result.
Generating at training sizes removes that structural guarantee. Worse, logistics has only 203
distinct (a,c,s,p) tuples across 400 training instances, so tuples repeat and two instances
differ only in package placement and goals. Every candidate is therefore hashed on canonical
(:objects)+(:init)+(:goal) and rejected against train, val and already-accepted; the
rejection rate is reported, and a high one would mean the instance space at these sizes is
too small for the comparison to mean anything.

NOTE ON THE EXCLUSION SET. The logistics models are `logistics_topo_*`, trained on
`logistics_dataset_topo`, which has NO test split -- only train (400) and val (120). So the
exclusion set is those 520 instances, not the v1 `logistics_dataset` the old probes came
from. Pass both --exclude directories.

NO DISTANCE CONTROL, by design. These are whole instances solved from their initial state,
so `distance_to_goal` is left empty in labels.csv and there are no .plan files. Difficulty is
whatever the generator produces at training sizes -- the only thing held fixed is shape.

Usage:
  venv/bin/python gen_logistics_real.py <generator> <train_dir> <out_dir> [n] \\
                                        [--seed S] [--exclude DIR]...
  e.g. venv/bin/python gen_logistics_real.py \\
         /path/to/pddl-generators/logistics/logistics \\
         datasets/logistics_dataset_topo/train datasets/logIndistReal 120 \\
         --exclude datasets/logistics_dataset_topo/train \\
         --exclude datasets/logistics_dataset_topo/val
"""
import os, re, csv, sys, glob, random, hashlib, subprocess, collections, statistics as st

_FLAGS = {"--seed", "--exclude"}
_pos, _i = [], 1
while _i < len(sys.argv):
    a = sys.argv[_i]
    if a.startswith("--"):
        if a not in _FLAGS:
            sys.exit(f"unknown option {a}\n  known: {' '.join(sorted(_FLAGS))}")
        _i += 2
        continue
    _pos.append(a); _i += 1
if len(_pos) not in (3, 4):
    sys.exit(f"expected <generator> <train_dir> <out_dir> [n], got {len(_pos)}: {_pos}")
GEN, TRAIN, OUT = _pos[0], _pos[1], _pos[2]
N = int(_pos[3]) if len(_pos) == 4 else 120
SEED = int(sys.argv[sys.argv.index("--seed") + 1]) if "--seed" in sys.argv else 20260812
EXCLUDE = [sys.argv[i + 1] for i, a in enumerate(sys.argv) if a == "--exclude"]

if not os.path.exists(GEN):
    sys.exit(f"generator not found: {GEN}\n  build it: cd <pddl-generators>/logistics && make")

rng = random.Random(SEED)


def canon(txt):
    """objects+init+goal, atoms sorted -- the same fingerprint check_probe_set.py uses."""
    txt = txt.lower(); parts = []
    for sec in (":objects", ":init", ":goal"):
        i = txt.find("(" + sec)
        if i < 0:
            parts.append(""); continue
        j, d = i, 0
        while j < len(txt):
            if txt[j] == "(": d += 1
            elif txt[j] == ")":
                d -= 1
                if d == 0: break
            j += 1
        parts.append("|".join(sorted(a.strip() for a in
                                     re.findall(r"\(([^()]*)\)", txt[i:j + 1]) if a.strip())))
    return hashlib.sha1("||".join(parts).encode()).hexdigest()


def shape_of(txt):
    """(airplanes, cities, size, packages, trucks, locations) from generator output."""
    m = re.search(r"logistics-c(\d+)-s(\d+)-p(\d+)-a(\d+)", txt)
    if not m:
        return None
    c, s, p, a = map(int, m.groups())
    tr = len(re.findall(r"\(TRUCK ", txt, re.I))
    loc = len(re.findall(r"\(LOCATION ", txt, re.I))
    return (a, c, s, p, tr, loc)


def run_gen(a, c, s, p, t, seed):
    # -t is TOTAL trucks with a floor of one per city ("default and minimal: same as number
    # of cities"), so passing -t 1 at 3 cities makes the generator print usage and emit no
    # PDDL. Training is always trucks == cities, which IS the default -- so -t is omitted
    # entirely and the t argument is vestigial. shape_of() still verifies the truck count on
    # every accepted instance, so a build whose default differs would be caught, not kept.
    res = subprocess.run([GEN, "-a", str(a), "-c", str(c), "-s", str(s),
                          "-p", str(p), "-r", str(seed)],
                         capture_output=True, text=True)
    txt = res.stdout
    k = txt.find("(define")
    if k < 0:
        return None, (res.stdout + res.stderr)[:800]
    return txt[k:], None


# ---- training shapes ------------------------------------------------------------------
shapes = []
for f in sorted(glob.glob(os.path.join(TRAIN, "*.pddl"))):
    if os.path.basename(f) == "domain.pddl":
        continue
    sh = shape_of(open(f, errors="ignore").read())
    if sh:
        shapes.append(sh)
if not shapes:
    sys.exit(f"no parsable logistics instances in {TRAIN}")

bad_t = [sh for sh in shapes if sh[4] != sh[1]]
bad_l = [sh for sh in shapes if sh[5] != sh[1] * sh[2]]
objs = [sh[0] + sh[1] + sh[4] + sh[5] + sh[3] for sh in shapes]
print(f"training: {len(shapes)} instances, objects {min(objs)}-{max(objs)} "
      f"(median {st.median(objs):.0f})")
for i, nm in ((0, "airplanes"), (1, "cities"), (2, "size"), (3, "packages")):
    v = [sh[i] for sh in shapes]
    print(f"  {nm:10s} {min(v)}-{max(v)}  median {st.median(v):.0f}")
print(f"  trucks == cities in {len(shapes)-len(bad_t)}/{len(shapes)};  "
      f"locations == cities*size in {len(shapes)-len(bad_l)}/{len(shapes)}")
if bad_t or bad_l:
    print("  WARNING: the invariants this generator relies on do not hold everywhere.")
tuples = collections.Counter(sh[:4] for sh in shapes)
print(f"  {len(tuples)} distinct (a,c,s,p) tuples across {len(shapes)} instances -- tuples "
      f"repeat, so instances differ only in placement and goals")

# ---- calibrate what -t means on THIS build --------------------------------------------
probe_txt, err = run_gen(1, 3, 1, 3, 1, 12345)
if probe_txt is None:
    sys.exit(f"generator produced no PDDL. Its output was:\n{err}\n"
             f"Check the flag names -- this script assumes -a -c -s -p -t -r.")
ps = shape_of(probe_txt)
if ps is None:
    sys.exit("generator output has no `logistics-cN-sN-pN-aN` header; cannot verify shape.")
if ps[4] == 3:
    T_PER_CITY, tdesc = True, "-t omitted; generator defaults to one truck per city"
else:
    sys.exit(f"3 cities produced {ps[4]} trucks, not 3 -- this build's default is not one "
             f"truck per city, which is what training has. Aborting rather than guessing.")
print(f"\ncalibration: {tdesc}")

# training always has trucks == cities, i.e. one per city
def t_arg(c):
    return 1 if T_PER_CITY else c

# variability check: the same shape with two seeds must differ, or -r is being ignored
t1, _ = run_gen(1, 3, 1, 3, t_arg(3), 111)
t2, _ = run_gen(1, 3, 1, 3, t_arg(3), 222)
if t1 and t2 and canon(t1) == canon(t2):
    sys.exit("two different -r seeds gave an identical instance -- this build ignores the "
             "seed flag, so a 120-instance set cannot be generated. Check the usage string.")
print("seed check: different -r seeds give different instances\n")

# ---- exclusion set --------------------------------------------------------------------
seen = set()
for d in EXCLUDE:
    n = 0
    for f in glob.glob(os.path.join(d, "*.pddl")):
        if os.path.basename(f) != "domain.pddl":
            seen.add(canon(open(f, errors="ignore").read())); n += 1
    print(f"excluding {n} instances from {d}")
if not EXCLUDE:
    print("WARNING: no --exclude given, so overlap with training is NOT being checked.")
print(f"{len(seen)} distinct fingerprints excluded\n")

# ---- generate -------------------------------------------------------------------------
os.makedirs(OUT, exist_ok=True)
for cand in (os.path.join(os.path.dirname(TRAIN.rstrip("/")), "domain.pddl"),
             os.path.join(TRAIN, "domain.pddl")):
    if os.path.exists(cand):
        open(os.path.join(OUT, "domain.pddl"), "w").write(open(cand).read())
        break
else:
    print(f"WARNING: no domain.pddl found near {TRAIN}")

made = tries = dup = mismatch = 0
rows, nobj = [], []
while made < N and tries < N * 400:
    tries += 1
    a, c, s, p = shapes[rng.randrange(len(shapes))][:4]
    txt, err = run_gen(a, c, s, p, t_arg(c), rng.randint(1, 10 ** 6))
    if txt is None:
        continue
    sh = shape_of(txt)
    # never trust the flags: the instance must BE what was asked for
    if sh is None or sh[:4] != (a, c, s, p) or sh[4] != c or sh[5] != c * s:
        mismatch += 1
        continue
    h = canon(txt)
    if h in seen:
        dup += 1
        continue
    seen.add(h)
    nobj_ = a + c + sh[4] + sh[5] + p
    name = f"{made:03d}_p-IND-n{nobj_}-c{c}s{s}p{p}a{a}"
    open(os.path.join(OUT, name + ".pddl"), "w").write(txt)
    rows.append(dict(file=name + ".pddl", distance_to_goal="", source_split="generated",
                     source_problem="", source_plan_len="", num_objects=nobj_))
    nobj.append(nobj_)
    made += 1

with open(os.path.join(OUT, "labels.csv"), "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["file", "distance_to_goal", "source_split",
                                       "source_problem", "source_plan_len", "num_objects"])
    w.writeheader(); w.writerows(rows)

print(f"wrote {made} instances to {OUT}")
if nobj:
    print(f"  objects {min(nobj)}-{max(nobj)} (median {st.median(nobj):.0f})   "
          f"training was {min(objs)}-{max(objs)} (median {st.median(objs):.0f})")
print(f"  {dup} rejected as duplicates of excluded/already-made "
      f"({100.0*dup/max(1,tries):.1f}% of {tries} tried)")
if mismatch:
    print(f"  {mismatch} rejected for not matching the requested shape -- if this is most of "
          f"them, the flag convention is wrong")
if made < N:
    print(f"\nSTOPPED at {made}/{N}. The instance space at training sizes is too small to "
          f"build a set disjoint from training -- that is itself a finding.")

print("\nNEXT:")
print("  check_probe_set.py --dataset datasets/logistics_dataset_topo "
      "--trained-on datasets/logistics_dataset_topo")
print("  run_fd_optimal.sh  (optimal lengths)   and   run_fd_solve.sh  (.plan files, needed")
print("  by prior_peak.py -- whole-instance sets ship without them)")
