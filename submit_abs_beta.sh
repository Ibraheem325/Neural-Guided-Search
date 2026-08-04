#!/bin/bash
# beta sweep for the OPTION 9 additive arms on goldminer, on an axis MATCHED to the
# old binc formulation's beta rather than sharing its numbers.
#
# Why the numbers cannot simply be reused. The two betas act on different objects:
#   old binc   u ~ c * mult(a) * P(a) * sqrt(N)/(1+n),  mult = max(0.1, 1+beta*(rel-1))
#              -> the selection weight is proportional to mult(a)*P(a), so it stays
#                 GATED by the prior. Multiplying a P~0 arm by 13 leaves it P~0.
#   OPTION 9   P_+(a) = (P0(a) + beta*x_a/K)/(1+beta*g_s)
#              -> injects mass independent of P(a), so it is NOT gated.
#
# Matched on the median perturbation of the selection weights, TV(baseline, arm), over
# the 905 goldminer states in new_signal_data.json:
#
#   beta_old   TV      ->  beta_new   TV      max P reachable on a P<0.01 arm: old / new
#     1.0    0.0012          0.005  0.0011                          0.0008 / 0.0012
#     2.0    0.0078          0.035  0.0073                          0.0012 / 0.0059
#     4.0    0.0135          0.065  0.0134                          0.0016 / 0.0105
#     6.0    0.0176          0.085  0.0175                          0.0021 / 0.0135
#     8.0    0.0220          0.110  0.0224                          0.0029 / 0.0172
#    12.0    0.0303          0.150  0.0299                          0.0042 / 0.0230
#
# So the ENTIRE old sweep beta_old 1..12 fits inside beta_new 0.005..0.15. The already-run
# beta_new=1 arm is TV 0.149, five times stronger than the strongest old arm; beta_new=12
# is TV 0.454, fifteen times stronger. The old formulation could not reach that range at
# any beta, because P(a) gates it.
#
# kappa=0 on every arm here: the old formulation had no exploration-constant channel, so
# leaving c(s) out is what makes this a like-for-like comparison of the prior channel.
#
# Run from a COMPUTE node:  bash submit_abs_beta.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

sub () {   # sub <outdir> <beta_new> <kappa>
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" add 1.0 $2 $3
}

# --- matched to the old sweep (dir name records the OLD beta it corresponds to) ---
sub gm_abs_eqb1   0.005 0.0
sub gm_abs_eqb2   0.035 0.0
sub gm_abs_eqb4   0.065 0.0
sub gm_abs_eqb6   0.085 0.0
sub gm_abs_eqb8   0.110 0.0
sub gm_abs_eqb12  0.150 0.0

# --- the regime the old formulation cannot reach at any beta (beta_new = 4, 6, 8, 12;
#     1 and 2 already ran as gm_abs_t1b1k1 / gm_abs_t1b2k1 at kappa=1) ---
sub gm_abs_t1b4k1   4.0 1.0
sub gm_abs_t1b6k1   6.0 1.0
sub gm_abs_t1b8k1   8.0 1.0
sub gm_abs_t1b12k1 12.0 1.0

squeue -u $USER -h -o "%T" | sort | uniq -c
