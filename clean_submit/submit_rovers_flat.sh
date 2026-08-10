#!/bin/bash
# PORTED to run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# Rovers: signal-free FLATTENING at matched weights -- the rung rovers is missing.
#
# WHY. On rovers the signal is null against both its controls at base-problem level:
#   real vs shuffle   p = 1.0000   (action placement carries nothing)
#   real vs random    p = 1.0000   (per-state magnitude carries nothing)
# but ONE arm still looks different against the baseline:
#   eps=0.60 k=0      27 of 35 base problems improve, p = 0.0019
#   beta=2  k=1       19 / 16,  p = 0.7359
#   random control    16 / 19,  p = 0.7359
# eps=0.60 improves BROADLY (27/35), not by outlier concentration. But it also injects far
# more prior mass than the arms we actually controlled (0.29 and 0.40, both null against
# their own shuffles at p = 0.1755 and p = 0.8642), and there is no eps=0.60 shuffle. So
# nothing currently separates "the signal helps at high mass" from "more flattening helps".
#
# These three arms settle it. `--signal constant --const_w w` flattens every prior toward
# uniform by a fixed w with NO IQN and NO Bellman residual, so it is the same amount of
# perturbation with zero signal content:
#     prior'(a) = (1-w) P(a) + w/K
# If flat060 matches eps=0.60's 27/8, the effect is DOSE. If eps=0.60 beats flat060, that is
# a second positive result in the study and worth chasing.
#
# The weights mirror the multiplicative rungs so the pairs are matched: 0.29 is rovers' own
# W = beta*g_s/(1+beta*g_s) at beta=1 (fit on the TEST probes), 0.40 and 0.60 carry over.
# This is the same ladder that settled goldminer, where signal-free flattening at w=0.28
# beat EVERY signal arm (coverage 337 -> 478).
#
# Note arg 13 (W_MAX) must equal CONST_W: the script's default caps it at 0.95, which would
# silently truncate a w=1.0 arm, so both are passed explicitly.
#
# Baseline: results/rov_base. qrdqn_value=1 keeps the leaf value on the same model as every
# other rovers arm, so the only difference is the prior transform.
# Run from a COMPUTE node:  bash submit_rovers_flat.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

RD=example/probeRov_distinct_d5-22/domain.pddl; RT=example/probeRov_distinct_d5-22
RP=models/rovers_small_sac_policy_best.pth
RQ1=models/rovers_small_sac_q1_best.pth; RQ2=models/rovers_small_sac_q2_best.pth
RI=models/rovers_small_qrdqn_frozen.pth
N=120

# flat <outdir> <w>   -- args 10=constant, 12=13=w, 33=abs_signal off
flat () {
  sbatch $CPU --array=1-$N run_search_signal.sh $RD $RT $RP $RQ1 $RQ2 $RI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

flat rov_flat029 0.29     # matches eps=0.29 (rovers' own W at beta=1)
flat rov_flat040 0.40     # matches eps=0.40
flat rov_flat060 0.60     # matches eps=0.60 -- the arm that looks different

squeue -u $USER -h -o "%T" | sort | uniq -c
