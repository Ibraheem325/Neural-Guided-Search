"""Validate a probe set before spending a sweep on it.

Six checks, each guarding a mistake this project actually made:

  1. INDEPENDENCE   how many DISTINCT source problems, and how many probes each contributes.
                    The old sets drew 480 probes from 29-44 problems (up to 16 states from
                    one instance), so every count-based statistic was inflated and had to be
                    aggregated back down. goldminer's tilt read 73/27 per probe and 14/15
                    per problem -- the apparent positive was an artefact of this.

  2. DUPLICATES     any two probes with the same objects+init+goal. Two probes from the same
                    instance at different depths are legitimately different states, but a
                    generator bug can emit the same state twice.

  3. PROVENANCE     were the probes actually cut from the dataset you named? Pointed at a
                    sibling dataset the checks below pass VACUOUSLY -- nothing collides with
                    instances that were never there. probeSat_distinct_d5-22 was checked
                    against satellite_dataset when it came from satellite_dataset_s18 and
                    reported a clean PASS with 0 of 120 sources in range.

  4. LEAKAGE        does any probe's state coincide with a TRAIN or VAL instance? A probe is
                    a state lifted from partway through a test plan, and nothing structurally
                    prevents it from matching an instance the model trained on.

  5b. TRAINING-SET  --trained-on, for when the model was trained on a DIFFERENT dataset than
      LEAKAGE       the probes came from. Logistics is that case: probes from
                    logistics_dataset/test, models logistics_topo_*, trained on
                    logistics_dataset_topo. Check 4 compares against the wrong dataset there.

  5. SPLIT OVERLAP  are the underlying dataset splits themselves disjoint? The datasets are
                    randomly generated, so a collision between train and test is possible and
                    would invalidate everything downstream.

  6. SHAPE          depth histogram, object range, and how far out of distribution the probes
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
ap.add_argument("--trained-on", dest="trained_on", default=None,
                help="dataset the MODEL was trained on, when that differs from the one the "
                     "probes were cut from. Logistics is exactly this case: its probes come "
                     "from logistics_dataset/test while the models are logistics_topo_*, "
                     "trained on logistics_dataset_topo. Leakage against --dataset says "
                     "nothing there -- what matters is whether a probe state appears in the "
                     "instances the model actually saw.")
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
overlap_fails = []   # split-overlap findings, downgradable by 5b (see below)

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
# The dataset must be the one the probes were CUT FROM. Pointed at a sibling dataset, every
# check below passes vacuously -- nothing collides with instances that were never there.
# That happened: probeSat_distinct_d5-22 was checked against satellite_dataset when it came
# from satellite_dataset_s18, and reported a clean PASS with 0/120 sources in range.
ds = A_.dataset
srcs_wanted = [r["source_problem"] for r in rows if r.get("source_problem")]


def sources_found(d):
    """How many of the probes' source problems exist under this dataset root."""
    have = {os.path.basename(f) for sp in ("train", "val", "test")
            for f in glob.glob(os.path.join(d, sp, "*.pddl"))}
    return sum(1 for s in srcs_wanted if s in have)


if ds is None and rows:
    sp = rows[0].get("source_split", "")
    guess = os.path.dirname(A_.probe_dir.rstrip("/"))
    cands = [c for c in glob.glob(os.path.join(guess, "*"))
             if os.path.isdir(os.path.join(c, sp))]
    # rank by how many sources actually resolve, not by merely having a split of that name
    ds = max(cands, key=sources_found, default=None) if srcs_wanted else \
        (cands[0] if cands else None)
    if ds: print(f"\n   (dataset inferred: {ds})")

if ds is None or not os.path.isdir(ds):
    print("\n3-5. PROVENANCE / LEAKAGE / SPLIT OVERLAP: skipped, pass --dataset <dir>")
else:
    split_fp = {}
    for sp in ("train", "val", "test"):
        d = os.path.join(ds, sp)
        if not os.path.isdir(d): continue
        split_fp[sp] = {canon(f): os.path.basename(f) for f in glob.glob(d + "/*.pddl")
                        if os.path.basename(f) != "domain.pddl"}

    print(f"\n3. PROVENANCE: were these probes cut from {ds}?")
    if not srcs_wanted:
        print("   labels.csv has no source_problem column, cannot verify -- treat 4/5 as weak")
    else:
        n = sources_found(ds)
        if n == 0:
            fails.append(f"none of the probes' sources are in {ds}")
            print(f"   FAIL: 0 of {len(srcs_wanted)} source problems exist under {ds}.")
            print("         Wrong dataset -- checks 4 and 5 below are vacuous, not clean.")
        elif n < len(srcs_wanted):
            fails.append(f"{len(srcs_wanted)-n} sources missing from {ds}")
            print(f"   FAIL: only {n} of {len(srcs_wanted)} source problems exist under {ds}")
        else:
            print(f"   OK: all {n} source problems resolve in this dataset")

    # duplicates INSIDE a split: not leakage, but 400 files holding 348 unique instances
    # means 13% of a training set was spent re-showing what the model already had.
    for sp, fpm in split_fp.items():
        n_files = len([f for f in glob.glob(os.path.join(ds, sp, "*.pddl"))
                       if os.path.basename(f) != "domain.pddl"])
        if n_files > len(fpm):
            print(f"   note: {sp} has {n_files} files but only {len(fpm)} unique instances "
                  f"({n_files - len(fpm)} duplicated within the split)")

    print("\n4. LEAKAGE: does any probe state match a TRAIN or VAL instance?")
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

    print("\n5. SPLIT OVERLAP: are the dataset splits themselves disjoint?")
    bad = False
    for a, b in (("train", "val"), ("train", "test"), ("val", "test")):
        if a in split_fp and b in split_fp:
            common = set(split_fp[a]) & set(split_fp[b])
            if common:
                bad = True
                overlap_fails.append(f"{a}/{b} share {len(common)} instances")
                fails.append(f"{a}/{b} share {len(common)} instances")
                print(f"   FAIL: {a} and {b} share {len(common)} identical instances")
            else:
                print(f"   OK: {a} vs {b} disjoint ({len(split_fp[a])} vs {len(split_fp[b])})")
    if not bad and rows:
        got = {r.get("source_split") for r in rows}
        print(f"   probes are drawn from: {', '.join(sorted(got))}")
        if got & {"train", "val"}:
            fails.append("probes drawn from train/val")
            print("   FAIL: probes come from a split used for training or model selection")

# --- 5b. LEAKAGE AGAINST THE TRAINING DATASET, when it differs -----------------------
# The dataset the probes were CUT FROM is not always the dataset the MODEL SAW. Logistics
# is exactly that case: probes from logistics_dataset/test, models logistics_topo_*, trained
# on logistics_dataset_topo. Check 4 compares against the wrong one there and would report a
# clean pass while saying nothing about the only leakage that could invalidate a result.
if A_.trained_on:
    print(f"\n5b. LEAKAGE vs the dataset the MODEL was trained on ({A_.trained_on})")
    if not os.path.isdir(A_.trained_on):
        fails.append(f"--trained-on {A_.trained_on} is not a directory")
        print(f"   FAIL: {A_.trained_on} is not a directory")
    else:
        tfp = {}
        for sp in ("train", "val"):
            d = os.path.join(A_.trained_on, sp)
            if os.path.isdir(d):
                tfp[sp] = {canon(f): os.path.basename(f) for f in glob.glob(d + "/*.pddl")
                           if os.path.basename(f) != "domain.pddl"}
        hit2 = []
        for p_ in probes:
            h = canon(p_)
            for sp, m in tfp.items():
                if h in m:
                    hit2.append((os.path.basename(p_), sp, m[h]))
        n = sum(len(m) for m in tfp.values())
        if hit2:
            fails.append(f"{len(hit2)} probes match a {A_.trained_on} train/val instance")
            print(f"   FAIL: {len(hit2)} probes are identical to an instance the model saw")
            for a, sp, b in hit2[:5]:
                print(f"      {a}  ==  {sp}/{b}")
        else:
            print(f"   OK: none of {len(probes)} probes matches any of the {n} "
                  f"train/val instances the model was trained on")
            # The point of check 5 is that overlapping splits IMPLY possible leakage. Here
            # leakage against the dataset that actually trained the model has been measured
            # directly and is zero, so an overlap in the provenance dataset's splits is a
            # defect in a dataset this model never learned from. Demote it, or the tool
            # reports an unfixable FAIL on a sound probe set and stops being worth running.
            tsp = {}
            for sp in ("train", "val", "test"):
                d2 = os.path.join(A_.trained_on, sp)
                if os.path.isdir(d2):
                    tsp[sp] = {canon(f) for f in glob.glob(d2 + "/*.pddl")
                               if os.path.basename(f) != "domain.pddl"}
            tbad = [f"{a}/{b}" for a, b in (("train", "val"), ("train", "test"), ("val", "test"))
                    if a in tsp and b in tsp and (tsp[a] & tsp[b])]
            if tbad:
                print(f"   FAIL: the TRAINING dataset's own splits overlap: {', '.join(tbad)}")
                fails.append(f"{A_.trained_on} splits overlap: {', '.join(tbad)}")
            elif overlap_fails:
                for f_ in overlap_fails:
                    if f_ in fails:
                        fails.remove(f_)
                print(f"   -> demoting check 5 ({'; '.join(overlap_fails)}): those splits belong")
                print(f"      to {ds}, which did not train this model. {A_.trained_on}'s own")
                print(f"      splits are disjoint and no probe leaks into them. Still a real")
                print(f"      dataset defect -- state it -- but it cannot have leaked here.")

# --- 5. SHAPE --------------------------------------------------------------------------
print("\n6. SHAPE")
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
