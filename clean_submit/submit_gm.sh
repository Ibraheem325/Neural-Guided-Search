#!/bin/bash
# GOLDMINER on the DISTINCT probe set -- baseline + the additive row, with both blind controls.
#
# REPLACES submit_abs_goldminer.sh, which ran on probeGold_near_goal_d5-20: 480 probes from
# 30 source problems, and 64 of those probes came from the VAL split -- the split used for
# checkpoint selection. The 337 -> 478 flattening result, which anchors the dose explanation
# for grid and rovers, rests on that set. This one is test-only and 118 independent units.
#
# PROBE SET: example/probeGold_distinct_d5-22 -- 118 probes from 118 DISTINCT test problems,
# 6-7 per depth over d5-22. Two of the 120 test instances had no FD plan and were dropped.
# goldminer_dataset is the cleanest in the study: 400/120/120, zero duplicates, splits
# disjoint. Extrapolation 3.2x (objects 49-100 vs a train median of 25).
#
# CONSTANTS from fit_random_control.py on gold_signal_distinct.json (698 states, 1829 edges):
#   RANDOM control  lognormal:0.999:-0.757   (level: mean g_s 0.3474 real vs 0.3506 drawn)
#   mean g_s 0.3474 -> c(s) matched control c_puct = 2.02 at kappa=1
#   W at beta=1 = 0.258 -> eps_p 0.26;  W at beta=2 = 0.410
# The old config used eps=0.28, fitted on the 480-probe set.
#
# ------------------------------------------------------------------------------------------
# READ THIS BEFORE INTERPRETING ANY CONTROL ON GOLDMINER.
#
# prior_peak.py on these probes reports a MEDIAN OF 2 APPLICABLE ACTIONS (uniform baseline
# 41.7%). Every other domain: grid 5, rovers 31, logistics 42, satellite 274. At K=2 the
# control ladder degenerates:
#
#   SHUFFLE  permuting x_a among 2 siblings is a coin flip between two arrangements, not a
#            destruction of placement information.
#   RANDOM   fails its own diagnostic here. fit_random_control wants the drawn g_s spread
#            BELOW the real one; it comes back 0.1222 real vs 0.1226 drawn -- no reduction.
#            g_s is the mean of two x_a values, so its state-to-state variation is sampling
#            noise, not structure, and there is no structure for the control to destroy.
#            Satellite by contrast goes 0.0969 -> 0.0087.
#
# So on goldminer the blind controls do NOT isolate what they isolate elsewhere, and a null
# against them is weak evidence either way. The FLAT arms (submit_gm_flat.sh) are the only
# clean control on this domain, because flattening does not depend on there being sibling
# structure to scramble. Weight the conclusions accordingly.
# ------------------------------------------------------------------------------------------
#
# PRIOR ON THESE PROBES: top-1 77.8% against a uniform 41.7%, median P_max 1.0000, P_max
# >= 0.9 on 92.4% of states, CONFIDENTLY WRONG 17.7%. The old set read 11.0%; dropping the
# val probes and the 16x clustering moved goldminer from "mildly miscalibrated" into grid's
# and rovers' band (19.6%, 18.7%), which is consistent with flattening having won here.
# Note the uniform baseline: 77.8% top-1 at ~2.4 actions is a far weaker prior than the same
# number would be on satellite, where uniform is 0.5%.
#
# Run from a COMPUTE node:  bash submit_gm.sh
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
LN=lognormal:0.999:-0.757                    # refit on THIS probe set

# sub <outdir> <shuffle> <mode> <beta> <kappa> [random_spec]
# Positional args 8..19 of the cleaned launcher: max_time 1800, signal bellman, const_w 0.0,
# c_puct 1.5, qrdqn_value 1, then shuffle, random_spec, abs_signal, tau, beta, kappa, eps_p.
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "${6:-}" $3 1.0 $4 $5 0.001
}

# BASELINE: abs_signal=off, qrdqn_value=1, matching every other domain's baseline.
sbatch $CPU --array=1-$N "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI \
  results/gm_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

sub gm_abs_t1b1k1       0 add 1.0 1.0        # the doc's configuration
sub gm_abs_t1b1k0       0 add 1.0 0.0        # prior tilt only -- the best variant here before
sub gm_abs_t1b0k1       0 add 0.0 1.0        # c(s) only
sub gm_abs_t1b1k1_shuf  1 add 1.0 1.0        # DEGENERATE at K=2, see the header
sub gm_abs_t1b1k1_rndm  0 add 1.0 1.0 "$LN"  # FAILS its own fit diagnostic, see the header

squeue -u $USER -h -o "%T" | sort | uniq -c
