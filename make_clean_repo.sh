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

echo
echo "copied $(ls "$DEST" | wc -l) files to $DEST"
echo
echo "NOT copied (deliberately): models/, example/, results/, venv/ -- large, and better"
echo "symlinked or left in place. To link them instead of duplicating gigabytes:"
echo "  ln -s $SRC/models   $DEST/models"
echo "  ln -s $SRC/example  $DEST/example"
echo "  ln -s $SRC/results  $DEST/results"
echo "  ln -s $SRC/venv     $DEST/venv"
