#!/bin/bash
# Build a clean, organised copy of the thesis code.
#
# The working repo has 210 .py/.sh files at the top level. A dependency walk from the real
# entry points reaches 27 python files; the rest are one-off probes and superseded
# diagnostics. They stay in the original directory as a record -- this copies only what is
# needed, into a tree you can navigate.
#
# LAYOUT
#   training/   the training code and its launchers
#   slurm/      every sbatch launcher and per-domain sweep submitter
#   (root)      search, dataset/probe generation, model gates, analysis
#   example/    the five sweep datasets + probe sets (+ benchmark datasets)
#   models/     the models those sweeps actually load (+ benchmark DQN/supervised)
#
# Moving files breaks relative paths, so the script REWRITES the affected references in the
# COPIES:
#   run_train_*.sh   call training/train_*.py, and export PYTHONPATH so `import utils` works
#   submit_*.sh      call slurm/run_alphazero_bellman.sh
# Everything still assumes it is run FROM THE REPO ROOT, which is what --chdir gives.
#
# COPIES ONLY -- nothing is deleted or moved from the source.
#
# Usage:  bash make_clean_repo.sh ../Neural-Guided-Search-clean
#         KEEP_BENCH=0 bash make_clean_repo.sh <dir>     # skip the benchmark chapter
set -e
DEST=${1:?usage: bash make_clean_repo.sh <destination-dir>}
SRC=$(pwd)

# Refuse to build into a non-empty directory. An earlier version of this script copied
# everything flat; running the reorganised version over the top left BOTH layouts in place
# (stale .py and .sh at the root alongside the new training/ and slurm/), which looks like
# the reorganisation silently failed. Set FORCE=1 to wipe and rebuild.
if [ -d "$DEST" ] && [ -n "$(ls -A "$DEST" 2>/dev/null)" ]; then
  if [ "${FORCE:-0}" = "1" ]; then
    echo "FORCE=1: removing existing $DEST"
    rm -rf "$DEST"
  else
    echo "ERROR: $DEST already exists and is not empty."
    echo "       Building over it would mix layouts. Either:"
    echo "         rm -rf $DEST && bash $0 $DEST"
    echo "       or:"
    echo "         FORCE=1 bash $0 $DEST"
    exit 1
  fi
fi
mkdir -p "$DEST" "$DEST/training" "$DEST/slurm"

# ---------------------------------------------------------------- file groups ----------
# ROOT: baseline search algorithms (the start-of-thesis benchmark), the AlphaZero search
# under test, dataset/probe generation, the model gates, and the analysis pipeline.
# utils.py and rgnn_readout_fix.py stay at root so plain `import utils` keeps working;
# rgnn_readout_fix patches a silent pymimir_rgnn multi-output bug and is not optional.
# alphaZero.py is the plain AlphaZero the benchmark runs (run_alphazero.sh invokes it);
# alphaZero_bellman.py is the version under test. The other eight alphaZero_* variants
# (decoupled/ensemble/mix/w1/width) are superseded experiments, deliberately left behind.
# greedy_value_plan.py and greedy_sac_plan.py are run_search.sh's greedy_value / greedy_sac
# modes; new_signal_report.py produced the offline arm-ranking and g_s AUC evidence that
# submit_abs_goldminer.sh's header cites.
ROOT_PY="search.py qstar.py wastar.py beam.py evaluate.py
         aggregate_qstar_weight.py aggregate_alphazero.py summarize_results.py
         alphaZero.py alphaZero_bellman.py
         utils.py rgnn_readout_fix.py
         gen_rovers_dataset.py gen_satellite_dataset.py make_probes.py
         solve_dataset.py verify_dataset.py collect_fd.py
         check_qrdqn_calibration.py check_training.py prior_peak.py
         domains_config.py table_plan_len.py table_by_base.py
         cluster_contrib.py pair_contrib.py arm_totals.py
         new_signal_probe.py new_signal_report.py fit_random_control.py
         greedy_value_plan.py greedy_sac_plan.py"

# TRAINING: the trainers plus iqn_soft_bounds.py (SoftBoundsIQNOptimization, imported at
# runtime by train_iqn.py) and the launchers/sbatch files.
TRAIN_FILES="train_iqn.py train_sac.py train_dqn.py train_supervised.py
             iqn_soft_bounds.py
             run_train_iqn.sh run_train_sac.sh
             train_sac.sbatch train_grid.sbatch train_iqn_ensemble.sbatch"

# SLURM: every launcher and per-domain sweep submitter -- the record of what was run.
SLURM_FILES="run_alphazero_bellman.sh run_search.sh run_qstar_weight.sh run_alphazero.sh
             run_fd_solve.sh run_fd_optimal.sh
             submit_satellite.sh submit_satellite_rest.sh submit_satellite_test.sh
             submit_rovers.sh submit_rovers_rest.sh submit_rovers_flat.sh
             submit_abs_goldminer.sh submit_abs_grid.sh submit_abs_logistics.sh
             submit_flat_sweep.sh submit_tau_kappa.sh"

# ---------------------------------------------------------------- datasets -------------
# The five sweep domains and the dataset each domain's models were trained on:
#   goldminer  goldminer_dataset       grid       grid_dataset
#   logistics  logistics_dataset_topo  satellite  satellite_dataset_s18
#   rovers     rovers_dataset_small
# goldminer and grid were never regenerated -- their originals already varied the structural
# axis. The other three were: logistics trained on c2s1 only, rovers had 391/400 single-rover
# training instances, satellite pinned train at 1-2 satellites while test ran 1-8.
DS_SWEEP="goldminer_dataset grid_dataset logistics_dataset_topo
          rovers_dataset_small satellite_dataset_s18"
PROBES="probeGold_near_goal_d5-20 probe_near_goal_d5-20 probeLog_multiloc_d5-20
        probeSat_val_d5-20 probeSat_test_d5-20 probeRov_test_d5-20"
DS_BENCH="barman_dataset_v2 logistics_dataset rovers_dataset satellite_dataset"

# ---------------------------------------------------------------- models ---------------
# Taken from the submit scripts, not by name-matching -- two are counter-intuitive:
#   goldminer loads goldminer_iqn.pth, the OLD IQN (already -1.213, never needed the QR-DQN
#     retrain that grid and the others got).
#   rovers loads rovers_small_qrdqn_FROZEN.pth: _best is a later, worse checkpoint (-0.600)
#     and _latest had collapsed to -0.017 while validation still reported improvement.
# goldminer_iqn_qrdqn_best.pth is included although the SWEEP loaded goldminer_iqn.pth --
# goldminer's old IQN was already calibrated so the QR-DQN was never swapped in, but it was
# trained and belongs with the other four domains' QR-DQNs.
MODELS_SWEEP="goldminer_iqn.pth goldminer_iqn_qrdqn_best.pth
              goldminer_sac_policy.pth goldminer_sac_q1.pth goldminer_sac_q2.pth
              grid_iqn_qrdqn_best.pth grid_sac_policy.pth grid_sac_q1.pth grid_sac_q2.pth
              logistics_topo_frozen.pth logistics_topo_sac_policy_best.pth
              logistics_topo_sac_q1_best.pth logistics_topo_sac_q2_best.pth
              satellite_s18_qrdqn_best.pth satellite_s18_sac_policy_best.pth
              satellite_s18_sac_q1_best.pth satellite_s18_sac_q2_best.pth
              rovers_small_qrdqn_frozen.pth rovers_small_sac_policy_best.pth
              rovers_small_sac_q1_best.pth rovers_small_sac_q2_best.pth"
# barman_v2 rather than barman: v1 is the easy pool (99% at w=1), v2 is the 0% -> 50.5% result.
MODELS_BENCH="barman_v2_dqn.pth barman_v2_supervised.pth
              goldminer_dqn.pth goldminer_supervised.pth
              grid_dqn.pth grid_supervised.pth
              logistics_dqn.pth logistics_supervised.pth
              rovers_dqn.pth rovers_supervised.pth
              satellite_dqn.pth satellite_supervised.pth"

# ---------------------------------------------------------------- copy helpers ---------
copy () {   # copy <label> <subdir-or-.> <files...>
  local group=$1 sub=$2; shift 2
  local n=0 miss=""
  mkdir -p "$DEST/$sub"
  for f in $@; do
    if [ -e "$SRC/$f" ]; then cp "$SRC/$f" "$DEST/$sub/"; n=$((n+1)); else miss="$miss $f"; fi
  done
  printf "%-11s %2d -> %-10s" "$group" "$n" "$sub"
  [ -n "$miss" ] && printf "  MISSING:%s" "$miss"
  echo
}
copytree () {   # copytree <label> <under> <dirs...>
  local group=$1 under=$2; shift 2
  local n=0 miss=""
  mkdir -p "$DEST/$under"
  for d in $@; do
    if [ -d "$SRC/$under/$d" ]; then cp -r "$SRC/$under/$d" "$DEST/$under/"; n=$((n+1))
    else miss="$miss $d"; fi
  done
  printf "%-11s %2d -> %-10s" "$group" "$n" "$under/"
  [ -n "$miss" ] && printf "  NOT HERE:%s" "$miss"
  echo
}

copyfiles () {   # copyfiles <label> <under> <files...>  -- SRC/<under>/f -> DEST/<under>/f
  local group=$1 under=$2; shift 2
  local n=0 miss=""
  mkdir -p "$DEST/$under"
  for f in $@; do
    if [ -e "$SRC/$under/$f" ]; then cp "$SRC/$under/$f" "$DEST/$under/"; n=$((n+1))
    else miss="$miss $f"; fi
  done
  printf "%-11s %2d -> %-10s" "$group" "$n" "$under/"
  [ -n "$miss" ] && printf "  NOT HERE:%s" "$miss"
  echo
}

copy ROOT     .         $ROOT_PY
copy TRAINING training  $TRAIN_FILES
copy SLURM    slurm     $SLURM_FILES
copytree DATASETS example $DS_SWEEP
copytree PROBES   example $PROBES
copyfiles MODELS  models  $MODELS_SWEEP
if [ "${KEEP_BENCH:-1}" = "1" ]; then
  copytree BENCH-DS example $DS_BENCH
  copyfiles BENCH-MD models $MODELS_BENCH
fi

for f in requirements.txt README.md LICENSE .gitignore; do
  [ -e "$SRC/$f" ] && cp "$SRC/$f" "$DEST/"
done
# FD-verified optimal plan lengths: 480 Fast Downward runs per domain to regenerate.
for f in "$SRC"/optlen_*.json; do [ -e "$f" ] && cp "$f" "$DEST/"; done

# ---------------------------------------------------------------- path fixups ----------
# The moves above break two classes of reference. Fix them in the COPIES only.
echo
echo "rewriting paths in the copied scripts:"

# 1. run_train_*.sh invoke the trainers, now under training/. They also need the repo root
#    on PYTHONPATH, because python sets sys.path[0] to training/ and `import utils` would
#    otherwise fail.
for f in "$DEST"/training/run_train_*.sh; do
  [ -e "$f" ] || continue
  perl -0pi -e 's{venv/bin/python (train_[a-z_]+\.py)}{venv/bin/python training/$1}g' "$f"
  grep -q 'PYTHONPATH' "$f" || perl -0pi -e 's{(\nvenv/bin/python training/)}{\nexport PYTHONPATH="\$PWD:\$PYTHONPATH"$1}' "$f"
  echo "  training/$(basename $f): trainer path + PYTHONPATH"
done

# 2. submit_*.sh call run_alphazero_bellman.sh, now under slurm/.
for f in "$DEST"/slurm/submit_*.sh; do
  [ -e "$f" ] || continue
  if grep -q ' run_alphazero_bellman.sh' "$f"; then
    perl -0pi -e 's{ run_alphazero_bellman\.sh}{ slurm/run_alphazero_bellman.sh}g' "$f"
    echo "  slurm/$(basename $f): -> slurm/run_alphazero_bellman.sh"
  fi
done

# ---------------------------------------------------------------- sanity check ---------
# Every .py invoked by a copied .sh must exist in the tree. run_alphazero.sh calling
# alphaZero.py was missed once; this makes that class of omission impossible to ship.
echo
missing_py=""
for sh in "$DEST"/slurm/*.sh "$DEST"/training/*.sh; do
  [ -e "$sh" ] || continue
  for py in $(grep -oE '[A-Za-z0-9_/]+\.py' "$sh" | sort -u); do
    case "$py" in *downward*) continue;; esac
    base=$(basename "$py")
    if [ ! -e "$DEST/$base" ] && [ ! -e "$DEST/training/$base" ] && [ ! -e "$DEST/$py" ]; then
      missing_py="$missing_py\n  $(basename $sh) invokes $py -- NOT IN TREE"
    fi
  done
done
if [ -n "$missing_py" ]; then
  echo "WARNING: broken script references:"; printf "$missing_py\n"
else
  echo "check: every .py invoked by a copied .sh is present"
fi

echo
echo "$DEST"
echo "  root      $(ls -1 "$DEST"/*.py 2>/dev/null | wc -l) python files"
echo "  training/ $(ls -1 "$DEST"/training 2>/dev/null | wc -l) files"
echo "  slurm/    $(ls -1 "$DEST"/slurm 2>/dev/null | wc -l) files"
echo "  example/  $(ls -1 "$DEST"/example 2>/dev/null | wc -l) datasets/probe sets"
echo "  models/   $(ls -1 "$DEST"/models 2>/dev/null | wc -l) checkpoints"
du -sh "$DEST" 2>/dev/null
echo
echo "results/ and venv/ not copied. Link them:"
echo "  ln -s $SRC/results $DEST/results"
echo "  ln -s $SRC/venv    $DEST/venv"
echo
echo "Run everything FROM THE REPO ROOT:"
echo "  sbatch training/run_train_iqn.sh example/rovers_dataset_small models/rov_ lifted"
echo "  bash   slurm/submit_rovers.sh"
echo "  venv/bin/python table_by_base.py --domain rovers"
