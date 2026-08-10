#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_cpu
#SBATCH --gres=none
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00
#SBATCH --chdir=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search-clean
#
# Launcher for the cleaned alphaZero_bellman.py -- one problem per array task.
#
# 19 positional arguments, against the archived version's 37. The old launcher carried an
# argument for every one of the nine channels that were tried; eight are gone, so the
# positional block that used to read
#     ... 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" add 1.0 1.0 1.0 0.001
# is now just what the arm actually varies. Dropping an argument silently shifted every
# later one in the old script -- that bug cost a full 9-arm sweep once -- so fewer slots is
# not cosmetic.
#
# Usage:
#   sbatch --array=1-N run_search_signal.sh <domain> <probe_dir> <policy> <q1> <q2> <iqn> \
#          <outdir> <max_time> <signal> <const_w> <c_puct> <qrdqn_value> \
#          <shuffle> <random_spec> <abs_signal> <tau> <beta> <kappa> <eps_p>
#
# The five configurations the thesis uses:
#   BASELINE   ... bellman  0.0  1.5 1  0 ""    off 1.0 1.0 1.0 0.001
#   SIGNAL     ... bellman  0.0  1.5 1  0 ""    add 1.0 1.0 1.0 0.001
#   SHUFFLE    ... bellman  0.0  1.5 1  1 ""    add 1.0 1.0 1.0 0.001
#   RANDOM     ... bellman  0.0  1.5 1  0 "$LN" add 1.0 1.0 1.0 0.001
#   FLATTEN    ... constant 0.28 1.5 1  0 ""    off 1.0 1.0 1.0 0.001
# where $LN is that DOMAIN's own lognormal fit (fit_random_control.py) -- goldminer
# 1.003:-0.585, logistics 0.992:-0.461, satellite 0.666:-0.970, rovers 1.098:-0.483.
# Copying one domain's spec to another puts g_s at the wrong level and voids the control.

DOMAIN_FILE=$1
TEST_DIR=$2
POLICY=$3
Q1=$4
Q2=$5
IQN=$6
OUTDIR=$7
MAXTIME=$8
SIGNAL=${9:-bellman}      # bellman (no-op) | constant (signal-free flattening)
CONST_W=${10:-0.0}        # flattening weight, only read when SIGNAL=constant
C_PUCT=${11:-1.5}
QRDQN_VALUE=${12:-1}      # 1 = leaf value from the QR-DQN, matching every reported baseline
SHUFFLE=${13:-0}
RANDOM_SPEC=${14:-}
ABS_SIGNAL=${15:-off}     # off | add | mul
TAU_STEP=${16:-1.0}
ABS_BETA=${17:-1.0}
ABS_KAPPA=${18:-1.0}
EPS_P=${19:-0.001}

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
PROB=${FILES[$((SLURM_ARRAY_TASK_ID - 1))]}
NAME=$(basename "$PROB" .pddl)
mkdir -p "$OUTDIR"

FLAGS=""
[ "$QRDQN_VALUE" = "1" ] && FLAGS="$FLAGS --qrdqn_value"
[ "$SHUFFLE" = "1" ]     && FLAGS="$FLAGS --sib_shuffle"
[ -n "$RANDOM_SPEC" ]    && FLAGS="$FLAGS --sib_random $RANDOM_SPEC"

venv/bin/python alphaZero_bellman.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" --iqn_model "$IQN" \
    --signal "$SIGNAL" --const_w "$CONST_W" --c_puct "$C_PUCT" $FLAGS \
    --abs_signal "$ABS_SIGNAL" --tau_step "$TAU_STEP" \
    --abs_beta "$ABS_BETA" --abs_kappa "$ABS_KAPPA" --eps_p "$EPS_P" \
    --max_time "$MAXTIME" > "${OUTDIR}/${NAME}.out" 2>&1
