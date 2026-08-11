#!/bin/bash
# SATELLITE at c_puct = 2.04, where DeltaU ~ DeltaQ.
#
# WHY. The supervisor's criterion: we want DeltaQ ~ DeltaU, with
#   DeltaQ = max_{a,b}|q_norm(a) - q_norm(b)|,  DeltaU = max_{a,b}|u(a) - u(b)|
# because the prior enters pUCT only through u, so if DeltaU is too small the prior cannot
# influence action selection whatever information it carries. Measured with --diag_select
# over all 120 satellite probes (collect_diag.py), the median is
#
#     DeltaU/DeltaQ = 0.735   (p25 0.61, p75 0.83; only 2 of 120 probes reach 1.0)
#
# so at the c_puct = 1.5 every arm in the study used, the prior is weighted about 1.4x too
# little. u scales linearly in c_puct, so c_puct = 1.5/0.735 = 2.04 brings the median to 1.
# The other domains sit at 2.0-3.5, all in the same direction.
#
# WHAT THIS DECIDES. Satellite is the study's positive result: the signal beats matched
# signal-free flattening 78/19 at p = 0.0000. If that margin GROWS at DeltaU ~ DeltaQ, the
# effect was throttled by an arbitrary c_puct and the reported numbers understate it. If it
# does not move, the reported numbers stand and we can say so from a measurement rather
# than from an assumption. Either way this closes a real confound: c_puct was never tuned,
# and it was the same 1.5 for every domain despite their implied values differing.
#
# ALL THREE ARMS MUST RERUN. A comparison is only valid within one exploration constant --
# pairing a c_puct=2.04 signal arm against the existing c_puct=1.5 flat arm would confound
# the two changes. Hence the baseline is rerun too.
#
# CAVEAT to state alongside the result: DeltaQ = 0 on 14% of satellite's decisions -- the
# siblings are visited and their q_norm values are identical, so the prior is the sole
# tiebreaker there no matter what c_puct is. The DeltaU ~ DeltaQ framing does not cover
# those decisions.
#
# Run from a COMPUTE node:  bash submit_satellite_cpuct.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/probeSat_distinct_d5-22/domain.pddl; ST=example/probeSat_distinct_d5-22
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=120
CP=2.04                                      # 1.5 / 0.735, the measured median ratio

# args 8..19: max_time, signal, const_w, c_puct, qrdqn_value, shuffle, random_spec,
#             abs_signal, tau, beta, kappa, eps_p
go () { sbatch $CPU --array=1-$N "$LAUNCH" $SD $ST $SP $SQ1 $SQ2 $SI results/"$@"; }

go sat_base_cp204        1800 bellman  0.0  $CP 1 0 "" off 1.0 1.0 1.0 0.001
go sat_mul_e025_k0_cp204 1800 bellman  0.0  $CP 1 0 "" mul 1.0 1.0 0.0 0.25
go sat_flat025_cp204     1800 constant 0.25 $CP 1 0 "" off 1.0 1.0 1.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
