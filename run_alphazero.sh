#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:6
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=00:30:00

cd /u/ibrahim.eisawy/Neural-Guided-Search

DOMAIN=$1
PROBLEM_DIR=$2
POLICY_MODEL=$3
Q1_MODEL=$4
Q2_MODEL=$5
OUTPUT_DIR=$6

PROBLEM=$(ls ${PROBLEM_DIR}/*.pddl | sort | sed -n "${SLURM_ARRAY_TASK_ID}p")
PROBLEM_NAME=$(basename $PROBLEM .pddl)

venv/bin/python alphaZero.py \
    --domain ${DOMAIN} \
    --problem ${PROBLEM} \
    --policy_model ${POLICY_MODEL} \
    --q1_model ${Q1_MODEL} \
    --q2_model ${Q2_MODEL} \
    --max_time 1800 \
    > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1
