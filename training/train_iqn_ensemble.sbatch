#!/bin/bash
#SBATCH --job-name=iqn_ens
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --time=24:00:00
#SBATCH --partition=rleap_gpu_24gb,rleap_gpu_48gb
#SBATCH --gres=shard:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Usage: sbatch train_iqn_ensemble.sbatch <train_dir> <val_dir> <hindsight> <seed> <output_prefix> [extra args...]
# Trains one IQN ensemble member; identical config except the seed.
# Models are saved as <output_prefix>best.pth and <output_prefix>latest.pth

source venv/bin/activate

TRAIN_DIR=$1
VAL_DIR=$2
HINDSIGHT=$3
SEED=$4
PREFIX=$5
shift 5

python train_iqn.py \
    --train "$TRAIN_DIR" \
    --validation "$VAL_DIR" \
    --hindsight "$HINDSIGHT" \
    --seed "$SEED" \
    --output_prefix "$PREFIX" \
    "$@"
