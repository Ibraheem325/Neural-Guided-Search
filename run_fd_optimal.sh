#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_cpu
#SBATCH --gres=none
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=00:40:00
#SBATCH --chdir=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search

# Optimal (or satisficing) plan length for ONE probe per array task.
#
# Running these serially is hopeless -- 480 probes x up to 300s is many hours -- but each
# FD call is independent, so one array task per probe finishes the whole set in the time
# of the slowest single probe.
#
# Usage:
#   sbatch --array=1-480 run_fd_optimal.sh <probe_dir> <out_dir> [opt|lama] [timeout_s]
# Example:
#   sbatch --array=1-480 run_fd_optimal.sh example/probeGold_near_goal_d5-20 \
#          results/fdopt_gold opt 1800
#
# Writes <out_dir>/<probe_name>.len containing a single integer (the plan length), or the
# word FAIL. collect_fd.py turns that directory into optlen_<domain>.json, which
# table_plan_len.py reads in place of the distance encoded in the probe name.

PROBE_DIR=$1
OUT_DIR=$2
MODE=${3:-opt}
TIMEOUT=${4:-1800}

FD=/work/rleap1/ibrahim.eisawy/downward/fast-downward.py
# Probe dirs carry their own domain.pddl; dataset splits share one at the root. Accept both
# -- assuming the former is what made 84 satellite val solves die instantly with translate
# exit code 30 (see run_fd_solve.sh).
if [ -f "$PWD/$PROBE_DIR/domain.pddl" ]; then
    DOMAIN="$PWD/$PROBE_DIR/domain.pddl"
elif [ -f "$PWD/$PROBE_DIR/../domain.pddl" ]; then
    DOMAIN="$(cd "$PROBE_DIR/.." && pwd)/domain.pddl"
else
    echo "ERROR: no domain.pddl in $PROBE_DIR or its parent" >&2
    exit 1
fi

FILES=($(ls ${PROBE_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB="$PWD/${FILES[$IDX]}"
NAME=$(basename "$PROB" .pddl)

mkdir -p "$OUT_DIR"
# FD writes its plan and temp files into CWD, so give every task its own scratch dir --
# otherwise 480 concurrent tasks overwrite each other's output.sas and sas_plan.
WORK=$(mktemp -d)
cd "$WORK" || exit 1

if [ "$MODE" = "opt" ]; then
    timeout "$TIMEOUT" "$FD" --plan-file sas_plan "$DOMAIN" "$PROB" \
        --search "astar(lmcut())" > fd.log 2>&1
else
    timeout "$TIMEOUT" "$FD" --plan-file sas_plan --alias seq-sat-lama-2011 \
        "$DOMAIN" "$PROB" > fd.log 2>&1
fi

# lama writes sas_plan.1, sas_plan.2, ... improving each time; the LAST one is the best.
BEST=$(ls sas_plan* 2>/dev/null | sort -V | tail -1)
OUT="$OLDPWD/$OUT_DIR/$NAME.len"
if [ -n "$BEST" ] && [ -f "$BEST" ]; then
    grep -c '^(' "$BEST" > "$OUT"
else
    echo FAIL > "$OUT"
fi

cd "$OLDPWD" || exit 1
rm -rf "$WORK"
