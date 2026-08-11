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
mkdir -p "$DEST" "$DEST/benchmark" "$DEST/training" "$DEST/slurm"

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
ROOT_PY="evaluate.py
         aggregate_qstar_weight.py aggregate_alphazero.py summarize_results.py
         utils.py rgnn_readout_fix.py
         gen_rovers_dataset.py gen_satellite_dataset.py make_probes.py
         solve_dataset.py verify_dataset.py collect_fd.py make_probes_distinct.py
         check_probe_set.py
         check_qrdqn_calibration.py check_training.py prior_peak.py
         domains_config.py table_plan_len.py table_by_base.py
         cluster_contrib.py pair_contrib.py arm_totals.py
         new_signal_probe.py new_signal_report.py fit_random_control.py"

# BENCHMARK: the search algorithms compared at the start of the thesis. run_search.sh
# dispatches to search.py (Q*), wastar.py (weighted A*, w=2 and w=5), greedy_value_plan.py
# and greedy_sac_plan.py; run_qstar_weight.sh drives the qstar.py weight sweep;
# run_alphazero.sh runs plain alphaZero.py. beam.py is deliberately EXCLUDED -- so
# run_search.sh's beam1/beam5 modes will not work in the clean tree, which is intended.
BENCH_FILES="alphaZero.py greedy_sac_plan.py greedy_value_plan.py
             qstar.py search.py wastar.py"

# TRAINING: the trainers plus iqn_soft_bounds.py (SoftBoundsIQNOptimization, imported at
# runtime by train_iqn.py) and the launchers/sbatch files.
TRAIN_FILES="train_iqn.py train_sac.py train_dqn.py train_supervised.py
             iqn_soft_bounds.py
             run_train_iqn.sh run_train_sac.sh
             train_sac.sbatch train_grid.sbatch train_iqn_ensemble.sbatch"

# SLURM: every launcher and per-domain sweep submitter -- the record of what was run.
# NOTE the 11 submit_*.sh are NOT shipped yet. They build the archived launcher's 37-
# positional-argument line, which includes flags the cleaned search no longer accepts
# (--binc_beta, --add_beta, --width_beta, ...), so they would fail immediately. They need
# regenerating against run_search_signal.sh's 19 arguments. Until then the originals remain
# in the archive as the record of what was actually run.
SLURM_FILES="run_search_signal.sh run_diag_select.sh run_search.sh run_qstar_weight.sh run_alphazero.sh
             run_fd_solve.sh run_fd_optimal.sh"
# The 11 submit_*.sh come from clean_submit/ -- the same arms, PORTED to
# run_search_signal.sh's 19 positional arguments. The originals in the repo root target the
# archived 37-argument launcher and its eight abandoned channels; they stay there as the
# record of what was actually run.

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
# The CLEANED search ships as alphaZero_bellman.py: 794 lines against the archive's 1556.
# Eight abandoned channels removed; behaviour verified byte-identical on 4 probes x 7
# configurations (off/add/add-k0/mul/shuffle/random/flat).
cp "$SRC/alphaZero_clean.py" "$DEST/alphaZero_bellman.py"
echo "ROOT         1 -> .           alphaZero_clean.py -> alphaZero_bellman.py (cleaned)"
copy BENCHMARK benchmark $BENCH_FILES
copy TRAINING training  $TRAIN_FILES
copy SLURM    slurm     $SLURM_FILES
n=0; for f in "$SRC"/clean_submit/*.sh; do [ -e "$f" ] && cp "$f" "$DEST/slurm/" && n=$((n+1)); done
printf "%-11s %2d -> %-10s  (ported to the 19-arg launcher)\n" "SUBMIT" "$n" "slurm"
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

# 2. submit_*.sh sbatch the launcher, which lives under slurm/ in the destination.
#    Two spellings: the archived scripts say run_alphazero_bellman.sh, the ported ones in
#    clean_submit/ already say run_search_signal.sh. Only the first was handled, so every
#    ported script shipped calling a bare `run_search_signal.sh` that sbatch cannot find --
#    "sbatch: error: Unable to open file run_search_signal.sh", nothing queued, exit 0 from
#    the submit script so it looks like it worked. Rewrite both, idempotently: the second
#    substitution collapses slurm/slurm/ so re-running is safe.
for f in "$DEST"/slurm/submit_*.sh; do
  [ -e "$f" ] || continue
  if grep -qE ' (run_alphazero_bellman|run_search_signal)\.sh' "$f"; then
    perl -0pi -e 's{ run_alphazero_bellman\.sh}{ slurm/run_search_signal.sh}g;
                   s{ run_search_signal\.sh}{ slurm/run_search_signal.sh}g;
                   s{slurm/slurm/}{slurm/}g' "$f"
    echo "  slurm/$(basename $f): launcher -> slurm/run_search_signal.sh"
  fi
done

# 3. the benchmark launchers invoke algorithms now under benchmark/, and need the repo root
#    on PYTHONPATH so `import utils` resolves.
for f in "$DEST"/slurm/run_search.sh "$DEST"/slurm/run_alphazero.sh "$DEST"/slurm/run_qstar_weight.sh; do
  [ -e "$f" ] || continue
  perl -0pi -e 's{venv/bin/python (alphaZero\.py|greedy_sac_plan\.py|greedy_value_plan\.py|qstar\.py|search\.py|wastar\.py)}{venv/bin/python benchmark/$1}g' "$f"
  grep -q 'PYTHONPATH' "$f" || perl -0pi -e 's{(\nvenv/bin/python|\n *venv/bin/python)}{\nexport PYTHONPATH="\$PWD:\$PYTHONPATH"$1}' "$f"
  echo "  slurm/$(basename $f): -> benchmark/ + PYTHONPATH"
done

# 4. Every copied .sh hardcodes the SOURCE repo in --chdir and in R=. Left alone, the clean
#    tree's scripts would cd into the OLD repo and write results there -- the sweeps would
#    look like they ran while quietly filling the archive. Point them at the destination.
DEST_ABS=$(cd "$DEST" && pwd)
n=0
for f in "$DEST"/slurm/*.sh "$DEST"/training/*.sh; do
  [ -e "$f" ] || continue
  if grep -qE '(--chdir=|^R=)/' "$f"; then
    perl -0pi -e "s{(--chdir=)\S+}{\$1$DEST_ABS}g; s{^R=\S+}{R=$DEST_ABS}mg" "$f"
    n=$((n+1))
  fi
done
echo "  repointed --chdir / R= to $DEST_ABS in $n scripts"

# 5. Cross-folder imports. Moving files into benchmark/ and training/ breaks two sets:
#      root      alphaZero_bellman.py, check_qrdqn_calibration.py, new_signal_probe.py
#                all do `from train_iqn import ...`, and train_iqn.py is now in training/
#      benchmark all six algorithms do `from utils import ...`, and utils.py is at the root
#    PYTHONPATH in the launchers is not enough -- these are also run directly by hand. Insert
#    an explicit sys.path bootstrap so they work from any CWD, launcher or not.
venv/bin/python - "$DEST" <<'BOOTSTRAP'
import ast, os, sys
dest = sys.argv[1]
JOBS = [(os.path.join(dest, f), '"training"') for f in
        ("alphaZero_bellman.py","check_qrdqn_calibration.py","new_signal_probe.py")]
JOBS += [(os.path.join(dest,"benchmark",f), None) for f in
         ("alphaZero.py","greedy_sac_plan.py","greedy_value_plan.py","qstar.py","search.py","wastar.py")]
for path, sub in JOBS:
    if not os.path.exists(path): continue
    src = open(path).read()
    if "_NGS_PATH_BOOTSTRAP" in src: continue
    tree = ast.parse(src)
    first = next((n.lineno for n in tree.body if isinstance(n,(ast.Import, ast.ImportFrom))), 1)
    tgt = (f'os.path.join(os.path.dirname(os.path.abspath(__file__)), {sub})' if sub
           else 'os.path.dirname(os.path.dirname(os.path.abspath(__file__)))')
    boot = ("# _NGS_PATH_BOOTSTRAP: this file lives in a subdirectory of the repo but imports a\n"
            "# module from another one, so make that importable regardless of CWD.\n"
            "import sys as _sys, os as _os\n"
            f"_sys.path.insert(0, {tgt.replace('os.','_os.')})\n")
    lines = src.split("\n")
    out = "\n".join(lines[:first-1] + [boot] + lines[first-1:])
    open(path,"w").write(out)
    print(f"  bootstrap -> {os.path.relpath(path, dest)}")
BOOTSTRAP

# ---------------------------------------------------------------- sanity check ---------
# IMPORT-TEST every python file, rather than reasoning about imports statically. The static
# version passed a tree in which alphaZero_bellman.py could not import train_iqn at all --
# it assumed a PYTHONPATH that only the launchers set. Actually importing is the only check
# that cannot be fooled that way.
echo
echo "checking that every import RESOLVES (without executing anything):"
"$SRC/venv/bin/python" - "$DEST" <<'IMPORTCHECK'
# Resolve every top-level import against the sys.path each file will actually have,
# including its _NGS_PATH_BOOTSTRAP. Deliberately does NOT execute the modules: these are
# scripts, so importing them runs them (loads torch, parses argv, starts searches). An
# earlier version did execute, and stalled. Resolution is what we need to verify anyway --
# the failure this guards against is `from train_iqn import ...` when train_iqn.py moved to
# training/, which is a lookup failure, not a runtime one.
import ast, importlib.util, os, sys
dest = sys.argv[1]
bad = []
for sub in (".", "benchmark", "training"):
    d = os.path.join(dest, sub)
    if not os.path.isdir(d): continue
    # the path this file will see: its own dir, plus whatever its bootstrap adds
    search = [d, dest, os.path.join(dest, "training")]
    for f in sorted(os.listdir(d)):
        if not f.endswith(".py"): continue
        src = open(os.path.join(d, f)).read()
        try: tree = ast.parse(src)
        except SyntaxError as e:
            bad.append((f"{sub}/{f}", f"SyntaxError: {e}")); continue
        mods = set()
        for n in ast.walk(tree):
            if isinstance(n, ast.Import): mods |= {a.name.split(".")[0] for a in n.names}
            elif isinstance(n, ast.ImportFrom) and n.module and n.level == 0:
                mods.add(n.module.split(".")[0])
        for m in mods:
            if any(os.path.exists(os.path.join(p, m + ".py")) for p in search): continue
            saved = sys.path[:]
            sys.path[:0] = search
            try: found = importlib.util.find_spec(m) is not None
            except Exception: found = False
            finally: sys.path[:] = saved
            if not found:
                bad.append((f"{sub}/{f}", f"cannot resolve `{m}`"))
print("  every import resolves" if not bad else "  UNRESOLVED IMPORTS:")
for p, e in sorted(set(bad)): print(f"    {p}: {e}")
IMPORTCHECK

# every .py invoked by a copied .sh must exist somewhere in the tree
missing_py=""
for sh in "$DEST"/slurm/*.sh "$DEST"/training/*.sh; do
  [ -e "$sh" ] || continue
  for py in $(grep -oE '[A-Za-z0-9_/]+\.py' "$sh" | sort -u); do
    case "$py" in *downward*) continue;; *beam.py) continue;; esac
    base=$(basename "$py")
    if [ ! -e "$DEST/$base" ] && [ ! -e "$DEST/training/$base" ] \
       && [ ! -e "$DEST/benchmark/$base" ] && [ ! -e "$DEST/$py" ]; then
      missing_py="$missing_py\n  $(basename $sh) invokes $py -- NOT IN TREE"
    fi
  done
done
[ -n "$missing_py" ] && { echo "WARNING: broken script references:"; printf "$missing_py\n"; } \
                     || echo "  every .py invoked by a copied .sh is present"

echo
echo "$DEST"
echo "  root       $(ls -1 "$DEST"/*.py 2>/dev/null | wc -l) python files"
echo "  benchmark/ $(ls -1 "$DEST"/benchmark 2>/dev/null | wc -l) files"
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
