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
echo "[train-sac] dataset=$DATASET prefix=$PREFIX hindsight=$HINDSIGHT"

venv/bin/python train_sac.py \
    --train "${DATASET}/train" \
    --validation "${DATASET}/val" \
    --hindsight "$HINDSIGHT" \
    --aggregation smax \
    --embedding_size 32 \
    --layers 12 \
    --output_prefix "$PREFIX"
