#!/bin/bash
# ROVERS at c_puct = 2.69, where DeltaU ~ DeltaQ.
#
# collect_diag.py over all 120 rovers probes: median DeltaU/DeltaQ = 0.558 (p25 0.22,
# p75 0.70; 1 of 120 probes reaches 1.0). u scales linearly in c_puct, so
# 1.5/0.558 = 2.69 brings the median to 1.
#
# Baseline, additive beta=1 kappa=1, and its matched RANDOM control -- same three rows as
# the other c_puct reruns. All three rerun: a comparison is only valid within one
# exploration constant.
#
# WHY ROVERS MATTERS FOR THIS TEST. It is the study's cleanest null: at c_puct = 1.5 the
# signal and its own shuffle are the same arm to two decimal places (0.980 vs 0.971, both
# p > 0.44), random matches too, and win_source.py found the signal's own uncertainty
# measure carries NO information about where it wins -- Spearman(g_s, log ratio) = +0.079,
# p = 0.46, with g_s nearly constant across instances (0.379 to 0.384). On satellite the
# same test gave -0.089 and the arm beat every control.
#
# So if rovers' null is caused by an under-weighted prior rather than by the signal being
# uninformative, this run is where it shows. If the null survives at DeltaU ~ DeltaQ, then
# combined with the g_s result it is about as strong a negative as this design can produce.
#
# Run from a COMPUTE node:  bash submit_rovers_cpuct.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

RD=example/probeRov_distinct_d5-22/domain.pddl; RT=example/probeRov_distinct_d5-22
RP=models/rovers_small_sac_policy_best.pth
RQ1=models/rovers_small_sac_q1_best.pth; RQ2=models/rovers_small_sac_q2_best.pth
RI=models/rovers_small_qrdqn_frozen.pth
N=120
CP=2.69                                      # 1.5 / 0.558, the measured median ratio
LN=lognormal:1.030:-0.578                    # rovers' own fit

go () { sbatch $CPU --array=1-$N "$LAUNCH" $RD $RT $RP $RQ1 $RQ2 $RI results/"$@"; }

go rov_base_cp269             1800 bellman 0.0 $CP 1 0 ""     off 1.0 1.0 1.0 0.001
go rov_abs_t1b1k1_cp269       1800 bellman 0.0 $CP 1 0 ""     add 1.0 1.0 1.0 0.001
go rov_abs_t1b1k1_rndm_cp269  1800 bellman 0.0 $CP 1 0 "$LN"  add 1.0 1.0 1.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
