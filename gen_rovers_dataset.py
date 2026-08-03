"""Generate a rovers dataset whose ROVER COUNT spans 1..8 in every split.

Why: example/rovers_dataset has 391/400 single-rover training instances but 1-8 rovers
at test. That is the same structural blind spot that broke logistics (trained c2s1 only,
tested on c3s3/c4s2) -- scale generalises, structure does not. This keeps each split's
OBJECT-SIZE range exactly as the original and changes only the rover distribution.

Object count is exact:  n = 2*rovers + waypoints + objectives + cameras + 4
  (2 per rover = rover + store; +4 = 3 modes + 1 lander)
so an instance needs n >= 2*r + 8, i.e. 8 rovers needs n >= 24.

Usage:
  venv/bin/python gen_rovers_dataset.py <rovgen_path> <out_dir> [--plans <fast-downward.py>]
"""
import sys, os, random, subprocess, collections, re

ROVGEN = sys.argv[1]
OUT = sys.argv[2]
FD = sys.argv[sys.argv.index("--plans") + 1] if "--plans" in sys.argv else None

# (split, tag, count, n_lo, n_hi) -- object ranges copied from the original dataset
SPLITS = [("train", "TR3r", 400, 11, 40),
          ("val",   "VAL3r", 120, 41, 50),
          ("test",  "TST3r", 120, 51, 101)]
RSEED = 20260803


def pick(n_lo, n_hi, rng):
    """Choose (r, w, o, c) with 2r+w+o+c+4 in [n_lo, n_hi], rover count as uniform as
    the object budget allows."""
    for _ in range(500):
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
            got = pick(n_lo, n_hi, rng)
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
