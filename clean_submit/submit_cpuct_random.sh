#!/bin/bash
# The DeltaU ~ DeltaQ test, with the RANDOM control instead of flattening.
#
# submit_satellite_cpuct.sh and submit_log_cpuct.sh reran baseline / signal / FLATTENING at
# the c_puct that makes DeltaU ~ DeltaQ. This adds the arms needed to make the same
# comparison against the RANDOM control.
#
# PAIRING. random is the matched control for the ADDITIVE beta=1 kappa=1 arm -- identical in
# every parameter (tau=1, beta=1, kappa=1, eps_p=0.001), with sib_random the only difference.
# It is NOT the control for the multiplicative eps ladder, which has its own shuffles. So the
# arms here are abs_t1b1k1 and abs_t1b1k1_rndm, not the mul_e0XX arms the flattening test used.
#
# c_puct per domain, from collect_diag.py over every probe:
#   satellite  median DeltaU/DeltaQ 0.735 -> 1.5/0.735 = 2.04
#   logistics  median DeltaU/DeltaQ 0.433 -> 1.5/0.433 = 3.46   (ZERO of 113 probes reach 1.0)
#
# The baselines at those c_puct values already exist (sat_base_cp204, log_base_cp346) so they
# are not rerun here.
#
# Run from a COMPUTE node:  bash submit_cpuct_random.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

# ---- satellite, c_puct 2.04 ----
SD=example/probeSat_distinct_d5-22/domain.pddl; ST=example/probeSat_distinct_d5-22
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
SLN=lognormal:0.717:-0.831

sbatch $CPU --array=1-120 "$LAUNCH" $SD $ST $SP $SQ1 $SQ2 $SI \
  results/sat_abs_t1b1k1_cp204      1800 bellman 0.0 2.04 1 0 ""      add 1.0 1.0 1.0 0.001
sbatch $CPU --array=1-120 "$LAUNCH" $SD $ST $SP $SQ1 $SQ2 $SI \
  results/sat_abs_t1b1k1_rndm_cp204 1800 bellman 0.0 2.04 1 0 "$SLN" add 1.0 1.0 1.0 0.001

# ---- logistics, c_puct 3.46 ----
LD=example/probeLog_distinct_d5-22/domain.pddl; LT=example/probeLog_distinct_d5-22
LP=models/logistics_topo_sac_policy_best.pth
LQ1=models/logistics_topo_sac_q1_best.pth; LQ2=models/logistics_topo_sac_q2_best.pth
LI=models/logistics_topo_frozen.pth
LLN=lognormal:0.839:-0.307

sbatch $CPU --array=1-113 "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
  results/log_abs_t1b1k1_cp346      1800 bellman 0.0 3.46 1 0 ""      add 1.0 1.0 1.0 0.001
sbatch $CPU --array=1-113 "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
  results/log_abs_t1b1k1_rndm_cp346 1800 bellman 0.0 3.46 1 0 "$LLN" add 1.0 1.0 1.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
