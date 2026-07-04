#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:12
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --chdir=/u/ibrahim.eisawy/Neural-Guided-Search

# Usage: sbatch --array=1-120 run_alphazero_ensemble.sh <domain> <test_dir> \
#          <policy> <q1> <q2> <outdir> <v_lambda> <v_beta> <v_n0> <max_time> \
#          <iqn_model_1> [iqn_model_2 ...]

DOMAIN_FILE=$1
TEST_DIR=$2
POLICY=$3
Q1=$4
Q2=$5
OUTDIR=$6
VLAMBDA=$7
VBETA=$8
VN0=$9
MAXTIME=${10}
shift 10
IQN_MODELS=("$@")

FILES=($(ls ${TEST_DIR}/*.pddl | grep -v domain | sort))
IDX=$((SLURM_ARRAY_TASK_ID - 1))
PROB=${FILES[$IDX]}
NAME=$(basename "$PROB" .pddl)

mkdir -p "$OUTDIR"
venv/bin/python alphaZero_ensemble.py \
    --domain "$DOMAIN_FILE" --problem "$PROB" \
    --policy_model "$POLICY" --q1_model "$Q1" --q2_model "$Q2" \
    --iqn_models "${IQN_MODELS[@]}" \
    --v_lambda "$VLAMBDA" --v_beta "$VBETA" --v_n0 "$VN0" \
    --max_time "$MAXTIME" > "${OUTDIR}/${NAME}.out" 2>&1
