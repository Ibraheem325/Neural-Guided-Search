#!/bin/bash
# PORTED to run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# Satellite: baseline + the additive arms, on the NEW val probe set.
#
# WHY SATELLITE IS WORTH RUNNING AT ALL, given the signal is already a controlled negative
# on goldminer, grid and logistics: it is a third test of the PLAN-QUALITY MECHANISM.
#
# CORRECTION (2026-08-08, after the run): this header originally justified prediction 1 by
# claiming satellite's SAC "collapsed alpha to 0.005-0.009 with entropy 0.02-0.05 (logs
# 3170334 / 3171742)". Those logs are JULY BARMAN runs -- sacct -B shows train_sac.sbatch
# with the barman hindsight header, and they ended 2026-07-23, while the satellite models
# were written 2026-08-05/06. The rovers/satellite training logs are not in logs/ at all.
# Measured instead with prior_peak.py on satellite's own policy: top-1 70.8% (uniform 1.4%,
# median 99 applicable actions), median P_max 1.0000, confidently-wrong only 4.9% vs
# goldminer's 11.0% and grid's 20.8%. So satellite's prior is peaked AND accurate -- the
# opposite of the claimed pathology. The search result is unaffected; only this rationale
# was wrong. Predictions 1-3 below are kept verbatim as submitted.
#
#   PREDICTION 1  prior-touching arms (b1k1, b1k0) improve plan quality vs the baseline
#   PREDICTION 2  beta=0 kappa=1 (c(s), the only arm that does NOT touch the prior) moves
#                 neither plan quality nor expansions -- as on goldminer (1.238 -> 1.207)
#                 and grid (2.023 -> 2.024)
#   PREDICTION 3  the SIGN of the expansion effect follows the baseline's vs-opt ratio:
#                 near 1.2 like goldminer => expansions fall; near 2.0 like grid => they rise
#
# Satellite is the only domain whose QR-DQN passes the calibration gate besides goldminer
# and grid: slope -1.083 on probeSat_train_d5-40. Rovers is EXCLUDED -- its QR-DQN is flat
# (-0.007, i.e. V ~ -5 at every distance from d5 to d70), so its Bellman signal would be
# noise and no search result from it could mean anything.
#
# PROBE SET: example/probeSat_val_d5-20, 480 probes / 44 distinct sources, built from the
# VAL split (all 120 instances solved). Deliberately mirrors probeGold_near_goal_d5-20 and
# probe_near_goal_d5-20 (480 probes, d5-20) so the domains are compared on the same design.
# NOT the train-split probes -- the models trained on those instances.
#
# RANDOM CONTROL, fitted to satellite's OWN raw-e marginal (fit_random_control.py on
# sat_signal_data.json, 90 states / 8302 edges): mu=-0.970 sigma=0.666. Note how different
# this is from goldminer (-0.585/1.003) and logistics (-0.461/0.992) -- satellite's
# residuals are both smaller and tighter, so copying another domain's spec would have put
# g_s at the wrong level entirely. The fit is clean: mean g_s 0.2937 real vs 0.2935 drawn
# (level preserved) while sd drops 0.0671 -> 0.0155 (state-to-state structure destroyed),
# which is exactly the contrast the control is meant to isolate.
#
# Other satellite constants from the same fit, for later arms:
#   mean g_s = 0.2937  ->  c(s) matched control c_puct = 1.94 (kappa=1)
#   W at beta=1 = 0.227  ->  eps_p for a mass-matched flattening control
#
# Run from a COMPUTE node:  bash submit_satellite.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/probeSat_val_d5-20/domain.pddl; ST=example/probeSat_val_d5-20
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=480

LN=lognormal:0.666:-0.970      # fitted to satellite's OWN raw-e marginal

# sub <outdir> <shuffle> <mode> <beta> <kappa> [random_spec]
# args 8..37; 23=SHUFFLE, 25=C_PUCT 1.5, 26=QRDQN_VALUE 1, 32=SIB_RANDOM, 33-37=ABS_*.
sub () {
  sbatch $CPU --array=1-$N run_search_signal.sh $SD $ST $SP $SQ1 $SQ2 $SI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "${6:-}" $3 1.0 $4 $5 0.001
}

# BASELINE: abs_signal=off, so no prior transform and no explore_mult. qrdqn_value=1 keeps
# the leaf value on the same model the signal would use, matching gm_base / az_probe_qrval_base.
sbatch $CPU --array=1-$N run_search_signal.sh $SD $ST $SP $SQ1 $SQ2 $SI \
  results/sat_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

sub sat_abs_t1b1k1       0 add 1.0 1.0    # the doc's configuration
sub sat_abs_t1b1k0       0 add 1.0 0.0    # prior tilt only
sub sat_abs_t1b0k1       0 add 0.0 1.0    # c(s) only -- the mechanism control
sub sat_abs_t1b1k1_shuf  1 add 1.0 1.0        # signal-blind placement, spread preserved
sub sat_abs_t1b1k1_rndm  0 add 1.0 1.0 "$LN"  # values discarded, only the level preserved

squeue -u $USER -h -o "%T" | sort | uniq -c
