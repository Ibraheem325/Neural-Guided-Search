#!/bin/bash
# GRID on the DISTINCT probe set -- baseline + the additive row, with both blind controls.
#
# REPLACES submit_abs_grid.sh, which ran on example/probe_near_goal_d5-20: 480 probes drawn
# from only 30 source problems, so every per-probe count was inflated ~16x and had to be
# aggregated back down before it meant anything. It also had no baseline, no random control
# and no c(s) arm, because it predates the control ladder.
#
# PROBE SET: example/probeGrid_distinct_d5-22 -- 113 probes from 113 DISTINCT test problems,
# one probe each, 6-7 per depth over d5-22. 113 independent units against 30. Seven of the
# split's instances had stored plans that did not replay to the goal (all H1/H2) and were
# re-solved with FD before the set was built.
#
# CONSTANTS from fit_random_control.py on grid_signal_distinct.json (671 states, 2913 edges),
# measured on the probes this script runs on:
#   RANDOM control  lognormal:1.093:-0.710   (level: mean g_s 0.3604 real vs 0.3637 drawn;
#                                             structure: sd 0.1398 -> 0.1007)
#   mean g_s 0.3604 -> c(s) matched control c_puct = 2.04 at kappa=1
#   W at beta=1 = 0.265 -> eps_p 0.27;  W at beta=2 = 0.419 -> eps_p 0.40
# A first fit on only 397 edges gave 1.080:-0.497 and W=0.286, which would have moved the
# rung to 0.29 for no reason. Grid's median branching is 5, so states buy few edges here --
# fit on the whole probe set, not a 30-instance sample.
#
# WHAT TO EXPECT, recorded before the run. prior_peak.py on these probes: top-1 67.4%
# against a uniform 23.8%, median P_max 1.0000, P_max >= 0.9 on 78.6% of states,
# CONFIDENTLY WRONG on 19.6% (old set 20.8%). That is the miscalibrated regime -- goldminer
# 11.0%, rovers 18.7%, satellite 4.4%. Under the scope condition established on satellite,
# blind perturbation should MATCH OR BEAT the real arms here, and the flat arms in
# submit_grid_flat.sh should do at least as well as anything with a signal in it.
#
# Grid is also the widest extrapolation in the study: probe objects 22-179 (median 65)
# against a train median of 10 = 6.5x, versus satellite 4.5x and rovers 3.3x. A failure here
# may be about extrapolation rather than about the signal; the 22-179 span is wide enough to
# test that directly by splitting the 113 problems at the median.
#
# Run from a COMPUTE node:  bash submit_grid.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

GD=example/probeGrid_distinct_d5-22/domain.pddl; GT=example/probeGrid_distinct_d5-22
GP=models/grid_sac_policy.pth; GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth
N=113
LN=lognormal:1.093:-0.710                    # refit on THIS probe set

# sub <outdir> <shuffle> <mode> <beta> <kappa> [random_spec]
# Positional args 8..19 of the cleaned launcher: max_time 1800, signal bellman, const_w 0.0,
# c_puct 1.5, qrdqn_value 1, then shuffle, random_spec, abs_signal, tau, beta, kappa, eps_p.
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $GD $GT $GP $GQ1 $GQ2 $GI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "${6:-}" $3 1.0 $4 $5 0.001
}

# BASELINE: abs_signal=off. qrdqn_value=1 puts the leaf value on the same model the signal
# uses, matching rov_base / sat_base / gm_base.
sbatch $CPU --array=1-$N "$LAUNCH" $GD $GT $GP $GQ1 $GQ2 $GI \
  results/grid_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

sub grid_abs_t1b1k1       0 add 1.0 1.0        # the doc's configuration
sub grid_abs_t1b1k0       0 add 1.0 0.0        # prior tilt only
sub grid_abs_t1b0k1       0 add 0.0 1.0        # c(s) only -- harmful on rovers and satellite
sub grid_abs_t1b1k1_shuf  1 add 1.0 1.0        # signal-blind placement, spread preserved
sub grid_abs_t1b1k1_rndm  0 add 1.0 1.0 "$LN"  # values discarded, only the level preserved

squeue -u $USER -h -o "%T" | sort | uniq -c
