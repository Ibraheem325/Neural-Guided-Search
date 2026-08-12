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
# MEASURING AN ARM, NOT JUST THE BASELINE. With no signal arguments this reports DeltaU for
# the RAW SAC prior. That is not what any treatment arm uses: the real arm searches with
# P+ = (P0 + beta x_a/K)/(1 + beta g_s), and the random control with the same expression
# built from drawn residuals. Those have different spreads, so they have different DeltaU.
#
# The question this answers: "in the random approach, what are DeltaU and DeltaQ? If DeltaU
# is low it mostly serves as a tie-breaker among already-good options." Run the same probe
# set three times -- baseline, real signal, random -- and compare.
#
# Usage:
#   sbatch --array=1-N run_diag_select.sh <probe_dir> <policy> <q1> <iqn> <outdir> \
#          [max_time] [c_puct] [abs_signal] [beta] [kappa] [eps_p] [shuffle] [random_spec]
# Example:
#   sbatch --array=1-118 run_diag_select.sh example/probeGold_distinct_d5-22 \
#          models/goldminer_sac_policy.pth models/goldminer_sac_q1.pth \
#          models/goldminer_iqn.pth results/diag_gold 60 1.5
#
# Three-way comparison on one domain:
#   sbatch --array=1-118 run_diag_select.sh <args> results/diag_gold_base 60 1.5
#   sbatch --array=1-118 run_diag_select.sh <args> results/diag_gold_sig  60 1.5 add 1.0 1.0 0.001 0 ""
#   sbatch --array=1-118 run_diag_select.sh <args> results/diag_gold_rnd  60 1.5 add 1.0 1.0 0.001 0 "lognormal:0.999:-0.757"
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
ABS_SIGNAL=${8:-off}      # off | add | mul
ABS_BETA=${9:-1.0}
ABS_KAPPA=${10:-1.0}
EPS_P=${11:-0.001}
SHUFFLE=${12:-0}
RANDOM_SPEC=${13:-}

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

FLAGS=""
[ "$SHUFFLE" = "1" ]  && FLAGS="$FLAGS --sib_shuffle"
[ -n "$RANDOM_SPEC" ] && FLAGS="$FLAGS --sib_random $RANDOM_SPEC"

venv/bin/python "$SEARCH" \
    --domain "$DOMAIN" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --iqn_model "$IQN" \
    --qrdqn_value --c_puct "$C_PUCT" --max_time "$MAXTIME" --diag_select \
    --abs_signal "$ABS_SIGNAL" --tau_step 1.0 \
    --abs_beta "$ABS_BETA" --abs_kappa "$ABS_KAPPA" --eps_p "$EPS_P" $FLAGS \
    > "${OUT_DIR}/${NAME}.out" 2>&1
