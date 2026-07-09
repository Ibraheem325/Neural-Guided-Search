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

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB=${FILES[$IDX]}
NAME=$(basename "$PROB" .pddl)

mkdir -p "$OUTDIR"
venv/bin/python alphaZero_bellman.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_model "$IQN" \
    --bellman_lambda "$LAMBDA" --bellman_k "$K" --signal "$SIGNAL" \
    --const_w "$CONST_W" \
    --max_time "$MAXTIME" > "${OUTDIR}/${NAME}.out" 2>&1
