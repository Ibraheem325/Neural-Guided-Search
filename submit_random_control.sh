#!/bin/bash
# RANDOM control sweep for grid + goldminer, Bellman channel.
#
# Third control alongside real and shuffle:
#   real     signal values, real placement
#   shuffle  signal values, scrambled placement   -> spread PRESERVED
#   random   fresh U(0,1) draws per child          -> spread DESTROYED
#
# Baselines: results/az_probe_qrval_base (grid), results/gm_base (goldminer).
# Run from a COMPUTE node:  bash submit_random_control.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

# ---- grid ----
GD=example/probe_near_goal_d5-20/domain.pddl; GT=example/probe_near_goal_d5-20
GP=models/grid_sac_policy.pth; GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth
for pair in 10:1.0 20:2.0 40:4.0 60:6.0 80:8.0 120:12.0; do
  t=${pair%:*}; b=${pair#*:}
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $GD $GT $GP $GQ1 $GQ2 $GI \
    results/az_probe_qrval_binc${t}rand 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 \
    0.0 0 $b 0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 uniform
done

# ---- goldminer ----
MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth
for pair in 10:1.0 20:2.0 40:4.0 60:6.0 80:8.0 120:12.0; do
  t=${pair%:*}; b=${pair#*:}
  sbatch $CPU --array=1-480 run_alphazero_bellman.sh $MD $MT $MP $MQ1 $MQ2 $MI \
    results/gm_binc${t}rand 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 \
    0.0 0 $b 0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 uniform
done

squeue -u $USER -h -o "%T" | sort | uniq -c
