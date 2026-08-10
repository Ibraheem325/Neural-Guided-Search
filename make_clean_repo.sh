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
# Two generations, and BOTH are needed.
#
# ORIGINAL: what the start-of-thesis benchmark (Q*, weighted A*, GBFS, beam) ran on.
# STUDY:    regenerated because the originals had a structural blind spot -- logistics
#           trained on c2s1 only, rovers had 391/400 single-rover training instances,
#           satellite pinned train at 1-2 satellites while test ran 1-8. Scale generalises,
#           structure does not; that is what broke logistics and it is why the _topo /
#           _small / _s18 variants exist. goldminer and grid needed no replacement.
# PROBES:   the evaluation sets. Each is 480 states (288 for logistics) lifted from inside
#           solved instances at known distance 5-20 from the goal, so the value function
#           stays in its calibrated range while the problems stay large enough to have
#           search room.
DS_ORIGINAL="barman_dataset_v2 goldminer_dataset grid_dataset
             logistics_dataset rovers_dataset satellite_dataset"
DS_STUDY="logistics_dataset_topo rovers_dataset_small satellite_dataset_s18"
PROBES="probeGold_near_goal_d5-20 probe_near_goal_d5-20 probeLog_multiloc_d5-20
        probeSat_val_d5-20 probeSat_test_d5-20 probeRov_test_d5-20"

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

copydirs DS-ORIG   $DS_ORIGINAL
copydirs DS-STUDY  $DS_STUDY
copydirs PROBES    $PROBES

echo
echo "copied $(ls "$DEST" | wc -l) top-level entries to $DEST"
du -sh "$DEST" 2>/dev/null
echo
echo "NOT copied (deliberately): models/, results/, venv/ -- gigabytes. Link them:"
echo "  ln -s $SRC/models   $DEST/models"
echo "  ln -s $SRC/results  $DEST/results"
echo "  ln -s $SRC/venv     $DEST/venv"
