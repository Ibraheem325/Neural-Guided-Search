"""Goldminer instances from the REAL generator (AI-Planning/pddl-generators/goldminer).

WHY THIS REPLACES gen_goldminer_indist.py. That script reconstructed the instance
distribution by resampling (rows, cols, clear cells, soft-rock fraction) from the training
split. But the real generator takes only THREE options --

    -r <rows>   -c <cols>   -s <seed>

-- so rock density, the clear-cell count and the soft/hard split are all internal. There is
no parameter for them, which means my reconstruction was guessing at a distribution the
generator produces implicitly, with no way to verify I had it right. The satellite
comparison showed that guessing is not free: my satellite set came out with median
instruments 5 against training's 4 and median directions 5 against 6.

So this drives the real binary and only chooses the grid size, which IS a parameter.

GRID SIZES come from the training split's own distribution -- the instance name carries
rows/cols ("typed-bomberman-rows5-cols7"), so the empirical (R,C) histogram is read straight
off it and resampled. Training runs 2x2 through 6x7, giving objects = R*C in 4-42.

OVERLAP. Generating at training sizes removes the structural guarantee that test and train
cannot collide -- the shipped splits used disjoint object ranges (train 4-42, val 42-49,
test 49-100) and that is exactly what makes every result so far a size-extrapolation result.
Every candidate is hashed on canonical (:objects)+(:init)+(:goal) and rejected against
train, val and already-accepted. Small grids are the risk: a 2x2 has few distinct
configurations, so the rejection rate is reported.

Usage:
  venv/bin/python gen_goldminer_real.py <generator> <train_dir> <out_dir> [n] \\
                                        [--seed S] [--exclude DIR]...
  e.g. venv/bin/python gen_goldminer_real.py \\
         /work/rleap1/ibrahim.eisawy/pddl-generators/goldminer/gold-miner-generator \\
         example/goldminer_dataset/train example/gmIndistReal 120 \\
         --exclude example/goldminer_dataset/train --exclude example/goldminer_dataset/val
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

rng = random.Random(SEED)


def canon(txt):
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


# --- grid sizes from the training split, read off the problem name ----------------------
sizes = []
for f in sorted(glob.glob(os.path.join(TRAIN, "*.pddl"))):
    if os.path.basename(f) == "domain.pddl":
        continue
    m = re.search(r"rows(\d+)-cols(\d+)", open(f, errors="ignore").read())
    if m:
        sizes.append((int(m.group(1)), int(m.group(2))))
if not sizes:
    sys.exit(f"no rows/cols found in {TRAIN}")
hist = collections.Counter(sizes)
cells = [r * c for r, c in sizes]
print(f"training: {len(sizes)} instances, cells {min(cells)}-{max(cells)} "
      f"(median {st.median(cells):.0f})")
print("  grid sizes: " + " ".join(f"{r}x{c}:{n}" for (r, c), n in sorted(hist.items())))

seen = set()
for d in EXCLUDE:
    for f in glob.glob(os.path.join(d, "*.pddl")):
        if os.path.basename(f) != "domain.pddl":
            seen.add(canon(open(f, errors="ignore").read()))
print(f"excluding {len(seen)} fingerprints from {len(EXCLUDE)} directories\n")

os.makedirs(OUT, exist_ok=True)
dom = os.path.join(os.path.dirname(GEN), "domain.pddl")
if os.path.exists(dom):
    open(os.path.join(OUT, "domain.pddl"), "w").write(open(dom).read())
else:
    src = os.path.join(os.path.dirname(TRAIN.rstrip("/")), "domain.pddl")
    if os.path.exists(src):
        open(os.path.join(OUT, "domain.pddl"), "w").write(open(src).read())

made = tries = dup = 0
rows, nobj = [], []
while made < N and tries < N * 400:
    tries += 1
    R, C = sizes[rng.randrange(len(sizes))]          # resample the training size histogram
    seed = rng.randint(1, 10 ** 6)
    res = subprocess.run([GEN, "-r", str(R), "-c", str(C), "-s", str(seed)],
                         capture_output=True, text=True)
    txt = res.stdout
    k = txt.find("(define")
    if k < 0 or "(:goal" not in txt or "(:init" not in txt:
        continue
    txt = txt[k:]
    h = canon(txt)
    if h in seen:
        dup += 1
        continue
    seen.add(h)
    name = f"{made:03d}_p-IND-{R}x{C}-{seed}"
    open(os.path.join(OUT, name + ".pddl"), "w").write(txt)
    rows.append(dict(file=name + ".pddl", distance_to_goal="", source_split="generated",
                     source_problem="", source_plan_len="", num_objects=R * C))
    nobj.append(R * C)
    made += 1

with open(os.path.join(OUT, "labels.csv"), "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["file", "distance_to_goal", "source_split",
                                       "source_problem", "source_plan_len", "num_objects"])
    w.writeheader(); w.writerows(rows)

print(f"wrote {made} instances to {OUT}")
if nobj:
    print(f"  cells {min(nobj)}-{max(nobj)} (median {st.median(nobj):.0f})")
print(f"  {dup} rejected as duplicates of excluded/already-made "
      f"({100.0*dup/max(1,tries):.1f}% of {tries} tried)")
print("\nNEXT: check_probe_set.py --dataset <ds> --trained-on <ds>, then run_fd_optimal.sh")
print("and run_fd_solve.sh. No .plan files and no depth labels -- whole instances.")
