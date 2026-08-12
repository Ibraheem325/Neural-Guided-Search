"""Generate a satellite dataset whose SATELLITE COUNT spans 1..8 in every split.

Why: example/satellite_dataset trains on 400/400 single-satellite instances (and val is
single-INSTRUMENT too) while test runs 1-8 satellites. Same structural blind spot that
broke logistics -- scale generalises, structure does not.

satgen usage:  satgen <seed> <#s> <#i> <#m> <#t> <#o>
  #s = satellites, #i = MAX instruments per satellite (not a total),
  #m = modes, #t = targets, #o = observations (goals)

Object count cannot be predicted from the arguments: instruments are drawn per satellite
in 1..#i, and directions come out as #t + 4 (targets plus calibration ground stations).
So -- as with rovers -- generate first, COUNT the objects by their declared type, and
keep the instance only if the real count lands in the split's range.

Naming keeps the original convention: s/i/m/t are the generator ARGUMENTS (that is what
the old dataset encoded), n is the ACTUAL object count.

Ranges rescaled upward so train can host 8 satellites (needs n >= 2s+6 = 22).

Usage: venv/bin/python gen_satellite_dataset.py <satgen_path> <out_dir>
"""
import sys, os, re, glob, random, hashlib, subprocess, collections

# Positionals, with flags stripped. Reading sys.argv[1]/[2] directly would silently take a
# flag VALUE as the output directory if the flags were passed first, and gen_rovers_dataset
# already learned that lesson: an unrecognised flag there once produced the DEFAULT dataset
# and printed a normal-looking summary.
_FLAGS_WITH_VALUE = {"--split", "--seed", "--exclude"}
_pos, _i = [], 1
while _i < len(sys.argv):
    _a = sys.argv[_i]
    if _a.startswith("--"):
        if _a not in _FLAGS_WITH_VALUE:
            sys.exit(f"unknown option {_a}\n  known: {' '.join(sorted(_FLAGS_WITH_VALUE))}")
        _i += 2
        continue
    _pos.append(_a); _i += 1
if len(_pos) != 2:
    sys.exit(f"expected <satgen_path> <out_dir>, got {len(_pos)}: {_pos}")
SATGEN, OUT = _pos
SPLITS = [("train", "TR2s", 400, 8, 22),
          ("val",   "VAL2s", 120, 23, 45),
          ("test",  "TST2s", 120, 46, 95)]
RSEED = 20260803

# --- overrides, for building an IN-DISTRIBUTION test set with the REAL satgen ------------
# The shipped SPLITS give each split a disjoint object range, which is what makes every
# result in this study a size-extrapolation result. To build the missing condition, point a
# split at the TRAINING range with a different seed:
#
#   --split test_ind:IND2s:120:8:22  --seed 20260812 \
#   --exclude example/satellite_dataset_s18/train example/satellite_dataset_s18/val
#
# --exclude rejects any instance whose canonical (:objects)+(:init)+(:goal) matches one in
# those directories. Without it, generating at the training range can and will re-emit
# instances the model was trained on -- the disjoint ranges were previously the only thing
# preventing that.
_ov = [sys.argv[i + 1] for i, a in enumerate(sys.argv) if a == "--split"]
if _ov:
    SPLITS = []
    for _o in _ov:
        _n, _t, _c, _lo, _hi = _o.split(":")
        SPLITS.append((_n, _t, int(_c), int(_lo), int(_hi)))
if "--seed" in sys.argv:
    RSEED = int(sys.argv[sys.argv.index("--seed") + 1])
EXCLUDE = [sys.argv[i + 1] for i, a in enumerate(sys.argv) if a == "--exclude"]


def _canon(txt):
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


_SEEN = set()
for _d in EXCLUDE:
    for _f in glob.glob(os.path.join(_d, "*.pddl")):
        if os.path.basename(_f) != "domain.pddl":
            _SEEN.add(_canon(open(_f, errors="ignore").read()))
if EXCLUDE:
    print(f"excluding {len(_SEEN)} fingerprints from {len(EXCLUDE)} directories")


def count_objects(txt):
    """Count objects by declared type from the (:objects ...) block."""
    m = re.search(r"\(:objects(.*?)\n\s*\)", txt, re.S)
    if not m:
        return None
    toks = m.group(1).split()
    counts, pending = collections.Counter(), []
    i = 0
    while i < len(toks):
        if toks[i] == "-":
            t = toks[i + 1] if i + 1 < len(toks) else "?"
            counts[t.lower()] += len(pending)
            pending = []
            i += 2
        else:
            pending.append(toks[i]); i += 1
    counts["__total__"] = sum(v for k, v in counts.items() if k != "__total__")
    return counts


def main():
    rng = random.Random(RSEED)
    os.makedirs(OUT, exist_ok=True)
    subprocess.run(["cp", os.path.join(os.path.dirname(SATGEN), "domain.pddl"),
                    os.path.join(OUT, "domain.pddl")], check=True)

    for split, tag, count, n_lo, n_hi in SPLITS:
        d = os.path.join(OUT, split)
        os.makedirs(d, exist_ok=True)
        made = tries = dup = 0
        sat = collections.Counter(); ins = collections.Counter(); nobj = []
        while made < count and tries < count * 200:
            tries += 1
            s_max = min(8, max(1, (n_hi - 6) // 2))
            s = rng.randint(1, s_max)
            i = rng.randint(1, 3)                       # max instruments per satellite
            m = rng.randint(1, 5)
            # budget: n ~ s + instruments + m + (t + 4); solve for t, then verify
            i_est = round(s * (1 + i) / 2)
            n_tgt = rng.randint(max(n_lo, 2 * s + 6), n_hi)
            t = n_tgt - s - i_est - m - 4
            if t < 1:
                continue
            o = rng.randint(1, max(1, min(t * m, 2 * t)))
            seed = rng.randint(1, 10 ** 6)
            res = subprocess.run([SATGEN, str(seed), str(s), str(i), str(m), str(t), str(o)],
                                 capture_output=True, text=True)
            txt = res.stdout
            k = txt.find("(define")
            if k < 0 or "(:goal" not in txt or "(:init" not in txt:
                continue
            txt = txt[k:]
            c = count_objects(txt)
            if not c:
                continue
            n = c["__total__"]
            if not (n_lo <= n <= n_hi):
                continue
            a_s = c.get("satellite", 0)
            if a_s != s:                                 # sanity: satellites must be exact
                continue
            h = _canon(txt)
            if h in _SEEN:                               # never re-emit a training instance
                dup += 1
                continue
            _SEEN.add(h)
            name = f"{made:03d}_p-{tag}-n{n}-s{s}i{i}m{m}t{t}-{seed}.pddl"
            with open(os.path.join(d, name), "w") as fh:
                fh.write(txt)
            made += 1; sat[s] += 1; ins[c.get("instrument", 0)] += 1; nobj.append(n)
        print(f"{split}: {made} instances  objects {min(nobj)}-{max(nobj)} "
              f"(median {sorted(nobj)[len(nobj)//2]})"
              + (f"   [{dup} rejected as duplicates of excluded instances]" if dup else ""))
        print(f"   satellites: {dict(sorted(sat.items()))}")
        print(f"   total instruments: {dict(sorted(ins.items()))}")


if __name__ == "__main__":
    main()
