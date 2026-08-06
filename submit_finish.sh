#!/bin/bash
# The two gaps that stop the cross-domain table being stated in the same terms.
#
# 1. LOGISTICS has no signal-free flattening control. It is the domain with the
#    strongest negative (72-77% of failures are the search WANDERING -- expanding ~19000
#    states where the baseline solved the same instance in ~7000), but without a flat arm
#    that reads as "any perturbation hurts here" rather than "the signal hurts here".
#    Shuffle partly covers it; flat is the control grid and goldminer both have.
#    W=0.29 is logistics' own measured beta*g_s/(1+beta*g_s) at beta=1.
#
# 2. The MULTIPLICATIVE variant at a floor where it can act is untested outside goldminer.
#    It is the only arm anywhere that beat both its shuffle (67/33) and mass-matched
#    flattening (73/27), at eps_p=0.40. Logistics is where it has the most room in
#    principle: median |A|=19, so blind flattening dilutes its 29% to 1.5% per action,
#    while a tilt can concentrate it. If the tilt ever earns its keep, it is here.
#
# Deliberately NOT resubmitting the six logistics arms that already ran.
# Run from a COMPUTE node:  bash submit_finish.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

LD=example/probeLog_multiloc_d5-20/domain.pddl; LT=example/probeLog_multiloc_d5-20
LP=models/logistics_topo_sac_policy_best.pth
LQ1=models/logistics_topo_sac_q1_best.pth; LQ2=models/logistics_topo_sac_q2_best.pth
LI=models/logistics_topo_frozen.pth
GD=example/probe_near_goal_d5-20/domain.pddl; GT=example/probe_near_goal_d5-20
GP=models/grid_sac_policy.pth; GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth

# mul <outdir> <D> <T> <P> <Q1> <Q2> <I> <N> <shuffle> <eps_p>
mul () {
  sbatch $CPU --array=1-$8 run_alphazero_bellman.sh $2 $3 $4 $5 $6 $7 \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    $9 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" mul 1.0 1.0 0.0 ${10}
}
flat () {  # flat <outdir> <D> <T> <P> <Q1> <Q2> <I> <N> <w>
  sbatch $CPU --array=1-$8 run_alphazero_bellman.sh $2 $3 $4 $5 $6 $7 \
    results/$1 0.0 4 constant 1800 $9 $9 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" off 1.0 1.0 1.0 0.001
}

# ---- gap 1: logistics signal-free controls ----
flat logi_flat029 $LD $LT $LP $LQ1 $LQ2 $LI 288 0.29
flat logi_flat010 $LD $LT $LP $LQ1 $LQ2 $LI 288 0.10

# ---- gap 2: multiplicative at a floor where it acts ----
mul logi_mul_e029_k0      $LD $LT $LP $LQ1 $LQ2 $LI 288 0 0.29
mul logi_mul_e029_k0_shuf $LD $LT $LP $LQ1 $LQ2 $LI 288 1 0.29
mul grid_mul_e040_k0      $GD $GT $GP $GQ1 $GQ2 $GI 480 0 0.40
mul grid_mul_e040_k0_shuf $GD $GT $GP $GQ1 $GQ2 $GI 480 1 0.40

squeue -u $USER -h -o "%T" | sort | uniq -c
