#!/bin/bash
# GOLDMINER: the beta=2 additive row and the multiplicative eps_p ladder, distinct probe set.
#
# eps_p RUNGS. 0.26 is goldminer's OWN matched mass: fit_random_control.py on
# gold_signal_distinct.json gives W = beta*g_s/(1+beta*g_s) = 0.258 at beta=1, so eps_p=0.26
# makes P0 identical to what a flattening arm of that weight would produce and leaves the
# tilt as the only difference. 0.40 is the beta=2 rung (W=0.410); 0.60 carries over.
# The old config used 0.28, fitted on the 480-probe set.
#
# At eps_p=0.001 the multiplicative variant is close to inert but NOT fully: the floor lifts
# an action from unselectable to selectable, and on the OLD goldminer set that alone moved
# coverage 337 -> 357. Worth re-measuring here, because with a median of 2 applicable actions
# the floor is a much larger relative intervention than on any other domain.
#
# CAVEAT: goldminer's median branching is TWO. eps_p spreads w/K = w/2 onto each action, the
# coarsest intervention in the study by a wide margin (satellite spreads w/274). Compare
# rungs within goldminer only.
#
# gm_mul_e040_k0_shuf is new -- the old arm list omitted it, so goldminer's table had 12 rows
# where the other four domains have 17. All five now match.
#
# Baseline for all of these: results/gm_base (submitted by submit_gm.sh).
# Run from a COMPUTE node:  bash submit_gm_rest.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
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

# sub <outdir> <shuffle> <mode> <beta> <kappa> <eps_p>
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $MD $MT $MP $MQ1 $MQ2 $MI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" $3 1.0 $4 $5 $6
}

# ---- additive: the missing beta row ----
sub gm_abs_t1b2k1        0 add 2.0 1.0 0.001

# ---- multiplicative ladder ----
sub gm_mul_e001_k0       0 mul 1.0 0.0 0.001
sub gm_mul_e001_k1       0 mul 1.0 1.0 0.001
sub gm_mul_e026_k0       0 mul 1.0 0.0 0.26    # goldminer's own matched mass (W=0.258)
sub gm_mul_e026_k0_shuf  1 mul 1.0 0.0 0.26
sub gm_mul_e040_k0       0 mul 1.0 0.0 0.40    # also the beta=2 matched mass (W=0.410)
sub gm_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub gm_mul_e060_k0       0 mul 1.0 0.0 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
