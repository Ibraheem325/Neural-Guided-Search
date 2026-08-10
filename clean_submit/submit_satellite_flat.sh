#!/bin/bash
# Satellite: signal-free FLATTENING at matched weights -- the rung satellite is missing.
#
# WHY THIS IS THE MOST IMPORTANT ARM IN THE STUDY. Satellite is the one domain where the
# signal wins: it beats its matched shuffle at 100% coverage, 35/3 base problems, p=0.0000.
# The explanation on offer is that the signal earns its keep where the prior is confidently
# RIGHT (satellite conf-wrong 4.4%) and blind perturbation matches or beats it where the
# prior is confidently WRONG (grid 20.8%, rovers 18.7%, goldminer 11.0%).
#
# But that explanation has a hole: on goldminer and rovers the arm that actually won was
# signal-free flattening, and satellite has never been run against it.
#   goldminer   flat w=0.28 beat EVERY signal arm, coverage 337 -> 478 / 480
#   rovers      flat060 vs eps=0.60 head-to-head p = 0.7359 -- the effect was DOSE, not signal
# Satellite's shuffle and random controls hold the injected MASS fixed and destroy only the
# placement or the per-state structure. Flattening is the stricter test: same mass, no IQN
# call at all, no Bellman residual anywhere.
#
#     prior'(a) = (1-w) P(a) + w/K        (--signal constant --const_w w)
#
# If the signal still beats flat025 at matched mass, the positive result survives the
# control that killed the other two domains, and the confidently-right/confidently-wrong
# account holds across all five. If flat025 matches it, satellite's win is dose as well and
# the study has no positive result -- which is a finding, and better found here than by a
# reviewer.
#
# WEIGHTS mirror the multiplicative rungs so the pairs are matched. 0.25 is satellite's own
# W = beta*g_s/(1+beta*g_s) = 0.247 at beta=1, refit on probeSat_distinct_d5-22 (the old
# probe set gave 0.227 -- every constant moved, so the old value would not be matched to
# anything). 0.40 is both the next rung and satellite's W at beta=2 (0.397). 0.60 carries
# over so the ladder lines up with grid, goldminer and rovers.
#
# CAVEAT specific to satellite: these probes carry a median 274 applicable actions against
# rovers' ~30, and flattening puts w/K on each of them. At K=274 that is a far thinner
# spread per action than the same w buys on a narrow domain, so a null here is weaker
# evidence than a null on rovers would be. Read it together with the eps ladder in
# submit_satellite_rest.sh, which perturbs the same mass multiplicatively.
#
# Baseline: results/sat_base (submitted by submit_satellite.sh). qrdqn_value=1 keeps the
# leaf value on the same model as every other satellite arm, so the only difference is the
# prior transform.
# Run from a COMPUTE node:  bash submit_satellite_flat.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/probeSat_distinct_d5-22/domain.pddl; ST=example/probeSat_distinct_d5-22
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=120

# flat <outdir> <w>
# Positional args 8..19: max_time 1800, signal constant, const_w $2, c_puct 1.5,
# qrdqn_value 1, shuffle 0, no random spec, abs_signal off (no IQN, no residual).
flat () {
  sbatch $CPU --array=1-$N run_search_signal.sh $SD $ST $SP $SQ1 $SQ2 $SI \
    results/$1 1800 constant $2 1.5 1 0 "" off 1.0 1.0 1.0 0.001
}

flat sat_flat025 0.25     # matches eps=0.25 (satellite's own W at beta=1) -- THE test
flat sat_flat040 0.40     # matches eps=0.40, and W at beta=2
flat sat_flat060 0.60     # matches eps=0.60

squeue -u $USER -h -o "%T" | sort | uniq -c
