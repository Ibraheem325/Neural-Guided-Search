#!/bin/bash
# DECISIVE control for the OPTION 9 additive result on goldminer.
#
# The additive prior is P_+(a) = (P0(a) + beta*x_a/K) / (1 + beta*g_s). Rewrite it:
# it injects a total mass fraction w = beta*g_s/(1+beta*g_s) spread over the arms in
# proportion to x_a. When the x_a are similar within a state -- and they are: median
# within-state spread max(x)-min(x) is 0.24 on goldminer -- that injection is
# indistinguishable from flattening the prior toward UNIFORM by w.
#
# Measured offline (n=905 goldminer states, new_signal_data.json):
#   median w                                     = 0.277
#   median TV(P_additive, pure-flattening-at-w)  = 0.039
#   median TV(P0,          pure-flattening-at-w) = 0.139
#   => only ~28% of what P_+ does to the prior is signal-carried. ~72% is flattening.
#
# So this arm asks the question the shuffle control CANNOT answer. Shuffling x_a among
# siblings preserves g_s and therefore preserves the whole injection -- which is exactly
# why shuffle matched the real signal (96.5% vs 95.8% coverage). Constant widening uses
# NO IQN and NO signal at all: it just flattens every expanded node's prior by a fixed w.
#
# If this reaches ~96% coverage, the entire OPTION 9 result is "flatten a
# confidently-wrong SAC prior" (= OPTION 1), and the Bellman signal is contributing
# nothing beyond setting the flattening strength.
#
# w=0.28 matches the beta=1 arms; w=0.42 matches the beta=2 arm (2g/(1+2g)).
# Run from a COMPUTE node:  bash submit_abs_control.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

sub () {   # sub <outdir> <const_w>
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 0.0 4 constant 1800 $2 $2 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" off 1.0 1.0 1.0
}

sub gm_flat028  0.28    # matches the beta=1 arms' injected mass
sub gm_flat042  0.42    # matches the beta=2 arm

squeue -u $USER -h -o "%T" | sort | uniq -c
