#!/bin/bash
# OPTION 9 MULTIPLICATIVE variant (the supervisor's P_x) on goldminer and grid.
#
#   P_x(a) = P0(a)(1 + beta*x_a) / sum_b P0(b)(1 + beta*x_b),   P0 = (1-eps_p)P + eps_p/K
#
# TWO eps_p SETTINGS, because at the doc's value this arm cannot act.
#
# eps_p = 0.001 (as specified). MEASURED NO-OP: median TV(P0, P_x) = 0.0001 goldminer /
#   0.0003 grid; a live smoke run moves 0.0006 of prior mass. The reason is that P_x is
#   gated by the prior and SAC saturates -- grid puts 0.994 on the top action and 0.0056
#   on the runner-up, so multiplying 0.0056 by (1+beta*x) ~ 1.45 gives 0.008, still
#   invisible to pUCT. Expect results indistinguishable from baseline. Run it anyway:
#   it completes the supervisor's document and the null is worth having on record.
#
# eps_p = w (0.28 goldminer / 0.27 grid). This is the INFORMATIVE arm. eps_p is his own
#   parameter, and setting it to the flattening weight makes P0 IDENTICAL to the prior
#   used by the existing gm_flat028 / grid_flat027 runs. So those become an exactly
#   matched control and the ONLY remaining difference is his multiplicative tilt.
#   Live check: prior mass moved goes 0.0006 -> 0.1712, comparable to the additive arm.
#
# kappa=0 on the matched arms so the c(s) channel does not confound the prior comparison.
# Read the results against gm_flat028 / grid_flat027 with analyze_matched.py.
#
# Run from a COMPUTE node:  bash submit_mul.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth
GD=example/probe_near_goal_d5-20/domain.pddl; GT=example/probe_near_goal_d5-20
GP=models/grid_sac_policy.pth; GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth

# mul <outdir> <D> <T> <P> <Q1> <Q2> <IQN> <shuffle> <kappa> <eps_p>
mul () {
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $2 $3 $4 $5 $6 $7 \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    $8 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" mul 1.0 1.0 $9 ${10}
}

# ---- goldminer (matched control = results/gm_flat028) ----
mul gm_mul_e001_k1       $MD $MT $MP $MQ1 $MQ2 $MI 0 1.0 0.001   # doc default
mul gm_mul_e001_k0       $MD $MT $MP $MQ1 $MQ2 $MI 0 0.0 0.001
mul gm_mul_e028_k0       $MD $MT $MP $MQ1 $MQ2 $MI 0 0.0 0.28    # informative arm
mul gm_mul_e028_k0_shuf  $MD $MT $MP $MQ1 $MQ2 $MI 1 0.0 0.28

# ---- grid (matched control = results/grid_flat027) ----
mul grid_mul_e001_k1      $GD $GT $GP $GQ1 $GQ2 $GI 0 1.0 0.001
mul grid_mul_e001_k0      $GD $GT $GP $GQ1 $GQ2 $GI 0 0.0 0.001
mul grid_mul_e027_k0      $GD $GT $GP $GQ1 $GQ2 $GI 0 0.0 0.27
mul grid_mul_e027_k0_shuf $GD $GT $GP $GQ1 $GQ2 $GI 1 0.0 0.27

squeue -u $USER -h -o "%T" | sort | uniq -c
