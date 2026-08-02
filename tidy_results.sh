#!/bin/bash
# Move non-thesis-relevant result dirs into results/_archive/ (reversible).
#   bash tidy_results.sh          -> dry run, lists what WOULD move
#   bash tidy_results.sh --apply  -> actually moves them
cd /work/rleap1/ibrahim.eisawy/Neural-Guided-Search/results || exit 1
APPLY=0; [ "$1" = "--apply" ] && APPLY=1

# --- KEEP: current multi-location logistics work (mlbinc* are NOT in git) ---
KEEP="^mlbinc|^multiloc_|^mloc_"
# --- KEEP: logistics c2s1 probe work ---
KEEP="$KEEP|^logt3cpu_|^logdeep_base$|^logstrat_base_qr$"
# --- KEEP: grid signal sweeps used in the comparison tables ---
KEEP="$KEEP|^az_probe_qrval_|^grid_add|^grid_g05$|^grid_g075$"
# --- KEEP: goldminer signal sweeps ---
KEEP="$KEEP|^gm_"
# --- KEEP: classical-planner baselines per domain (thesis comparison tables) ---
KEEP="$KEEP|_astar|_qstar|_wastar|_beam_|_greedy|alphazero"
# --- KEEP: all json/csv summaries ---
KEEP="$KEEP|\.json$|\.csv$|\.jsonl$|\.txt$"
KEEP="$KEEP|^_archive$"

mkdir -p _archive
n_keep=0; n_move=0
for d in *; do
    if echo "$d" | grep -qE "$KEEP"; then n_keep=$((n_keep+1)); continue; fi
    n_move=$((n_move+1))
    if [ $APPLY -eq 1 ]; then mv "$d" _archive/ 2>/dev/null; else echo "would move: $d"; fi
done
echo "-----"
echo "keep: $n_keep   move-to-_archive: $n_move"
[ $APPLY -eq 0 ] && echo "(dry run -- rerun with --apply to actually move)"
