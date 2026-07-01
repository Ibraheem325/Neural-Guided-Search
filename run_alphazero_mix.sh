#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

DOMAIN_FILE=$1; TEST_DIR=$2; POLICY=$3; Q1=$4; Q2=$5; IQN=$6; OUTDIR=$7; METRIC=$8; ALPHA=$9

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB=${FILES[$IDX]}
NAME=$(basename "$PROB" .pddl)

mkdir -p "$OUTDIR"
venv/bin/python alphaZero_mix.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_model "$IQN" --metric "$METRIC" --mix_alpha "$ALPHA" \
    --max_time 1800 > "${OUTDIR}/${NAME}.out" 2>&1
