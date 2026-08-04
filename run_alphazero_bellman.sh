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

# --- CUDA MPS -----------------------------------------------------------------
# These jobs issue MANY TINY kernels (batch-of-1 GNN forwards). With GPU sharding but
# no MPS the driver TIME-SLICES the processes: nvidia-smi reads ~100% "utilisation"
# (a kernel is always resident) while real throughput is poor, because every process
# pays a context switch and its kernels never fill the device. MPS funnels all of this
# user's processes through ONE shared CUDA context so their kernels run CONCURRENTLY.
# The daemon is per-user and per-NODE, so keep the pipe dir node-local (/tmp), and never
# exit on failure: another array task (or another job) may have started it already, and
# a job that cannot start MPS must still run normally.
export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps-$USER
export CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-mps-log-$USER
mkdir -p "$CUDA_MPS_PIPE_DIRECTORY" "$CUDA_MPS_LOG_DIRECTORY" 2>/dev/null
if command -v nvidia-cuda-mps-control >/dev/null 2>&1; then
    nvidia-cuda-mps-control -d >/dev/null 2>&1   # no-op if a daemon is already up
    if [ -e "$CUDA_MPS_PIPE_DIRECTORY/control" ]; then
        echo "[MPS] ACTIVE on $(hostname) (pipe=$CUDA_MPS_PIPE_DIRECTORY)"
    else
        echo "[MPS] control binary found but NO daemon pipe -- running WITHOUT MPS"
    fi
else
    echo "[MPS] nvidia-cuda-mps-control NOT FOUND -- running WITHOUT MPS"
fi
# NOTE: deliberately NO daemon shutdown at exit -- other running jobs share it.
# The job ALWAYS continues regardless of MPS status (per cluster admin's instruction).

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
# arg 22: OPTION 6 SIBLING BELLMAN-INCONSISTENCY exploration strength (1-step min-W1
# parent-vs-child). 0 = off. Point $IQN at the QR-DQN. Mutually exclusive with SIB_BETA.
BINC_BETA=${22:-0.0}
# arg 23: SHUFFLE CONTROL (0/1) for OPTION 5/6/7 -- signal-blind sibling placement. 1 = shuffle.
SHUFFLE=${23:-0}
SHUFFLE_FLAG=""
[ "$SHUFFLE" = "1" ] && SHUFFLE_FLAG="--sib_shuffle"
# arg 24: OPTION 7 SIBLING RAW EDGE-W1 exploration strength (no reward/discount). 0 = off.
# Mutually exclusive with SIB_BETA and BINC_BETA.
W1RAW_BETA=${24:-0.0}
# arg 25: c_puct (pUCT exploration constant). Baseline default = 1.5. Lower => more
# commitment (signal-free "commitment" control: does over-exploration explain the shuffle gains).
C_PUCT=${25:-1.5}
# arg 26: SELF-CONSISTENT VALUE (0/1) -- use the QR-DQN as the leaf value (not SAC critics),
# so the width/Binc uncertainty signal matches the value function driving search. 1 = on.
QRDQN_VALUE=${26:-0}
QRDQN_VALUE_FLAG=""
[ "$QRDQN_VALUE" = "1" ] && QRDQN_VALUE_FLAG="--qrdqn_value"
# arg 27: OPTION 6 B_good width (value units). 0 = hard best; ~0.5-1.0 forgives near-tied successors.
BINC_EPS=${27:-0.0}
# args 28-31: OPTION 8 ADDITIVE bonus (prior-independent) + P-gate softening.
#   28 ADD_BETA   : additive strength (0 = off)
#   29 ADD_SRC    : which signal feeds it (width|binc|w1raw)
#   30 ADD_CAP    : cap on (rel-1)
#   31 PRIOR_GAMMA: exponent on P(a) in the exploration term (1.0 = standard, 0.5 = sqrt softening)
ADD_BETA=${28:-0.0}
ADD_SRC=${29:-binc}
ADD_CAP=${30:-2.0}
PRIOR_GAMMA=${31:-1.0}
# arg 32: RANDOM control -- "" (off) | uniform | exp. Stronger than arg 23 (shuffle):
# shuffle permutes the REAL signal values among siblings, so the spread is preserved and
# only the placement is scrambled; random throws the values away and draws fresh weights,
# so the spread is destroyed too. Takes precedence over SHUFFLE when both are set.
SIB_RANDOM=${32:-}
RANDOM_ARGS=""
[ -n "$SIB_RANDOM" ] && RANDOM_ARGS="--sib_random $SIB_RANDOM"
# args 33-36: OPTION 9 ABSOLUTE-SCALE signal (supervisor's reformulation; no sibling division).
#   33 ABS_SIGNAL: off | add | mul   (add = prior-independent P_+, the only one that can lift a
#                                     P~0 arm; mul is a near no-op at eps_p=0.001)
#   34 TAU_STEP  : squash knee in reward units (1 action = 1.0). Sweep {0.5, 1, 2}.
#   35 ABS_BETA  : prior-tilt strength
#   36 ABS_KAPPA : exploration widening c(s)=c_puct*(1+kappa*g_s); 0 = prior channel only
# Mutually exclusive with args 16/17/20/22/24/28 (asserted in alphaZero_bellman.py).
ABS_SIGNAL=${33:-off}
TAU_STEP=${34:-1.0}
ABS_BETA=${35:-1.0}
ABS_KAPPA=${36:-1.0}
# arg 37: OPTION 9 prior floor. P0 = (1-eps_p)*P + eps_p/K, applied BEFORE the tilt.
# At the doc's 0.001 the multiplicative variant is a measured no-op (median TV 0.0003)
# because SAC saturates. Setting eps_p equal to a flattening arm's w makes P0 IDENTICAL
# to that arm's prior, so the only remaining difference is the multiplicative tilt --
# which turns an existing flat run into an exactly matched control.
EPS_P=${37:-0.001}

venv/bin/python alphaZero_bellman.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_model "$IQN" \
    --bellman_lambda "$LAMBDA" --bellman_k "$K" --signal "$SIGNAL" \
    --const_w "$CONST_W" --w_max "$W_MAX" $ADAPTIVE_FLAG \
    --value_lambda "$VALUE_LAMBDA" --width_beta "$WIDTH_BETA" \
    --ens_beta "$ENS_BETA" $ENS_ARGS --sib_beta "$SIB_BETA" --sib_gate "$SIB_GATE" \
    --binc_beta "$BINC_BETA" --w1raw_beta "$W1RAW_BETA" $SHUFFLE_FLAG $RANDOM_ARGS \
    --c_puct "$C_PUCT" $QRDQN_VALUE_FLAG --binc_eps "$BINC_EPS" \
    --add_beta "$ADD_BETA" --add_src "$ADD_SRC" --add_cap "$ADD_CAP" --prior_gamma "$PRIOR_GAMMA" \
    --abs_signal "$ABS_SIGNAL" --tau_step "$TAU_STEP" --abs_beta "$ABS_BETA" \
    --abs_kappa "$ABS_KAPPA" --eps_p "$EPS_P" \
    --max_time "$MAXTIME" > "${OUTDIR}/${NAME}.out" 2>&1
