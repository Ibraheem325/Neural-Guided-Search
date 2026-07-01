#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=01:00:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

DOMAIN_FILE=$1
TEST_DIR=$2
POLICY=$3
Q1=$4
Q2=$5
IQN=$6
OUTDIR=$7
LAMBDA=${8:-0.0}
TOPK=${9:-0}

# Read the Nth dropped-instance name (1-indexed by array task id)
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${INSTLIST:-dropped_instances.txt})
PROB="${TEST_DIR}/${NAME}.pddl"

mkdir -p "$OUTDIR"
AZ_FANOUT=1 venv/bin/python alphaZero_w1.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_model "$IQN" --w1_lambda "$LAMBDA" --w1_topk "$TOPK" ${FPU:+--fpu_reduction $FPU} ${VGATE:+--w1_visit_gated} \
    --max_time 1200 > "${OUTDIR}/${NAME}.out" 2>&1
