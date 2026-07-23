# Signal Sanity Checks — Phase II

**Purpose of this document.** Phase II repeatedly asks the same question: *does an
uncertainty / consistency signal derived from a learned value model actually improve
AlphaZero search, or does an apparent improvement come from a confound?* Almost every
signal in this project looked promising at first and then dissolved under a control. This
file records, per signal, the **sanity checks / control experiments** that separated real
effects from artifacts — each with its **purpose** (which artifact it guards against),
**method**, **result**, and **takeaway**. It is written to be turned directly into thesis
prose.

Format for every entry:

- **Purpose** — the specific question or artifact the check targets.
- **Method** — what was run (models, data, metric).
- **Result** — the numbers.
- **Takeaway** — what it lets us claim (and what it does not).

---

## 0. The recurring artifacts (why every signal needs a control)

These are the confounds that have produced false positives in this project. Every sanity
check below exists to rule one of them out. Stating them up front doubles as a methodology
section for the thesis.

1. **Prior-flattening confound.** Any mechanism that touches the pUCT prior `P(a)` also
   changes the explore/exploit balance. On domains where the policy prior is harmful or
   over-confident (e.g. Rovers), *flattening the prior by any means* improves search — so a
   "signal" wired into the prior can win for reasons unrelated to its information content.
   **Control:** replace the signal with a content-free perturbation of equal magnitude
   (constant widening, uniform floor) and see if the win survives.
2. **Exploration-redistribution confound (prior untouched).** Even a channel that leaves
   `P(a)` intact but scales the *exploration term* changes the balance of exploration among
   siblings. A generic redistribution of that magnitude might reproduce the effect without
   the signal pointing anywhere meaningful. **Control:** shuffle the signal across siblings
   (same multiplier multiset, wrong targets).
3. **Offline ≠ search-visited distribution.** A signal's AUC measured on optimal-plan or
   sampled states does **not** predict its behaviour on the states AlphaZero actually
   expands. Signals that scored 0.7–1.0 offline have gone to chance on search-visited states.
   **Control:** always re-measure on search-visited states with exact labels.
4. **In-distribution ≠ deployment distance.** The value models are trained on short
   distances (grid h\* ≤ ~22) but search on large instances spends almost all its time far
   beyond that range, where the model is out-of-distribution and the signal is dead. A
   signal validated only near the goal will not transfer to hard instances. **Control:**
   slice every measurement by true distance-to-goal.
5. **Normalization corruption.** Dividing width by value (`cv = width/|value|`) to make it
   distance-invariant destroys the signal, because width and |value| co-vary within a fixed
   distance. **Control:** measure raw width vs the normalized version on the same exact-distance
   states.
6. **Coverage-vs-expansions selection bias.** Comparing expansions only on the instances an
   arm solved rewards arms that drop the hard (expensive) instances. **Control:** report the
   **median per-instance ratio on the common-solved set**, plus coverage, plus a net
   expansion accounting — never an aggregate over a self-selected set.
7. **Node-AUC vs transition-AUC / metric hygiene.** Node-level AUC (one action per state) is
   a property of the state distribution, not the domain, and flips between distributions.
   Transition-level AUC on search-visited states is the trustworthy predictor.

---

## 1. QR-DQN sibling raw-width exploration channel  *(current signal, most rigorously checked)*

**The signal.** The QR-DQN (`models/grid_iqn_qrdqn_best.pth`) — a de-saturated distributional
value model — outputs a 99-quantile value distribution per action. Its **raw width**
`q90 − q10` is a validated uncertainty signal, but *only* when compared among **same-distance
states** (a node's children/siblings), never divided by value. The channel
(`alphaZero_bellman.py`, OPTION 5, `--sib_beta`) boosts the pUCT exploration term toward
wider (more-uncertain) children; the prior `P(a)` and the Q-values are untouched:

```
rel(a)  = width(a) / mean_sibling_width          # ratio to this node's own children
mult(a) = max(0.1, 1 + β·(rel(a) − 1))
u(a)    = c_puct · mult(a) · P(a) · √N_parent / (1 + n_a)      # only this term is scaled
```

**Search stack.** AlphaZero uses the SAC policy (`grid_sac_policy`) + twin SAC critics
(`grid_sac_q1/q2`). The QR-DQN is a **signal source only**; it replaces nothing.

**Test set.** `example/probe_near_goal_d5-20/` — 480 "probe" problems, 30 at each exact
distance d = 5…20, carved from the *hard* test instances (long plans 172–445, 65–179 objects
→ high branching). Each is a full problem whose initial state sits at a known exact distance
d from the original goal. Design goal: **shallow (d ≤ 20 → signal validated clean) but bushy
(large problems → search room)** — the "clean signal + room" regime that whole small instances
never provided. Zero training overlap (content-hash checked). `labels.csv` gives exact
distance and object count per probe. *(Infra note: `labels.csv` uses CRLF line endings; parse
with `open(path, newline="").read().replace("\r","")`.)*

### 1.1 Room check — does the test set even permit savings?

- **Purpose.** Guard against artifact #6 in reverse: if baseline AlphaZero already solves
  these probes near-optimally (~50 expansions), there is *no room* for any signal to save,
  and a null result would be uninformative. Confirm room exists *before* spending the sweep.
- **Method.** Baseline AlphaZero (no channel), 48-probe stratified sample (object tiers
  65 / 84 / 179 × 16 distances), `--max_time 120`. Metric: expansions-to-solution vs
  solution length.
- **Result.** All 48 solved. Mean expansions (exp/len ratio) by branching × distance band:

  | objs | d5–8 | d9–12 | d13–16 | d17–20 | exp/len |
  |------|------|-------|--------|--------|---------|
  | 65 (low branch)  | 34 | 48  | 71  | 77  | ~4–5× |
  | 84 (mid)         | 55 | 95  | 85  | **528** | ~4–6× |
  | 179 (high)       | 85 | **153** | **160** | **374** | ~5–7.5× |

  16/48 probes expand ≥150 nodes, 7/48 ≥300, max 650 — vs solution lengths 15–84
  (4–7.5× the solution length in wasted expansions; plans found are often ~4× optimal, i.e.
  genuine wandering).
- **Takeaway.** **Room exists and grows with depth × branching, concentrated in the mid/high
  branching tiers at d ≥ 13.** The low-branching 65-obj tier is near-roomless (a built-in null
  control). Consequence for all downstream analysis: **stratify by branching**, because the
  signal can only help where there is room.

### 1.2 Main sweep — coverage and expansions

- **Purpose.** Measure whether the channel reduces expansions without losing coverage, across
  β strengths.
- **Method.** 480 probes × 4 arms: β ∈ {0 (baseline), 0.5, 1.0, 2.0}. `--iqn_model` = QR-DQN,
  `--max_time 120`. Metric: coverage; median per-instance expansion ratio and aggregate ratio
  on the common-solved set (artifact #6 discipline). Channel activation verified: 480/480 sib
  arms print `[Sib] OPTION5`; 0/480 baseline.
- **Result.**

  | arm | coverage | median ratio | aggregate ratio |
  |-----|----------|--------------|-----------------|
  | sib0 (baseline) | 476/480 | — | — |
  | sib0.5 | 473/480 | 1.000 | 1.006 |
  | sib1.0 | 472/480 | 1.000 | 0.980 |
  | sib2.0 | 474/480 | 1.000 | 0.944 |

  Coverage is flat (−2 to −4, within noise). **Median ratio = 1.000 in every arm and every
  branching tier** — the typical probe is untouched. The aggregate falls monotonically with
  β (1.006 → 0.980 → 0.944).
- **Takeaway.** Coverage preserved (the "prior untouched" design holds — cf. §1.6). The effect
  is **not on the median probe**; it is a heavy-tailed, dose-dependent aggregate shift that
  needs the accounting in §1.3 to interpret honestly.

### 1.3 Expansion accounting — net decomposition

- **Purpose.** The median-1.000 / aggregate-<1 pattern is exactly the shape a few lucky
  windfalls can fake. Decompose the aggregate into gross saved vs gross lost to see whether
  the net is real and where it comes from.
- **Method.** On the common-solved set (~471 probes, baseline total ≈ 102,000 expansions), sum
  `base − sib` over improved probes (gross saved) and `sib − base` over regressed probes
  (gross lost); net = saved − lost. Also split by baseline room.
- **Result.**

  | arm | gross saved (probes) | gross lost (probes) | **net** | net % |
  |-----|----------------------|---------------------|---------|-------|
  | sib0.5 | 2,382 (94) | 2,988 (92) | **−606** | −0.6% |
  | sib1.0 | 5,626 (122) | 3,621 (132) | **+2,005** | +2.0% |
  | sib2.0 | 9,629 (158) | 3,927 (132) | **+5,702** | +5.6% |

  Room split (β=2.0): baseline-exp ≥ 300 (high room) → mean ratio **0.918**, median 0.964;
  baseline-exp < 300 (low room) → median **1.000**, mean 1.035.
- **Takeaway.** (1) **Monotone dose-response** (−0.6% → +2.0% → +5.6%) = a real effect, not
  noise, and not yet plateaued at β=2. (2) At β=2, **wins total 2.4× the losses** in magnitude
  (9,629 vs 3,927); mistakes are cheap (low-room probes doubling 60→140) while wins are large
  (high-room probes −50 to −70%). (3) The net is **entirely room-gated**: helps where baseline
  has room, neutral-to-slightly-worse where it does not. β=0.5 is net-negative — widening must
  be strong enough to bite. This is the first in-search result where the signal produces
  concentrated wins *exactly where the premise predicted* (in-distribution + room).

### 1.4 Win/loss case study — mechanism

- **Purpose.** Move beyond aggregates: on one clear win and one clear loss, see *what* the
  channel did differently from baseline.
- **Method.** Compare baseline vs sib2.0 traces on `280_d14_031` (win) and `403_d18_038`
  (loss): expansions, solution length, and the simulation at which the goal path was found.
- **Result.**

  | instance | baseline | sib2.0 |
  |----------|----------|--------|
  | **win** 280_d14 (d14) | 770 exp, plan **54**, found @sim 295 | 234 exp, plan **56**, found @sim 83 |
  | **loss** 403_d18 (d18) | 106 exp, plan **22** (near-optimal), found @sim 33 | 279 exp, plan **48**, found @sim 97 |

- **Takeaway.** The win is **genuine search efficiency, not a shorter route** — sib found a
  *slightly longer* plan (56 vs 54) in far fewer expansions (committed to a productive region
  sooner). The loss is **over-exploration of an already-efficient search** — baseline was on a
  near-optimal 22-step track (d18), and widening derailed it into a 48-step meander. This
  concretely explains the room-dependence: on bushy instances where baseline wanders, "look at
  the uncertain child" tends to be right; on near-solved instances it diverts from the policy's
  already-good choice.

### 1.5 Width-blind shuffle control — the decisive anti-artifact test

- **Purpose.** *The* central check (artifact #2). The channel scales the exploration term, so
  the savings might come from generically redistributing exploration by these magnitudes,
  independent of *where* width points. If a width-blind assignment of the same multipliers
  reproduces the savings, the signal is doing nothing — this is the sibling-width analogue of
  the constant-w control that killed the Bellman line (§4.1).
- **Method.** Added `--sib_shuffle` (`alphaZero_bellman.py`): at each node, compute the same
  per-child widths, then **permute them among the children** (seeded by the integer state
  index → deterministic, width-blind) before forming the multipliers. Identical multiplier
  multiset and identical nodes touched; only the width→child mapping is randomized. Run at
  β=2.0.
- **Result (per-instance, n=2 so far).**

  | instance | baseline | real width (sib2.0) | **width-blind shuffle** |
  |----------|----------|---------------------|-------------------------|
  | **win** 280_d14 | 770 | **234** (−70%) | **621** (−19%) |
  | **loss** 403_d18 | 106 | **279** (+163%) | **181** (+71%), plan 22 (not 48) |

  Full 480-probe aggregate shuffle control at β=2.0: **[RUNNING — fill in net saved/lost vs
  the +5,702 real-width net; compare per §1.3].**
- **Takeaway (from n=2; aggregate pending).** The shuffle does **not** reproduce the real-width
  result in *either* direction: on the win, real width (234) far beats the width-blind shuffle
  (621) — generic redistribution gets only partway; on the loss, real width (279) is *worse*
  than shuffle (181), which even preserved the near-optimal plan. So width carries **real
  directional information** — it is *not* the W1/prior-flattening artifact. It *amplifies* in
  the direction it points (helps more than random on high-room, hurts more than random on
  low-room). The full aggregate below is the decisive confirmation.

### 1.6 Root-node mechanism — where the channel acts (safety property)

- **Purpose.** Understand *where* in the tree the channel operates, and confirm it cannot
  destroy the policy prior (the failure mode that collapsed grid coverage in every prior
  prior-mixing attempt).
- **Method.** Instrument the win instance: after search, dump the root's children with raw
  width, prior, and final visit share (`edge_N`), for baseline vs sib2.0.
- **Result.** At the root, both arms put ~92.6% of visits on the *same* child — the one the
  **policy** already dominates (prior 0.923, and it is also the 2nd-widest). The *widest* root
  child, `(putdown … key0-2)` (width 0.919, prior **0.000**), gets **0 visits in both** runs.
- **Takeaway.** Two structural facts: (1) **The channel cannot touch prior-0 children**,
  because `u ∝ P(a)` is multiplicative in the prior — so it can never divert search onto
  actions the policy rules out. (2) At **confident nodes** (peaked prior) it is essentially
  inert. Therefore the channel only redistributes exploration among the **nonzero-prior
  children of *uncertain* nodes**, deeper in the tree — which is why coverage is preserved and
  why the effect is a *refinement* of the policy's exploration, not an override. The observed
  savings originate at those deeper uncertain nodes, not at the root.

### 1.7 Room gate — documented negative (same failure as all prior gating)

- **Purpose.** §1.3 showed the channel helps high-room probes and hurts low-room ones
  (over-widening near-solved searches). The obvious fix: activate the channel only once the
  search shows *struggle*, so low-room probes solve first (baseline) and only high-room probes
  get widened. "Room" is observable online as the transposition-table size (expansions so far).
  Test whether such a gate keeps the wins while dropping the losses. This is the sibling-channel
  version of the `--widen_after N` idea that failed on Rovers and the ensemble-vote easy-tax.
- **Method.** Added `--sib_gate N` (`alphaZero_bellman.py`): `_compute_sib_mult` is a no-op
  (baseline behaviour) while `len(tt) < N`, and the channel activates once `N` unique states
  have been expanded. Tested at β=2.0 on the §1.4 win (`280_d14`, baseline 770, ungated sib
  **234**) and loss (`403_d18`, baseline 106, ungated sib 279), sweeping N ∈ {40, 60, 100, 150}.
- **Result.**

  | gate N | win 280_d14 | loss 403_d18 |
  |--------|-------------|--------------|
  | 40  | **747** (win destroyed) | 285 (not protected) |
  | 60  | **747** (win destroyed) | 285 (not protected) |
  | 100 | **747** (win destroyed) | 106 (protected ✓) |
  | 150 | **745** (win destroyed) | 106 (protected ✓) |

- **Takeaway.** **The gate's requirements are mutually exclusive, so no threshold works.** The
  loss is only protected at N ≥ 100 (it solves at 106 baseline before the channel bites), but
  the win is destroyed at *every* N ≥ 40 → back to ~747. Mechanism: the win came from the
  channel **committing early** (ungated sib found the goal at sim 83, ≈ its first ~40
  expansions); delaying the channel lets the baseline tree-shape form first, so by the time the
  gate opens the search is already on the baseline wandering trajectory. The win needs the
  channel *on from the start*; the loss needs it *off* — and those windows do not overlap. This
  reproduces the project-wide gating negative ("delaying the signal destroys hard-instance
  wins", 087: 144→612) on the sibling channel and now explains it mechanistically: **the benefit
  (early commitment) and the cost (early over-widening) are the same early action, so they
  cannot be separated by timing.** The full 480-probe gated sweep was therefore not run — the
  n=2 mechanism result is decisive and matches all prior gating attempts. *(Structural note: a
  gate on per-node **branching factor** — active from the start but only at bushy nodes — is a
  distinct idea that this expansion-count gate does not test; it would keep the channel active
  early while sparing low-branching near-solved regions. Untested.)*

---

## 2. QR-DQN sibling Bellman-inconsistency exploration channel  *(current signal, parallel to §1)*

**Naming.** This channel is called **"Bellman inconsistency"**, not "W1", to avoid confusion
with the older raw parent–child W1 prior channel (§6). It *uses* the 1-Wasserstein (W1) metric,
but what it *measures* is Bellman self-inconsistency. Code: `alphaZero_bellman.py`, OPTION 6,
`--binc_beta`.

**The signal.** For each child action *a* at parent state *s*, with *s′ = a.apply(s)*, the
per-child signal is the 1-step min-W1 Bellman inconsistency between the parent's distribution
for *a* and the Bellman target built from the best successor:

```
Binc(a) = min_{b in B_good(s')}  (1/99) Σ_τ | Z_τ(s,a) − (r + γ·Z_τ(s',b)) |      r = −1, γ = 0.999
```

(mean-abs-difference of the 99 sorted quantiles = the 1-Wasserstein distance; B_good = best
successor action(s) by mean value, eps=0; if *s′* is the goal the target is the constant *r*).
Binc ≈ 0 when the model is self-consistent at *a*, large when the parent's prediction
contradicts its own successor. This is the same quantity as the Bellman-widening line's
`err(s,a)` (§4), but done at 1 step and used **per child**, not on the top action only.

**Integration (identical to §1, only the per-child quantity changes).** Prior and Q untouched;
only the exploration term is scaled, boosting exploration toward *more-inconsistent* siblings:

```
mult(a) = max(0.1, 1 + β·(Binc(a) / mean_sibling_Binc − 1))
u(a)    = c_puct · mult(a) · P(a) · √N_parent / (1 + n_a)
```

**Cost.** One QR-DQN forward for the parent + **one per child** (to read each successor's
distribution) — heavier than the width channel's single forward per node. Same probe test set
as §1. Motivation for testing it despite §6: it is the natural *consistency* counterpart to
width's *spread*, run through the same clean (prior-untouched, sibling-relative) integration —
a fair head-to-head. **Caveat going in:** `w1_qrdqn_uncertainty.py` found W1/Bellman-style
signals are **at chance near the goal on the QR-DQN** (AUC ≈ 0.52/0.49 at d1–10/d11–22), and the
probes are d5–20 — squarely that regime. So the prior expectation is that this channel may
behave like random redistribution (the §2.2 shuffle control is therefore decisive, not
optional).

### 2.1 Case study — Binc vs width vs baseline (n=2)

- **Purpose.** Same two instances as §1.4, to compare the Bellman-inconsistency channel's
  behaviour against the width channel head-to-head on a clear win and a clear loss.
- **Method.** Binc at β ∈ {1.0, 2.0} on the win (`280_d14`) and loss (`403_d18`); compare to
  baseline and width sib2.0.
- **Result.**

  | instance | baseline | width sib2.0 | Binc β1.0 | Binc β2.0 |
  |----------|----------|--------------|-----------|-----------|
  | win 280_d14  | 770 | 234 | **244** | 276 |
  | loss 403_d18 | 106 | **279** | **97** | 101 |

- **Takeaway (n=2 only).** On these two, Binc *looks* better-behaved than width: it wins on the
  win (244 ≈ width's 234) **and does not derail the loss** (97–101 vs width's 279). That would
  be notable if it holds — width's failure mode was over-committing on low-room instances, and
  Binc appears not to. But n=2, and the §2.2 control shows this is not yet trustworthy.

### 2.2 Shuffle control — signal-blind placement (n=2, INCONCLUSIVE)

- **Purpose.** The decisive check (artifact #2), and doubly important here because Binc is
  expected to be near-chance near the goal (see caveat above). If shuffling the Binc values
  among siblings reproduces the effect, the channel is generic exploration redistribution, not
  the Bellman signal. Reuses `--sib_shuffle` (now applies to OPTION 6 as well): same per-child
  Binc multiset, permuted onto the wrong children (seeded by state index → deterministic).
- **Method.** Binc + `--sib_shuffle` at β ∈ {1.0, 2.0} on the win and loss.
- **Result.**

  | instance | Binc β1.0 | Binc-shuffle β1.0 | Binc β2.0 | Binc-shuffle β2.0 |
  |----------|-----------|-------------------|-----------|-------------------|
  | win 280_d14  | 244 | **957** | 276 | **246** |
  | loss 403_d18 | 97  | 104     | 101 | 91  |

- **Takeaway — INCONCLUSIVE at n=2.** The shuffle is **erratic**: at β=1.0 the real signal
  (244) crushes its shuffle (957, worse than baseline), which would say "real signal"; but at
  β=2.0 the shuffle (246) *matches* the real signal (276), which would say "generic". The same
  instance's shuffle swings 957→246 between adjacent β. So — unlike the width channel, whose
  n=2 shuffle was cleanly and consistently worse than the real signal (§1.5) — the
  Bellman-inconsistency n=2 does **not** support a conclusion either way. **The aggregate
  480-probe Binc sweep + a matched 480-probe Binc-shuffle sweep are required to decide.** Given
  the near-goal-chance prior, the honest expectation is that Binc will not robustly beat its
  shuffle at scale; the sweep will confirm or overturn that. **[PENDING — fill in the 480-probe
  Binc net vs Binc-shuffle net when the cluster runs return.]**

---

## 3. Single-model distributional width (raw vs normalized)  *(offline signal-quality checks)*

### 2.1 cv-normalization corruption

- **Purpose.** The AlphaZero width channel originally divided width by |value| (`cv`) for
  distance-invariance. Check whether that normalization preserves the signal (artifact #5).
- **Method.** On search-visited states with **exact** distance labels
  (`qrdqn_search_signal_deep.jsonl`), compute AUC(signal → ensemble-disagreement) for raw
  width vs cv, at single exact distances (removes any within-band distance confound).
- **Result.** Raw width AUC = 0.82–1.00 at every exact distance through d21; cv degrades and
  inverts with distance (0.71 → 0.26). Mechanism: at a fixed exact distance, width and |value|
  are strongly positively correlated (Spearman 0.62–0.92) — the model expresses uncertainty by
  *both* widening the distribution *and* predicting farther — so width ÷ |value| divides two
  co-varying symptoms and cancels the signal. `banded` (raw width vs median width in value
  bins) fails the same way.
- **Takeaway.** **Raw width is the strong signal; the cv normalization is the culprit** behind
  the earlier "width is weak/flat" conclusions. The only clean use of raw width is *locally
  among same-distance states* — i.e. a node's siblings (§1), because they need no cross-distance
  normalization at all.

### 2.2 Offline vs search-visited distribution (transfer check)

- **Purpose.** Guard against artifact #3: does an offline width AUC predict search behaviour?
- **Method.** Measure width→uncertainty AUC on optimal-plan / sampled states, then re-measure
  on the states AlphaZero actually expands, sliced by exact distance.
- **Result.** Width is strong on search-visited states at d ≤ ~21 (0.86–1.00), but sampled
  *equidistant* states invert past d ≈ 20, and hard-instance search spends most time at d ≫ 22
  (OOD) where width collapses. Same signal, same labels — only the state distribution differs.
- **Takeaway.** Width is **distribution-fragile**: valid on the on-policy states search visits
  near the goal, not on arbitrary equidistant states, and dead OOD. This is *the* reason the
  probe dataset (§1) exists — it puts search in-distribution (d ≤ 20) with room, the only
  regime where the signal is both clean and actionable.

---

## 4. Bellman consistency / residual  *(closed by controls)*

### 3.1 Constant-w control (widening channel)

- **Purpose.** The Bellman-widening arm (flatten prior by w ∝ Bellman inconsistency) improved
  Rovers coverage. Test artifact #1: is it the *signal*, or just prior-flattening?
- **Method.** Replace the signal with `--signal constant --const_w X` (widen every node by a
  fixed w, no IQN, no Bellman check), matched to the signal arm's mean w. 120 Rovers test
  instances.
- **Result.** Baseline 69, Bellman λ=8 → 72, **constant w=0.93 (no signal) → 74**. Head-to-head
  on both-solved: median per-instance ratio **1.000**; Bellman cheaper on 21 / control cheaper
  on 19 (coin flip). Cost: 1.6M IQN forward calls (signal) vs 0 (control).
- **Takeaway.** **The entire win was prior-flattening; the Bellman ordering added nothing.**
  Separately produced a real positive: the Rovers SAC policy prior is *harmful* — a near-uniform
  prior beats baseline for free. On grid the same channel was "constant widening in disguise"
  because a fixed err_scale saturated w at the cap, so the grid negative was withdrawn and
  re-run with an adaptive scale.

### 3.2 Definitional null (single-model 1-step residual)

- **Purpose.** Ask whether the 1-step Bellman residual can rank action quality *even in
  principle*.
- **Method.** Measure `|Q(s,a) − (−1 + γV(s'))|` at correct vs incorrect actions (SAC, grid).
- **Result.** Correct-action median 0.369 vs incorrect 0.367 (identical, AUC ≈ 0.5). For the
  *true* value function the residual is ~0 on **every** action, because `Q*(s,a) = −1 + γV*(s')`
  holds by definition for optimal and suboptimal actions alike.
- **Takeaway.** The single-model 1-step residual measures **self-consistency, which is
  action-independent by construction** — there is no action-quality signal to extract. All
  W1/width variants of it inherit this. (Scope: same-model; cross-model differs, §4.4.)

### 3.3 Affine-correction control

- **Purpose.** The supervisor proposed per-instance affine recalibration `w·V + b`. Test
  whether it rescues the residual.
- **Method.** Fit `w,b` with the **oracle** (regress V on true distance — best case) on
  calibrated SAC/DQN, then score the corrected 1-step residual's AUC.
- **Result.** SAC 0.466 → 0.523, DQN 0.520 → 0.532 — both stay at chance. Scaling multiplies
  V(s) and V(s') by the same w, fixing the mean to −1 but leaving per-state noise proportionally
  identical (changes units, not SNR). On the flat IQN the fit is unidentifiable (slope ≈ 0).
- **Takeaway.** Affine correction **recovers distance (a good A\* heuristic) but not the
  Bellman uncertainty signal** on any model. The two ideas want different homes.

### 3.4 Cross-model independence

- **Purpose.** Same-model residual is definitionally null (§4.2); does reading the endpoint
  with a *differently-trained* model recover signal?
- **Method.** Parent = IQN, endpoint = SAC Q-critic (error-corr 0.093 with IQN); vs seed-diverse
  IQN ensemble (too correlated). Far-from-goal (d ≥ 11) transition AUC.
- **Result.** Same-IQN 0.443 (inverted) < seed-ensemble 0.507 (chance) < Q-critic-endpoint 0.592
  — monotone in independence. But 0.59 is modest, and **in search (Option 2 value channel) it
  did not reduce expansions on the fair common-solved set** (median ≥ 1.0 across grid/rovers/
  logistics). Averaging more models (consensus) *hurts* vs the single most-independent endpoint.
- **Takeaway.** Independence (not consistency) is what carries the little information there is;
  the offline lift (~0.59) is real but too weak to pay for itself in search. Line closed as a
  search signal.

---

## 5. Ensemble vote  *(the one signal that survived — with an ablation)*

### 4.1 Single-model vs six-model ablation

- **Purpose.** The ensemble vote (each of N seed-diverse value models votes its top child;
  boost = vote share) was the only Grid signal to beat chance in both directions. Confirm the
  *ensemble* is causally necessary, not the boost formula.
- **Method.** Same search formula, vary only the model count: single-model vote vs six-model
  vote, hard-Grid.
- **Result.** Single-model vote → hard ratio **1.314** (worse than baseline); six-model vote →
  **0.743**. The 41% → 28% value-error drop from ensembling causally produces the search gain.
- **Takeaway.** The ensemble is **necessary** — the effect is the disagreement structure across
  independently-trained models, not the boost mechanism. (Caveat: the floor variant that gives
  the hard-instance gain also taxes easy instances; all gating attempts to separate them
  failed — the benefit and cost are the same mechanism.)

---

## 6. W1 (parent–child distribution shift)  *(closed by control)*

### 5.1 Uniform-floor control

- **Purpose.** W1-multiplicative gave a real Grid expansion reduction (10.6% overall / 17.8%
  hard). Test whether W1's *ordering* of siblings carries it, or just the escape-hatch
  widening.
- **Method.** Replace W1-ranked additive floor with a **uniform** floor (same β, N0, λ; no W1
  ranking), 22 hard Grid instances.
- **Result.** W1-ranked floor 18/22 @ 1.087 vs uniform floor 18/22 @ 1.113 — indistinguishable.
  W1's plan-action-has-top-W1 rate is ~30% at decision nodes (≈ chance).
- **Takeaway.** **W1's ordering adds nothing at the escape hatch**; the Grid effect is the
  widening, not the signal. W1 works on Goldminer for a different, verified reason (it acts as a
  filter/tie-breaker: redundant actions have exactly W1=0), not via ranking.

---

## 7. The prior-flattening law  *(cross-cutting control result)*

- **Purpose.** Establish the baseline against which every prior-touching signal must be judged
  (artifact #1), by measuring what *content-free* prior flattening alone does.
- **Method.** Constant flatten `P'(a) = (1−w)P(a) + w/|A|` across w ∈ {0, 0.6, 0.8, 0.93} on
  four domains, no IQN, no signal.
- **Result.** grid 108→29→23→19 (collapses); goldminer 112→78→23→0 (collapses); rovers
  69→65→74→74 (helps, best at near-uniform); logistics 109→106→104→105 (neutral coverage, ~45%
  fewer expansions). Cross-checked against measured policy-wrong rates: grid 4% (flattening
  catastrophic), goldminer 24% (catastrophic — needs the prior to prune branching regardless of
  accuracy), rovers 11% (helps), logistics 44% (neutral).
- **Takeaway.** **The policy prior is worth roughly as much as it is accurate** (with a
  branching-factor caveat for goldminer). Any signal wired into the prior must beat the
  corresponding constant-w point to claim it carries information — this is the control that
  every prior-based signal is measured against, and it is a free, more general finding than the
  signal work that motivated it.

---

## Appendix — measurement-pitfall checklist (for any new signal)

Before believing a new positive, confirm it clears all of these:

- [ ] Reported on the **common-solved set**, median per-instance ratio (not an aggregate over a
      self-selected set) + coverage + net expansion accounting.
- [ ] Compared against a **content-free control** of equal magnitude (constant widening if it
      touches the prior; width-blind shuffle if it touches the exploration term).
- [ ] Measured on **search-visited** states, not optimal-plan/sampled states.
- [ ] **Sliced by exact distance-to-goal** (in-distribution vs OOD).
- [ ] Uses **raw** width among same-distance states, not cv / value-normalized.
- [ ] Transition-level AUC, not node-level, when scoring offline discrimination.
- [ ] Coverage losses diagnosed as **speed timeouts vs genuine search degradation** (the metric
      is expansions-to-solution, which is cost-independent and deterministic).
