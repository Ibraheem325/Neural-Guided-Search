#!/bin/bash
# DeltaU / DeltaQ for BASELINE vs REAL SIGNAL vs RANDOM, all five domains.
#
# THE QUESTION (supervisor): "what are DeltaU and DeltaQ in the random approach? If DeltaU
# is low it mostly serves as a tie-breaker among already-good options."
#
# The DeltaU/DeltaQ figures reported so far (satellite 0.74 ... logistics 0.43) were measured
# with --abs_signal off -- they describe the RAW SAC prior, not any treatment arm. The real
# arm and the random control both search with
#
#     P+(a) = (P0(a) + beta x_a / K) / (1 + beta g_s)
#
# built from real e_a and from drawn e~_a respectively. Those two priors have different
# spreads, so they have different DeltaU, and neither equals the baseline's. This measures
# all three on the same probes.
#
# WHAT THE ANSWER WOULD MEAN. If the random arm's DeltaU is much SMALLER than the real
# arm's, the supervisor's reading is right: random works by breaking ties among options the
# policy already ranks well, not by redirecting search. If the two are comparable, then
# random and the real signal perturb by the same amount and the difference between them is
# purely WHERE the mass goes -- which is what the shuffle control isolates.
#
# Also worth reading from collect_diag: the share of decisions where DeltaQ = 0. There the
# value function discriminates nothing and the prior IS the tie-breaker, whatever its
# spread. Baseline figures were 8-20% depending on domain.
#
# 15 arrays, 1,752 tasks at 60s. DeltaU/DeltaQ is a property of the selection arithmetic,
# not of the search budget, so 60s is plenty.
#
# Run from a COMPUTE node:  bash submit_diag_arms.sh [domain ...]
LAUNCH=run_diag_select.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_diag_select.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_diag_select.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=02:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

# name:tag:N:probe:policy:q1:iqn:LN
DOMAINS=(
  "goldminer:gold:118:probeGold_distinct_d5-22:goldminer_sac_policy:goldminer_sac_q1:goldminer_iqn:lognormal:0.999:-0.757"
  "grid:grid:113:probeGrid_distinct_d5-22:grid_sac_policy:grid_sac_q1:grid_iqn_qrdqn_best:lognormal:1.093:-0.710"
  "logistics:log:113:probeLog_distinct_d5-22:logistics_topo_sac_policy_best:logistics_topo_sac_q1_best:logistics_topo_frozen:lognormal:0.839:-0.307"
  "rovers:rov:120:probeRov_distinct_d5-22:rovers_small_sac_policy_best:rovers_small_sac_q1_best:rovers_small_qrdqn_frozen:lognormal:1.030:-0.578"
  "satellite:sat:120:probeSat_distinct_d5-22:satellite_s18_sac_policy_best:satellite_s18_sac_q1_best:satellite_s18_qrdqn_best:lognormal:0.717:-0.831"
)

WANT=("$@"); n=0
for D in "${DOMAINS[@]}"; do
  # LN contains colons, so split off the first 7 fields and keep the rest
  NAME=${D%%:*}; REST=${D#*:}
  TAG=${REST%%:*}; REST=${REST#*:}
  N=${REST%%:*};   REST=${REST#*:}
  PROBE=${REST%%:*}; REST=${REST#*:}
  POL=${REST%%:*};  REST=${REST#*:}
  Q1=${REST%%:*};   REST=${REST#*:}
  IQN=${REST%%:*};  LN=${REST#*:}

  if [ ${#WANT[@]} -gt 0 ]; then
    hit=0; for w in "${WANT[@]}"; do [ "$w" = "$NAME" ] && hit=1; done
    [ $hit -eq 1 ] || continue
  fi

  A="example/$PROBE models/$POL.pth models/$Q1.pth models/$IQN.pth"
  echo "=== $NAME ($N probes)   LN=$LN"

  sbatch $CPU --array=1-$N "$LAUNCH" $A results/diag_${TAG}_base 60 1.5 off 1.0 1.0 0.001 0 ""    >/dev/null
  sbatch $CPU --array=1-$N "$LAUNCH" $A results/diag_${TAG}_sig  60 1.5 add 1.0 1.0 0.001 0 ""    >/dev/null
  sbatch $CPU --array=1-$N "$LAUNCH" $A results/diag_${TAG}_rnd  60 1.5 add 1.0 1.0 0.001 0 "$LN" >/dev/null
  n=$((n+3))
done
echo "submitted $n arrays"
squeue -u $USER -h -o "%T" | sort | uniq -c
