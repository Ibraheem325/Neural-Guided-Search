#!/bin/bash
# PORTED to slurm/run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# How far does prior flattening go before it stops helping?
#
# We currently have exactly TWO points on this curve: w=0 (baseline, 337/480 solved)
# and w=0.28 (478/480). Two points do not establish "more is better" -- they establish
# that 0.28 beats 0. This sweep maps the curve.
#
# The endpoint is the one that matters. --signal constant sets
#     prior'(a) = (1-w)*prior(a) + w/K
# so w=1.0 discards the SAC policy ENTIRELY and runs pUCT on a uniform prior, i.e. the
# Q-critics alone guide the search. If w=1.0 is at or near the top of the curve, the
# goldminer policy is not merely overconfident, it is worse than no policy at all for
# guiding search -- and every prior-channel result on this domain is really a statement
# about how much of the policy to switch off.
#
# If instead the curve peaks in the middle (say w~0.3-0.6) and falls off by w=1.0, the
# policy does carry usable information and the story is calibration, not competence.
#
# w=0.28 already ran as gm_flat028, w=0.42 as gm_flat042.
# Run from a COMPUTE node:  bash submit_flat_sweep.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

MD=example/probeGold_near_goal_d5-20/domain.pddl; MT=example/probeGold_near_goal_d5-20
MP=models/goldminer_sac_policy.pth; MQ1=models/goldminer_sac_q1.pth; MQ2=models/goldminer_sac_q2.pth
MI=models/goldminer_iqn.pth

sub () {   # sub <outdir> <w>;  arg 12 = CONST_W, arg 13 = W_MAX (must equal w, or it clips)
  sbatch $CPU --array=1-480 "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

sub gm_flat010  0.10
sub gm_flat020  0.20
sub gm_flat060  0.60
sub gm_flat080  0.80
sub gm_flat100  1.00     # SAC prior fully discarded -> uniform prior, Q-critics only

squeue -u $USER -h -o "%T" | sort | uniq -c
