#!/bin/bash
# GOLDMINER at c_puct = 2.97, where DeltaU ~ DeltaQ.
#
# collect_diag.py over all 118 goldminer probes: median DeltaU/DeltaQ = 0.504
# (p25 0.18, p75 0.78; 5 of 118 probes reach 1.0). u scales linearly in c_puct, so
# 1.5/0.504 = 2.97 brings the median to 1.
#
# Baseline, the additive beta=1 kappa=1 arm, and its matched RANDOM control -- the same
# three rows as satellite_cp204 and logistics_cp346, so the tables line up. All three rerun:
# a comparison is only valid within one exploration constant.
#
# ---------------------------------------------------------------------------------------
# READ THIS BEFORE INTERPRETING THE RANDOM ROW. goldminer's median branching is TWO
# applicable actions (grid 5, rovers 31, logistics 42, satellite 274). At K=2 the random
# control fails its own fit diagnostic: fit_random_control wants the drawn g_s spread BELOW
# the real one, and it comes back 0.1222 real vs 0.1226 drawn -- no reduction, because g_s
# is the mean of two draws and its variation is sampling noise in both cases. There is no
# per-state structure for the control to destroy. Satellite by contrast goes 0.0969 ->
# 0.0087. So a signal-vs-random result on goldminer is weak evidence in either direction,
# and the flat arms (submit_gm_flat.sh) remain the only clean control here.
#
# What this run CAN answer is whether goldminer's null is an artefact of an under-weighted
# prior -- which is the live alternative to "the method does not work" on this domain, and
# the reason it is worth running despite the degenerate control.
# ---------------------------------------------------------------------------------------
#
# Prior context: at c_puct = 1.5 the baseline solves 88/118 and EVERY perturbation arm takes
# it to ~100% (flat026 118, eps=0.26 118, beta=2 kappa=1 118). The gain there is coverage,
# not expansions -- flat026 vs gm_base is 20/22, p = 0.8776, on the 88 both solve.
#
# Run from a COMPUTE node:  bash submit_gm_cpuct.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_distinct_d5-22/domain.pddl; MT=example/probeGold_distinct_d5-22
MP=models/goldminer_sac_policy.pth
MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth
N=118
CP=2.97                                      # 1.5 / 0.504, the measured median ratio
LN=lognormal:0.999:-0.757                    # goldminer's own fit

go () { sbatch $CPU --array=1-$N "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI results/"$@"; }

go gm_base_cp297             1800 bellman 0.0 $CP 1 0 ""     off 1.0 1.0 1.0 0.001
go gm_abs_t1b1k1_cp297       1800 bellman 0.0 $CP 1 0 ""     add 1.0 1.0 1.0 0.001
go gm_abs_t1b1k1_rndm_cp297  1800 bellman 0.0 $CP 1 0 "$LN"  add 1.0 1.0 1.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
