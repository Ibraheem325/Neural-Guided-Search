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
import sys, os, re, random, subprocess, collections

SATGEN, OUT = sys.argv[1], sys.argv[2]
SPLITS = [("train", "TR2s", 400, 8, 22),
          ("val",   "VAL2s", 120, 23, 45),
          ("test",  "TST2s", 120, 46, 95)]
RSEED = 20260803


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
        made = tries = 0
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
            name = f"{made:03d}_p-{tag}-n{n}-s{s}i{i}m{m}t{t}-{seed}.pddl"
            with open(os.path.join(d, name), "w") as fh:
                fh.write(txt)
            made += 1; sat[s] += 1; ins[c.get("instrument", 0)] += 1; nobj.append(n)
        print(f"{split}: {made} instances  objects {min(nobj)}-{max(nobj)} "
              f"(median {sorted(nobj)[len(nobj)//2]})")
        print(f"   satellites: {dict(sorted(sat.items()))}")
        print(f"   total instruments: {dict(sorted(ins.items()))}")


if __name__ == "__main__":
    main()
