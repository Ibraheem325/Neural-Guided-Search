#!/bin/bash
# SATELLITE, IN-DISTRIBUTION test set. The condition the study was missing.
#
# WHY. Every satellite result so far is a SIZE-EXTRAPOLATION result -- train 8-22 objects,
# test 46-95. This is the in-distribution condition, built with the REAL satgen from
# AI-Planning/pddl-generators rather than reconstructed.
#
# THIS REPLACES submit_sat_indist.sh, which ran on example/satIndist_120 -- instances from a
# generator I wrote by resampling shape tuples off the training split. That set matched
# training on object counts but not on everything:
#
#                        train    satgen    my reconstruction
#   instruments, median    4         -            5
#   directions,  median    6         -            5
#   CONFIDENTLY WRONG      -       9.8%         16.3%
#
# The constants came out close (W 0.223 vs 0.218) but prior_peak did not, and conf-wrong is
# the statistic the whole confidently-right/confidently-wrong argument rests on. Treat the
# sind_* results as superseded.
#
# THE SET: example/satIndistReal/test_ind, 120 instances from satgen at the TRAINING object
# range (8-22, median 17, matching train at every quartile), every candidate rejected if its
# canonical objects+init+goal matches one of the 520 train+val instances. Verified
# independently by check_probe_set.py. FD solved 120/120; optimal length median 8 (p25 6,
# p75 13, max 25).
#
# NOT PROBES. Whole instances from their INITIAL state, no distance-to-goal control.
#
# CONSTANTS refit on these instances (696 states, 15623 edges):
#   RANDOM control  lognormal:0.661:-1.019
#   mean g_s 0.2866 -> c(s) matched c_puct 1.93
#   W at beta=1 = 0.223 -> eps_p 0.22;  W at beta=2 = 0.364
#
# WHAT THIS DECIDES. Satellite's positive result -- at beta=8 the signal beat shuffle 65/15
# and random 64/15, both p=0.0000 -- was explained by K=274 making uniform flattening spread
# too thin, so placement matters. Here K is 26. If that explanation holds the advantage
# should shrink, and the claim becomes "the signal helps under wide branching and size
# extrapolation" rather than "the signal helps on satellite".
#
# Run from a COMPUTE node:  bash submit_sat_indreal.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/satIndistReal/test_ind/domain.pddl; ST=example/satIndistReal/test_ind
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=120
LN=lognormal:0.661:-1.019                    # refit on the REAL satgen set

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
  results/sreal_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

# --- additive row + its blind controls ---
sub sreal_abs_t1b1k1       0 add 1.0 1.0 0.001
sub sreal_abs_t1b1k0       0 add 1.0 0.0 0.001
sub sreal_abs_t1b0k1       0 add 0.0 1.0 0.001
sub sreal_abs_t1b2k1       0 add 2.0 1.0 0.001
sub sreal_abs_t1b1k1_shuf  1 add 1.0 1.0 0.001
sub sreal_abs_t1b1k1_rndm  0 add 1.0 1.0 0.001 "$LN"

# --- beta=8, satellite's best cell on the extrapolated set, WITH controls ---
sub sreal_abs_b8k1_e001       0 add 8.0 1.0 0.001
sub sreal_abs_b8k1_e001_shuf  1 add 8.0 1.0 0.001
sub sreal_abs_b8k1_e001_rndm  0 add 8.0 1.0 0.001 "$LN"

# --- multiplicative ladder. 0.22 is this set's OWN matched mass (W=0.218 at beta=1) ---
sub sreal_mul_e001_k0       0 mul 1.0 0.0 0.001
sub sreal_mul_e001_k1       0 mul 1.0 1.0 0.001
sub sreal_mul_e022_k0       0 mul 1.0 0.0 0.22
sub sreal_mul_e022_k0_shuf  1 mul 1.0 0.0 0.22
sub sreal_mul_e040_k0       0 mul 1.0 0.0 0.40
sub sreal_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub sreal_mul_e060_k0       0 mul 1.0 0.0 0.60

# --- signal-free flattening at the matched weights ---
flat sreal_flat022 0.22
flat sreal_flat040 0.40
flat sreal_flat060 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
