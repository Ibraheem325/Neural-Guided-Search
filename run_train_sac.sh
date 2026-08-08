#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

# Train the SAC policy + twin critics for one domain.
#
# WHY THIS EXISTS: the logistics SAC policy was trained on the c2s1-only dataset.
# On multi-location probes its softmax collapses to a near-delta distribution
# (median entropy 0.027 nats vs 1.609 in-distribution; P_max > 0.99 on 51% of
# on-path states) and the OPTIMAL action gets P(a*) < 1e-3 on 51% of them, often
# ~1e-13. Since pUCT's exploration term is c_puct*P(a)*sqrt(N)/(1+n), an optimal
# action with P ~ 1e-13 is numerically unreachable -- it can only be selected once
# its Q dominates, but Q needs a visit first. That deadlock is why plans come out
# ~12x optimal and why fixing the VALUE (QR-DQN slope -0.303 -> -1.268) changed
# nothing at all: coverage stayed at 80.6%, exactly-optimal stayed at 4/232.
#
# Architecture below mirrors models/logistics_sac_policy.pth exactly (read from its
# stored config): embedding_size 32, 12 layers, SmoothMaximum aggregation.
#
# Usage:
#   sbatch run_train_sac.sh <dataset_dir> <output_prefix> [hindsight]
# Example:
#   sbatch run_train_sac.sh example/logistics_dataset_topo models/logistics_topo_sac_
# Produces <prefix>policy_best.pth, <prefix>q1_best.pth, <prefix>q2_best.pth
# (and _latest variants). The loop is `while True:` -- it runs until the SLURM
# time limit, so *_best.pth is what you consume.

DATASET=$1                      # e.g. example/logistics_dataset_topo
PREFIX=$2                       # e.g. models/logistics_topo_sac_   (note trailing _)
HINDSIGHT=${3:-lifted}          # matches the QR-DQN training

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
echo "[train-sac] dataset=$DATASET prefix=$PREFIX hindsight=$HINDSIGHT"

venv/bin/python train_sac.py \
    --train "${DATASET}/train" \
    --validation "${DATASET}/val" \
    --hindsight "$HINDSIGHT" \
    --aggregation smax \
    --embedding_size 32 \
    --layers 12 \
    --output_prefix "$PREFIX"
