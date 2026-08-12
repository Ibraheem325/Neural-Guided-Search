"""Generate goldminer instances IN the training distribution, disjoint from training.

WHY GOLDMINER SECOND. It is the anchor of the dose result: the baseline solves 88/118 of the
extrapolated test set while every perturbation arm reaches ~118, and that 74.6% -> 100% jump
is what grid's and rovers' "it is just dose" conclusions lean on. But the test set is 49-100
objects against a training range of 4-42, so the baseline may be failing because the
instances are 2-4x training size rather than because its prior is wrong. If the gap
disappears in-distribution, the dose conclusion needs the same scope condition the satellite
positive does.

STRUCTURE, verified on all 400 training instances rather than assumed:
  - grid R x C, cells named fR-Cf, `connected` in the 4-neighbourhood BOTH ways
  - gold sits on a SOFT-rock cell in 400/400 (never hard, never clear)
  - bomb and laser are CO-LOCATED on a CLEAR cell in 400/400 -- the "shop"
  - the robot starts on a CLEAR cell in 400/400
  - instances are DENSE: rock density 0.50-0.86 (median 0.80), only 2-6 clear cells
  - grid sizes 2x2 through 6x7, so objects = R*C lands in 4-42

SOLVABILITY, which the density makes non-trivial. fire-laser DESTROYS gold, so the gold cell
must be cleared with a bomb, not the laser. Both tools are at the shop, so the robot must
reach the shop THROUGH CLEAR CELLS before it can do anything at all. This generator therefore
makes the clear cells a single connected blob containing both the robot and the shop; from
there the laser tunnels anywhere (it clears hard rock too), the bomb clears the gold cell
without destroying the gold, and the instance is solvable by construction.

The alternative -- scatter rocks at the training density and hope -- produces unsolvable
instances most of the time at 80% density, which is presumably why the original generator
also constructed rather than sampled.

OVERLAP. Generating at training sizes removes the structural guarantee that test and train
cannot collide, so every candidate is hashed on canonical (:objects)+(:init)+(:goal) and
rejected against train, val, and already-accepted. Small grids are the real risk here: a 2x2
has very few distinct configurations, so the rejection rate is reported and a high one means
the comparison is not meaningful at that size.

Usage:
  venv/bin/python gen_goldminer_indist.py <train_dir> <out_dir> [n] [--seed S] [--val DIR]
"""
import os, re, csv, glob, random, hashlib, argparse, collections, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("train_dir")
ap.add_argument("out_dir")
ap.add_argument("n", nargs="?", default=120, type=int)
ap.add_argument("--val", default=None)
ap.add_argument("--seed", default=20260812, type=int)
ap.add_argument("--max-tries", dest="max_tries", default=400, type=int)
A_ = ap.parse_args()

rng = random.Random(A_.seed)


def canon_text(txt):
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
    """(rows, cols, n_clear, soft_fraction) from a training instance."""
    m = re.search(r"rows(\d+)-cols(\d+)", txt)
    if not m:
        return None
    R, C = int(m.group(1)), int(m.group(2))
    soft = len(re.findall(r"\(soft-rock-at", txt))
    hard = len(re.findall(r"\(hard-rock-at", txt))
    clear = len(re.findall(r"\(clear ", txt))
    if not (R and C and clear) or soft + hard == 0:
        return None
    return (R, C, clear, soft / (soft + hard))


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
        seen.add(canon_text(open(f, errors="ignore").read())); n_val += 1

cells = [R * C for R, C, _, _ in shapes]
sz = collections.Counter((R, C) for R, C, _, _ in shapes)
print(f"training shapes: {len(shapes)} instances, cells {min(cells)}-{max(cells)} "
      f"(median {st.median(cells):.0f})")
print("  grid sizes: " + " ".join(f"{r}x{c}:{n}" for (r, c), n in sorted(sz.items())))
print(f"  clear cells {min(s[2] for s in shapes)}-{max(s[2] for s in shapes)}, "
      f"soft fraction median {st.median(s[3] for s in shapes):.2f}")
print(f"excluding {n_train} train + {n_val} val fingerprints\n")


def blob(R, C, k):
    """A connected set of k cells, grown by random walk. This is what guarantees the robot
    can reach the shop: both are placed inside it, and at 80% rock density a scattered
    clear set would usually leave them disconnected."""
    start = (rng.randrange(R), rng.randrange(C))
    out, frontier = {start}, [start]
    while len(out) < k and frontier:
        r, c = frontier[rng.randrange(len(frontier))]
        nb = [(r + dr, c + dc) for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1))
              if 0 <= r + dr < R and 0 <= c + dc < C and (r + dr, c + dc) not in out]
        if not nb:
            frontier = [p for p in frontier if p != (r, c)]
            continue
        p = nb[rng.randrange(len(nb))]
        out.add(p); frontier.append(p)
    return out


def build(R, C, nclear, softfrac):
    nclear = max(2, min(nclear, R * C - 1))          # need >=1 rock cell for the gold
    clear = blob(R, C, nclear)
    if len(clear) < 2:
        return None
    rocks = [(r, c) for r in range(R) for c in range(C) if (r, c) not in clear]
    if not rocks:
        return None

    cl = sorted(clear)
    shop = cl[rng.randrange(len(cl))]
    robot = cl[rng.randrange(len(cl))]
    gold = rocks[rng.randrange(len(rocks))]          # gold always on soft rock
    soft = {gold}
    for p in rocks:
        if p != gold and rng.random() < softfrac:
            soft.add(p)
    hard = [p for p in rocks if p not in soft]

    nm = lambda p: f"f{p[0]}-{p[1]}f"
    L = [f"(define (problem typed-bomberman-rows{R}-cols{C})",
         "(:domain gold-miner-typed)", "(:objects "]
    for r in range(R):
        L.append("\t" + " ".join(nm((r, c)) for c in range(C)) + " ")
    L.append("\t- LOC")
    L.append(")")
    L.append("(:init")
    L.append("(arm-empty)")
    # connected, both directions, 4-neighbourhood
    for r in range(R):
        for c in range(C):
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < R and 0 <= nc < C:
                    L.append(f"(connected {nm((r, c))} {nm((nr, nc))})")
    L.append(f"(bomb-at {nm(shop)})")
    L.append(f"(laser-at {nm(shop)})")
    for p in sorted(clear):
        L.append(f"(clear {nm(p)})")
    for p in sorted(soft):
        L.append(f"(soft-rock-at {nm(p)})")
    for p in sorted(hard):
        L.append(f"(hard-rock-at {nm(p)})")
    L.append(f"(robot-at {nm(robot)})")
    L.append(f"(gold-at {nm(gold)})")
    L.append(")")
    L += ["(:goal", "(holds-gold)", ")", ")"]
    return "\n".join(L) + "\n"


os.makedirs(A_.out_dir, exist_ok=True)
dom = os.path.join(os.path.dirname(A_.train_dir.rstrip("/")), "domain.pddl")
if not os.path.exists(dom):
    dom = os.path.join(A_.train_dir, "domain.pddl")
if os.path.exists(dom):
    open(os.path.join(A_.out_dir, "domain.pddl"), "w").write(open(dom).read())

written = collisions = tries = 0
rows, made = [], []
while written < A_.n:
    tries += 1
    if tries > A_.n * A_.max_tries:
        print(f"\nSTOPPED at {written}/{A_.n} after {tries} candidates, {collisions} "
              f"collisions. The instance space at these sizes is too small to build a test "
              f"set disjoint from training -- that is itself the finding.")
        break
    R, C, nclear, softfrac = shapes[rng.randrange(len(shapes))]
    txt = build(R, C, nclear, softfrac)
    if txt is None:
        continue
    h = canon_text(txt)
    if h in seen:
        collisions += 1
        continue
    seen.add(h)
    name = f"{written:03d}_p-IND-{R}x{C}-{written:03d}"
    open(os.path.join(A_.out_dir, name + ".pddl"), "w").write(txt)
    rows.append(dict(file=name + ".pddl", distance_to_goal="", source_split="generated",
                     source_problem="", source_plan_len="", num_objects=R * C))
    made.append(R * C)
    written += 1

with open(os.path.join(A_.out_dir, "labels.csv"), "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["file", "distance_to_goal", "source_split",
                                       "source_problem", "source_plan_len", "num_objects"])
    w.writeheader(); w.writerows(rows)

print(f"wrote {written} instances to {A_.out_dir}")
if made:
    print(f"  cells {min(made)}-{max(made)} (median {st.median(made):.0f})")
print(f"  {collisions} rejected for colliding with train/val/already-made "
      f"({100.0*collisions/max(1,tries):.1f}% of {tries} tried)")
print("\nNEXT: check_probe_set.py, then run_fd_optimal.sh. Solvability is by construction")
print("(robot and shop share one connected clear blob) but FD will confirm it.")
