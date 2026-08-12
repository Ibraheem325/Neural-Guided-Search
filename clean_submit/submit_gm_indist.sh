#!/bin/bash
# GOLDMINER, IN-DISTRIBUTION test set. The condition the study was missing.
#
# WHY. Goldminer is the anchor of the DOSE result: on the extrapolated test set the
# baseline solves 88/118 while every perturbation arm reaches ~118, and grid's and rovers'
# "it is just dose" conclusions lean on that 74.6% -> 100% jump. But that test set is 49-100
# objects against a training range of 4-42, so the baseline may be failing because the
# instances are 2-4x training size rather than because its prior is wrong.
#
# example/gmIndist_120: 120 generated instances whose grid size, rock density and clear-cell
# count are resampled from the training split (cells 4-42 median 25, identical to train at
# every quartile), verified disjoint from all 520 train+val instances by canonical hash.
#
# NOT PROBES. Whole instances from their INITIAL state, no distance-to-goal control.
# FD-verified optimal length: median 13 (p25 8, p75 19, max 34) -- HARDER than the
# extrapolated probe set's 11.78, so this is not an easy-instance artefact.
#
# CONSTANTS refit on these instances (671 states, 2252 edges):
#   RANDOM control  lognormal:0.934:-0.718   (extrapolated: 0.999:-0.757)
#   mean g_s 0.3527 -> c(s) matched c_puct 2.03
#   W at beta=1 = 0.261 -> eps_p 0.26        (extrapolated: 0.258, same rung)
#
# THE RANDOM CONTROL IS DEGENERATE HERE, in both conditions. fit_random_control wants the
# drawn g_s spread BELOW the real one; it comes back 0.1091 real vs 0.1066 drawn -- no
# reduction, because median branching is THREE and g_s is the mean of three draws, so its
# variation is sampling noise with no structure to destroy. The FLAT arms are the only clean
# control on goldminer. Read the random row as weak evidence either way.
#
# THE PRIOR IS MUCH WORSE IN-DISTRIBUTION, which was not expected:
#
#                        extrapolated      in-distribution
#   top-1 accuracy          77.8%             63.9%
#   uniform baseline        41.7%             35.4%
#   P_max >= 0.9 on         92.4%             89.8%
#   CONFIDENTLY WRONG       17.7%             30.5%
#
# Satellite showed the same direction (4.4% -> 16.3%). CAVEAT, and it is a confound in both:
# the probe sets are states cut d steps from the GOAL, where the right action is often
# forced, while these run from the INITIAL state where the policy faces the hard early
# commitments. So "in-distribution" and "from the start" are entangled, and part of the rise
# is about position in the plan rather than about extrapolation.
#
# WHAT THIS DECIDES. If the baseline now solves ~120/120, the 88 -> 118 coverage effect --
# the strongest single piece of evidence for the dose explanation -- was measured under
# extrapolation and needs that scope condition stated, exactly like satellite's positive.
#
# Run from a COMPUTE node:  bash submit_gm_indist.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/gmIndist_120/domain.pddl; ST=example/gmIndist_120
SP=models/goldminer_sac_policy.pth
SQ1=models/goldminer_sac_q1.pth; SQ2=models/goldminer_sac_q2.pth
SI=models/goldminer_iqn.pth
N=120
LN=lognormal:0.934:-0.718                    # refit on THESE instances

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
  results/gind_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

# --- additive row + its blind controls ---
sub gind_abs_t1b1k1       0 add 1.0 1.0 0.001
sub gind_abs_t1b1k0       0 add 1.0 0.0 0.001
sub gind_abs_t1b0k1       0 add 0.0 1.0 0.001
sub gind_abs_t1b2k1       0 add 2.0 1.0 0.001
sub gind_abs_t1b1k1_shuf  1 add 1.0 1.0 0.001
sub gind_abs_t1b1k1_rndm  0 add 1.0 1.0 0.001 "$LN"

# --- beta=8, satellite's best cell on the extrapolated set, WITH controls ---
sub gind_abs_b8k1_e001       0 add 8.0 1.0 0.001
sub gind_abs_b8k1_e001_shuf  1 add 8.0 1.0 0.001
sub gind_abs_b8k1_e001_rndm  0 add 8.0 1.0 0.001 "$LN"

# --- multiplicative ladder. 0.26 is this set's OWN matched mass (W=0.218 at beta=1) ---
sub gind_mul_e001_k0       0 mul 1.0 0.0 0.001
sub gind_mul_e001_k1       0 mul 1.0 1.0 0.001
sub gind_mul_e026_k0       0 mul 1.0 0.0 0.26
sub gind_mul_e026_k0_shuf  1 mul 1.0 0.0 0.26
sub gind_mul_e040_k0       0 mul 1.0 0.0 0.40
sub gind_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub gind_mul_e060_k0       0 mul 1.0 0.0 0.60

# --- signal-free flattening at the matched weights ---
flat gind_flat026 0.26
flat gind_flat040 0.40
flat gind_flat060 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
