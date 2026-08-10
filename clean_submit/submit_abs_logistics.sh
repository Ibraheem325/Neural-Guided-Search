#!/bin/bash
# PORTED to slurm/run_search_signal.sh (19 positional args, was 37). The archived original
# targets the pre-cleanup search and its eight abandoned channels; this one is the
# same arms against the cleaned alphaZero_bellman.py. Arms and comments unchanged.
#
# OPTION 9 (supervisor's reformulation) on multi-location LOGISTICS: additive P_+ and
# multiplicative P_x, with the same control ladder used on grid and goldminer.
#
# Baseline: results/multiloc_base_topopolicy (94.4% coverage, 3370 median expansions).
# NOTE that 94.4% leaves almost no coverage headroom, so this domain should behave like
# GRID (every intervention is pure cost) rather than goldminer (70.2% baseline, where
# injection bought 141 instances). Read it on median ratio and 'dropped', not coverage.
#
# eps_p: at the doc's 0.001 the multiplicative arm is a near no-op on grid/goldminer
# (median TV 0.0001-0.0003) because SAC saturates -- but it is NOT inert, since the floor
# lifts exactly-zero priors to eps_p/K and makes previously unselectable actions
# selectable. Both settings are run: 0.001 as specified, and eps_p = W (the matched
# flattening weight) where P0 becomes identical to the flat control's prior so the only
# difference left is the multiplicative tilt.
#
# W is the median injected mass beta*g_s/(1+beta*g_s) at beta=1, measured on this domain's
# own residuals. Set from logi_signal_data.json -- do NOT reuse goldminer's 0.28.
W=${W:-}
if [ -z "$W" ]; then
  echo "W is unset. Measure it first:"
  echo "  venv/bin/python new_signal_probe.py 120 8 -o logi_signal_data.json \\"
  echo "    --set logistics:example/probeLog_multiloc_d5-20:models/logistics_topo_frozen.pth:models/logistics_topo_sac_policy_best.pth"
  echo "then re-run as:  W=<value> bash submit_abs_logistics.sh"
  echo "(the ADD arms below do not depend on W; only the mul-matched and flat arms do)"
fi

# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

LD=example/probeLog_multiloc_d5-20/domain.pddl; LT=example/probeLog_multiloc_d5-20
LP=models/logistics_topo_sac_policy_best.pth
LQ1=models/logistics_topo_sac_q1_best.pth; LQ2=models/logistics_topo_sac_q2_best.pth
LI=models/logistics_topo_frozen.pth
N=288                      # instances in probeLog_multiloc_d5-20

# abs <outdir> <mode> <shuffle> <beta> <kappa> <eps_p>
abs () {
  sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
    results/$1 1800 bellman 0.0 1.5 1 $3 "" $2 1.0 $4 $5 $6
}
flat () {  # flat <outdir> <w>
  sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

# ---- ADDITIVE (independent of W) ----
abs logi_abs_t1b1k1      add 0 1.0 1.0 0.001     # his starting configuration
abs logi_abs_t1b1k0      add 0 1.0 0.0 0.001     # prior channel only
abs logi_abs_t1b2k1      add 0 2.0 1.0 0.001
abs logi_abs_t1b1k1_shuf add 1 1.0 1.0 0.001     # signal-blind placement

# ---- MULTIPLICATIVE at the doc's eps_p (independent of W) ----
abs logi_mul_e001_k1     mul 0 1.0 1.0 0.001
abs logi_mul_e001_k0     mul 0 1.0 0.0 0.001

# ---- arms that need the measured W ----
if [ -n "$W" ]; then
  abs logi_mul_eW_k0      mul 0 1.0 0.0 $W       # P0 == flat's prior; only the tilt differs
  abs logi_mul_eW_k0_shuf mul 1 1.0 0.0 $W
  flat logi_flat$W        $W                     # signal-free matched control
  flat logi_flat010       0.10                   # a little of the curve, as on grid
else
  echo "skipped: logi_mul_eW_k0, logi_mul_eW_k0_shuf, logi_flat* (need W)"
fi

squeue -u $USER -h -o "%T" | sort | uniq -c
