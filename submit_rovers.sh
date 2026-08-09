#!/bin/bash
# Rovers: baseline + the additive arms. Fifth domain, and the most interesting prior.
#
# WHY ROVERS IS BACK. It was excluded because rovers_dataset_r18's QR-DQN calibrated at
# slope -0.007 (flat at every distance from d5 to d70) -- its Bellman signal would be noise.
# That turned out to be a TRAINING BUDGET problem, not a domain property: r18 got 2,144
# steps, and on this domain the value function does not begin learning distance until
# somewhere between 3,600 and 5,400 steps. Retrained on smaller, topology-matched instances
# with a proper budget, the slope climbed
#     1,536 -> -0.041 | 3,584 -> -0.045 | 5,408 -> -0.487 | 6,176 -> -0.554 | 8,096 -> -0.804
# and corrected for probe-depth looseness (37% of rovers d labels overstate the true
# optimum) the real figure is nearer -0.96, i.e. satellite territory.
#
# WHAT MAKES ROVERS WORTH A FIFTH SLOT: its SAC prior is the most CONFIDENTLY WRONG in the
# study -- prior_peak.py gives top-1 40.6% (uniform 5.5%), median P_max 0.9009, and
# confidently-wrong on 24.3% of on-plan states, against goldminer 11.0%, grid 20.8%,
# satellite 4.9%. On the satellite finding, blind perturbation wins where the prior is
# confidently wrong and the SIGNAL wins where it is confidently right. Rovers is the extreme
# of the first case, so the prediction is: shuffle/random should match or beat the real arms
# here, and prior perturbation should move plan quality a lot.
#
# DATASET: example/rovers_dataset_small, rovers 1-6 MATCHED across train/val/test (10-26 /
# 27-48 / 50-95 objects). Narrower than r18's 1-8 by necessity -- rovers needs n >= 2r+8 and
# camera inflation pushed 7-8 rover instances out of a small object budget -- but matched on
# both sides, which is what the logistics failure showed actually matters.
#
# PROBE SET: example/probeRov_small_d5-20, 480 probes / 41 distinct sources, from the VAL
# split (all 120 instances solved). Mirrors the other four domains' design exactly.
#
# CONSTANTS from fit_random_control.py on rov_signal_data.json (90 states, 1968 edges):
#   RANDOM control  lognormal:0.846:-0.675   (level: mean g_s 0.3611 real vs 0.3594 drawn;
#                                             structure: sd 0.0741 -> 0.0356)
#   mean g_s 0.3611 -> c(s) matched control c_puct = 2.04 at kappa=1
#   W at beta=1 = 0.265 -> eps_p for a mass-matched flattening control
# These are DOMAIN FITS. goldminer is -0.585/1.003, logistics -0.461/0.992, satellite
# -0.970/0.666. Copying one to another puts g_s at the wrong level entirely.
#
# !! REFIT BEFORE RUNNING IF THE MODEL CHANGED. The constants above were measured on
# models/rovers_small_qrdqn_frozen.pth captured at 8,096 steps. If training continued and
# you re-freeze a better checkpoint, rerun new_signal_probe.py + fit_random_control.py and
# update LN below, or the random control will be matched to the wrong model.
#
# Run from a COMPUTE node:  bash submit_rovers.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

RD=example/probeRov_small_d5-20/domain.pddl; RT=example/probeRov_small_d5-20
RP=models/rovers_small_sac_policy_best.pth
RQ1=models/rovers_small_sac_q1_best.pth; RQ2=models/rovers_small_sac_q2_best.pth
RI=models/rovers_small_qrdqn_frozen.pth      # FROZEN copy -- never point at _best.pth while
                                             # training runs: 480 tasks would load different
                                             # models as the file is rewritten mid-sweep.
N=480
LN=lognormal:0.846:-0.675                    # fitted to rovers' OWN raw-e marginal

# sub <outdir> <shuffle> <mode> <beta> <kappa> [random_spec]
# args 8..37; 23=SHUFFLE, 25=C_PUCT 1.5, 26=QRDQN_VALUE 1, 32=SIB_RANDOM, 33-37=ABS_*.
sub () {
  sbatch $CPU --array=1-$N run_alphazero_bellman.sh $RD $RT $RP $RQ1 $RQ2 $RI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    $2 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "${6:-}" $3 1.0 $4 $5 0.001
}

# BASELINE: abs_signal=off. qrdqn_value=1 puts the leaf value on the same model the signal
# uses, matching gm_base / az_probe_qrval_base / sat_base.
sbatch $CPU --array=1-$N run_alphazero_bellman.sh $RD $RT $RP $RQ1 $RQ2 $RI \
  results/rov_base 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
  0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" off 1.0 1.0 1.0 0.001

sub rov_abs_t1b1k1       0 add 1.0 1.0        # the doc's configuration
sub rov_abs_t1b1k0       0 add 1.0 0.0        # prior tilt only
sub rov_abs_t1b0k1       0 add 0.0 1.0        # c(s) only -- null on all four domains so far
sub rov_abs_t1b1k1_shuf  1 add 1.0 1.0        # signal-blind placement, spread preserved
sub rov_abs_t1b1k1_rndm  0 add 1.0 1.0 "$LN"  # values discarded, only the level preserved

squeue -u $USER -h -o "%T" | sort | uniq -c
