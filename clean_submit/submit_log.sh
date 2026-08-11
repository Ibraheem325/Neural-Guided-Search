#!/bin/bash
# LOGISTICS on the DISTINCT probe set -- baseline + the additive row, with both blind controls.
#
# REPLACES submit_abs_logistics.sh, which ran on example/probeLog_multiloc_d5-20: 288 probes
# drawn from only 18 source problems -- the worst ratio in the study, 16 probes per problem.
#
# PROBE SET: example/probeLog_distinct_d5-22 -- 113 probes from 113 DISTINCT problems, 6-7
# per depth over d5-22.
#
# CROSS-DATASET SETUP, unique to logistics and worth stating in the writeup. The probes come
# from example/logistics_dataset/test (v1) while the models are logistics_topo_*, trained on
# example/logistics_dataset_topo, which HAS NO TEST SPLIT. So the ordinary leakage check
# looks at the wrong dataset here; check_probe_set.py --trained-on measures it directly and
# finds 0 of 113 probes in any of topo's 520 train/val instances.
#
# v1 is the sloppiest dataset in the study -- 13 duplicate train instances, 6 duplicate val,
# 7 duplicate test (removed before building this set), and its splits are NOT disjoint
# (train/val share 16, val/test share 8). None of it can have leaked, because v1 did not
# train these models, but it should be disclosed rather than discovered.
#
# CONSTANTS from fit_random_control.py on log_signal_distinct.json (671 states, 27344 edges):
#   RANDOM control  lognormal:0.839:-0.307   (level: mean g_s 0.4308 real vs 0.4349 drawn;
#                                             structure: sd 0.0674 -> 0.0291)
#   mean g_s 0.4308 -> c(s) matched control c_puct = 2.15 at kappa=1  (highest of the five)
#   W at beta=1 = 0.301 -> eps_p 0.30;  W at beta=2 = 0.463
# The old config used eps=0.29, fitted on the 288-probe set.
#
# THE PRIOR HERE IS DIFFUSE, NOT MISCALIBRATED -- a THIRD regime, and the reason logistics
# has never fitted the table. prior_peak.py on these probes: median P_max 0.5000 (satellite
# and grid are both 1.0000, rovers 0.9140), P_max >= 0.9 on only 42.1% of states (grid
# 78.6%), top-1 51.4% against a uniform 2.8%, CONFIDENTLY WRONG 12.6%.
#
# That 12.6% is low for the OPPOSITE reason to satellite's 4.4%: satellite's prior is peaked
# and right, logistics' is hardly ever peaked. Reporting confidently-wrong alone would put
# them side by side, which is wrong -- quote median P_max next to it.
#
# WHAT TO EXPECT. Flattening a prior that is already near-uniform should do very little,
# since P0 = (1-eps)P + eps/K barely moves when P is already close to 1/K. If the flat arms
# come out inert here while they dominated on goldminer and rovers, that is evidence the
# flattening effect is about UNDOING a bad peak, not about exploration in general.
#
# Logistics also has by far the largest plan-quality headroom in the study -- its baseline
# planned 51x optimal on the old set -- so read expansions against plan length here, never
# alone.
#
# Run from a COMPUTE node:  bash submit_log.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

LD=example/probeLog_distinct_d5-22/domain.pddl; LT=example/probeLog_distinct_d5-22
LP=models/logistics_topo_sac_policy_best.pth
LQ1=models/logistics_topo_sac_q1_best.pth; LQ2=models/logistics_topo_sac_q2_best.pth
LI=models/logistics_topo_frozen.pth
N=113
LN=lognormal:0.839:-0.307                    # refit on THIS probe set

# sub <outdir> <shuffle> <mode> <beta> <kappa> [random_spec]
# Positional args 8..19 of the cleaned launcher: max_time 1800, signal bellman, const_w 0.0,
# c_puct 1.5, qrdqn_value 1, then shuffle, random_spec, abs_signal, tau, beta, kappa, eps_p.
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "${6:-}" $3 1.0 $4 $5 0.001
}

# BASELINE: abs_signal=off, qrdqn_value=1, matching rov_base / sat_base / gm_base / grid_base.
sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
  results/log_base 1800 bellman 0.0 1.5 1 0 "" off 1.0 1.0 1.0 0.001

sub log_abs_t1b1k1       0 add 1.0 1.0        # the doc's configuration
sub log_abs_t1b1k0       0 add 1.0 0.0        # prior tilt only
sub log_abs_t1b0k1       0 add 0.0 1.0        # c(s) only
sub log_abs_t1b1k1_shuf  1 add 1.0 1.0        # signal-blind placement, spread preserved
sub log_abs_t1b1k1_rndm  0 add 1.0 1.0 "$LN"  # values discarded, only the level preserved

squeue -u $USER -h -o "%T" | sort | uniq -c
