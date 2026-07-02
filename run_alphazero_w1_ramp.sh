#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=00:40:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

DOMAIN_FILE=$1
TEST_DIR=$2
POLICY=$3
Q1=$4
Q2=$5
IQN=$6
OUTDIR=$7
LAMBDA=${8:-0.0}
BETA=${9:-0.25}
N0=${10:-512}
TOPK=${11:-1}
UNIFORM=${12:-0}      # pass 1 to use the uniform-floor control

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB=${FILES[$IDX]}
NAME=$(basename "$PROB" .pddl)

EXTRA=""
if [ "$UNIFORM" = "1" ]; then
    EXTRA="--w1_ramp_uniform"
fi

mkdir -p "$OUTDIR"
venv/bin/python alphaZero_w1_ramp.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_model "$IQN" \
    --w1_lambda "$LAMBDA" --w1_beta "$BETA" --w1_n0 "$N0" \
    --w1_ramp_topk "$TOPK" $EXTRA \
    --max_time 1800 > "${OUTDIR}/${NAME}.out" 2>&1
