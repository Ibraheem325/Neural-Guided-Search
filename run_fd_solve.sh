#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_cpu
#SBATCH --gres=none
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=00:40:00
#SBATCH --chdir=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search

# Solve ONE dataset instance per array task and write <instance>.pddl.plan beside it,
# which is the input make_probes.py needs.
#
# WHY THIS EXISTS: solve_dataset.py does this serially and the satellite val split was
# abandoned for being too slow. Each solve is independent, so an array finishes the split
# in the time of the slowest single instance.
#
# MODE. Default is lama-first (satisficing) because make_probes.py only needs A plan to
# walk backwards, and probe DEPTH is then corrected afterwards by run_fd_optimal.sh +
# collect_fd.py, which measure the true optimal per probe. Using opt here would be far
# slower for no benefit, since the optimal lengths get measured on the probes anyway.
# (On grid this correction mattered: 12 of 480 probes had a d that was 1-2 steps loose.)
#
# Usage:
#   sbatch --array=1-<N> run_fd_solve.sh <instance_dir> [lama|opt] [timeout_s]
# Example:
#   ls example/satellite_dataset_s18/val/*.pddl | grep -vc domain    # get N first
#   sbatch --array=1-N run_fd_solve.sh example/satellite_dataset_s18/val lama 1800
#
# Skips instances that already have a .plan, so a partially-finished split can be resumed
# by resubmitting the same array.

INST_DIR=$1
MODE=${2:-lama}
TIMEOUT=${3:-1800}

FD=/work/rleap1/ibrahim.eisawy/downward/fast-downward.py

# The domain may sit INSIDE the split dir (probe sets) or at the DATASET ROOT one level up
# (example/<dataset>/{train,val,test}/ share one domain.pddl). Assuming the former made 84
# of 120 satellite val tasks die in 0.15s with translate exit code 30 -- a missing-file
# error that looked like FD failing on hard instances.
if [ -f "$PWD/$INST_DIR/domain.pddl" ]; then
    DOMAIN="$PWD/$INST_DIR/domain.pddl"
elif [ -f "$PWD/$INST_DIR/../domain.pddl" ]; then
    DOMAIN="$(cd "$INST_DIR/.." && pwd)/domain.pddl"
else
    echo "ERROR: no domain.pddl in $INST_DIR or its parent" >&2
    exit 1
fi

FILES=($(ls ${INST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB="$PWD/${FILES[$IDX]}"
NAME=$(basename "$PROB" .pddl)
OUT="${PROB}.plan"

if [ -f "$OUT" ]; then
    echo "already solved: $OUT"
    exit 0
fi

# FD writes output.sas and sas_plan into CWD, so each task needs its own scratch dir --
# otherwise concurrent tasks clobber one another.
WORK=$(mktemp -d)
cd "$WORK" || exit 1

if [ "$MODE" = "opt" ]; then
    timeout "$TIMEOUT" "$FD" --plan-file sas_plan "$DOMAIN" "$PROB" \
        --search "astar(lmcut())" > fd.log 2>&1
else
    timeout "$TIMEOUT" "$FD" --plan-file sas_plan --alias lama-first \
        "$DOMAIN" "$PROB" > fd.log 2>&1
fi

# lama emits sas_plan.1, .2, ... as it improves; the highest suffix is the best plan.
BEST=$(ls sas_plan* 2>/dev/null | sort -V | tail -1)
if [ -n "$BEST" ] && [ -f "$BEST" ]; then
    grep '^(' "$BEST" > "$OUT"
    echo "solved $(basename "$PROB"): $(wc -l < "$OUT") steps"
    cd "$OLDPWD" || exit 1
    rm -rf "$WORK"
else
    # Do NOT discard fd.log on failure. The first version deleted the scratch dir
    # unconditionally, so when 84 tasks died in under a second there was no way to see
    # why -- the only signal was the word FAILED. Echo the tail and keep the log.
    echo "FAILED $(basename "$PROB") -- fd.log tail:"
    tail -20 fd.log 2>/dev/null | sed 's/^/    /'
    cd "$OLDPWD" || exit 1
    mkdir -p fd_failures
    cp "$WORK/fd.log" "fd_failures/$NAME.log" 2>/dev/null
    rm -rf "$WORK"
fi
