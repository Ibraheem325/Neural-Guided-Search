#!/bin/bash
# SHUFFLE and RANDOM controls at each domain's BEST cell of the beta x eps grid.
#
# WHY THE EXISTING CONTROLS DO NOT COVER THIS. Both controls run the SAME pipeline as the
# real arm, so they inherit its beta limit:
#
#     P+(a) = (P0(a) + beta x_a / K) / (1 + beta g_s)   ->   x_a / (K g_s)  as beta -> inf
#
# independent of P0, hence of eps. So at beta=1 the random control asks "does a small
# signal-shaped nudge beat a small random nudge?", while at beta=8 it asks "does a
# residual-ordered PRIOR beat a random PRIOR?" -- both arms have discarded the policy by
# then. Different questions; the second is the sharper one, because at saturation the
# comparison isolates the residual's ordering and nothing else.
#
# SHUFFLE is the cleanest control at high beta: it permutes the REAL e_a within a state, so
# the multiset of values and therefore g_s are preserved EXACTLY, and only the assignment
# action -> value changes. At beta=8 that is a pure placement test.
#
# BEST CELLS, from table_by_base over the 20-cell grid (median expansion ratio vs baseline):
#   satellite  beta=8 eps=0.001   0.517, 94/11   -- saturated; every cell beta>=4 is identical
#   satellite  beta=4 eps=0.26    0.533, 92/13   -- included to check the saturation claim
#   logistics  beta=6 eps=0.001   0.916, 61/23, p=0.0000
#   rovers     beta=4 eps=0.26    0.827, 54/33, p=0.0314  -- 1 of 20 cells, fails correction
#
# goldminer and grid are NOT included: their best cells are beta=1-2, which already have
# controls. On goldminer coverage saturates at 100% from beta=2 and higher beta only costs
# expansions; on grid every cell is worse than the baseline, monotonically, up to 21.6x.
#
# Run from a COMPUTE node:  bash submit_highbeta_controls.sh
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

# pair <outdir_stem> <N> <probe> <pol> <q1> <q2> <iqn> <LN> <beta> <eps>
pair () {
  local stem=$1 N=$2 P=$3 POL=$4 Q1=$5 Q2=$6 IQN=$7 LN=$8 B=$9 E=${10}
  local D=example/$P/domain.pddl T=example/$P
  local M=models
  sbatch $CPU --array=1-$N "$LAUNCH" $D $T $M/$POL.pth $M/$Q1.pth $M/$Q2.pth $M/$IQN.pth \
    results/${stem}_shuf 1800 bellman 0.0 1.5 1 1 ""     add 1.0 $B 1.0 $E
  sbatch $CPU --array=1-$N "$LAUNCH" $D $T $M/$POL.pth $M/$Q1.pth $M/$Q2.pth $M/$IQN.pth \
    results/${stem}_rndm 1800 bellman 0.0 1.5 1 0 "$LN"  add 1.0 $B 1.0 $E
}

SAT="120 probeSat_distinct_d5-22 satellite_s18_sac_policy_best satellite_s18_sac_q1_best satellite_s18_sac_q2_best satellite_s18_qrdqn_best lognormal:0.717:-0.831"
LOG="113 probeLog_distinct_d5-22 logistics_topo_sac_policy_best logistics_topo_sac_q1_best logistics_topo_sac_q2_best logistics_topo_frozen lognormal:0.839:-0.307"
ROV="120 probeRov_distinct_d5-22 rovers_small_sac_policy_best rovers_small_sac_q1_best rovers_small_sac_q2_best rovers_small_qrdqn_frozen lognormal:1.030:-0.578"

pair sat_abs_b8k1_e001 $SAT 8 0.001
pair sat_abs_b4k1_e026 $SAT 4 0.26
pair log_abs_b6k1_e001 $LOG 6 0.001
pair rov_abs_b4k1_e026 $ROV 4 0.26

squeue -u $USER -h -o "%T" | sort | uniq -c
