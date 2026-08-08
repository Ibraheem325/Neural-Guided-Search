#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

# Train a QR-DQN distributional value model for one domain.
#
# This is the config that de-saturated the GRID model (models/grid_iqn_qrdqn_best.pth):
#   --tau_conditioning qrdqn   : drop the tau-conditioning entirely; the head emits
#                                num_atoms quantiles on a fixed grid (the DQN-like path
#                                that reaches -149 instead of saturating at -16).
#   --use_object_context       : the DOMINANT fix -- ~90% of the far-field recovery came
#                                from giving the readout a global object context so the
#                                model can see problem SCALE.
#   --bounds_weight 1.0        : soft bounds penalty instead of the hard target clamp.
#
# Usage:
#   sbatch run_train_iqn.sh <dataset_dir> <output_prefix> [hindsight] [train_steps]
# Example:
#   sbatch run_train_iqn.sh example/goldminer_dataset models/goldminer_iqn_qrdqn_
# Produces <output_prefix>best.pth and <output_prefix>latest.pth

DATASET=$1                      # e.g. example/goldminer_dataset
PREFIX=$2                       # e.g. models/goldminer_iqn_qrdqn_   (note trailing _)
HINDSIGHT=${3:-lifted}          # matches the grid QR-DQN training
TRAIN_STEPS=${4:-32}

# --- CUDA MPS (same rationale as the search jobs: many tiny kernels) ---
# --- CUDA MPS: OFF by default for TRAINING jobs ---
# MPS exists to let MANY TINY array tasks share one GPU context (see
# run_alphazero_bellman.sh). A single training job gains nothing from it, and it can
# actively break: on cn-412 the daemon reported ACTIVE while the client failed with
# "Error 805: MPS client failed to connect", CUDA init failed, and PyTorch fell back to
# CPU -- silently, so the job "ran" for two hours producing one episode. Torch only warns.
# Set USE_MPS=1 to re-enable if a future job genuinely needs it.
if [ "${USE_MPS:-0}" = "1" ]; then
    export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps-$USER
    export CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-mps-log-$USER
    mkdir -p "$CUDA_MPS_PIPE_DIRECTORY" "$CUDA_MPS_LOG_DIRECTORY" 2>/dev/null
    command -v nvidia-cuda-mps-control >/dev/null 2>&1 && nvidia-cuda-mps-control -d >/dev/null 2>&1
    echo "[MPS] requested via USE_MPS=1 on $(hostname)"
else
    unset CUDA_MPS_PIPE_DIRECTORY CUDA_MPS_LOG_DIRECTORY
    echo "[MPS] disabled for training (set USE_MPS=1 to enable)"
fi

# FAIL LOUDLY if the GPU is not visible. A silent CPU fallback wastes the whole
# allocation; better to die in 10 seconds than to discover it 20 hours later.
if [ "${ALLOW_CPU:-0}" != "1" ]; then
    venv/bin/python -c "import torch,sys; sys.exit(0 if torch.cuda.is_available() else 1)" || {
        echo "ERROR: torch.cuda.is_available() is False on $(hostname) -- refusing to train on CPU."
        echo "       Re-run with ALLOW_CPU=1 to override."
        exit 1
    }
    echo "[GPU] CUDA visible on $(hostname)"
fi

mkdir -p models
echo "[train] dataset=$DATASET prefix=$PREFIX hindsight=$HINDSIGHT steps=$TRAIN_STEPS"

venv/bin/python train_iqn.py \
    --train "${DATASET}/train" \
    --validation "${DATASET}/val" \
    --hindsight "$HINDSIGHT" \
    --tau_conditioning qrdqn \
    --use_object_context \
    --bounds_weight 1.0 \
    --num_atoms 64 \
    --embedding_size 32 \
    --layers 12 \
    --aggregation smax \
    --train_steps "$TRAIN_STEPS" \
    --output_prefix "$PREFIX"
