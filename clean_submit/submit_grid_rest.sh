#!/bin/bash
# GRID: the beta=2 additive row and the whole multiplicative eps_p ladder, on the distinct
# probe set. Completes the arm list so grid's tables line up with rovers and satellite.
#
# eps_p RUNGS. 0.27 is grid's OWN matched mass: fit_random_control.py on
# grid_signal_distinct.json gives W = beta*g_s/(1+beta*g_s) = 0.265 at beta=1, so eps_p=0.27
# makes P0 identical to what a flattening arm of that weight would produce and leaves the
# tilt as the only difference. 0.40 doubles as the beta=2 matched rung (W=0.419). 0.60
# carries over so the ladders line up across domains.
#
# The parallel values are satellite 0.25, rovers 0.27, goldminer 0.28, logistics 0.29.
# Grid's mean g_s is 0.3604 -- second highest of the five, so it injects more mass than
# satellite does at the same beta.
#
# CAVEAT specific to grid: median branching is FIVE applicable actions, against rovers' 31
# and satellite's 274. A given eps_p spreads across five actions here, so the same nominal
# mass is a far coarser intervention than on satellite. Grid's ladder is comparable to
# grid's own arms; comparing rung-for-rung ACROSS domains is not meaningful.
#
# At eps_p=0.001 the multiplicative variant is close to inert but NOT fully: the floor lifts
# an action from unselectable to selectable, and that alone moved goldminer 337 -> 357. Both
# kappa rungs are included since kappa is free.
#
# Baseline for all of these: results/grid_base (submitted by submit_grid.sh).
# Run from a COMPUTE node:  bash submit_grid_rest.sh
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

# sub <outdir> <shuffle> <mode> <beta> <kappa> <eps_p>
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $GD $GT $GP $GQ1 $GQ2 $GI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" $3 1.0 $4 $5 $6
}

# ---- additive: the missing beta row ----
sub grid_abs_t1b2k1        0 add 2.0 1.0 0.001

# ---- multiplicative ladder ----
sub grid_mul_e001_k0       0 mul 1.0 0.0 0.001
sub grid_mul_e001_k1       0 mul 1.0 1.0 0.001
sub grid_mul_e027_k0       0 mul 1.0 0.0 0.27    # grid's own matched mass (W=0.265)
sub grid_mul_e027_k0_shuf  1 mul 1.0 0.0 0.27
sub grid_mul_e040_k0       0 mul 1.0 0.0 0.40    # also the beta=2 matched mass (W=0.419)
sub grid_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub grid_mul_e060_k0       0 mul 1.0 0.0 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
