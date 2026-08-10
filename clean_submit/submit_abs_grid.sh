#!/bin/bash
# PORTED to run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# OPTION 9 additive + matched flattening controls on GRID.
#
# READ THIS BEFORE INTERPRETING: the grid baseline (results/az_probe_qrval_base) already
# solves 479/480 = 99.8%. There is NO coverage headroom, so the goldminer result
# (337 -> 478) cannot replicate here. On grid the ONLY meaningful axis is expansion
# efficiency (mean ratio, improved/regressed), and any coverage LOSS is a pure negative.
#
# Two reasons to expect this to go badly, stated up front so a null result is not a surprise:
#   - grid's arm ranking is BELOW chance: the signal's top action is the plan action 18%
#     of the time at mistake nodes, against 24% for random guessing (n=914 states).
#   - with nothing left to rescue, extra exploration is pure cost.
#
# Matched control values, from the grid raw residuals (new_signal_data.json, n=914):
#   g_s median 0.373  ->  beta=1 injects w = 0.27,  beta=2 injects w = 0.43
# so gm-style pairing is: t1b1k1 <-> flat027, t1b2k1 <-> flat043.
#
# Run from a COMPUTE node:  bash submit_abs_grid.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

GD=example/probe_near_goal_d5-20/domain.pddl; GT=example/probe_near_goal_d5-20
GP=models/grid_sac_policy.pth; GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth

# arg 26 = qrdqn_value = 1, matching the az_probe_qrval_base baseline.
abs () {   # abs <outdir> <shuffle> <beta> <kappa>
  sbatch $CPU --array=1-480 run_search_signal.sh $GD $GT $GP $GQ1 $GQ2 $GI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" add 1.0 $3 $4 0.001
}
flat () {  # flat <outdir> <w>
  sbatch $CPU --array=1-480 run_search_signal.sh $GD $GT $GP $GQ1 $GQ2 $GI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

# --- the supervisor's equation ---
abs grid_abs_t1b1k1       0  1.0 1.0     # his starting configuration
abs grid_abs_t1b1k0       0  1.0 0.0     # prior channel only (best variant on goldminer)
abs grid_abs_t1b2k1       0  2.0 1.0
abs grid_abs_t1b1k1_shuf  1  1.0 1.0     # signal-blind placement

# --- mass-matched signal-free controls ---
flat grid_flat027  0.27                  # matches beta=1
flat grid_flat043  0.43                  # matches beta=2
# --- and enough of a curve to see the shape ---
flat grid_flat010  0.10
flat grid_flat060  0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
