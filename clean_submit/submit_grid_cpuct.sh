#!/bin/bash
# GRID at c_puct = 2.87, where DeltaU ~ DeltaQ.
#
# collect_diag.py over all 113 grid probes: median DeltaU/DeltaQ = 0.523 (p25 0.36,
# p75 0.68; only 1 of 113 probes reaches 1.0). u scales linearly in c_puct, so
# 1.5/0.523 = 2.87 brings the median to 1.
#
# Baseline, additive beta=1 kappa=1, and its matched RANDOM control -- the same three rows
# as the other domains' c_puct reruns. All three rerun: a comparison is only valid within
# one exploration constant.
#
# WHAT TO WATCH. At c_puct = 1.5 grid has NO coverage headroom -- the baseline solves
# 113/113 -- and every perturbation arm is significantly WORSE on expansions (beta=1 kappa=1
# is 16/54 against the baseline, p = 0.0000) while returning much SHORTER plans (baseline
# 1.83x optimal, arms 1.27-1.38x). Grid pays expansions for plan quality. Raising c_puct
# adds exploration to a domain that already solves everything, so the question is whether
# the extra prior weight offsets that or compounds it.
#
# Grid also has the narrowest branching after goldminer -- median 5 applicable actions -- so
# a given eps_p or flattening weight is a much coarser intervention here than on satellite
# (K=274). Compare grid to grid, not rung-for-rung across domains.
#
# Run from a COMPUTE node:  bash submit_grid_cpuct.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

GD=example/probeGrid_distinct_d5-22/domain.pddl; GT=example/probeGrid_distinct_d5-22
GP=models/grid_sac_policy.pth
GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth
N=113
CP=2.87                                      # 1.5 / 0.523, the measured median ratio
LN=lognormal:1.093:-0.710                    # grid's own fit

go () { sbatch $CPU --array=1-$N "$LAUNCH" $GD $GT $GP $GQ1 $GQ2 $GI results/"$@"; }

go grid_base_cp287             1800 bellman 0.0 $CP 1 0 ""     off 1.0 1.0 1.0 0.001
go grid_abs_t1b1k1_cp287       1800 bellman 0.0 $CP 1 0 ""     add 1.0 1.0 1.0 0.001
go grid_abs_t1b1k1_rndm_cp287  1800 bellman 0.0 $CP 1 0 "$LN"  add 1.0 1.0 1.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
