#!/bin/bash
#SBATCH --job-name=grid_train
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --time=24:00:00
#SBATCH --partition=rleap_gpu_24gb,rleap_gpu_48gb
#SBATCH --gres=shard:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

source venv/bin/activate

python train_supervised.py --domain grid
