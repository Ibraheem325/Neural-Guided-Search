#!/bin/bash
# The four logistics arms missing from the results tables:
#   additive:       beta=0 kappa=1 (c(s) only)  and  the RANDOM control
#   multiplicative: eps_p = 0.40 and 0.60
# so logistics can be reported in the same columns as goldminer and grid.
#
# RANDOM CONTROL. The spec is domain-specific and must be refitted, not copied. OPTION 9
# consumes RAW residuals e (no sibling division), so the draw has to match that marginal
# or g_s comes out at the wrong level. Fitted to logistics' own residuals
# (logi_signal_data.json, n=18164 edges): mu=-0.461 sigma=0.992. Verified this reproduces
# mean g_s to within 0.007 (0.4058 drawn vs 0.3991 real) while destroying the
# state-to-state structure (sd 0.0437 drawn vs 0.0551 real), which is the point of the
# control: if the real arm beats it, the PER-STATE magnitude of the residual carries
# information. Goldminer's mu=-0.585 sigma=1.003 would be wrong here.
#
# NOTE the c(s) arm on its own is a table row, not a controlled test -- it changes
# c_puct 1.5 -> 1.5*(1+mean g_s) as well as varying it per state. On goldminer and grid
# the matched-level control (kappa=0 at the raised c_puct) showed the per-state part
# contributes nothing. Logistics' mean g_s is 0.399, so the matched control would be
# c_puct = 1.5*1.399 = 2.10; the last line submits it, commented out by default since the
# channel is already a two-domain null.
#
# Baseline: results/multiloc_base_topopolicy (272/288 = 94.4%, median 3370 expansions).
# Run from a COMPUTE node:  bash submit_logi_missing.sh
R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

LD=example/probeLog_multiloc_d5-20/domain.pddl; LT=example/probeLog_multiloc_d5-20
LP=models/logistics_topo_sac_policy_best.pth
LQ1=models/logistics_topo_sac_q1_best.pth; LQ2=models/logistics_topo_sac_q2_best.pth
LI=models/logistics_topo_frozen.pth
N=288
LN=lognormal:0.992:-0.461      # fitted to logistics' OWN raw-e marginal

# sub <outdir> <c_puct> <random_spec> <mode> <beta> <kappa> <eps_p>
# args 8..37; 25=C_PUCT, 26=QRDQN_VALUE=1, 32=SIB_RANDOM, 33-37=ABS_*.
sub () {
  sbatch $CPU --array=1-$N run_alphazero_bellman.sh $LD $LT $LP $LQ1 $LQ2 $LI \
    results/$1 0.0 4 bellman 1800 0.0 0.95 "" 0.0 0.0 0.0 "" 5 0.0 0 0.0 \
    0 0.0 $2 1 0.0 0.0 binc 2.0 1.0 "$3" $4 1.0 $5 $6 $7
}

# ---- additive: the two missing rows ----
sub logi_abs_t1b0k1       1.5 ""    add 0.0 1.0 0.001   # c(s) only, prior untouched
sub logi_abs_t1b1k1_rndm  1.5 "$LN" add 1.0 1.0 0.001   # random control

# ---- multiplicative: the two missing eps_p rungs ----
sub logi_mul_e040_k0      1.5 ""    mul 1.0 0.0 0.40
sub logi_mul_e060_k0      1.5 ""    mul 1.0 0.0 0.60

# ---- optional matched-level control for the c(s) row (see header) ----
# sub logi_abs_t1b0k1_ctl 2.10 ""   add 0.0 0.0 0.001

squeue -u $USER -h -o "%T" | sort | uniq -c
