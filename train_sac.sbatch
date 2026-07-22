#!/bin/bash
#SBATCH --job-name=sac
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --time=24:00:00
#SBATCH --partition=rleap_gpu_24gb,rleap_gpu_48gb
#SBATCH --gres=shard:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Usage: sbatch train_sac.sbatch <train_dir> <val_dir> <hindsight> <seed> <output_prefix> [extra args...]
# Trains one SAC run. Models are saved as <output_prefix>{policy,q1,q2}_{best,latest}.pth
# For the barman hindsight experiment, launch two arms differing only in <hindsight>:
#   sbatch train_sac.sbatch example/barman_dataset/train example/barman_dataset/val state  42 barman_sac_state_
#   sbatch train_sac.sbatch example/barman_dataset/train example/barman_dataset/val lifted 42 barman_sac_lifted_

source venv/bin/activate

TRAIN_DIR=$1
VAL_DIR=$2
HINDSIGHT=$3
SEED=$4
PREFIX=$5
shift 5

python train_sac.py \
    --train "$TRAIN_DIR" \
    --validation "$VAL_DIR" \
    --hindsight "$HINDSIGHT" \
    --seed "$SEED" \
    --output_prefix "$PREFIX" \
    "$@"
