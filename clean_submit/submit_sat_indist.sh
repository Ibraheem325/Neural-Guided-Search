#!/bin/bash
# SATELLITE, IN-DISTRIBUTION test set. The condition the study was missing.
#
# WHY. Every dataset here has disjoint object ranges per split -- satellite is train 8-22,
# val 23-45, test 46-95 -- so every satellite result reported so far is a SIZE-EXTRAPOLATION
# result. This runs the same arms on example/satIndist_120: 120 generated instances whose
# shape is resampled from the training split itself (objects 8-22 median 17, matching train
# exactly), verified disjoint from all 520 train+val instances by canonical hash.
#
# NOT PROBES. These are whole instances used from their INITIAL state. There is no
# distance-to-goal control -- difficulty is whatever the generator produced. Only size is
# held fixed.
#
# CONSTANTS refit on these instances (642 states, 15708 edges) -- they all moved:
#   RANDOM control  lognormal:0.653:-1.070   (extrapolated set: 0.717:-0.831)
#   mean g_s 0.2792 -> c(s) matched c_puct 1.92   (was 0.3286 -> 2.04)
#   W at beta=1 = 0.218 -> eps_p 0.22             (was 0.247 -> 0.25)
#   W at beta=2 = 0.358
# Lower g_s in-distribution: less Bellman inconsistency where the model was trained.
#
# WHAT CHANGED IN THE PRIOR, and it is not what I expected. prior_peak on these instances:
#
#                        extrapolated      in-distribution
#   top-1 accuracy          61.6%             68.9%
#   uniform baseline         0.5%              4.6%
#   P_max >= 0.9 on         57.6%             79.4%
#   CONFIDENTLY WRONG        4.4%             16.3%
#   actions per state         274                26
#
# The policy is MORE accurate and MUCH more confident in-distribution, but conditional on
# being confident it is wrong far more often (20.5% vs 7.6%). Caveat: conf-wrong scores
# disagreement with ONE reference plan, and satellite has many equivalent orderings; small
# instances have more viable alternatives, so some of that 16.3% is the policy picking a
# different but equally good action. Treat it as an upper bound.
#
# THE PREDICTION THIS TESTS. Satellite is the study's only positive result: at beta=8 the
# signal beat shuffle 65/15 and random 64/15, both p=0.0000. The explanation offered was
# that with K=274 uniform flattening spreads too thin, so WHERE the mass goes starts to
# matter. Here K is 26. If that explanation is right, the signal's advantage over its
# controls should SHRINK or vanish on this set -- and the positive result would then be a
# statement about wide branching under extrapolation, not about the domain.
#
# Run from a COMPUTE node:  bash submit_sat_indist.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/satIndist_120/domain.pddl; ST=example/satIndist_120
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=120
LN=lognormal:0.653:-1.070                    # refit on THESE instances

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
  results/sind_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

# --- additive row + its blind controls ---
sub sind_abs_t1b1k1       0 add 1.0 1.0 0.001
sub sind_abs_t1b1k0       0 add 1.0 0.0 0.001
sub sind_abs_t1b0k1       0 add 0.0 1.0 0.001
sub sind_abs_t1b2k1       0 add 2.0 1.0 0.001
sub sind_abs_t1b1k1_shuf  1 add 1.0 1.0 0.001
sub sind_abs_t1b1k1_rndm  0 add 1.0 1.0 0.001 "$LN"

# --- beta=8, satellite's best cell on the extrapolated set, WITH controls ---
sub sind_abs_b8k1_e001       0 add 8.0 1.0 0.001
sub sind_abs_b8k1_e001_shuf  1 add 8.0 1.0 0.001
sub sind_abs_b8k1_e001_rndm  0 add 8.0 1.0 0.001 "$LN"

# --- multiplicative ladder. 0.22 is this set's OWN matched mass (W=0.218 at beta=1) ---
sub sind_mul_e001_k0       0 mul 1.0 0.0 0.001
sub sind_mul_e001_k1       0 mul 1.0 1.0 0.001
sub sind_mul_e022_k0       0 mul 1.0 0.0 0.22
sub sind_mul_e022_k0_shuf  1 mul 1.0 0.0 0.22
sub sind_mul_e040_k0       0 mul 1.0 0.0 0.40
sub sind_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub sind_mul_e060_k0       0 mul 1.0 0.0 0.60

# --- signal-free flattening at the matched weights ---
flat sind_flat022 0.22
flat sind_flat040 0.40
flat sind_flat060 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
