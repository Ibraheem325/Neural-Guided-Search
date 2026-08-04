#!/bin/bash
# beta sweep for the OPTION 9 additive arms on goldminer, so the table matches the
# binc/shuffle tables' axis (beta = 1, 2, 4, 6, 8, 12). beta=1 and beta=2 already ran
# as gm_abs_t1b1k1 / gm_abs_t1b2k1; this adds the rest.
#
# What beta does here. P_+(a) = (P0(a) + beta*x_a/K)/(1 + beta*g_s) injects a total mass
# fraction w = beta*g_s/(1+beta*g_s), so with the measured g_s ~ 0.39 on goldminer:
#     beta   1     2     4     6     8     12
#     w      0.28  0.44  0.61  0.70  0.76  0.82
# i.e. by beta=12 the SAC prior is 82% replaced by the signal. That is a different
# regime from the binc sweep, where beta multiplied a mean-1 quantity and never
# displaced the prior outright -- worth keeping in mind when comparing the two tables.
#
# Run from a COMPUTE node:  bash submit_abs_beta.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

sub () {   # sub <outdir> <beta>
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" add 1.0 $2 1.0
}

sub gm_abs_t1b4k1    4.0
sub gm_abs_t1b6k1    6.0
sub gm_abs_t1b8k1    8.0
sub gm_abs_t1b12k1  12.0

squeue -u $USER -h -o "%T" | sort | uniq -c
