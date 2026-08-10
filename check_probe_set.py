"""Validate a probe set before spending a sweep on it.

Five checks, each guarding a mistake this project actually made:

  1. INDEPENDENCE   how many DISTINCT source problems, and how many probes each contributes.
                    The old sets drew 480 probes from 29-44 problems (up to 16 states from
                    one instance), so every count-based statistic was inflated and had to be
                    aggregated back down. goldminer's tilt read 73/27 per probe and 14/15
                    per problem -- the apparent positive was an artefact of this.

  2. DUPLICATES     any two probes with the same objects+init+goal. Two probes from the same
                    instance at different depths are legitimately different states, but a
                    generator bug can emit the same state twice.

  3. LEAKAGE        does any probe's state coincide with a TRAIN or VAL instance? A probe is
                    a state lifted from partway through a test plan, and nothing structurally
                    prevents it from matching an instance the model trained on.

  4. SPLIT OVERLAP  are the underlying dataset splits themselves disjoint? The datasets are
                    randomly generated, so a collision between train and test is possible and
                    would invalidate everything downstream.

  5. SHAPE          depth histogram, object range, and how far out of distribution the probes
                    are relative to train. Grid's probes turned out to be 8.4x the training
                    median object count while satellite's were 2.2x -- worth knowing, since a
                    method that fails at 8x and succeeds at 2x may be telling you about
                    extrapolation rather than about the signal.

Comparison is on a canonical form: the (:objects), (:init) and (:goal) blocks with atoms
sorted and whitespace collapsed, so formatting differences do not hide a real match.

Usage: venv/bin/python check_probe_set.py <probe_dir> [--dataset <dataset_dir>]
   e.g. venv/bin/python check_probe_set.py example/probeRov_distinct_d5-22 \\
                                           --dataset example/rovers_dataset_small
"""
import sys, os, re, glob, csv, argparse, hashlib, collections, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("probe_dir")
ap.add_argument("--dataset", default=None,
                help="dataset root with train/ val/ test/. Enables the leakage and "
                     "split-overlap checks; inferred from labels.csv when omitted.")
A_ = ap.parse_args()

NAME = re.compile(r"^\d+_d(\d+)_(.+)$")


def canon(path):
    """Canonical fingerprint of a PDDL problem: objects + init + goal, atoms sorted."""
    txt = open(path, errors="ignore").read().lower()
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
        body = txt[i:j + 1]
        atoms = sorted(a.strip() for a in re.findall(r"\(([^()]*)\)", body) if a.strip())
        parts.append("|".join(atoms))
    return hashlib.sha1("||".join(parts).encode()).hexdigest()


probes = sorted(f for f in glob.glob(A_.probe_dir + "/*.pddl")
                if os.path.basename(f) != "domain.pddl")
if not probes:
    raise SystemExit(f"no probes in {A_.probe_dir}")

lab = os.path.join(A_.probe_dir, "labels.csv")
rows = list(csv.DictReader(open(lab, newline=""))) if os.path.exists(lab) else []
by_file = {r["file"]: r for r in rows}

print(f"### {A_.probe_dir}")
print(f"{len(probes)} probes\n")

fails = []

# --- 1. INDEPENDENCE -------------------------------------------------------------------
src = collections.Counter()
for p in probes:
    m = NAME.match(os.path.basename(p)[:-5])
    src[m.group(2) if m else os.path.basename(p)] += 1
c = list(src.values())
print("1. INDEPENDENCE")
print(f"   distinct source problems : {len(src)}")
print(f"   probes per problem       : min {min(c)}  median {st.median(c):.0f}  max {max(c)}")
print(f"   effective sample size    : {len(src)}  (this is what significance tests may use)")
if max(c) > 1:
    print(f"   -> {sum(1 for v in c if v > 1)} problems contribute more than one probe;")
    print(f"      counts must be aggregated with cluster_contrib.py before any p-value")
else:
    print("   -> one probe per problem: every probe is an independent unit, no aggregation needed")

# --- 2. DUPLICATES ---------------------------------------------------------------------
print("\n2. DUPLICATE PROBES")
fp = collections.defaultdict(list)
for p in probes:
    fp[canon(p)].append(os.path.basename(p))
dups = {k: v for k, v in fp.items() if len(v) > 1}
if dups:
    fails.append(f"{len(dups)} sets of identical probes")
    print(f"   FAIL: {len(dups)} groups of byte-identical states")
    for v in list(dups.values())[:5]:
        print(f"      {' == '.join(v[:4])}")
else:
    print(f"   OK: all {len(probes)} probes are distinct states")

# --- dataset-dependent checks ----------------------------------------------------------
ds = A_.dataset
if ds is None and rows:
    sp = rows[0].get("source_split", "")
    guess = os.path.dirname(A_.probe_dir.rstrip("/"))
    for cand in glob.glob(os.path.join(guess, "*")):
        if os.path.isdir(os.path.join(cand, sp)):
            ds = cand; break
    if ds: print(f"\n   (dataset inferred: {ds})")

if ds is None or not os.path.isdir(ds):
    print("\n3-4. LEAKAGE / SPLIT OVERLAP: skipped, pass --dataset <dir>")
else:
    split_fp = {}
    for sp in ("train", "val", "test"):
        d = os.path.join(ds, sp)
        if not os.path.isdir(d): continue
        split_fp[sp] = {canon(f): os.path.basename(f) for f in glob.glob(d + "/*.pddl")
                        if os.path.basename(f) != "domain.pddl"}

    print("\n3. LEAKAGE: does any probe state match a TRAIN or VAL instance?")
    hit = []
    for p in probes:
        h = canon(p)
        for sp in ("train", "val"):
            if h in split_fp.get(sp, {}):
                hit.append((os.path.basename(p), sp, split_fp[sp][h]))
    if hit:
        fails.append(f"{len(hit)} probes match a train/val instance")
        print(f"   FAIL: {len(hit)} probes are identical to an instance the model saw")
        for a, sp, b in hit[:5]: print(f"      {a}  ==  {sp}/{b}")
    else:
        n = sum(len(split_fp.get(s, {})) for s in ("train", "val"))
        print(f"   OK: none of {len(probes)} probes matches any of the {n} train/val instances")

    print("\n4. SPLIT OVERLAP: are the dataset splits themselves disjoint?")
    bad = False
    for a, b in (("train", "val"), ("train", "test"), ("val", "test")):
        if a in split_fp and b in split_fp:
            common = set(split_fp[a]) & set(split_fp[b])
            if common:
                bad = True; fails.append(f"{a}/{b} share {len(common)} instances")
                print(f"   FAIL: {a} and {b} share {len(common)} identical instances")
            else:
                print(f"   OK: {a} vs {b} disjoint ({len(split_fp[a])} vs {len(split_fp[b])})")
    if not bad and rows:
        got = {r.get("source_split") for r in rows}
        print(f"   probes are drawn from: {', '.join(sorted(got))}")
        if got & {"train", "val"}:
            fails.append("probes drawn from train/val")
            print("   FAIL: probes come from a split used for training or model selection")

# --- 5. SHAPE --------------------------------------------------------------------------
print("\n5. SHAPE")
if rows:
    d = [int(r["distance_to_goal"]) for r in rows]
    o = [int(r["num_objects"]) for r in rows if r.get("num_objects", "").strip().isdigit()]
    hd = collections.Counter(d)
    print(f"   distance-to-goal : {min(d)}-{max(d)}   per depth "
          f"min {min(hd.values())} max {max(hd.values())}")
    if o:
        print(f"   objects          : {min(o)}-{max(o)} (median {st.median(o):.0f})")
        if ds and os.path.isdir(os.path.join(ds, "train")):
            tr = []
            for f in glob.glob(os.path.join(ds, "train", "*.pddl")):
                if os.path.basename(f) == "domain.pddl": continue
                t = open(f, errors="ignore").read()
                m = re.search(r"\(:objects(.*?)\)\s*\(:init", t, re.S)
                if m:
                    g = re.findall(r"([^-]+)-\s*\w+", m.group(1).replace("\n", " "))
                    tr.append(sum(len(x.split()) for x in g) if g else 0)
            if tr:
                print(f"   train objects    : {min(tr)}-{max(tr)} (median {st.median(tr):.0f})"
                      f"   -> extrapolation {st.median(o)/st.median(tr):.1f}x")
else:
    print("   no labels.csv, skipping")

print("\n" + ("PASS -- probe set is sound" if not fails else "FAILED: " + "; ".join(fails)))
sys.exit(1 if fails else 0)
