#!/bin/bash
# SATELLITE, IN-DISTRIBUTION test set. The condition the study was missing.
#
# WHY. Goldminer anchors the DOSE result: on the extrapolated test set the baseline solves
# 88/118 while every perturbation arm reaches ~118, and grid's and rovers' "it is just dose"
# conclusions lean on that 74.6% -> 100% jump. But that set is 49-100 objects against a
# training range of 4-42, so the baseline may be failing because the instances are 2-4x
# training size rather than because its prior is wrong.
#
# THE SET: example/gmIndistReal, 120 instances from the REAL gold-miner-generator
# (AI-Planning/pddl-generators), grid sizes resampled from the training split's own (R,C)
# histogram, every candidate rejected if its canonical objects+init+goal matches one of the
# 520 train+val instances. Cells 9-42 median 25 against training's 4-42 median 25.
#
# NOTE the min: 9, not 4. All 8 of training's 2x2 configurations already exist, so every 2x2
# draw collided and was rejected (4 rejections, 3.2%). The small-grid end of this domain is
# genuinely exhausted -- an in-distribution goldminer test set cannot include the smallest
# grids without reusing training instances. Worth stating; it is a property of the domain.
#
# NOT PROBES. Whole instances from their INITIAL state, no depth control. FD-optimal solved
# 111/120; the 9 failures are all 6x6/6x7, where astar(lmcut()) exceeded 1800s. lama solved
# all 120, so they are hard to solve OPTIMALLY, not hard to solve -- they only drop out of
# the vs-opt column.
#
# CONSTANTS refit on these instances (652 states, 1916 edges):
#   RANDOM control  lognormal:0.887:-0.764
#   mean g_s 0.3367 -> c(s) matched c_puct 2.01
#   W at beta=1 = 0.252 -> eps_p 0.25;  W at beta=2 = 0.402
#
# THE RANDOM ARM IS NOT A CONTROL HERE, and it is worse than on the extrapolated set.
# fit_random_control wants the drawn g_s spread BELOW the real one; it comes back
# 0.0967 real vs 0.1067 drawn -- the draw ADDS spread. Median branching is 2, so g_s is the
# mean of two draws and there is no per-state structure to destroy. The FLAT arms are the
# only clean control on goldminer, in both conditions.
#
# THE PRIOR IS NEARLY USELESS IN-DISTRIBUTION, which is the opposite of what the
# extrapolated set suggests:
#
#                        extrapolated      in-distribution
#   top-1 accuracy          77.8%             50.7%
#   uniform baseline        41.7%             41.5%
#   CONFIDENTLY WRONG       17.7%             45.0%
#   P(a*) < 1e-3 on         14.6%             39.1%
#
# 50.7% against a 41.5% chance baseline is a 9-point edge. 45% confidently wrong is the
# worst figure in the study. CAVEAT, shared with satellite: the probe sets are states cut d
# steps from the GOAL where the right action is often forced, while these run from the
# INITIAL state. In-distribution and from-the-start are entangled.
#
# PREDICTION, recorded before the run. At 45% confidently wrong this is the flattening
# regime by every measure the study has used, so the flat arms should dominate and the
# signal should add nothing over them.
#
# Run from a COMPUTE node:  bash submit_gm_indreal.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/gmIndistReal/domain.pddl; ST=example/gmIndistReal
SP=models/goldminer_sac_policy.pth
SQ1=models/goldminer_sac_q1.pth; SQ2=models/goldminer_sac_q2.pth
SI=models/goldminer_iqn.pth
N=120
LN=lognormal:0.887:-0.764                    # refit on the REAL gold-miner-generator set

# sub <outdir> <shuffle> <mode> <beta> <kappa> <eps_p> [random_spec]
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $SD $ST $SP $SQ1 $SQ2 $SI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "${7:-}" $3 1.0 $4 $5 $6
}
flat () {
  sbatch $CPU --array=1-$N "$LAUNCH" $SD $ST $SP $SQ1 $SQ2 $SI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

# BASELINE
sbatch $CPU --array=1-$N "$LAUNCH" $SD $ST $SP $SQ1 $SQ2 $SI \
  results/greal_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

# --- additive row + its blind controls ---
sub greal_abs_t1b1k1       0 add 1.0 1.0 0.001
sub greal_abs_t1b1k0       0 add 1.0 0.0 0.001
sub greal_abs_t1b0k1       0 add 0.0 1.0 0.001
sub greal_abs_t1b2k1       0 add 2.0 1.0 0.001
sub greal_abs_t1b1k1_shuf  1 add 1.0 1.0 0.001
sub greal_abs_t1b1k1_rndm  0 add 1.0 1.0 0.001 "$LN"

# --- beta=8, satellite's best cell on the extrapolated set, WITH controls ---
sub greal_abs_b8k1_e001       0 add 8.0 1.0 0.001
sub greal_abs_b8k1_e001_shuf  1 add 8.0 1.0 0.001
sub greal_abs_b8k1_e001_rndm  0 add 8.0 1.0 0.001 "$LN"

# --- multiplicative ladder. 0.25 is this set's OWN matched mass (W=0.218 at beta=1) ---
sub greal_mul_e001_k0       0 mul 1.0 0.0 0.001
sub greal_mul_e001_k1       0 mul 1.0 1.0 0.001
sub greal_mul_e025_k0       0 mul 1.0 0.0 0.25
sub greal_mul_e025_k0_shuf  1 mul 1.0 0.0 0.25
sub greal_mul_e040_k0       0 mul 1.0 0.0 0.40
sub greal_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub greal_mul_e060_k0       0 mul 1.0 0.0 0.60

# --- signal-free flattening at the matched weights ---
flat greal_flat022 0.25
flat greal_flat040 0.40
flat greal_flat060 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
