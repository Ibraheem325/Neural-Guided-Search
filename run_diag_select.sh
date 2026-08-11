#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_cpu
#SBATCH --gres=none
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --chdir=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
#
# Measure DeltaU vs DeltaQ inside pUCT selection -- ONE probe per array task.
#
# THE QUESTION (raised independently by the supervisor and by the random-control result):
#
#     score(a) = q_norm(a) + c_puct * explore_mult * P(a) * sqrt(N) / (1 + n_a)
#     DeltaQ = max_{a,b} |q_norm(a) - q_norm(b)|      DeltaU = max_{a,b} |u(a) - u(b)|
#
# The prior enters ONLY through u. If DeltaU << DeltaQ the prior cannot move the decision,
# and then "the signal carries no information" and "the signal was never given a chance"
# produce exactly the same null -- no search comparison can tell them apart. This measures
# it directly.
#
# A first look at six d20-d22 probes gave median DeltaU/DeltaQ of ~0.20 on goldminer and
# ~0.55 on satellite, i.e. DeltaU is 2-5x too small on both, and by a different factor per
# domain. Six probes chosen in filename order is not enough to quote; this runs every probe.
#
# max_time only sets how many decisions each probe contributes. DeltaU/DeltaQ is a property
# of the selection arithmetic, not of the search budget, so 60s is plenty and keeps a
# 120-probe domain inside one array's wall clock.
#
# Usage:
#   sbatch --array=1-N run_diag_select.sh <probe_dir> <policy> <q1> <iqn> <outdir> \
#          [max_time] [c_puct]
# Example:
#   sbatch --array=1-118 run_diag_select.sh example/probeGold_distinct_d5-22 \
#          models/goldminer_sac_policy.pth models/goldminer_sac_q1.pth \
#          models/goldminer_iqn.pth results/diag_gold 60 1.5
#
# Then: venv/bin/python collect_diag.py results/diag_gold
#
# The c_puct argument exists so the criterion can be TESTED, not just measured: if
# DeltaU/DeltaQ is 0.20 at c_puct=1.5, then c_puct ~ 7.5 should bring it to ~1. Re-running
# an arm at that value asks whether the signal was throttled rather than uninformative.

PROBE_DIR=$1
POLICY=$2
Q1=$3
IQN=$4
OUT_DIR=$5
MAXTIME=${6:-60}
C_PUCT=${7:-1.5}

# The search is alphaZero_bellman.py in both trees (make_clean_repo ships alphaZero_clean.py
# under that name). Accept either so this works wherever it is run from.
SEARCH=alphaZero_bellman.py
[ -f "$SEARCH" ] || SEARCH=alphaZero_clean.py
[ -f "$SEARCH" ] || { echo "ERROR: no alphaZero_bellman.py or alphaZero_clean.py in $PWD" >&2; exit 1; }

DOMAIN="$PROBE_DIR/domain.pddl"
[ -f "$DOMAIN" ] || DOMAIN="$(dirname "$PROBE_DIR")/domain.pddl"
[ -f "$DOMAIN" ] || { echo "ERROR: no domain.pddl for $PROBE_DIR" >&2; exit 1; }

FILES=($(ls ${PROBE_DIR}/*.pddl | grep -v domain | sort))
PROB=${FILES[$((SLURM_ARRAY_TASK_ID - 1))]}
NAME=$(basename "$PROB" .pddl)
mkdir -p "$OUT_DIR"

venv/bin/python "$SEARCH" \
    --domain "$DOMAIN" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --iqn_model "$IQN" \
    --qrdqn_value --c_puct "$C_PUCT" --max_time "$MAXTIME" --diag_select \
    > "${OUT_DIR}/${NAME}.out" 2>&1
