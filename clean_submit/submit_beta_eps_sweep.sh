#!/bin/bash
# ADDITIVE beta x eps_p sweep, all five domains.
#
# TWO OBSERVATIONS DROVE THIS:
#   1. beta=2 kappa=1 beat beta=1 kappa=1 on several domains, so the beta ladder was never
#      pushed far enough. Extended to 4, 6, 8.
#   2. every additive arm ran at eps_p = 0.001. In the ADDITIVE form the tilt adds
#      beta*x_a/K directly, so an action with P(a) ~ 0 still receives mass and no floor is
#      needed -- which is why it was left at 0.001. But that also means the additive arms
#      were never tested with a raised floor, while the whole multiplicative ladder was.
#      This closes that gap.
#
#     P0(a) = (1-eps_p) P(a) + eps_p/K
#     P+(a) = (P0(a) + beta x_a / K) / (1 + beta g_s)
#     c(s)  = c_puct (1 + kappa g_s)                       kappa = 1 throughout
#
# ARMS PER DOMAIN (18):
#   beta in {4,6,8}                 at eps_p = 0.001    -- the beta extension
#   beta in {1,2,4,6,8} x eps_p in {0.26, 0.40, 0.60}   -- the beta x eps grid
# beta=1 and beta=2 at eps_p=0.001 already exist as <dom>_abs_t1b1k1 / _t1b2k1.
#
# NOTE ON THE eps RUNGS. 0.26/0.40/0.60 are used verbatim on every domain so the ladder is
# identical across domains and arms compare rung-for-rung. They are NOT each domain's own
# matched mass W = beta g_s/(1+beta g_s), which differs: satellite 0.25, goldminer 0.26,
# grid 0.27, rovers 0.27, logistics 0.30. So the existing flat controls (flat025/026/027/030)
# are the right comparators for the FIRST rung on each domain, and are within 0.01-0.04 of
# it -- close, but say which you mean when reporting.
#
# SIZE: 18 arms x 584 probes = 10,512 tasks. Submit one domain at a time if the queue is
# busy: bash submit_beta_eps_sweep.sh satellite
#
# Run from a COMPUTE node:  bash submit_beta_eps_sweep.sh [domain ...]
LAUNCH=run_search_signal.sh
[ -f "$LAUNCH" ] || LAUNCH=slurm/run_search_signal.sh
[ -f "$LAUNCH" ] || { echo "ERROR: run_search_signal.sh not found in . or slurm/ (cwd=$PWD)" >&2; exit 1; }

R=/work/rleap1/ibrahim.eisawy/Neural-Guided-Search
CPU="--chdir=$R --partition=rleap_cpu --gres=none --cpus-per-task=4 --mem=16G --time=1-00:00:00 --export=ALL,OMP_NUM_THREADS=4,MKL_NUM_THREADS=4,CUDA_VISIBLE_DEVICES="

# name:prefix:N:probe_dir:policy:q1:q2:iqn
DOMAINS=(
  "goldminer:gm:118:probeGold_distinct_d5-22:goldminer_sac_policy:goldminer_sac_q1:goldminer_sac_q2:goldminer_iqn"
  "grid:grid:113:probeGrid_distinct_d5-22:grid_sac_policy:grid_sac_q1:grid_sac_q2:grid_iqn_qrdqn_best"
  "logistics:log:113:probeLog_distinct_d5-22:logistics_topo_sac_policy_best:logistics_topo_sac_q1_best:logistics_topo_sac_q2_best:logistics_topo_frozen"
  "rovers:rov:120:probeRov_distinct_d5-22:rovers_small_sac_policy_best:rovers_small_sac_q1_best:rovers_small_sac_q2_best:rovers_small_qrdqn_frozen"
  "satellite:sat:120:probeSat_distinct_d5-22:satellite_s18_sac_policy_best:satellite_s18_sac_q1_best:satellite_s18_sac_q2_best:satellite_s18_qrdqn_best"
)

WANT=("$@")
n_sub=0

for D in "${DOMAINS[@]}"; do
  IFS=: read -r NAME PFX N PROBE POL Q1 Q2 IQN <<< "$D"

  if [ ${#WANT[@]} -gt 0 ]; then
    hit=0; for w in "${WANT[@]}"; do [ "$w" = "$NAME" ] && hit=1; done
    [ $hit -eq 1 ] || continue
  fi

  DD=example/$PROBE/domain.pddl; TT=example/$PROBE
  PP=models/$POL.pth; QQ1=models/$Q1.pth; QQ2=models/$Q2.pth; II=models/$IQN.pth
  echo "=== $NAME  ($N probes)"

  # go <outdir> <beta> <eps_p>
  go () {
    sbatch $CPU --array=1-$N "$LAUNCH" $DD $TT $PP $QQ1 $QQ2 $II \
      results/$1 1800 bellman 0.0 1.5 1 0 "" add 1.0 $2 1.0 $3 >/dev/null
    n_sub=$((n_sub+1))
  }

  # --- beta extension at the existing floor ---
  for B in 4 6 8; do
    go ${PFX}_abs_b${B}k1_e001 $B 0.001
  done

  # --- beta x eps grid ---
  for B in 1 2 4 6 8; do
    for E in 026 040 060; do
      case $E in 026) EV=0.26;; 040) EV=0.40;; 060) EV=0.60;; esac
      go ${PFX}_abs_b${B}k1_e${E} $B $EV
    done
  done
done

echo "submitted $n_sub arrays"
squeue -u $USER -h -o "%T" | sort | uniq -c
