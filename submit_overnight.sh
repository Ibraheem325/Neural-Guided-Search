#!/bin/bash
# Follow-ups on goldminer, in priority order. All 480 instances, baseline results/gm_base.
#
# 1. FLATTEN + BINC  (the one that matters)
#    Everything so far splits cleanly: flattening fixes COVERAGE (337 -> 478) and is
#    signal-free; binc fixes EFFICIENCY (matched-set mean 0.939 vs its shuffle's 1.094,
#    beating shuffle 67/33) but cannot touch coverage because mult(a)*P(a) stays gated by
#    the prior. Nobody has run them together. Verified locally that both channels engage
#    in the same run (22 nodes widened at w=0.28, 57 child-edges binc-modulated).
#      if 478 coverage AND ~0.94 efficiency  -> the two mechanisms compose, and the
#         Bellman signal earns its place in a clean two-part story
#      if the efficiency gain vanishes       -> binc was compensating for the
#         overconfidence that flattening already removes, i.e. it added no information
#    The shuffle arm is what distinguishes those two outcomes, so it is not optional.
#
# 2. RANDOM rung, never run. Completes real > shuffle > random > flat on the additive
#    family. Fitted to the raw-e marginal (mu=-0.585 sigma=1.003), NOT the old mean-1
#    lognormal:0.88 which is invalid once the sibling division is gone.
#
# 3. eps_p sweep on the multiplicative arm. At eps_p=0.28 it beat its shuffle 66/34 and
#    beat flattening 73/27 on efficiency -- the best showing of the supervisor's equation
#    anywhere -- but cost 8 instances of coverage (470 vs 478). A higher floor may recover
#    coverage while keeping the tilt.
#
# Run from a COMPUTE node:  bash submit_overnight.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="
MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

# flatbinc <outdir> <w> <binc_beta> <shuffle>
flatbinc () {
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 0.0 4 constant 1800 $2 $2 "" 0.0 0.0 0.0 "" 5 0.0 0 $3 \
    $4 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" off 1.0 1.0 1.0 0.001
}
# absarm <outdir> <mode> <shuffle> <kappa> <eps_p> <random_spec>
absarm () {
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    $3 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "$6" $2 1.0 1.0 $4 $5
}

# ---- 1. flatten + binc ----
flatbinc gm_flat028_binc4       0.28  4.0  0
flatbinc gm_flat028_binc4_shuf  0.28  4.0  1
flatbinc gm_flat028_binc12      0.28 12.0  0

# ---- 2. the missing random rung on the additive family ----
absarm gm_abs_t1b1k1_rndm  add 0 1.0 0.001 lognormal:1.003:-0.585

# ---- 3. eps_p sweep on the multiplicative arm ----
absarm gm_mul_e040_k0       mul 0 0.0 0.40 ""
absarm gm_mul_e060_k0       mul 0 0.0 0.60 ""
absarm gm_mul_e040_k0_shuf  mul 1 0.0 0.40 ""

squeue -u $USER -h -o "%T" | sort | uniq -c
