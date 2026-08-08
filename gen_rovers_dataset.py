"""Generate a rovers dataset. By default the ROVER COUNT spans 1..8 in every split;
--rovers R pins it instead.

Why: example/rovers_dataset has 391/400 single-rover training instances but 1-8 rovers
at test. That is the same structural blind spot that broke logistics (trained c2s1 only,
tested on c3s3/c4s2) -- scale generalises, structure does not. This keeps each split's
OBJECT-SIZE range exactly as the original and changes only the rover distribution.

Object count is exact:  n = 2*rovers + waypoints + objectives + cameras + 4
  (2 per rover = rover + store; +4 = 3 modes + 1 lander)
so an instance needs n >= 2*r + 8, i.e. 8 rovers needs n >= 24.

TOPOLOGY CONTROL (--rovers). Supervisor's rule, in three cases:
  train {2},    test {3}    -> FAILS. A structure never seen is not learned.
  train {2},    test {2}    -> fine. Pinning is allowed if both sides pin the same value;
                              use it when it makes data generation easier.
  train {2..4}, test {5}    -> likely fine. Seeing a RANGE teaches how the topology varies,
                              and that extrapolates a step beyond the range.
Accepted forms:
  --rovers 2          pin 2 everywhere                      (case 2)
  --rovers 2-4        uniform in 2..4 in every split        (case 3, no extrapolation)
  --rovers 2-4:2-5    train 2..4, val+test 2..5             (case 3, tests the step beyond)
Default (flag absent) is 1..8 in every split.

Rovers, waypoints and objectives are exact from rovgen; cameras are NOT (it adds extras to
keep goals achievable), so cameras cannot be pinned.

--objects overrides the per-split object ranges, in either form:
  --objects 8:22                one range for every split
  --objects 10:24,25:46,47:95   per-split: train,val,test
Worth knowing: the DEFAULT ranges are disjoint (train 11-40, val 41-50, test 51-101), so
every test instance is larger than anything seen in training. That is a scale
extrapolation, a SEPARATE issue from the topology point above, and not fixed by --rovers.

SIZING AGAINST SATELLITE. satellite_dataset_s18 uses train 8-22 / val 23-45 / test 46-95,
and its QR-DQN trained to a calibration slope of -0.921 while rovers_dataset_r18
(train 12-40, median 31 objects) produced a FLAT -0.007 -- unusable. Copying satellite's
shape is therefore worth trying, but 8:22 cannot be copied literally: satellite needs
n >= 2s+6 so 8 satellites fit in 22, while rovers needs n >= 2r+8 so 8 rovers need 24.
Use train 10:24 to keep the full 1..8 rover range, or keep 8:22 and pin --rovers 1-7.

Usage:
  venv/bin/python gen_rovers_dataset.py <rovgen_path> <out_dir> [--plans <fast-downward.py>]
                                        [--rovers SPEC] [--objects SPEC]
"""
import sys, os, random, subprocess, collections, re

# Validate argv BEFORE anything else. This script parses by index and used to ignore
# whatever it did not recognise -- so an unsupported flag (or one added after the copy on
# the cluster was last pulled) silently produced the DEFAULT dataset and printed a
# normal-looking summary. Fail loudly instead.
_KNOWN = {"--plans", "--rovers", "--objects"}
_pos, _i = [], 1
while _i < len(sys.argv):
    _a = sys.argv[_i]
    if _a.startswith("--"):
        if _a not in _KNOWN:
            sys.exit(f"unknown option {_a}\n  known: {' '.join(sorted(_KNOWN))}\n"
                     f"  (if you expected this flag to exist, `git pull` -- an older copy "
                     f"of this script would have IGNORED it and generated the default set)")
        if _i + 1 >= len(sys.argv):
            sys.exit(f"{_a} needs a value")
        _i += 2
        continue
    _pos.append(_a); _i += 1
if len(_pos) != 2:
    sys.exit(f"expected <rovgen_path> <out_dir>, got {len(_pos)}: {_pos}")

ROVGEN, OUT = _pos
FD = sys.argv[sys.argv.index("--plans") + 1] if "--plans" in sys.argv else None
def _rspec(t):
    """'2' -> (2,2);  '2-4' -> (2,4)"""
    if "-" in t:
        a, b = t.split("-"); return (int(a), int(b))
    return (int(t), int(t))


_R = sys.argv[sys.argv.index("--rovers") + 1] if "--rovers" in sys.argv else None
if _R:
    _parts = _R.split(":")
    R_TRAIN = _rspec(_parts[0])
    R_EVAL = _rspec(_parts[1]) if len(_parts) > 1 else R_TRAIN
else:
    R_TRAIN = R_EVAL = None
_OBJ = sys.argv[sys.argv.index("--objects") + 1] if "--objects" in sys.argv else None

# (split, tag, count, n_lo, n_hi) -- object ranges copied from the original dataset
SPLITS = [("train", "TR3r", 400, 11, 40),
          ("val",   "VAL3r", 120, 41, 50),
          ("test",  "TST3r", 120, 51, 101)]
if _OBJ:
    # Two forms:
    #   --objects 8:22                  one range for every split (original behaviour)
    #   --objects 10:24,25:46,47:95     per-split: train,val,test
    # Per-split is needed to mirror the satellite dataset's shape (small train, disjoint
    # larger val/test). NOTE the rovers constraint n >= 2*r + 8: a train range topping out
    # at 22 caps the rover count at 7, so 1..8 rovers needs n_hi >= 24 in train.
    _specs = _OBJ.split(",")
    if len(_specs) == 1:
        _lo, _hi = (int(x) for x in _specs[0].split(":"))
        SPLITS = [(s_, t, c, _lo, _hi) for s_, t, c, _, _ in SPLITS]
    elif len(_specs) == len(SPLITS):
        _rng = [tuple(int(x) for x in sp.split(":")) for sp in _specs]
        SPLITS = [(s_, t, c, lo, hi)
                  for (s_, t, c, _, _), (lo, hi) in zip(SPLITS, _rng)]
    else:
        sys.exit(f"--objects takes 1 or {len(SPLITS)} ranges, got {len(_specs)}: {_OBJ}")
    for s_, _t, _c, lo, hi in SPLITS:
        if lo > hi:
            sys.exit(f"--objects: {s_} range {lo}:{hi} is inverted")
        _rmax = (hi - 8) // 2
        if _rmax < 1:
            sys.exit(f"--objects: {s_} tops out at {hi} objects, which cannot fit even "
                     f"1 rover (needs n >= 10)")
        print(f"[objects] {s_}: {lo}-{hi} objects -> at most {_rmax} rovers "
              f"(constraint n >= 2r+8)")
if R_TRAIN is not None:
    def _tag(sp):
        lo, hi = R_TRAIN if sp == "train" else R_EVAL
        return f"R{lo}" if lo == hi else f"R{lo}t{hi}"
    SPLITS = [(s_, _tag(s_), c, lo, hi) for s_, t, c, lo, hi in SPLITS]
RSEED = 20260803


def pick(n_lo, n_hi, rng, rspec=None):
    """Choose (r, w, o, c) with 2r+w+o+c+4 in [n_lo, n_hi], rover count as uniform as
    the object budget allows."""
    for _ in range(500):
        if rspec is not None:
            r_lo, r_hi = rspec             # controlled topology
            r_hi = min(r_hi, max(r_lo, (n_hi - 8) // 2))
            if 2 * r_lo + 8 > n_hi:
                return None                # object budget cannot fit this many rovers
            r = rng.randint(r_lo, r_hi)
        else:
            r_max = min(8, (n_hi - 8) // 2)
            if r_max < 1:
                r_max = 1
            r = rng.randint(1, r_max)
        n = rng.randint(max(n_lo, 2 * r + 8), n_hi)
        rest = n - 2 * r - 4                      # split across w, o, c
        if rest < 4:
            continue
        # waypoints dominate (a map needs room); objectives and cameras take the tail
        w = rng.randint(max(2, int(rest * 0.45)), max(3, int(rest * 0.75)))
        left = rest - w
        if left < 2:
            continue
        o = rng.randint(1, max(1, left - 1))
        c = left - o
        if c < 1:
            continue
        assert 2 * r + w + o + c + 4 == n
        return r, w, o, c, n
    return None


def main():
    rng = random.Random(RSEED)
    os.makedirs(OUT, exist_ok=True)
    # domain.pddl ships with the generator
    dom_src = os.path.join(os.path.dirname(ROVGEN), "domain.pddl")
    subprocess.run(["cp", dom_src, os.path.join(OUT, "domain.pddl")], check=True)

    for split, tag, count, n_lo, n_hi in SPLITS:
        d = os.path.join(OUT, split)
        os.makedirs(d, exist_ok=True)
        made, tries, seen = 0, 0, set()
        rovhist = collections.Counter(); nhist = []
        while made < count and tries < count * 60:
            tries += 1
            got = pick(n_lo, n_hi, rng, R_TRAIN if split == "train" else R_EVAL)
            if not got:
                continue
            r, w, o, c, n = got
            key = (r, w, o, c)
            seed = rng.randint(1, 10 ** 6)
            goals = rng.randint(1, max(1, min(o + 2, 3 + o)))
            # NOTE: rovgen's -f flag mis-parses its arguments and just prints usage.
            # It writes the instance to stdout instead, so capture that.
            #
            # NOTE 2: rovgen does NOT honour #cameras exactly -- it adds extra cameras
            # (observed +1..+6) so that every goal image has a supporting camera on a
            # reachable rover. Rovers/waypoints/objectives ARE exact. So never predict
            # the object count from a formula: generate, then COUNT what came out and
            # name the file from that. Keeps filenames truthful and the split's object
            # range exact.
            res = subprocess.run([ROVGEN, str(seed), str(r), str(w),
                                  str(o), str(c), str(goals)],
                                 capture_output=True, text=True)
            txt = res.stdout
            i = txt.find("(define")
            if i < 0 or "(:goal" not in txt or "(:init" not in txt:
                continue
            txt = txt[i:]
            mo = re.search(r"\(:objects(.*?)\n\s*\)", txt, re.S)
            if not mo:
                continue
            toks = [t for t in re.split(r"[\s]+", mo.group(1)) if t and t != "-"]
            names = [t for t in toks if not t.lower() in
                     ("lander", "mode", "rover", "store", "waypoint", "camera", "objective")]
            a_n = len(names)
            a_r = sum(1 for x in names if re.fullmatch(r"rover\d+", x, re.I))
            a_w = sum(1 for x in names if re.fullmatch(r"waypoint\d+", x, re.I))
            a_o = sum(1 for x in names if re.fullmatch(r"objective\d+", x, re.I))
            a_c = sum(1 for x in names if re.fullmatch(r"camera\d+", x, re.I))
            if not (n_lo <= a_n <= n_hi):      # excess cameras pushed it out of range
                continue
            name = f"{made:03d}_p-{tag}-n{a_n}-r{a_r}w{a_w}o{a_o}c{a_c}-{seed}.pddl"
            path = os.path.join(d, name)
            with open(path, "w") as fh:
                fh.write(txt)
            r, n = a_r, a_n
            made += 1; rovhist[r] += 1; nhist.append(n); seen.add(key)
        print(f"{split}: {made} instances  objects {min(nhist)}-{max(nhist)} "
              f"(median {sorted(nhist)[len(nhist)//2]})  distinct (r,w,o,c) {len(seen)}")
        print(f"   rovers: {dict(sorted(rovhist.items()))}")


if __name__ == "__main__":
    main()
