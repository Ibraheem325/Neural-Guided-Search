#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

DOMAIN_FILE=$1
TEST_DIR=$2
POLICY=$3
Q1=$4
Q2=$5
OUTDIR=$6
C1=$7
C2=$8

NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" priorconc_probe.txt)
PROB="${TEST_DIR}/${NAME}.pddl"

mkdir -p "$OUTDIR"
venv/bin/python alphaZero_decoupled.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --c1 "$C1" --c2 "$C2" --max_time 1200 > "${OUTDIR}/${NAME}.out" 2>&1
