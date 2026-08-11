#!/bin/bash
# LOGISTICS at c_puct = 3.46, where DeltaU ~ DeltaQ.
#
# WHY. The supervisor's criterion: we want DeltaQ ~ DeltaU, with
#   DeltaQ = max_{a,b}|q_norm(a) - q_norm(b)|,  DeltaU = max_{a,b}|u(a) - u(b)|
# because the prior enters pUCT only through u, so if DeltaU is too small the prior cannot
# influence action selection whatever information it carries. Measured with --diag_select
# over all 120 logistics probes (collect_diag.py), the median is
#
#     DeltaU/DeltaQ = 0.433   (p25 0.19, p75 0.71; ZERO of 113 probes reach 1.0)
#
# so at the c_puct = 1.5 every arm in the study used, the prior is weighted about 1.4x too
# little. u scales linearly in c_puct, so c_puct = 1.5/0.433 = 3.46 brings the median to 1.
# The other domains sit at 2.0-3.5, all in the same direction.
#
# WHAT THIS DECIDES. Logistics is the WORST case for the criterion -- its measured ratio is
# the lowest of the five and NOT ONE of its 113 probes reaches DeltaU >= DeltaQ, so if
# under-weighting the prior ever mattered it should matter most here. At c_puct = 1.5 the
# signal solves 90/113 against the baseline's 112 and flattening's 111, i.e. it pays 20
# points of coverage. The question is whether that is the prior being too weak to steer
# (in which case c_puct = 3.46 should recover it) or the perturbation simply being too
# costly on this domain.
#
# On satellite the same test came back negative: coverage fell 111 -> 100 for the signal
# while the baseline and flattening stayed at 120/120, because c_puct scales u for EVERY
# action and so inflates the exploration bonus, which is largest exactly where n_a = 0.
# Logistics has a diffuse prior (median P_max 0.5000), so unlike satellite there is no
# confidently-correct prior for the extra weight to amplify -- which makes it the cleaner
# test of whether the criterion helps anywhere.
#
# ALL THREE ARMS MUST RERUN. A comparison is only valid within one exploration constant --
# pairing a c_puct=2.04 signal arm against the existing c_puct=1.5 flat arm would confound
# the two changes. Hence the baseline is rerun too.
#
# CAVEAT to state alongside the result: DeltaQ = 0 on 11.5% of logistics' decisions -- the
# siblings are visited and their q_norm values are identical, so the prior is the sole
# tiebreaker there no matter what c_puct is. The DeltaU ~ DeltaQ framing does not cover
# those decisions.
#
# Run from a COMPUTE node:  bash submit_log_cpuct.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

LD=example/probeLog_distinct_d5-22/domain.pddl; LT=example/probeLog_distinct_d5-22
LP=models/logistics_topo_sac_policy_best.pth
LQ1=models/logistics_topo_sac_q1_best.pth; LQ2=models/logistics_topo_sac_q2_best.pth
LI=models/logistics_topo_frozen.pth
N=113
CP=3.46                                      # 1.5 / 0.433, the measured median ratio

# args 8..19: max_time, signal, const_w, c_puct, qrdqn_value, shuffle, random_spec,
#             abs_signal, tau, beta, kappa, eps_p
go () { sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI results/"$@"; }

go log_base_cp346        1800 bellman  0.0  $CP 1 0 "" off 1.0 1.0 1.0 0.001
go log_mul_e030_k0_cp346 1800 bellman  0.0  $CP 1 0 "" mul 1.0 1.0 0.0 0.30
go log_flat030_cp346     1800 constant 0.30 $CP 1 0 "" off 1.0 1.0 1.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
