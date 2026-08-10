#!/bin/bash
# PORTED to slurm/run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# OPTION 9 (supervisor's absolute-scale reformulation) on goldminer.
#   x_a = e_a/(e_a+tau_step)   -- NO sibling division, so a state whose residuals are all
#                                 small gets a near-no-op instead of a full-strength boost
#   g_s = mean_a x_a           -- state-level channel: c(s) = c_puct*(1+kappa*g_s)
#   P_+ = (P0 + beta*x_a/K)/(1+beta*g_s)
#
# Why goldminer and why ADDITIVE only (offline evidence, new_signal_report.py, n=905):
#   - g_s separates mistake nodes from correct nodes with AUC 0.785 here (grid: 0.581)
#   - the arm ranking hits the plan action 61% vs 39% chance here (grid: 18% vs 24% = worse
#     than guessing), so grid is not worth a job
#   - MULTIPLICATIVE moves 0.0001 of prior mass (median TV) because SAC saturates: at
#     mistake nodes the plan action has P0 < 0.01 in 54% of states. It is baseline pUCT
#     with extra IQN cost. Not submitted.
#
# Baseline for comparison: results/gm_base (same instances, same qrdqn_value=1 setting).
# Run from a COMPUTE node:  bash submit_abs_goldminer.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

# args 8..36. Everything is off except OPTION 9 (args 33-36 = mode, tau, beta, kappa).
# arg 23 = shuffle control, arg 26 = qrdqn_value (1, matching the gm_base baseline).
sub () {   # sub <outdir> <shuffle> <tau> <beta> <kappa>
  sbatch $CPU --array=1-480 "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" add $3 $4 $5 0.001
}

# --- main arm: the doc's starting configuration -------------------------------
sub gm_abs_t1b1k1        0  1.0 1.0 1.0

# --- channel split: which half does the work? ---------------------------------
# g_s is the strong part offline (AUC 0.785), the arm ranking the weaker part.
sub gm_abs_t1b1k0        0  1.0 1.0 0.0    # prior tilt only, c_puct untouched
sub gm_abs_t1b0k1        0  1.0 0.0 1.0    # c(s) widening only, prior untouched

# --- beta sweep: offline, beta=2 lifts P(plan) at mistake nodes 0.17 -> 0.25 ---
sub gm_abs_t1b2k1        0  1.0 2.0 1.0

# --- control: same magnitudes, signal-blind placement among siblings -----------
# NOTE the old lognormal random control is NOT valid here -- it was calibrated to
# reproduce a mean-1 rel, and the mean-1 normalisation is exactly what is gone.
sub gm_abs_t1b1k1_shuf   1  1.0 1.0 1.0

squeue -u $USER -h -o "%T" | sort | uniq -c
