#!/bin/bash
# Bellman-inconsistency sweep on multi-location logistics, RETRAINED policy+critics.
# Baseline for all of these: results/multiloc_base_topopolicy (94.4% cov, 3370 med exp).
# Run from a COMPUTE node:  bash submit_binc_multiloc.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
D=example/probeLog_multiloc_d5-20/domain.pddl
T=example/probeLog_multiloc_d5-20
P=models/logistics_topo_sac_policy_best.pth
Q1=models/logistics_topo_sac_q1_best.pth
Q2=models/logistics_topo_sac_q2_best.pth
IQN=models/logistics_topo_frozen.pth
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

for pair in 20:2.0 40:4.0 80:8.0 120:12.0; do
  t=${pair%:*}; b=${pair#*:}
  sbatch $CPU --array=1-288 run_alphazero_bellman.sh $D $T $P $Q1 $Q2 $IQN \
    results/mlbinc${t}     0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 $b 0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0
  sbatch $CPU --array=1-288 run_alphazero_bellman.sh $D $T $P $Q1 $Q2 $IQN \
    results/mlbinc${t}shuf 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 $b 1 0.0 1.5 1 0.0 0.0 binc 2.0 1.0
done
squeue -u $USER -h -o "%T" | sort | uniq -c
