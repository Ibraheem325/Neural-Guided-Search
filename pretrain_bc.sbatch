#!/bin/bash
#SBATCH --job-name=bc
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --time=12:00:00
#SBATCH --partition=rleap_gpu_24gb,rleap_gpu_48gb
#SBATCH --gres=shard:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Usage: sbatch pretrain_bc.sbatch <train_dir> <test_dir> <output_prefix> [extra args...]
# Behavior-clones a per-action policy from exact optimal actions (state-space expansion).
# The saved <output_prefix>policy_best.pth is a drop-in for greedy_sac_plan.py and for
# train_sac.py --warm_start (identical architecture => full-network transfer).
#   sbatch pretrain_bc.sbatch example/barman_dataset/train example/barman_dataset/test barman_bc_

source venv/bin/activate

TRAIN_DIR=$1
TEST_DIR=$2
PREFIX=$3
shift 3

python pretrain_bc.py \
    --train "$TRAIN_DIR" \
    --test "$TEST_DIR" \
    --output_prefix "$PREFIX" \
    "$@"
