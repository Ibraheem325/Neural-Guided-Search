#!/bin/bash
# LOGISTICS: signal-free FLATTENING at matched weights, distinct probe set.
#
#     prior'(a) = (1-w) P(a) + w/K        (--signal constant --const_w w)
#
# no IQN call, no Bellman residual -- the same perturbation with zero signal content. This
# arm decided three domains: it beat EVERY signal arm on goldminer (337 -> 478), reduced
# rovers' one moving arm to dose (p = 0.4657), and tied grid's ladder (p = 0.3135). On
# satellite it is the control the signal SURVIVED (78/19, p = 0.0000).
#
# LOGISTICS IS THE INTERESTING CASE FOR THIS ARM, because its prior is DIFFUSE rather than
# wrongly peaked: median P_max 0.5000 against 1.0000 on grid and satellite, P_max >= 0.9 on
# only 42.1% of states. Flattening moves P toward uniform -- but P is already near uniform
# here, so (1-w)P + w/K barely changes anything. If the flat arms come out INERT on logistics
# while they dominated goldminer and rovers, that is direct evidence the flattening effect is
# about UNDOING A BAD PEAK rather than about exploration in general, which is the mechanism
# the whole two-regime account assumes but has never tested separately.
#
# WEIGHTS mirror the multiplicative rungs: 0.30 is logistics' own W = 0.301 at beta=1, then
# 0.40 and 0.60.
#
# Baseline: results/log_base. qrdqn_value=1 keeps the leaf value on the same model as every
# other logistics arm, so the only difference is the prior transform.
# Run from a COMPUTE node:  bash submit_log_flat.sh
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

# flat <outdir> <w>
flat () {
  sbatch $CPU --array=1-$N "$LAUNCH" $LD $LT $LP $LQ1 $LQ2 $LI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

flat log_flat030 0.30     # matches eps=0.30 (logistics' own W at beta=1) -- THE test
flat log_flat040 0.40     # matches eps=0.40
flat log_flat060 0.60     # matches eps=0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
