#!/bin/bash
# GRID: signal-free FLATTENING at matched weights, on the distinct probe set.
#
# `--signal constant --const_w w` flattens every prior toward uniform by a fixed w with NO
# IQN call and NO Bellman residual anywhere:
#
#     prior'(a) = (1-w) P(a) + w/K
#
# so it is the same amount of perturbation with zero signal content. This is the arm that
# decided the other domains: it beat EVERY signal arm on goldminer (coverage 337 -> 478),
# and on rovers it reduced the one arm that looked different to dose (eps=0.60 vs flat060
# head-to-head p = 0.4657). On satellite it is the control the signal SURVIVED (78/19,
# p = 0.0000), which is what makes satellite the study's positive result.
#
# Grid should behave like goldminer and rovers, not like satellite: prior_peak.py reads
# CONFIDENTLY WRONG on 19.6% of on-plan states with P_max >= 0.9 on 78.6% -- a prior that is
# peaked and often wrong, which is exactly where blind flattening wins.
#
# WEIGHTS mirror the multiplicative rungs so the pairs are matched: 0.27 is grid's own
# W = 0.265 at beta=1, 0.40 is W at beta=2 (0.419), 0.60 carries over.
#
# CAVEAT: grid's median branching is FIVE, so w/K puts w/5 on each action -- a much heavier
# per-action nudge than the same w on satellite (K=274). Read grid's flat arms against
# grid's own eps ladder, not against another domain's flat arms.
#
# Baseline: results/grid_base. qrdqn_value=1 keeps the leaf value on the same model as every
# other grid arm, so the only difference is the prior transform.
# Run from a COMPUTE node:  bash submit_grid_flat.sh
# Locate the launcher. It sits at the repo root in the archive and under slurm/ in the
# clean tree, and a submit script that names the wrong one fails per-arm with
# "sbatch: error: Unable to open file run_search_signal.sh" -- while the submit script
# itself still exits 0, so a whole sweep silently queues nothing. Resolve it, or stop.
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

GD=example/probeGrid_distinct_d5-22/domain.pddl; GT=example/probeGrid_distinct_d5-22
GP=models/grid_sac_policy.pth; GQ1=models/grid_sac_q1.pth; GQ2=models/grid_sac_q2.pth
GI=models/grid_iqn_qrdqn_best.pth
N=113

# flat <outdir> <w>
# Positional args 8..19: max_time 1800, signal constant, const_w $2, c_puct 1.5,
# qrdqn_value 1, shuffle 0, no random spec, abs_signal off (no IQN, no residual).
flat () {
  sbatch $CPU --array=1-$N "$LAUNCH" $GD $GT $GP $GQ1 $GQ2 $GI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

flat grid_flat027 0.27     # matches eps=0.27 (grid's own W at beta=1) -- THE test
flat grid_flat040 0.40     # matches eps=0.40, and W at beta=2
flat grid_flat060 0.60     # matches eps=0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
