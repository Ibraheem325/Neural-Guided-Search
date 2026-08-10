#!/bin/bash
# PORTED to run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# The satellite arms needed for FULL parity with the grid and goldminer tables:
# the beta=2 additive row, and the whole multiplicative eps_p ladder.
#
# submit_satellite.sh deliberately ran only five arms (baseline + b1k1 + b1k0 + b0k1 +
# shuffle + random), because satellite's job was to replicate the plan-quality MECHANISM
# rather than reproduce a ladder already measured cleanly on grid. This script closes the
# gap if the tables are to be presented side by side.
#
# eps_p RUNGS. 0.25 is satellite's OWN matched mass, refit on probeSat_distinct_d5-22:
# W = beta*g_s/(1+beta*g_s) = 0.247 at beta=1, so eps_p=0.25 makes P0 identical to what a
# flattening arm of that weight would produce and leaves the tilt as the only difference.
# The parallel values are rovers 0.27, grid 0.27, goldminer 0.28, logistics 0.29 -- satellite's
# is lowest because its mean g_s is 0.3286 against ~0.38-0.40 for the others. 0.40 doubles as
# the beta=2 matched rung (W=0.397); 0.60 is carried over so the ladders line up.
#
# At eps_p=0.001 the multiplicative variant is close to inert (median TV ~0.0003 on
# goldminer) but NOT fully: the floor lifts an action from unselectable to selectable, and
# that alone moved goldminer 337 -> 357. Both kappa rungs are included since kappa is free.
#
# Baseline for all of these: results/sat_base (submitted by submit_satellite.sh).
# Run from a COMPUTE node:  bash submit_satellite_rest.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/probeSat_distinct_d5-22/domain.pddl; ST=example/probeSat_distinct_d5-22
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=120

# sub <outdir> <shuffle> <mode> <beta> <kappa> <eps_p>
sub () {
  sbatch $CPU --array=1-$N run_search_signal.sh $SD $ST $SP $SQ1 $SQ2 $SI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" $3 1.0 $4 $5 $6
}

# ---- additive: the missing beta row ----
sub sat_abs_t1b2k1        0 add 2.0 1.0 0.001

# ---- multiplicative ladder ----
sub sat_mul_e001_k0       0 mul 1.0 0.0 0.001
sub sat_mul_e001_k1       0 mul 1.0 1.0 0.001
sub sat_mul_e025_k0       0 mul 1.0 0.0 0.25    # satellite's own matched mass (W=0.247)
sub sat_mul_e025_k0_shuf  1 mul 1.0 0.0 0.25
sub sat_mul_e040_k0       0 mul 1.0 0.0 0.40    # also the beta=2 matched mass (W=0.397)
sub sat_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub sat_mul_e060_k0       0 mul 1.0 0.0 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
