#!/bin/bash
# LOGISTICS: the beta=2 additive row and the multiplicative eps_p ladder, distinct probe set.
#
# eps_p RUNGS. 0.30 is logistics' OWN matched mass: fit_random_control.py on
# log_signal_distinct.json gives W = beta*g_s/(1+beta*g_s) = 0.301 at beta=1, so eps_p=0.30
# makes P0 identical to what a flattening arm of that weight would produce and leaves the
# tilt as the only difference. 0.40 is close to the beta=2 rung (W=0.463); 0.60 carries over.
# The old config used 0.29, fitted on the 288-probe set.
#
# Logistics has the highest mean g_s of the five (0.4308, vs grid 0.3604, rovers 0.3779,
# satellite 0.3286), so at a given beta it injects MORE mass than any other domain.
#
# CAVEAT: median branching is 42 applicable actions, between rovers (31) and satellite (274)
# and far above grid (5). Compare rungs within logistics, not across domains.
#
# Baseline for all of these: results/log_base (submitted by submit_log.sh).
# Run from a COMPUTE node:  bash submit_log_rest.sh
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

# sub <outdir> <shuffle> <mode> <beta> <kappa> <eps_p>
sub () {
  sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
    results/$1 1800 bellman 0.0 1.5 1 $2 "" $3 1.0 $4 $5 $6
}

# ---- additive: the missing beta row ----
sub log_abs_t1b2k1        0 add 2.0 1.0 0.001

# ---- multiplicative ladder ----
sub log_mul_e001_k0       0 mul 1.0 0.0 0.001
sub log_mul_e001_k1       0 mul 1.0 1.0 0.001
sub log_mul_e030_k0       0 mul 1.0 0.0 0.30    # logistics' own matched mass (W=0.301)
sub log_mul_e030_k0_shuf  1 mul 1.0 0.0 0.30
sub log_mul_e040_k0       0 mul 1.0 0.0 0.40
sub log_mul_e040_k0_shuf  1 mul 1.0 0.0 0.40
sub log_mul_e060_k0       0 mul 1.0 0.0 0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
