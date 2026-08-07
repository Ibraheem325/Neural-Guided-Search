"""Turn a run_fd_optimal.sh output directory into optlen_<name>.json, and report whether
the distance encoded in each probe name is actually the optimal plan length.

make_probes.py names probes by the remaining suffix of a SOURCE plan, so the encoded d is
optimal only if those source plans were optimal. This compares FD's answer to d and says
which it is.

Usage: venv/bin/python collect_fd.py <fd_out_dir> <json_out> [--probe DIR]
   e.g. venv/bin/python collect_fd.py results/fdopt_gold optlen_goldminer.json
"""
import sys, os, glob, json, re, argparse, collections

ap = argparse.ArgumentParser()
ap.add_argument("fd_dir")
ap.add_argument("json_out")
ap.add_argument("--probe", default="example/probeGold_near_goal_d5-20")
A_ = ap.parse_args()

DEPTH = re.compile(r"^\d+_d(\d+)_")

lens, fails = {}, []
for f in glob.glob(A_.fd_dir + "/*.len"):
    name = os.path.basename(f)[:-4]
    v = open(f).read().strip()
    if v.isdigit():
        lens[name] = int(v)
    else:
        fails.append(name)

json.dump(lens, open(A_.json_out, "w"))
print(f"wrote {A_.json_out}: {len(lens)} solved, {len(fails)} failed/timed out")

agree = shorter = longer = 0
examples = []
by_depth = collections.defaultdict(lambda: [0, 0])   # d -> [agree, shorter]
for name, n in lens.items():
    m = DEPTH.match(name)
    if not m:
        continue
    d = int(m.group(1))
    if n == d:
        agree += 1
        by_depth[d][0] += 1
    elif n < d:
        shorter += 1
        by_depth[d][1] += 1
        if len(examples) < 15:
            examples.append((name, d, n))
    else:
        longer += 1

print(f"\nFD == d          : {agree}")
print(f"FD SHORTER than d: {shorter}   <- any of these means d is NOT optimal")
print(f"FD LONGER than d : {longer}")

if shorter:
    print("\nby depth (agree / shorter):")
    for d in sorted(by_depth):
        a, s = by_depth[d]
        print(f"  d{d:<3} {a:>4} / {s:<4}" + ("   <- d is loose here" if s else ""))
    print("\nexamples where FD beat the encoded distance:")
    for name, d, n in examples:
        print(f"  {name}  d={d}  FD={n}")
    print("\nCONCLUSION: the source plans were suboptimal, so d overstates the optimal")
    print("length. Point table_plan_len.py at this json (--optlen) for the true values;")
    print("expect every 'vs opt' ratio to RISE, and the baseline's gap to widen.")
else:
    print("\nCONCLUSION: d == optimal wherever FD solved it -- the encoded distance is")
    print("safe to use as the optimal length.")

if fails:
    print(f"\n{len(fails)} probes have no FD answer; table_plan_len.py falls back to the")
    print("encoded d for those. First few: " + ", ".join(sorted(fails)[:8]))
