#!/bin/bash
# PORTED to run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# The rovers arms needed for FULL parity with the other four domains' tables:
# the beta=2 additive row, and the multiplicative eps_p ladder.
#
# submit_rovers.sh covers baseline + b1k1 + b1k0 + b0k1 + shuffle + random. This adds the
# rest so rovers can be presented in the same columns as goldminer, grid, logistics and
# satellite rather than as a reduced table.
#
# eps_p RUNGS. 0.27 is rovers' OWN matched mass: fit_random_control.py on
# rov_signal_data.json gives W = beta*g_s/(1+beta*g_s) = 0.265 at beta=1, so eps_p=0.27
# makes P0 identical to what a flattening arm of that weight produces and leaves the tilt
# as the only difference. Across domains: grid 0.27, goldminer 0.28, logistics 0.29,
# satellite 0.23, rovers 0.27 -- remarkably stable, which is itself evidence that P_+
# behaves like a constant-mass injection. 0.40 and 0.60 carry over unchanged so the ladders
# line up.
#
# At eps_p=0.001 the multiplicative variant is close to inert (median TV ~0.0003 on
# goldminer) but NOT fully: the floor lifts an action from unselectable to selectable, which
# alone moved goldminer 337 -> 357. Both kappa rungs included since kappa is free.
#
# Uses the SAME frozen checkpoint as submit_rovers.sh (rovers_small_qrdqn_frozen.pth, the
# -0.804 model captured mid-run). Do not repoint at _best.pth: that is a later, worse
# checkpoint (-0.600), and _latest has collapsed entirely (-0.017).
#
# Baseline for all of these: results/rov_base (submitted by submit_rovers.sh).
# Run from a COMPUTE node:  bash submit_rovers_rest.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

RD=example/probeRov_distinct_d5-22/domain.pddl; RT=example/probeRov_distinct_d5-22
RP=models/rovers_small_sac_policy_best.pth
RQ1=models/rovers_small_sac_q1_best.pth; RQ2=models/rovers_small_sac_q2_best.pth
RI=models/rovers_small_qrdqn_frozen.pth
N=120

# sub <outdir> <shuffle> <mode> <beta> <kappa> <eps_p>
sub () {
  sbatch $CPU --array=1-$N run_search_signal.sh $RD $RT $RP $RQ1 $RQ2 $RI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" $3 1.0 $4 $5 $6
}

# ---- additive: the missing beta row ----
sub rov_abs_t1b2k1        0 add 2.0 1.0 0.001

# ---- multiplicative ladder ----
sub rov_mul_e001_k0       0 mul 1.0 0.0 0.001
sub rov_mul_e001_k1       0 mul 1.0 1.0 0.001
sub rov_mul_e029_k0       0 mul 1.0 0.0 0.29    # rovers' own matched mass (W=0.288)
sub rov_mul_e029_k0_shuf  1 mul 1.0 0.0 0.29
sub rov_mul_e040_k0       0 mul 1.0 0.0 0.40
sub rov_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub rov_mul_e060_k0       0 mul 1.0 0.0 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
