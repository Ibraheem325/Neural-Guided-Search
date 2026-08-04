#!/bin/bash
# RANDOM control for the OPTION 9 additive arms on goldminer -- the rung between
# shuffle and flat. See submit_abs_control.sh for the full ladder.
#
# The old lognormal:0.88 control is NOT reusable here. It draws with mu=0 (median value
# 1.0), which was correct when the caller divided by the sibling mean, but OPTION 9
# consumes the values as RAW residuals: mu=0 would put the median e at 1.0 instead of the
# real ~0.56 and inflate g_s. So sigma AND mu are fitted to the real marginal of e
# (new_signal_data.json, n=905 goldminer states): mu=-0.585 sigma=1.003.
#
# This reproduces mean g_s to within 0.001 (0.386 drawn vs 0.387 real) while destroying
# the state-to-state structure (sd 0.124 drawn vs 0.134 real). If the real arm beats
# this one, the per-state magnitude of the Bellman residual is carrying information.
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth
LN=lognormal:1.003:-0.585      # fitted to the REAL raw-e marginal on goldminer

sub () {   # sub <outdir> <beta> <kappa>
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "$LN" add 1.0 $2 $3
}

sub gm_abs_t1b1k1_rndm  1.0 1.0    # matches the default arm
sub gm_abs_t1b1k0_rndm  1.0 0.0    # matches the prior-only arm (the one that won)

squeue -u $USER -h -o "%T" | sort | uniq -c
