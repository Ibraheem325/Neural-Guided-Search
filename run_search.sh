#!/bin/bash
#SBATCH --account=rleap
#SBATCH --partition=rleap_gpu_48gb
#SBATCH --gres=shard:L40S:6
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=00:30:00

cd /u/ibrahim.eisawy/Neural-Guided-Search

DOMAIN=$1
PROBLEM_DIR=$2
MODEL=$3
OUTPUT_DIR=$4
ALGORITHM=$5
EXTRA_ARGS=$6

PROBLEM=$(ls ${PROBLEM_DIR}/*.pddl | grep -v domain.pddl | sort | sed -n "${SLURM_ARRAY_TASK_ID}p")
PROBLEM_NAME=$(basename $PROBLEM .pddl)

case $ALGORITHM in
    astar)
        venv/bin/python search.py --domain $DOMAIN --problem $PROBLEM --model $MODEL > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    wastar_2)
        venv/bin/python wastar.py --domain $DOMAIN --problem $PROBLEM --model $MODEL --weight 2.0 > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    wastar_5)
        venv/bin/python wastar.py --domain $DOMAIN --problem $PROBLEM --model $MODEL --weight 5.0 > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    greedy)
        venv/bin/python greedy_value_plan.py --domain $DOMAIN --problem $PROBLEM --model $MODEL > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    beam_1)
        venv/bin/python beam.py --domain $DOMAIN --problem $PROBLEM --model $MODEL --beam 1 > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    beam_5)
        venv/bin/python beam.py --domain $DOMAIN --problem $PROBLEM --model $MODEL --beam 5 > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    beam_10)
        venv/bin/python beam.py --domain $DOMAIN --problem $PROBLEM --model $MODEL --beam 10 > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    qstar)
        venv/bin/python qstar.py --domain $DOMAIN --problem $PROBLEM --model $MODEL > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
    greedy_q)
        venv/bin/python qstar.py --domain $DOMAIN --problem $PROBLEM --model $MODEL > ${OUTPUT_DIR}/${PROBLEM_NAME}.out 2>&1 ;;
esac
