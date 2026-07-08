# Handoff — IQN + AlphaZero on Grid (→ Bellman-consistency next)

Read this first. It summarizes the whole investigation, the current state, the
next task (Bellman-consistency diagnostic), and the technical/cluster setup.

---

## 0. One-paragraph context

Bachelor thesis, Phase II. Goal: use an IQN (distributional value model) to
guide AlphaZero-style search so it expands FEWER states while keeping coverage,
across PDDL planning domains. Focus domain right now = **Grid**. The core
obstacle: the SAC **policy** is *confidently wrong* at ~83% of the states where
it errs (puts prob ~1.0 on the wrong action), and every uncertainty signal we
derived from the IQN fails to fire specifically at those states. One signal
(the IQN **ensemble value vote**) works; everything else fails for understood
reasons. Next direction (supervisor's): **Bellman-consistency** — stop trusting
the model's self-reported confidence, instead catch the model contradicting its
own one-step-ahead prediction.

---

## 1. Search setup / key definitions

- **Search** = AlphaZero over a transposition-table DAG. Each simulation starts
  from the root, descends by a selection rule to an unexpanded node, expands it
  (generates all successors), evaluates the leaf with twin Q-nets, backs the
  value up (max-backup). "Expansions" = unique states generated = the metric.
- **Baseline pUCT**: `U(s,a)=Q_norm(s,a)+c*P(a)*sqrt(N(s))/(1+N(s,a))`, c=1.5.
  P(a)=SAC policy prior. Unvisited edges get Q_norm=0 (pessimistic FPU).
- **IQN**: for a state-action returns 99 quantiles of the return distribution.
  A state's "curve" = sorted quantiles of its best action (highest mean).
- **W1 (old, ours)** = `mean|sorted(parent_curve)-sorted(child_curve)|` — belief
  SHIFT across a transition. **Width** = `q[90]-q[8]` — belief SPREAD at a state.
- **Mistake node** = a state on the optimal plan where the policy's argmax !=
  the plan's action. There are **321** of them across the 22 hard instances.
- **Hard instances** = the 22 Grid val instances the baseline solves with >=300
  expansions. Baseline solves 116/120 overall.

## 2. What we established (with numbers)

**W1 fails.** As a signal for "which action to explore," at mistake nodes the
plan action has the top W1 only ~20-25% of the time = chance (~24% for 4-6
actions). At correct nodes it "misfires" (says explore elsewhere) ~73-80%.
Search with multiplicative W1 (P'(a)=P(a)*(1+1.5*W1_norm)): 113/120 coverage,
**10.6% fewer expansions overall** (0.894 ratio), 17.8% on hard — but 83% of
that saving is 3 lucky instances that found SHORTER plans, median instance
unchanged, 3 coverage losses. Root cause: W1 measures unfamiliarity, and wrong
branches are as unfamiliar as right ones.

**Width fails the same way.** Fires at correct action only 15% at mistakes
(below chance), misfires 77% at correct nodes. Full-120 widthmult: 114/120,
0.976 overall (2.4%). Offline width did weakly track model error on
goldminer/logistics (partial corr +0.37..+0.46) but that doesn't transfer to a
useful search signal.

**IQN ENSEMBLE VOTE works — the one positive result.** Trained 5 seed-diverse
IQNs (+ original = 6). At the 321 mistake nodes: single model's VALUE is wrong
41% of the time, ensemble MAJORITY wrong only 28%, all-6-wrong just 5%. The
VOTE (each model votes its highest-valued child; boost = vote share) is the
FIRST signal to beat chance in BOTH directions: prefers the correct child 59%
at mistakes, agrees with policy 65% at correct nodes. Disagreement MAGNITUDE is
useless (spread 1.09 identical at mistake vs correct nodes).
Ablation (causal proof): single-model vote in search = ratio 1.314 (WORSE),
six-model vote = 0.743. Same formula, only model count differs.
Full-120 vote results vs baseline: mult_only 112/120 overall 0.957 hard 0.933
easy 0.975; floor-ramp 114/120 overall 0.932 (6.8%) hard 0.743 (**25.7%**) easy
1.148 (+tax). Rescues 038/042/112 (W1 never solved). Best HARD result of the
project; beats W1 on hard + coverage, NOT on overall (easy tax).

**Easy tax is unfixable by gating.** The additive "floor" that gives the big
hard wins also over-explores easy instances (+15%). Tried: raise N0 (fails,
visit counts saturate via transpositions), global warmup (kills early hard
wins, 087 144->612), vote-threshold gate (kills tie nodes, over-concentrates),
disagreement gate (both tiers worse). ALL gating hurts — the floor's benefit
and cost are the same mechanism. Best SAFE config = mult_only (no floor: better
than baseline on both tiers, best coverage, ~4% overall).

**Ensemble does NOT rescue W1.** Ensemble-mean W1 fires 27% vs single 25% (still
chance) — W1's misranking is systematic (all models shift the same wrong way);
seed diversity decorrelates value LEVELS not shift patterns.

**Policy ensemble (averaging) BACKFIRES.** Trained 5 seed-diverse SAC policies
(+original=6). Diagnostic looked promising: at mistake nodes single policy
peaked (>0.9) 83% -> averaged policy peaked only 21%, avg prob on correct action
0 -> 0.248. BUT running search with the averaged prior FAILED: hard coverage
13-18/22, easy 3x worse. Why: averaging de-peaks CORRECT nodes too (peaked
94% -> 63% there). Since correct nodes vastly outnumber mistakes, the damage
wins. Same lesson as prior-mixing (crashed 109->41). W1 on the de-peaked policy
(pe_w1) = hard 1.234, WORSE than single-policy W1 (0.822): confirms leverage was
never W1's fatal flaw — the chance-level ranking is.

**Policy VOTING would also not help** (didn't run, predicted from diagnostic):
policies are majority-WRONG at mistakes (only 1.45/6 pick correct), unlike value
models (3.53/6 prefer correct). Voting can't extract a correct answer that isn't
in the majority.

## 3. THE NEXT TASK — Bellman-consistency diagnostic

**Insight (supervisor):** a narrow IQN distribution means "confident," NOT
"correct" — the model can be narrowly, confidently WRONG, which is exactly our
failure mode. So stop asking the model how sure it is (width/W1/spread all do
this and fail). Instead check whether the model OBEYS the Bellman equation
against the TRUE deterministic transition. Where it violates its own law, its
confidence there is untrustworthy — a signal that could fire specifically at the
confidently-wrong nodes.

**Bellman law (cost / our sign convention):** scalar form
`Q(s,a) = c(s,a) + Q(s', b*)`, s'=T(s,a) is the real successor (deterministic,
so we can apply the action and get it exactly). NOTE our rewards are negative
(cost-like); confirm whether to use min or max for the successor's best action
by checking the IQN sign in train_iqn.py / how greedy action is picked.

**Distributional version:** replace scalar Q with the quantile distribution
Z(s,a). Check whether `Z(s,a)` matches the Bellman TARGET `c + gamma*Z(s',b*)`
(supervisor wrote "1 + gamma*Z" using unit cost c=1; use the real step cost).
Compare the two distributions with **1-Wasserstein (W1)** — same metric as our
old W1 but a DIFFERENT quantity: old W1 = parent-vs-child raw curves; this =
model's prediction vs its own Bellman target.

**Choosing b* (supervisor's refinement, important):**
```
b* = argmin_{b in B_good} D( Z(s,a), c + gamma*Z(s',b) )
B_good = { b : score(Z(s',b)) <= best_score + epsilon }   # near-tied-good successors
```
i.e. among the successor actions that are all roughly equally good (score within
epsilon of the best), pick the one whose Bellman target is CLOSEST to the
parent. This is "benefit of the doubt": only flag inconsistency if the parent
disagrees with EVEN the best-matching good successor (avoids false alarms when
two equally-good successors have different-shaped distributions). The measured
signal = that minimum distance. If it's large, the model is genuinely
inconsistent there.

**THE DIAGNOSTIC TO RUN FIRST (before any search code):**
Walk each of the 22 hard instances' optimal plans. At every node compute the
Bellman-consistency error = `min_{b in B_good} W1( Z(s,a), c+gamma*Z(s',b) )`
for the CHOSEN action a (policy argmax). Then the decisive question:
**is this error systematically LARGER at mistake nodes (policy wrong) than at
correct nodes (policy right)?**
- If YES -> first signal that discriminates -> build it into search (as a boost
  toward exploring inconsistent/untrustworthy nodes).
- If NO -> cheap documented negative, goes in report, then consider pivot.
Reuse the plan-walking machinery in grid_width_planpath.py / grid_ensemble_
disagreement.py (they already load models, walk plans, define mistake vs correct
nodes). Open choices to decide: score() = mean of the curve; epsilon (try a few,
e.g. small fraction of value range); gamma (check train_iqn default, likely
0.999); the exact per-step cost c (Grid is unit-cost per action → c=1, but the
IQN may be trained on discounted returns so the target shift must match how the
IQN was trained — verify against train_iqn.py).

**Watch out:** make sure the Bellman target is built in the SAME units/sign the
IQN was trained on. If the IQN predicts discounted cumulative negative reward,
the "best" successor action is the argmax of mean (not min), and the target is
`c + gamma*Z(s',b*)` with c matching training. Getting this wrong will make
everything look inconsistent. Sanity-check on a few nodes by hand first.

## 4. Technical / repo setup

**Local dir:** `/Users/ibrahim/Documents/Bachelor Thesis/relational-neural-network-python`
**Cluster dir:** `ibrahim.eisawy@cn-04:~/Neural-Guided-Search`  (same repo,
different folder name). Copy files up with scp, run with sbatch, copy result
dirs back down.

**Run python locally as `venv/bin/python` (NOT plain python).** Do not train on
CPU — training goes to the cluster GPU.

**Key models (models/):**
- `grid_sac_policy.pth` — the single SAC policy (search prior).
- `grid_sac_q1.pth`, `grid_sac_q2.pth` — twin Q critics (leaf eval).
- `grid_iqn.pth` — the single IQN (the value distribution model).
- `grid_iqn_ens_{1..5}_best.pth` — 5 seed-diverse IQNs (ensemble). +original=6.
- `grid_sac_ens_{i}_policy_best.pth` — 5 seed-diverse SAC policies (the policy
  ensemble; averaging them backfired but they exist).

**Key data (example/grid_dataset/):**
- `domain.pddl`; `train/`, `val/`, `test/` each with `NNN_*.pddl` problems.
- Grid val problems also have `NNN_*.pddl.plan` = the optimal plan, one action
  per line like `(pickup f2-1f key2-0)`. These define the mistake nodes.

**Search / algorithm files (all take --domain --problem --policy_model
--q1_model --q2_model and print `[Final] Expanded: N`):**
- `alphaZero.py` — baseline pUCT.
- `alphaZero_w1.py` — multiplicative W1 boost (main old variant; has
  --fpu_reduction, --w1_topk, --w1_visit_gated).
- `alphaZero_w1_ramp.py` — combined mult + visit-ramped additive floor; has
  `--signal {w1,width}`, `--w1_lambda`, `--w1_beta`, `--w1_n0`, `--w1_ramp_topk`,
  `--w1_ramp_uniform`, and `--policy_models` (averages a policy ensemble prior).
- `alphaZero_ensemble.py` — IQN ensemble VOTE search. Flags: `--iqn_models` (N
  paths), `--v_lambda` (mult vote boost), `--v_beta`/`--v_n0` (ramp floor),
  `--v_warmup`, `--v_floor_thresh`, `--v_floor_disagree`, `--policy_models`.
  **This is the file to extend for a Bellman-consistency boost** — it already
  loads N IQN models and has the EnsembleOracle pattern for batched value calls.
- `alphaZero_decoupled.py` — supervisor's old U=Q+c1*P+c2*f (failed, 96/120).

**Diagnostic scripts (walk plans, define mistake/correct nodes — COPY THESE
patterns for the Bellman diagnostic):**
- `grid_width_planpath.py` — per-node width fire/misfire at mistake vs correct.
- `grid_ensemble_disagreement.py` — per-model value votes at mistake nodes +
  correct-node control + k-distribution. Loads N IQN models via
  `train_iqn._load_model`, uses 99-tau grid, walks plans, matches plan action by
  canonical string. **Best template for the Bellman diagnostic.**
- `grid_policy_disagreement.py` — policy-ensemble peakedness at mistake/correct.
- `w1_planpath_analysis.py` — W1 fire/misfire + the multiplicative-boost TV/flip
  analysis.

**IQN loading:** `from train_iqn import _load_model as _load_iqn_model` →
`m,_,_ = _load_iqn_model(domain, Path(path), device); m.eval()`. Query with
`taus = torch.linspace(0.01,0.99,99,device=device).unsqueeze(0)` then
`q_values,_ = m.forward([(state,goal)], taus=taus.expand(n,99))[0]`, sort each
row, `.mean(dim=1)` for the scalar value, `.max()`/`argmax` for best action.
`get_state_key(state)` for TT keys; `action.apply(state)` for the true successor.

**Reference results (results/):**
- `grid_decoupled_comparison.json` — baseline / w1_lambda1.5 / decoupled on all
  120 val. THE reference for baseline expansions + defining the 22 hard.
- `grid_ramp_hard.json`, `grid_width_hard.json`, `grid_widthmult_full.json`,
  `grid_vote_ablation.json`, `grid_ens_hard.json`, `grid_ens_gate.json`,
  `grid_ens_disagree.json`, `grid_policyens.json` — the experiment tables above.
- `az_grid_ensvote_{mult,comb,ramp}/` — full-120 ensemble-vote cluster outputs.
- `az_gold_w1_*`, `az_logi_w1*` — Goldminer/Logistics W1 cluster runs (Goldminer
  is where W1 works: 47%, because it has junk actions with W1=0 to filter).

**How to make a cluster (sbatch) run — pattern that works on this cluster:**
```bash
# copy new files up
scp alphaZero_ensemble.py run_x.sh ibrahim.eisawy@cn-04:~/Neural-Guided-Search/
# array job, one problem per task. Example training (seed-diverse):
for i in 1 2 3 4 5; do
  sbatch --account=rleap --partition=rleap_gpu_48gb --gres=shard:L40S:12 \
    --cpus-per-task=4 --mem=32G --time=04:00:00 \
    --chdir=/u/ibrahim.eisawy/Neural-Guided-Search \
    --wrap="venv/bin/python -u train_iqn.py --train example/grid_dataset/train \
      --validation example/grid_dataset/val --hindsight lifted --seed $((100+i)) \
      --output_prefix models/grid_iqn_ens_${i}_"
done
```
For per-problem search sweeps, use an array sbatch script that indexes
`FILES=($(ls TEST_DIR/*.pddl|grep -v domain|sort)); PROB=${FILES[$SLURM_ARRAY_TASK_ID-1]}`
and writes `OUTDIR/$NAME.out`; submit `sbatch --array=1-120 script.sh ARGS`.
See `run_alphazero_ensemble.sh` and `run_alphazero_w1_ramp.sh` for templates.
Parsing: grep `\[Final\] Expanded: (\d+)` and `Found a solution of length (\d+)`.

**IMPORTANT gotcha:** the Bash tool shell is zsh — unquoted `$VAR` does NOT
word-split. Pass multi-path args (like `--iqn_models a b c`) inline, not via a
shell variable.

**Local eval pattern:** most `eval_*.py` scripts use ProcessPoolExecutor with
`max_workers=3` (ensemble is ~6x slower per expansion, CPU-bound). Local
baseline matches cluster (instance 000 logistics: 2494 local vs 2482 cluster),
so local ratios are trustworthy; but for TRUE overall coverage numbers run the
full 120 on the cluster with GPU (local 60s budget differs from cluster).

## 5. Report status

A full HTML report artifact was drafted earlier covering offline checks + W1 +
width + all pUCT formula variants across Goldminer/Grid/Logistics. It needs a
new chapter appended: the ensemble vote (positive result), the easy-tax gating
failures, the policy-ensemble backfire, and (next) the Bellman-consistency
work. Supervisor wants EVERYTHING in the final report, including the negative
failure modes — they are part of the contribution ("how IQN behaves and what
must be fixed before it works with AlphaZero across domains").

## 6. Immediate next action for the new chat

1. Verify IQN training sign/units in `train_iqn.py` (discount gamma, reward sign,
   how the greedy/best action is selected) so the Bellman target is built
   correctly. Hand-check 2-3 nodes.
2. Write `grid_bellman_consistency.py` modeled on
   `grid_ensemble_disagreement.py`: walk the 22 hard plans, at each node compute
   `min_{b in B_good} W1(Z(s,a), c+gamma*Z(s',b))` for the chosen action, report
   the error at mistake vs correct nodes (+ a random/chance sense of scale).
3. Decision rule: error bigger at mistakes than correct → build a search boost;
   else document as negative. Run it (fast, offline, policy+IQN only).
