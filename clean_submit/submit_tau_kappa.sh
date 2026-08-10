#!/bin/bash
# PORTED to run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# OPTION 9, point 6 of the review: does c(s) = c_puct*(1 + kappa*g_s) buy anything?
#
# WHY THIS IS NOT A NAIVE tau x kappa GRID.
# c(s) does two separable things, and only the second one is the hypothesis:
#   LEVEL   the mean exploration bump (1 + kappa*mean g_s), identical at every state
#   SPREAD  the state-to-state variation around that level
# Measured offline on goldminer's own residuals (new_signal_data.json, n=905), the
# c(s) p10..p90 spread is:
#            kappa=1   kappa=3   kappa=5
#   tau=0.25   1.25x     1.45x     1.54x
#   tau=0.5    1.29x     1.59x     1.74x
#   tau=1.0    1.30x     1.66x     1.88x
#   tau=2.0    1.25x     1.61x     1.87x
# tau does essentially NOTHING to the spread (1.25-1.30x at kappa=1 for every tau).
# What it moves is mean g_s (0.664 at tau=0.25 -> 0.387 at tau=1.0), i.e. the LEVEL --
# which at fixed kappa is just a global c_puct rescale. So a full tau x kappa grid spends
# most of its jobs re-measuring "we turned c_puct up". kappa is the only real knob:
# it buys 1.30x -> 1.88x. Hence 3 kappa values, 2 tau values, and a MATCHED LEVEL CONTROL
# for every arm.
#
# THE CONTROL. Each arm is paired with kappa=0 at c_puct = 1.5*(1 + kappa*mean g_s), so
# the pair has the same MEAN exploration pressure and differs only in whether that pressure
# is allocated per-state. Both sides run abs_signal=add with beta=0, so the prior transform
# is byte-identical ((P0 + 0)/(1 + 0) = P0, the eps_p=0.001 floor and nothing else) and
# explore_mult is the ONLY thing that differs. Arm beats its control => state-adaptive
# exploration is real. Arm == control => c(s) is a disguised c_puct knob, and point 6 is
# answered in the negative.
#
# NOTE the sibling-shuffle control is DEGENERATE here and is deliberately absent: g_s is a
# mean over siblings, so permuting the residuals among siblings leaves it exactly unchanged.
# For the c(s) channel the matched-c_puct arm IS the control.
#
# beta=0 throughout: this isolates c(s). The prior-tilt channel was already measured
# separately (gm_abs_t1b1k0) and the two together as gm_abs_t1b1k1.
# Baseline: results/gm_base (same 480 instances, same qrdqn_value=1).
# Run from a COMPUTE node:  bash submit_tau_kappa.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

# sub <outdir> <c_puct> <tau> <kappa>      (beta fixed at 0 = c(s) channel only)
# Positional args 8..36; arg 25 = C_PUCT, 33-36 = ABS_SIGNAL TAU_STEP ABS_BETA ABS_KAPPA.
# arg 26 = qrdqn_value = 1, matching gm_base. arg 37 (eps_p) defaults to 0.001.
sub () {
  sbatch $CPU --array=1-480 run_search_signal.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 1800 bellman 0.0 $2 1 0 "" add $3 0.0 $4 0.001
}

# ---- kappa sweep at tau=1.0 (mean g_s = 0.3872) ------------------------------
# k1 already ran as gm_abs_t1b0k1 at c_puct=1.5; it has no matched control, so its
# control ships here and the arm is NOT resubmitted.
sub gm_tk_t1k3      1.5  1.0 3.0
sub gm_tk_t1k5      1.5  1.0 5.0

# matched-level controls: kappa=0, c_puct = 1.5*(1 + kappa*0.3872)
sub gm_tk_t1k1_ctl  2.08 1.0 0.0
sub gm_tk_t1k3_ctl  3.24 1.0 0.0
sub gm_tk_t1k5_ctl  4.40 1.0 0.0

# ---- tau probe at kappa=3 (mean g_s = 0.6644 at tau=0.25) --------------------
# Tests the offline claim that tau is redundant once the level is controlled. If
# gm_tk_t025k3 - its control differs from gm_tk_t1k3 - its control, tau matters after all.
sub gm_tk_t025k3     1.5  0.25 3.0
sub gm_tk_t025k3_ctl 4.49 0.25 0.0

squeue -u $USER -h -o "%T" | sort | uniq -c
