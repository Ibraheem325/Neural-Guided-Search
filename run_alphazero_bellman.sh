#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

# AlphaZero + Bellman-consistency widening, one problem per array task.
#
# Usage:
#   sbatch --array=1-120 run_alphazero_bellman.sh <domain> <test_dir> \
#     <policy> <q1> <q2> <iqn> <outdir> <lambda> <k> <signal> <max_time>
#
# Run a lambda=0 arm too (identical to baseline) for a matched comparison on
# the SAME instance set. Example (Rovers, submit each arm):
#   D=example/rovers_dataset/domain.pddl; T=example/rovers_dataset/test
#   P=models/rovers_sac_policy.pth; Q1=models/rovers_sac_q1.pth; Q2=models/rovers_sac_q2.pth
#   IQN=models/rovers_iqn.pth; MT=300
#   sbatch --array=1-120 run_alphazero_bellman.sh $D $T $P $Q1 $Q2 $IQN results/az_rov_bellman_l0   0.0 4 bellman $MT
#   sbatch --array=1-120 run_alphazero_bellman.sh $D $T $P $Q1 $Q2 $IQN results/az_rov_bellman_l05  0.5 4 bellman $MT
#   sbatch --array=1-120 run_alphazero_bellman.sh $D $T $P $Q1 $Q2 $IQN results/az_rov_bellman_l10  1.0 4 bellman $MT
#   sbatch --array=1-120 run_alphazero_bellman.sh $D $T $P $Q1 $Q2 $IQN results/az_rov_bellman_l20  2.0 4 bellman $MT

DOMAIN_FILE=$1
TEST_DIR=$2
POLICY=$3
Q1=$4
Q2=$5
IQN=$6
OUTDIR=$7
LAMBDA=$8
K=$9
SIGNAL=${10}
MAXTIME=${11}
CONST_W=${12:-0.0}     # only used when SIGNAL=constant
# Cap on the widening weight. NOTE: this silently truncates CONST_W if left at the
# default -- a w=1.0 arm submitted without arg 13 actually runs at 0.95. So for
# SIGNAL=constant, default W_MAX to CONST_W itself rather than to 0.95.
if [ "$SIGNAL" = "constant" ]; then
    W_MAX=${13:-$CONST_W}
else
    W_MAX=${13:-0.95}
fi

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB=${FILES[$IDX]}
NAME=$(basename "$PROB" .pddl)

mkdir -p "$OUTDIR"
# arg 14: pass "adaptive" to normalize err by the running median of this search's
# own errors (recommended -- a fixed err_scale is domain-specific and saturates w).
ADAPTIVE=${14:-}
ADAPTIVE_FLAG=""
[ "$ADAPTIVE" = "adaptive" ] && ADAPTIVE_FLAG="--adaptive_scale"
# arg 15: OPTION 2 value-distrust strength (leaves prior untouched). 0 = off.
VALUE_LAMBDA=${15:-0.0}
# arg 16: OPTION 3 width-confidence exploration strength (leaves prior untouched). 0 = off.
# Point $IQN at the calibrated QR-DQN. width_beta=0 == exact baseline.
WIDTH_BETA=${16:-0.0}
# args 17-19: OPTION 4 ENSEMBLE-disagreement exploration strength + member prefix + count.
# ens_beta=0 == off. Prefix loads {prefix}{i}_q1_best.pth / {prefix}{i}_q2_best.pth.
ENS_BETA=${17:-0.0}
ENS_PREFIX=${18:-}
ENS_N=${19:-5}
ENS_ARGS=""
[ -n "$ENS_PREFIX" ] && ENS_ARGS="--ens_prefix $ENS_PREFIX --ens_n $ENS_N"
# arg 20: OPTION 5 sibling raw-width exploration strength (leaves prior untouched). 0 = off.
SIB_BETA=${20:-0.0}
# arg 21: OPTION 5 ROOM GATE -- activate the sibling channel only after this many expansions.
# 0 = no gate (channel active from the start). Try ~80-150.
SIB_GATE=${21:-0}

venv/bin/python alphaZero_bellman.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_model "$IQN" \
    --bellman_lambda "$LAMBDA" --bellman_k "$K" --signal "$SIGNAL" \
    --const_w "$CONST_W" --w_max "$W_MAX" $ADAPTIVE_FLAG \
    --value_lambda "$VALUE_LAMBDA" --width_beta "$WIDTH_BETA" \
    --ens_beta "$ENS_BETA" $ENS_ARGS --sib_beta "$SIB_BETA" --sib_gate "$SIB_GATE" \
    --max_time "$MAXTIME" > "${OUTDIR}/${NAME}.out" 2>&1
