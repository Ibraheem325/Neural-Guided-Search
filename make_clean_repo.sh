#!/bin/bash
# Copy only the files the thesis actually needs into a clean directory.
#
# The working repo has 210 .py/.sh files. A dependency walk from the real entry points
# (search, training, dataset generation, the analysis pipeline) reaches 27 python files;
# the other 146 are one-off probes and superseded diagnostics accumulated over the project.
# They are worth keeping in the old directory as a record, but they make the tree unusable.
#
# COPIES ONLY -- nothing is deleted or moved. Run it, check the result, then decide.
#
# Usage:  bash make_clean_repo.sh ../Neural-Guided-Search-clean
set -e
DEST=${1:?usage: bash make_clean_repo.sh <destination-dir>}
SRC=$(pwd)

mkdir -p "$DEST"

# --- 1. BASELINE SEARCH ALGORITHMS (the benchmark from the start of the thesis) ---
BENCH="search.py qstar.py wastar.py beam.py evaluate.py
       aggregate_qstar_weight.py aggregate_alphazero.py summarize_results.py
       run_search.sh run_qstar_weight.sh run_alphazero.sh"

# --- 2. THE ALPHAZERO SEARCH UNDER TEST, and its launcher ---
SEARCH="alphaZero_bellman.py run_alphazero_bellman.sh"

# --- 3. TRAINING ---
# iqn_soft_bounds.py and rgnn_readout_fix.py are imported at runtime, not optional:
# the first supplies SoftBoundsIQNOptimization, the second patches a silent pymimir_rgnn
# multi-output bug. utils.py is imported by nearly everything.
TRAIN="train_iqn.py train_sac.py train_dqn.py train_supervised.py
       iqn_soft_bounds.py rgnn_readout_fix.py utils.py
       run_train_iqn.sh run_train_sac.sh
       train_sac.sbatch train_grid.sbatch train_iqn_ensemble.sbatch"

# --- 4. DATASETS AND PROBE SETS ---
DATA="gen_rovers_dataset.py gen_satellite_dataset.py make_probes.py
      solve_dataset.py verify_dataset.py
      run_fd_solve.sh run_fd_optimal.sh collect_fd.py"

# --- 5. MODEL DIAGNOSTICS (the gates that decide whether a model is usable) ---
DIAG="check_qrdqn_calibration.py check_training.py prior_peak.py"

# --- 6. THE ANALYSIS PIPELINE (what the results chapter is built from) ---
# domains_config.py holds the arm/probe/baseline map shared by both table scripts.
ANALYSIS="domains_config.py table_plan_len.py table_by_base.py
          cluster_contrib.py pair_contrib.py arm_totals.py
          new_signal_probe.py fit_random_control.py"

# --- 7. SWEEP SUBMISSION (one per domain, the record of what was actually run) ---
SUBMIT="submit_satellite.sh submit_satellite_rest.sh submit_satellite_test.sh
        submit_rovers.sh submit_rovers_rest.sh submit_rovers_flat.sh
        submit_abs_goldminer.sh submit_abs_grid.sh submit_abs_logistics.sh
        submit_flat_sweep.sh submit_tau_kappa.sh"

copy () {
  local group=$1; shift
  local n=0 miss=""
  mkdir -p "$DEST"
  for f in $@; do
    if [ -e "$SRC/$f" ]; then cp "$SRC/$f" "$DEST/"; n=$((n+1)); else miss="$miss $f"; fi
  done
  printf "%-12s %2d copied" "$group" "$n"
  [ -n "$miss" ] && printf "   MISSING:%s" "$miss"
  echo
}

copy BENCH    $BENCH
copy SEARCH   $SEARCH
copy TRAIN    $TRAIN
copy DATA     $DATA
copy DIAG     $DIAG
copy ANALYSIS $ANALYSIS
copy SUBMIT   $SUBMIT

# Support files that are not code but are needed to run or to reproduce.
for f in requirements.txt README.md LICENSE .gitignore; do
  [ -e "$SRC/$f" ] && cp "$SRC/$f" "$DEST/"
done

# FD-verified optimal plan lengths -- expensive to regenerate (480 FD runs each), so they
# travel with the analysis rather than being recomputed.
for f in "$SRC"/optlen_*.json; do [ -e "$f" ] && cp "$f" "$DEST/"; done


# --- 8. DATASETS AND PROBE SETS -------------------------------------------------------
# THE FIVE SWEEP DOMAINS -- the dataset each domain's models were actually trained on, and
# the probe set its sweep was actually evaluated on. Model naming tracks the dataset:
#
#   goldminer   goldminer_dataset        goldminer_sac_*, goldminer_iqn
#   grid        grid_dataset             grid_sac_*, grid_iqn_qrdqn_best
#   logistics   logistics_dataset_topo   logistics_topo_sac_*, logistics_topo_frozen
#   satellite   satellite_dataset_s18    satellite_s18_sac_*, satellite_s18_qrdqn_best
#   rovers      rovers_dataset_small     rovers_small_sac_*, rovers_small_qrdqn_frozen
#
# goldminer and grid were never regenerated -- their originals already varied the structural
# axis. The other three WERE: logistics_dataset trained on c2s1 only, rovers_dataset had
# 391/400 single-rover training instances, satellite_dataset pinned train at 1-2 satellites
# while test ran 1-8. Scale generalises, structure does not; that is what broke logistics,
# and it is why _topo / _small / _s18 exist.
DS_SWEEP="goldminer_dataset grid_dataset logistics_dataset_topo
          rovers_dataset_small satellite_dataset_s18"

# The evaluation sets: states lifted from inside solved instances at known distance 5-20
# from the goal, so the value function stays inside its calibrated range while the problems
# stay large enough to have search room. satellite has both because its full 14-arm sweep
# ran on val and the headline was replicated on test.
PROBES="probeGold_near_goal_d5-20 probe_near_goal_d5-20 probeLog_multiloc_d5-20
        probeSat_val_d5-20 probeSat_test_d5-20 probeRov_test_d5-20"

# SUPERSEDED, benchmark chapter only -- the Q* / weighted-A* / GBFS / beam comparison ran on
# these before the structural problem was found. Set KEEP_BENCH=0 to leave them out.
DS_BENCH="barman_dataset_v2 logistics_dataset rovers_dataset satellite_dataset"

copydirs () {
  local group=$1; shift
  local n=0 miss=""
  mkdir -p "$DEST/example"
  for d in $@; do
    if [ -d "$SRC/example/$d" ]; then cp -r "$SRC/example/$d" "$DEST/example/"; n=$((n+1))
    else miss="$miss $d"; fi
  done
  printf "%-12s %2d copied" "$group" "$n"
  [ -n "$miss" ] && printf "   NOT PRESENT HERE:%s" "$miss"
  echo
}

copydirs SWEEP     $DS_SWEEP
copydirs PROBES    $PROBES
[ "${KEEP_BENCH:-1}" = "1" ] && copydirs BENCH-DS  $DS_BENCH

# --- 9. MODELS ------------------------------------------------------------------------
# SWEEP MODELS: exactly what the five domains' submit scripts load. Taken from the scripts
# rather than by name-matching, because two of them are counter-intuitive:
#
#   goldminer uses goldminer_iqn.pth -- the OLD IQN, not a QR-DQN. It already calibrated at
#     slope -1.213, so it never needed the retrain that grid and the others got.
#   rovers uses rovers_small_* and the FROZEN QR-DQN. rovers_iqn.pth / rovers_sac_* are the
#     superseded r18 generation. The frozen copy matters: _best.pth is a later, worse
#     checkpoint (-0.600) and _latest.pth had collapsed entirely (-0.017), while the frozen
#     mid-run checkpoint is -0.804 and is what every rovers arm actually ran on.
MODELS_SWEEP="goldminer_iqn.pth goldminer_sac_policy.pth goldminer_sac_q1.pth goldminer_sac_q2.pth
              grid_iqn_qrdqn_best.pth grid_sac_policy.pth grid_sac_q1.pth grid_sac_q2.pth
              logistics_topo_frozen.pth logistics_topo_sac_policy_best.pth
              logistics_topo_sac_q1_best.pth logistics_topo_sac_q2_best.pth
              satellite_s18_qrdqn_best.pth satellite_s18_sac_policy_best.pth
              satellite_s18_sac_q1_best.pth satellite_s18_sac_q2_best.pth
              rovers_small_qrdqn_frozen.pth rovers_small_sac_policy_best.pth
              rovers_small_sac_q1_best.pth rovers_small_sac_q2_best.pth"

# BENCHMARK MODELS: the DQN and supervised policy per domain, used by the Q* / weighted-A* /
# GBFS / beam comparison. barman has both but no usable SAC or QR-DQN, so it appears here
# only. barman_v2 is the real benchmark set -- barman_dqn/supervised are the easy v1 pool
# where weighting merely halves expansions (99% coverage at w=1), not the 3.7% -> 50.5% story.
MODELS_BENCH="barman_v2_dqn.pth barman_v2_supervised.pth
              goldminer_dqn.pth goldminer_supervised.pth
              grid_dqn.pth grid_supervised.pth
              logistics_dqn.pth logistics_supervised.pth
              rovers_dqn.pth rovers_supervised.pth
              satellite_dqn.pth satellite_supervised.pth"

copymodels () {
  local group=$1; shift
  local n=0 miss=""
  mkdir -p "$DEST/models"
  for f in $@; do
    if [ -e "$SRC/models/$f" ]; then cp "$SRC/models/$f" "$DEST/models/"; n=$((n+1))
    else miss="$miss $f"; fi
  done
  printf "%-12s %2d copied" "$group" "$n"
  [ -n "$miss" ] && printf "   NOT PRESENT HERE:%s" "$miss"
  echo
}

copymodels MODELS    $MODELS_SWEEP
[ "${KEEP_BENCH:-1}" = "1" ] && copymodels MODELS-BM $MODELS_BENCH

echo
echo "copied $(ls "$DEST" | wc -l) top-level entries to $DEST"
du -sh "$DEST" 2>/dev/null
echo
echo "NOT copied (deliberately): models/, results/, venv/ -- gigabytes. Link them:"
echo "  ln -s $SRC/models   $DEST/models"
echo "  ln -s $SRC/results  $DEST/results"
echo "  ln -s $SRC/venv     $DEST/venv"
