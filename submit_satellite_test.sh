#!/bin/bash
# Satellite, three arms, on the TEST probes -- a replication of the study's one positive
# result on the same footing as the other domains.
#
# WHY. The full 14-arm satellite sweep ran on example/probeSat_val_d5-20. grid, goldminer
# and logistics all evaluate on TEST; satellite and rovers were built on VAL, which was my
# inconsistency. Rovers moved to test at no cost because it had not been swept yet.
# Satellite HAS been swept, and it carries the headline finding -- real signal beats its
# matched shuffle by +43% expansions at 100% coverage, 40/4 base problems, p=0.0000 -- so
# rather than redo 14 arms, replicate the three that carry that claim:
#
#   sat_base_test            the reference
#   sat_abs_t1b1k0_test      the winning arm (prior tilt only, +43.0%, mean 0.734)
#   sat_abs_t1b1k1_shuf_test its matched control (-4.7%, mean 1.159)
#
# If the separation survives on test, the positive result is clean. If it collapses, the
# val result was partly an artefact of evaluating close to the training distribution.
#
# TEST IS A HARDER ASK, which is the point. Probe objects 56-95 (median 79) against a train
# median of 17 = 4.6x extrapolation, versus 2.2x for the val probes. That is goldminer's
# bracket (3.6x) rather than an easier one. Coverage may drop from the val sweep's 480/480;
# read the separation between the arm and its shuffle, not the absolute numbers.
#
# The gate holds on these probes: satellite_s18_qrdqn_best calibrates at -0.753 on test
# (-0.921 on val), so the value function is still usable at this size.
#
# NO REFIT NEEDED: none of these three arms uses the random control's lognormal. If the
# random arm is ever added here, refit it on the test probes first -- rovers' constants
# moved materially between val and test (0.846:-0.675 -> 1.098:-0.483).
#
# Run from a COMPUTE node:  bash submit_satellite_test.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

SD=example/probeSat_test_d5-20/domain.pddl; ST=example/probeSat_test_d5-20
SP=models/satellite_s18_sac_policy_best.pth
SQ1=models/satellite_s18_sac_q1_best.pth; SQ2=models/satellite_s18_sac_q2_best.pth
SI=models/satellite_s18_qrdqn_best.pth
N=480

# sub <outdir> <shuffle> <mode> <beta> <kappa>
sub () {
  sbatch $CPU --array=1-$N run_alphazero_bellman.sh $SD $ST $SP $SQ1 $SQ2 $SI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    $2 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" $3 1.0 $4 $5 0.001
}

sbatch $CPU --array=1-$N run_alphazero_bellman.sh $SD $ST $SP $SQ1 $SQ2 $SI \
  results/sat_base_test 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
  0 0.0 1.5 1 0.0 0.0 binc 2.0 1.0 "" off 1.0 1.0 1.0 0.001

sub sat_abs_t1b1k0_test       0 add 1.0 0.0   # the winning arm on val
sub sat_abs_t1b1k1_shuf_test  1 add 1.0 1.0   # its matched control

squeue -u $USER -h -o "%T" | sort | uniq -c
