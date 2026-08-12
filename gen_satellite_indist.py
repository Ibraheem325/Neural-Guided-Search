"""Generate satellite instances IN the training distribution, disjoint from training.

WHY. Every dataset in this study was built with disjoint object ranges per split --
satellite is train 8-22 objects, val 23-45, test 46-95 -- so every reported result is a
SIZE-EXTRAPOLATION result. That confounds two questions: does the signal help, and does it
help under distribution shift. This builds the missing condition: a test set whose instances
look like training instances, so the model is evaluated in-distribution.

NO DEPTH CONTROL. The existing probe sets cut a state d steps from the goal, with d
stratified 5-22. Here the instances are used from their INITIAL state, so difficulty is
whatever the generator produces. That is the point -- the only thing held fixed is size.

WHY A NATIVE GENERATOR. gen_satellite_dataset.py shells out to a `satgen` binary that is no
longer on the cluster. Rewriting the generation in Python removes that dependency and, more
importantly, lets the training-overlap check happen INSIDE generation rather than as an
afterthought.

SHAPE COMES FROM TRAINING, STRUCTURE DOES NOT. Rather than guess parameter ranges, this
reads the train split and resamples its (satellites, instruments, modes, directions, goals)
tuples. So the size and shape distribution matches training exactly by construction, while
the calibration targets, instrument assignments, initial pointing and goals are drawn fresh.

OVERLAP IS THE REAL RISK HERE, and it is new. Until now test instances COULD NOT collide
with training ones because the object ranges were disjoint -- 46-95 against 8-22. Generating
in the training range removes that guarantee. Every candidate is therefore hashed on its
canonical (:objects)+(:init)+(:goal) -- atoms sorted, whitespace collapsed, the same
fingerprint check_probe_set.py uses -- and rejected on any collision with train, val, or an
already-accepted instance. The rejection count is reported: a high rate would mean the
instance space at this size is too small for the comparison to be meaningful, which is
itself worth knowing before running a sweep on it.

SOLVABILITY. turn_to has no topology restriction, so any direction is reachable from any
other. An instance is therefore solvable iff every goal image (d, m) has some instrument
that supports m, is on board some satellite, and has at least one calibration target. The
generator enforces that rather than checking it afterwards.

Usage:
  venv/bin/python gen_satellite_indist.py <train_dir> <out_dir> [n] [--seed S] [--val DIR]
  e.g. venv/bin/python gen_satellite_indist.py example/satellite_dataset_s18/train \\
                                               example/satIndist_120 120 \\
                                               --val example/satellite_dataset_s18/val
"""
import sys, os, re, glob, random, hashlib, argparse, collections, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("train_dir")
ap.add_argument("out_dir")
ap.add_argument("n", nargs="?", default=120, type=int)
ap.add_argument("--val", default=None, help="val split, also excluded from overlap")
ap.add_argument("--seed", default=20260812, type=int)
ap.add_argument("--max-tries", dest="max_tries", default=200, type=int,
                help="candidates per accepted instance before giving up")
A_ = ap.parse_args()

rng = random.Random(A_.seed)


def canon_text(txt):
    """Canonical fingerprint: objects+init+goal, atoms sorted. Same as check_probe_set.py."""
    txt = txt.lower()
    parts = []
    for sec in (":objects", ":init", ":goal"):
        i = txt.find("(" + sec)
        if i < 0:
            parts.append(""); continue
        j, depth = i, 0
        while j < len(txt):
            if txt[j] == "(": depth += 1
            elif txt[j] == ")":
                depth -= 1
                if depth == 0: break
            j += 1
        atoms = sorted(a.strip() for a in re.findall(r"\(([^()]*)\)", txt[i:j + 1]) if a.strip())
        parts.append("|".join(atoms))
    return hashlib.sha1("||".join(parts).encode()).hexdigest()


def shape_of(txt):
    """(satellites, instruments, modes, directions, n_image, n_point) from an instance.

    n_point matters: 288 of the 400 training instances carry a `pointing` goal, so a
    generator that emits only have_image goals is off-distribution in a way that shows up in
    the plans (every pointing goal forces a final turn_to) even when the object counts match.
    """
    m = re.search(r"\(:objects(.*?)\n\)", txt, re.S)
    if not m:
        return None
    cnt = collections.Counter()
    for line in m.group(1).strip().splitlines():
        if "-" in line:
            names, typ = line.rsplit("-", 1)
            cnt[typ.strip()] += len(names.split())
    g = txt.split("(:goal", 1)[1] if "(:goal" in txt else ""
    nimg = len(re.findall(r"\(have_image", g))
    npnt = len(re.findall(r"\(pointing", g))
    if not all(cnt[k] for k in ("satellite", "instrument", "mode", "direction")) or nimg < 1:
        return None
    return (cnt["satellite"], cnt["instrument"], cnt["mode"], cnt["direction"], nimg, npnt)


# ---- read the training split: shapes to resample, hashes to avoid --------------------
shapes, seen = [], set()
for f in sorted(glob.glob(os.path.join(A_.train_dir, "*.pddl"))):
    if os.path.basename(f) == "domain.pddl":
        continue
    t = open(f, errors="ignore").read()
    sh = shape_of(t)
    if sh:
        shapes.append(sh)
    seen.add(canon_text(t))
n_train = len(seen)
if not shapes:
    raise SystemExit(f"no usable instances in {A_.train_dir}")

n_val = 0
if A_.val:
    for f in sorted(glob.glob(os.path.join(A_.val, "*.pddl"))):
        if os.path.basename(f) == "domain.pddl":
            continue
        seen.add(canon_text(open(f, errors="ignore").read()))
        n_val += 1

objs = [s + i + m + d for s, i, m, d, _, _ in shapes]
n_pt = sum(1 for sh in shapes if sh[5] > 0)
print(f"training shapes: {len(shapes)} instances, objects {min(objs)}-{max(objs)} "
      f"(median {st.median(objs):.0f});  {n_pt}/{len(shapes)} carry a pointing goal")
print(f"excluding {n_train} train + {n_val} val fingerprints\n")


def build(sat, ins, mod, dirs, nimg, npnt):
    """One instance. Directions are named GroundStation/Star/Planet as the original set is;
    calibration targets are drawn from non-Planet directions and image goals from any, which
    mirrors how the shipped instances look."""
    dnames = []
    for k in range(dirs):
        kind = rng.choice(("GroundStation", "Star", "Planet")) if k >= 2 else \
               rng.choice(("GroundStation", "Star"))
        dnames.append(f"{kind}{k}")
    sats = [f"satellite{k}" for k in range(sat)]
    inst = [f"instrument{k}" for k in range(ins)]
    mods = [f"mode{k}" for k in range(mod)]
    calib_pool = [d for d in dnames if not d.startswith("Planet")] or dnames

    # every instrument: on exactly one satellite, supports >=1 mode, >=1 calibration target
    on_board = {i: rng.choice(sats) for i in inst}
    supports = {i: rng.sample(mods, rng.randint(1, len(mods))) for i in inst}
    calib = {i: rng.sample(calib_pool, rng.randint(1, min(3, len(calib_pool)))) for i in inst}

    # a mode is usable iff some instrument supports it (every instrument has a target above)
    usable = sorted({m for i in inst for m in supports[i]})
    if not usable:
        return None

    # goals: distinct (direction, mode) pairs over usable modes -- solvable by construction
    pairs = [(d, m) for d in dnames for m in usable]
    if not pairs:
        return None
    goals = rng.sample(pairs, min(nimg, len(pairs)))
    # At most ONE pointing goal per satellite -- two would be unsatisfiable, since a
    # satellite points in exactly one direction.
    pgoals = [(s_, rng.choice(dnames)) for s_ in rng.sample(sats, min(npnt, len(sats)))]

    L = ["(define (problem satindist)", "(:domain satellite)", "(:objects"]
    L += [f"\t{s} - satellite" for s in sats]
    L += [f"\t{i} - instrument" for i in inst]
    L += [f"\t{m} - mode" for m in mods]
    L += [f"\t{d} - direction" for d in dnames]
    L += [")", "(:init"]
    for i in inst:
        for m in supports[i]:
            L.append(f"\t(supports {i} {m})")
        for d in calib[i]:
            L.append(f"\t(calibration_target {i} {d})")
        L.append(f"\t(on_board {i} {on_board[i]})")
    for s in sats:
        L.append(f"\t(power_avail {s})")
        L.append(f"\t(pointing {s} {rng.choice(dnames)})")
    L += [")", "(:goal (and"]
    L += [f"\t(have_image {d} {m})" for d, m in goals]
    L += [f"\t(pointing {s_} {d})" for s_, d in pgoals]
    L += ["))", "", ")"]
    return "\n".join(L) + "\n"


os.makedirs(A_.out_dir, exist_ok=True)
dom = os.path.join(os.path.dirname(A_.train_dir.rstrip("/")), "domain.pddl")
if not os.path.exists(dom):
    dom = os.path.join(A_.train_dir, "domain.pddl")
if os.path.exists(dom):
    open(os.path.join(A_.out_dir, "domain.pddl"), "w").write(open(dom).read())
else:
    print(f"WARNING: no domain.pddl found near {A_.train_dir}")

written, collisions, tries = 0, 0, 0
made = []
while written < A_.n:
    tries += 1
    if tries > A_.n * A_.max_tries:
        print(f"\nSTOPPED: only {written}/{A_.n} after {tries} candidates. The instance "
              f"space at this size is too small -- {collisions} collisions with "
              f"train/val/already-made. That is itself a finding: an in-distribution test "
              f"set of this size cannot be built disjoint from training.")
        break
    sat, ins, mod, dirs, nimg, npnt = shapes[rng.randrange(len(shapes))]
    txt = build(sat, ins, mod, dirs, nimg, npnt)
    if txt is None:
        continue
    h = canon_text(txt)
    if h in seen:
        collisions += 1
        continue
    seen.add(h)
    name = f"{written:03d}_p-IND-n{sat+ins+mod+dirs}-s{sat}i{ins}m{mod}d{dirs}g{nimg}p{npnt}"
    open(os.path.join(A_.out_dir, name + ".pddl"), "w").write(txt)
    made.append((sat + ins + mod + dirs, nimg, npnt))
    written += 1

o = [m[0] for m in made]
g = [m[1] for m in made]
pg = sum(1 for m in made if m[2] > 0)
print(f"wrote {written} instances to {A_.out_dir}")
if o:
    print(f"  objects {min(o)}-{max(o)} (median {st.median(o):.0f})   "
          f"image goals {min(g)}-{max(g)} (median {st.median(g):.0f})   "
          f"{pg}/{len(made)} with a pointing goal")
print(f"  {collisions} candidates rejected for colliding with train/val/already-made "
      f"({100.0*collisions/max(1,tries):.1f}% of {tries} tried)")
print("\nNEXT: verify with check_probe_set.py --dataset <the dataset> --trained-on <same>,")
print("then run_fd_optimal.sh for the optimal lengths. There are no .plan files and no")
print("distance-to-goal labels by design -- these are whole instances, not probes.")
