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
# Shuffle matching the real signal (96.5% vs 95.8%) therefore does NOT show the signal
# is inert -- shuffling x_a among siblings preserves g_s and so preserves the whole
# injection. It only rules out per-ARM placement. What is left untested is the
# per-STATE magnitude, which is exactly what OPTION 9 newly exposes as g_s, and which
# earlier runs hinted at: random scored below shuffle on the old binc arms.
#
# These two arms complete a 4-rung ladder, each rung destroying one more thing:
#   real    real e_a, real placement            g_s real, per-arm tilt real
#   shuffle real e_a, permuted among siblings   g_s real, per-arm tilt destroyed
#   random  e_a redrawn from the fitted         g_s ~constant + sampling noise
#           marginal (submit_abs_random.sh)
#   flat    no e_a at all, fixed w              g_s exactly constant
#
# real > shuffle  => per-arm placement carries information
# shuffle > random => the per-STATE magnitude carries information (supervisor's hypothesis)
# random > flat   => only the sampling noise in g_s matters, i.e. nothing
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
