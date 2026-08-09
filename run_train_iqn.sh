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
# --- GPU ACQUISITION: try MPS, then without, then give up -------------------
# Sharded GPU allocations (--gres=shard:...) normally need MPS, because the GPUs are in
# exclusive-process mode and several users share a node. But the MPS daemon is flaky:
# cn-412 and cn-406 both returned "Error 805: MPS client failed to connect", CUDA init
# failed, and torch silently fell back to CPU -- a 2-hour run that produced one episode.
# cn-404 works fine. So it is per-node luck.
#
# Queue waits are hours; a failed acquisition costs 20 seconds. Therefore TRY BOTH paths
# on the node we were given before surrendering the slot:
#   1. with MPS      (needed when the GPU is exclusive-process and shared)
#   2. without MPS   (works when we effectively have the device to ourselves)
# and only exit if neither yields a visible CUDA device. ALLOW_CPU=1 overrides.
_cuda_ok () { venv/bin/python -c "import torch,sys; sys.exit(0 if torch.cuda.is_available() else 1)" 2>/dev/null; }

export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps-$USER
export CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-mps-log-$USER
mkdir -p "$CUDA_MPS_PIPE_DIRECTORY" "$CUDA_MPS_LOG_DIRECTORY" 2>/dev/null
command -v nvidia-cuda-mps-control >/dev/null 2>&1 && nvidia-cuda-mps-control -d >/dev/null 2>&1
sleep 3
if _cuda_ok; then
    echo "[GPU] acquired WITH MPS on $(hostname)"
else
    echo "[GPU] MPS path failed on $(hostname) -- retrying without MPS"
    unset CUDA_MPS_PIPE_DIRECTORY CUDA_MPS_LOG_DIRECTORY
    if _cuda_ok; then
        echo "[GPU] acquired WITHOUT MPS on $(hostname)"
    elif [ "${ALLOW_CPU:-0}" = "1" ]; then
        echo "[GPU] no CUDA on $(hostname) -- ALLOW_CPU=1 set, continuing on CPU"
    else
        echo "ERROR: no usable CUDA device on $(hostname) (tried with and without MPS)."
        echo "       Slot surrendered. Resubmit; a different node will likely work."
        echo "       Re-run with ALLOW_CPU=1 to train on CPU anyway."
        exit 1
    fi
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
