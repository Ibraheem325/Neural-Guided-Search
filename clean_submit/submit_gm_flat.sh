#!/bin/bash
# GOLDMINER: signal-free FLATTENING at matched weights, distinct probe set.
#
#     prior'(a) = (1-w) P(a) + w/K        (--signal constant --const_w w)
#
# THIS IS THE ARM THAT DEFINED GOLDMINER. On the old 480-probe set, flattening at w=0.28 beat
# EVERY signal arm and took coverage 337 -> 478 of 480. That result is the anchor for the
# dose explanation used on grid (p = 0.3135) and rovers (p = 0.4657), so it needs to hold on
# a probe set that is test-only and free of the 16x clustering. Two defects in the old set
# bear directly on it: 64 of its 480 probes came from VAL, and the 480 came from only 30
# problems.
#
# IT IS ALSO THE ONLY CLEAN CONTROL ON THIS DOMAIN. goldminer's median branching is TWO, so
# shuffle degenerates to a coin flip between two arrangements and the random control fails
# its own fit diagnostic (drawn g_s spread 0.1226 vs real 0.1222 -- no reduction, where
# satellite gets 0.0969 -> 0.0087). Flattening does not depend on sibling structure existing,
# so it still isolates what it claims: same injected mass, zero signal content.
#
# WEIGHTS mirror the multiplicative rungs: 0.26 is goldminer's own W = 0.258 at beta=1, then
# 0.40 (W at beta=2) and 0.60. Note w/K = w/2 here -- at K=2 a weight of 0.26 moves 13 points
# of probability onto each action, by far the coarsest intervention in the study.
#
# Baseline: results/gm_base. qrdqn_value=1 keeps the leaf value on the same model as every
# other goldminer arm, so the only difference is the prior transform.
# Run from a COMPUTE node:  bash submit_gm_flat.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_distinct_d5-22/domain.pddl; MT=example/probeGold_distinct_d5-22
MP=models/goldminer_sac_policy.pth
MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth
N=118

# flat <outdir> <w>
flat () {
  sbatch $CPU --array=1-$N "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

flat gm_flat026 0.26     # matches eps=0.26 (goldminer's own W at beta=1) -- THE test
flat gm_flat040 0.40     # matches eps=0.40, and W at beta=2
flat gm_flat060 0.60     # matches eps=0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
