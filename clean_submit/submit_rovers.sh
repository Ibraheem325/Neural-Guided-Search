#!/bin/bash
# PORTED to slurm/run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
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
# PROBE SET: example/probeRov_distinct_d5-22 -- 120 probes from 120 DISTINCT test problems,
# one probe each, 6-7 per depth over d5-22. The previous set took up to 16 probes from the
# same problem to fill a per-depth quota, so its 480 probes were only 37 independent units
# and every count needed aggregating through cluster_contrib.py first. Here each probe IS a
# unit: 120 against 37, from a quarter of the searches.

#
# CONSTANTS from fit_random_control.py on rov_signal_distinct.json (90 states, 2737 edges),
# measured on the probeRov_distinct_d5-22 probes this script runs on:
#   RANDOM control  lognormal:1.030:-0.578   (level: mean g_s 0.3779 real vs 0.3891 drawn;
#                                             structure: sd 0.0980 -> 0.0474)
#   mean g_s 0.3779 -> c(s) matched control c_puct = 2.07 at kappa=1
#   W at beta=1 = 0.274 -> eps_p 0.27 for a mass-matched flattening control
# These moved from the old probe set's fit (1.098:-0.483 / 0.4042 / 0.288), which is why the
# refit is not optional: the random control is only a control if it matches the states being
# evaluated, not just the model.

#
# PRIOR ON THESE PROBES (prior_peak.py, 497 on-plan states from 40 of the 120): top-1 42.7%
# against a uniform 4.7%, median P_max 0.9140, P(a*) < 1e-3 on 27.0% of states, CONFIDENTLY
# WRONG on 18.7%. Still grid's regime (20.8%), not satellite's (4.9%) -- which is what the
# prediction above rests on. The old set read 21.1%; dropping the 16-probes-per-problem
# clustering moved it 2.4pp, not enough to change which regime rovers sits in.
#
# Run from a COMPUTE node:  bash submit_rovers.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

RD=example/probeRov_distinct_d5-22/domain.pddl; RT=example/probeRov_distinct_d5-22
RP=models/rovers_small_sac_policy_best.pth
RQ1=models/rovers_small_sac_q1_best.pth; RQ2=models/rovers_small_sac_q2_best.pth
RI=models/rovers_small_qrdqn_frozen.pth      # FROZEN copy -- never point at _best.pth while
                                             # training runs: 480 tasks would load different
                                             # models as the file is rewritten mid-sweep.
N=120
LN=lognormal:1.030:-0.578                    # refitted on THIS probe set; the old set gave
                                             # 1.098:-0.483, and a control fitted elsewhere
                                             # is not a control

# sub <outdir> <shuffle> <mode> <beta> <kappa> [random_spec]
# Positional args 8..19 of the cleaned launcher: max_time 1800, signal bellman, const_w 0.0,
# c_puct 1.5, qrdqn_value 1, then shuffle, random_spec, abs_signal, tau, beta, kappa, eps_p.
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $RD $RT $RP $RQ1 $RQ2 $RI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "${6:-}" $3 1.0 $4 $5 0.001
}

# BASELINE: abs_signal=off. qrdqn_value=1 puts the leaf value on the same model the signal
# uses, matching gm_base / az_probe_qrval_base / sat_base.
sbatch $CPU --array=1-$N "$LAUNCH" $RD $RT $RP $RQ1 $RQ2 $RI \
  results/rov_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

sub rov_abs_t1b1k1       0 add 1.0 1.0        # the doc's configuration
sub rov_abs_t1b1k0       0 add 1.0 0.0        # prior tilt only
sub rov_abs_t1b0k1       0 add 0.0 1.0        # c(s) only -- null on all four domains so far
sub rov_abs_t1b1k1_shuf  1 add 1.0 1.0        # signal-blind placement, spread preserved
sub rov_abs_t1b1k1_rndm  0 add 1.0 1.0 "$LN"  # values discarded, only the level preserved

squeue -u $USER -h -o "%T" | sort | uniq -c
