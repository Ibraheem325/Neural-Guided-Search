#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=01:00:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

# Weighted Q* (f = g + w*h, h = -Q). w>1 un-compresses a compressed DQN heuristic.
# Usage:
#   sbatch --array=1-113 run_qstar_weight.sh <domain> <test_dir> <q_model> <outdir> <w> <max_time>

DOMAIN_FILE=$1
TEST_DIR=$2
MODEL=$3
OUTDIR=$4
W=$5
MAXTIME=$6

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB=${FILES[$IDX]}
NAME=$(basename "$PROB" .pddl)

mkdir -p "$OUTDIR"
venv/bin/python qstar.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" --model "$MODEL" \
    --heuristic_weight "$W" --max_time "$MAXTIME" > "${OUTDIR}/${NAME}.out" 2>&1
