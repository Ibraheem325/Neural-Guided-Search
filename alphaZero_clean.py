"""AlphaZero pUCT search with the Bellman-inconsistency prior signal.

This is alphaZero.py plus ONE channel -- the absolute-scale signal (the supervisor's
reformulation) that every sweep in the thesis used -- and its controls. It was cut down from
a 1556-line file that had accumulated nine channels, one per approach tried; the eight that
were tried and abandoned are gone. The full version remains in the project archive.

WHAT THE SIGNAL DOES. At each expanded node, for every applicable action a:

    e_a  = min_b W1( Z(s,a),  r + gamma*Z(s',b) )     unsigned distributional TD error
    x_a  = e_a / (e_a + tau_step)                     squashed into [0,1), NO sibling division
    g_s  = (1/K) sum_a x_a                            state-level inconsistency
    P0   = (1 - eps_p) P(a) + eps_p/K                 prior floor, so a P~0 arm is reachable

    add:  P_+(a) = (P0(a) + beta*x_a/K) / (1 + beta*g_s)      sums to 1 exactly
    mul:  P_x(a) = P0(a)(1 + beta*x_a), renormalised
    both: c(s)   = c_puct * (1 + kappa*g_s)                   via node.explore_mult

Selection is then plain pUCT:  score(a) = q_norm(a) + c(s)*P(a)*sqrt(N)/(1+n).

THE CONTROLS, which is where the result actually lives:
    --sib_shuffle          permute the e_a among siblings. Keeps the magnitude and g_s,
                           destroys only WHICH action gets boosted. Tests placement.
    --sib_random SPEC      redraw e_a from a fitted lognormal. Keeps the average level,
                           destroys per-state structure. Tests magnitude.
    --signal constant
      --const_w W          flatten every prior by a fixed W with no model call at all.
                           Tests whether the signal matters versus any perturbation.

FINDING (five domains): the signal beats these controls only on satellite, whose SAC prior
is confidently RIGHT (confidently-wrong on 4.9% of on-plan states). Where the prior is
confidently WRONG -- goldminer 11.0%, grid 20.8%, rovers 21.1%, logistics prior collapse --
blind perturbation does just as well or better, and --signal constant is often the winner.
The exploration channel (kappa) is a null on all five against a matched-c_puct control.

Behaviour is byte-identical to the original on every configuration the sweeps used:
verified on 4 probes x 7 configs (off / add / add k=0 / mul / shuffle / random / flat),
matching expansions, plan length and the exact action sequence.
"""
import argparse
import math
import time
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import Dict, List, Optional, Tuple
from utils import create_device, get_state_key
import pymimir_rl as rl
from train_iqn import _load_model as _load_iqn_model


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, readout_name: str) -> None:
        super().__init__()
        self.model = model
        self.readout_name = readout_name

    def forward(
        self, state_goals: List[Tuple[mm.State, mm.GroundConjunctiveCondition]]
    ) -> List[Tuple[torch.Tensor, List[mm.GroundAction]]]:
        input_list: List[Tuple[mm.State, List[mm.GroundAction], mm.GroundConjunctiveCondition]] = []
        actions_list: List[List[mm.GroundAction]] = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        values_list = self.model.forward(input_list).readout(self.readout_name)  # type: ignore
        return list(zip(values_list, actions_list))


# ---- Bellman-consistency signal state (module-level to avoid threading through
#      every search function; set up once in _main). ----
class _Signal:
    def __init__(self):
        self.iqn = None
        self.taus = None
        self.const_w = 0.0         # constant mode: fixed widening at every node
        self.gamma = 0.999
        self.reward = -1.0
        self.iqn_calls = 0         # cost counter: total IQN forward passes
        self.w_sum = 0.0           # to report the mean widening actually applied
        self.w_count = 0
        # --- adaptive error scale ---------------------------------------
        # err is a W1 distance between value curves, so its magnitude scales
        # with the value magnitude (i.e. with plan length) and differs per
        # domain AND per instance. A fixed err_scale therefore saturates w at
        # the cap on some instances (prior erased -> search wanders) while
        # leaving dynamic range on others. Instead, normalize by the running
        # MEDIAN of the errors seen in THIS search, so w answers "how
        # inconsistent is this node relative to a typical node here?".
        # --- OPTION 2: value-distrust channel (leaves the prior untouched) ---
        # A statement about VALUE reliability belongs on the value term, not the
        # policy prior. Compute a per-action Bellman error with an INDEPENDENT
        # endpoint model (the SAC Q-critic; error-corr 0.093 with the IQN, so it
        # actually breaks the self-consistency the single-IQN check couldn't),
        # then in selection shrink q_norm of high-error actions toward the
        # pessimistic FPU floor (0). The offline check says this error is HIGHER
        # on worse actions (transition AUC ~0.59 far from goal), so demoting
        # high-error actions steers search AWAY from bad moves -- the signal's
        # DIRECTION is used, unlike widening which only flattens.
        # --- OPTION 3: width-confidence EXPLORATION channel (leaves the prior
        #     untouched, unlike widening). The calibrated QR-DQN's distribution
        #     WIDTH tracks epistemic uncertainty (offline AUC 0.60-0.95 vs ensemble
        #     disagreement, all distances). Where the model is CONFIDENT (narrow
        #     width) we shrink the pUCT exploration term c*P*sqrt(N)/(1+n) so search
        #     COMMITS instead of fanning out over siblings -> fewer expansions;
        #     where UNCERTAIN (wide) exploration is left at baseline -> coverage kept.
        #     Distance-invariant: width grows with distance, so we use the
        #     coefficient of variation cv = width/|value| normalized by the running
        #     MEDIAN cv of this search ("is this node confident RELATIVE to a
        #     typical node here?"). explore_mult in [1-beta, 1]; beta=0 == baseline.
        # normalization for the width confidence:
        #   'cv'     : confidence from cv=width/|value| vs running-median cv (original;
        #              the /|value| over-divides and costs ~0.15 AUC).
        #   'banded' : confidence from raw width vs the running-median width of nodes at a
        #              SIMILAR value (=distance), preserving the raw-width ranking that
        #              validated at AUC ~0.79-0.82. This is the better normalization.
        # --- diagnostic: does the width signal fire where the model is UNCERTAIN,
        #     measured on the states SEARCH ACTUALLY VISITS (not sampled states)?
        #     If diag_ens (list of (q1,q2) SAC members) is set, record per expanded
        #     node (cv, ensemble_disagreement, dist_estimate) so we can check whether
        #     low-cv (=confident) nodes really are low-disagreement nodes IN SEARCH. ---
        # --- diagnostic: log the distance (=-QRDQN value) of EVERY expanded node,
        #     for baseline AND width runs, to see WHERE (near/far goal) the width
        #     channel removes expansions. Needs iqn set even in baseline. ---
        # --- signal diagnostic: on a BASELINE search (no modulation), log per expanded
        #     node (exact_distance, cv, width, ensemble_disagreement) so we can measure
        #     AUC(signal -> disagreement) by TRUE distance on the search-visited distribution.
        #     dist_fn(state) -> exact steps-to-goal (or None). Needs iqn + diag_ens set. ---
        # --- OPTION 4: ENSEMBLE-disagreement exploration channel (leaves the prior
        #     untouched). Same modulation as OPTION 3 but the confidence comes from
        #     the DISAGREEMENT of N independently-trained SAC critics instead of the
        #     single-model width. Motivation: ensemble disagreement KEEPS its dynamic
        #     range far from the goal (CV 0.44) where the width collapses (CV 0.21) --
        #     independent models diverge OOD, which is what epistemic uncertainty is.
        #     Cost: 2*N forward passes per node. ens_members = list of (q1,q2). ---
        # --- OPTION 5: SIBLING raw-width exploration channel (leaves the prior
        #     untouched). RAW width tracks uncertainty strongly (AUC 0.82-1.00) but only
        #     AMONG SAME-DISTANCE states; any cross-distance normalization (cv) corrupts it
        #     because width and value co-vary. A node's CHILDREN are all one step away =
        #     same distance, so we compare their RAW widths directly (no normalization,
        #     nothing to cancel, compression-proof) and BOOST exploration toward the wider
        #     (more-uncertain) children. mult(a) = 1 + sib_beta*(width(a)/mean_sib_width - 1).
        #     sib_beta=0 == baseline. One QR-DQN forward per node (Z(s,a) for all actions). ---
        # CONTROL: shuffle widths among siblings (same multiplier multiset, width-BLIND
        # placement). If savings persist under shuffle, the effect is generic exploration
        # redistribution, NOT the width signal. Deterministic per node (seeded by state key).
        self.sib_shuffle = False
        # RANDOM control (stronger than shuffle): discard the signal values entirely and
        # draw a fresh weight per child. Shuffle keeps the multiset -- same dispersion,
        # only the placement is scrambled. Random keeps nothing but the mean-1
        # normalisation, so it also strips the signal's spread. "" = off.
        self.sib_random = ""       # "" | "uniform" | "exp"
        # ROOM GATE: only apply the sibling channel once the search has expanded >= sib_gate
        # unique states (len(tt)). Low-room probes solve before the gate opens (baseline
        # behaviour, no over-widening); high-room probes get the channel once they show
        # struggle. 0 = no gate (channel active from the start). n_expanded = live tt size.
        self.sib_gate = 0
        self.n_expanded = 0
        # --- OPTION 6: SIBLING BELLMAN-INCONSISTENCY exploration channel (leaves the prior
        #     untouched). Same clean integration as OPTION 5, but the per-child signal is the
        #     1-step min-W1 Bellman inconsistency W1(Z(s,a), reward + gamma*Z(s',b*)) -- how
        #     far the parent's per-action distribution is from what the Bellman equation says
        #     (its own discounted successor). ~0 when self-consistent, large when inconsistent.
        #     High => boost that child's exploration (among siblings). Named "Bellman
        #     inconsistency" (NOT "W1") to avoid confusion with the old raw parent-child W1
        #     prior channel. Costs one QR-DQN forward per child (parent + each successor). ---
        # OPTION 6 B_good width: a successor b counts as "good" if its mean value is within
        # binc_eps of the best successor's. binc = min-W1 over B_good (benefit of the doubt:
        # only flag inconsistency if the parent disagrees with EVERY near-optimal successor).
        # 0.0 = hard best neighbor (original); ~0.5-1.0 forgives near-tied successors.
        # --- OPTION 7: SIBLING RAW EDGE-W1 exploration channel (leaves the prior untouched).
        #     Same clean integration as OPTION 5/6, but the per-child signal is the RAW
        #     parent-vs-child distribution shift W1(Z_best(s), Z_best(s'_a)) -- NO reward, NO
        #     discount (exactly the alphaZero_w1.py "validation form" edge-W1). Differs from
        #     OPTION 6 by the ~1-per-step Bellman baseline that binc subtracts off. Boost
        #     exploration toward children with a larger distribution shift. ---
        # SELF-CONSISTENT VALUE: use the QR-DQN mean as the leaf value (instead of the SAC
        # twin critics), so the uncertainty signal matches the value function driving search.
        self.qrdqn_value = False
        # --- OPTION 8: ADDITIVE signal bonus (prior-INDEPENDENT) -------------------------
        #   u(a) = [ c_puct * P(a)^prior_gamma  +  add_beta * min(cap, max(0, rel-1)) ]
        #          * sqrt(N)/(1+n)
        # The bonus is NOT multiplied by P(a), so it can promote children the multiplicative
        # channel structurally cannot (35% of grid sibling edges have P == 0.0 exactly).
        # max(0,.) => only ever ADDS exploration, never penalises the policy's own pick.
        # The sqrt(N)/(1+n) decay keeps it a nudge, not a permanent hijack.
        # NOTE: prior_gamma < 1 SOFTENS the P-gate (sqrt(P) lifts numerically-dead tiny-P
        # children) while keeping P==0 -> 0, i.e. actions the policy truly rejected stay
        # rejected. That gate is what protected coverage in every multiplicative arm.
        # --- OPTION 9: ABSOLUTE-SCALE signal (supervisor's reformulation) -----------------
        # Drops the sibling division entirely. The per-action Bellman residual e_a is kept in
        # decoded reward units (1.0 = one action) and squashed on its own:
        #     x_a  = e_a / (e_a + tau_step)              in [0,1), no denominator over siblings
        #     g_s  = (1/K) sum_a x_a                     state-level inconsistency
        #     c(s) = c_puct (1 + kappa g_s)              exploration-constant channel (explore_mult)
        #     P0   = (1-eps_p) P + eps_p/K               prior floor, so a P~0 arm is reachable
        #   mul:  P_x(a) = P0(a)(1+beta x_a) / sum_b P0(b)(1+beta x_b)
        #   add:  P_+(a) = (P0(a) + beta x_a/K) / (1 + beta g_s)   [exact: sum_a x_a/K = g_s]
        # The 1/K stops the injected mass from growing with the branching factor.
        # Unlike rel = e_a/mean_b(e_b), x_a is scale-AWARE: a state whose residuals are all
        # small now gets a near-no-op instead of a full-strength boost (see new_signal_report.py:
        # old max-boost was flat/inverted across scale quartiles, new is monotone).
        self.abs_mode = "off"      # off | add | mul
        self.tau_step = 1.0
        self.abs_beta = 1.0
        self.abs_kappa = 1.0
        self.eps_p = 0.001
        self.abs_g_sum = 0.0; self.abs_g_count = 0; self.abs_tv_sum = 0.0

    @property
    def abs_active(self) -> bool:
        return self.abs_mode != "off" and self.iqn is not None








    @property
    def flatten_active(self) -> bool:
        return self.const_w > 0.0     # signal-free control: needs no model at all





_SIG = _Signal()


def _canon(s: str) -> str:
    return s.lower().replace(" ", "").replace("(", "").replace(")", "")


def _iqn_curves(state: mm.State, goal: mm.GroundConjunctiveCondition):
    """Sorted 99-quantile curves for all applicable actions: ([A,99], actions).
    None at a dead end. Counts one IQN forward pass."""
    _SIG.iqn_calls += 1
    q, actions = _SIG.iqn.forward([(state, goal)], taus=_SIG.taus)[0]
    if q.shape[0] == 0:
        return None, []
    qs, _ = torch.sort(q, dim=1)
    return qs, actions














def _randomise_signal(vals: dict, state_key) -> dict:
    """RANDOM control. Replace every child's signal value with an independent draw,
    keeping only the dict's keys. Unlike --sib_shuffle (which permutes the real values
    and so preserves their spread exactly), this destroys the spread as well: after the
    caller's mean-1 normalisation, rel carries no information about the signal at all.
    Seeded by state key, so it stays deterministic and independent of visit order.

    uniform  U(0,1)  -- CV of the resulting rel ~0.54-0.58 (closest to grid 0.66 / goldminer 0.61)
    exp      Exp(1)  -- CV ~0.71-0.95 (closer to logistics multi-loc, 1.26)
    """
    import math as _math, random as _random
    rng = _random.Random((hash(state_key) & 0x7fffffff) ^ 0x5eed)
    spec = _SIG.sib_random
    if spec.startswith("lognormal"):
        # MAGNITUDE-MATCHED control. uniform/exp draws do not reproduce the real signal's
        # dispersion (uniform gives CV~0.55 vs the real 0.61-0.66), so a uniform "random"
        # arm perturbs ~15-20% less hard and its smaller effect can be mistaken for
        # "the signal carries information". lognormal(0, sigma) lets us match CV exactly.
        # Calibrated sigma by median sibling count: goldminer n=3 -> 0.88 (CV 0.610),
        # grid n=5 -> 0.78 (CV 0.663), logistics n=17 -> 1.16 (CV 1.256).
        #
        # 3-part form "lognormal:<sigma>:<mu>" for OPTION 9. There the values are consumed
        # as RAW residuals (x_a = e_a/(e_a+tau)), not passed through a mean-1 normalisation,
        # so the control has to reproduce the MARGINAL of e itself, not just its dispersion:
        # mu=0 would put the median residual at 1.0 instead of ~0.55 and inflate g_s.
        # Fitted to new_signal_data.json: goldminer mu=-0.585 sigma=1.003, grid mu=-0.680
        # sigma=1.073. These reproduce mean g_s to within 0.001 while destroying the
        # state-to-state structure (g_s sd 0.124 drawn vs 0.134 real on goldminer).
        parts = spec.split(":")
        sigma = float(parts[1]) if len(parts) > 1 else 0.85
        mu = float(parts[2]) if len(parts) > 2 else 0.0
        draw = lambda: rng.lognormvariate(mu, sigma)
    elif spec == "exp":
        draw = lambda: rng.expovariate(1.0)
    else:
        draw = rng.random
    return {k: draw() for k in vals}




def _bellman_residuals(node: "Node", goal: mm.GroundConjunctiveCondition) -> Dict:
    """RAW per-action Bellman residual e_a = W1(Z(s,a), r + gamma*Z(s',b*)) in decoded
    reward units (1.0 = one action), b* = argmax_b E[Z(s',b)] with a deterministic
    tie-break. A goal successor grounds the target at the step reward (a Dirac), so
    e_a = mean|z - r|. Same quantity OPTION 6 computes, WITHOUT the sibling division."""
    qs, actions = _iqn_curves(node.state, goal)
    if qs is None:
        return {}
    amap = {_canon(str(a)): i for i, a in enumerate(actions)}
    es = {}
    for a in node.children:
        ai = amap.get(_canon(str(a)))
        if ai is None:
            continue
        z_sa = qs[ai]
        cur = a.apply(node.state)
        if goal.holds(cur):
            es[a] = (z_sa - torch.full_like(z_sa, _SIG.reward)).abs().mean().item()
            continue
        cqs, _ = _iqn_curves(cur, goal)
        if cqs is None:                                   # dead-end child: no comparison
            continue
        targets = _SIG.reward + _SIG.gamma * cqs
        scores = cqs.mean(dim=1)
        w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)
        es[a] = w1[scores >= scores.max()].min().item()   # b* = argmax mean, det. tie-break
    return es


def _compute_abs_signal(node: "Node", goal: mm.GroundConjunctiveCondition) -> None:
    """OPTION 9. Rewrites node.prior to P_+ (add) or P_x (mul) and sets node.explore_mult
    to c(s)/c_puct = 1 + kappa*g_s. Nothing downstream in _select needs to change: the
    formulation is entirely a prior transform plus an exploration-constant scale."""
    if not _SIG.abs_active or len(node.prior) <= 1:
        return
    if _SIG.sib_gate > 0 and _SIG.n_expanded < _SIG.sib_gate:
        return
    es = _bellman_residuals(node, goal)
    if len(es) < 2:
        return
    if _SIG.sib_random:
        es = _randomise_signal(es, node.state_key)
    elif _SIG.sib_shuffle:
        import random as _random
        rng = _random.Random(hash(node.state_key) & 0x7fffffff)
        keys = list(es.keys()); vals = list(es.values()); rng.shuffle(vals)
        es = {k: v for k, v in zip(keys, vals)}

    tau = _SIG.tau_step
    x = {a: e / (e + tau) for a, e in es.items()}
    # Actions with no residual (dead-end child) keep x=0: never boosted, never penalised.
    K = len(node.prior)
    g = sum(x.values()) / K
    beta, eps = _SIG.abs_beta, _SIG.eps_p

    p0 = {a: (1.0 - eps) * p + eps / K for a, p in node.prior.items()}
    if _SIG.abs_mode == "mul":
        z = {a: p0[a] * (1.0 + beta * x.get(a, 0.0)) for a in p0}
        s = sum(z.values())
        new = {a: v / s for a, v in z.items()} if s > 0 else p0
    else:                                                 # "add"
        # sum_a (p0 + beta*x_a/K) = 1 + beta*g exactly, so this is already normalised.
        new = {a: (p0[a] + beta * x.get(a, 0.0) / K) / (1.0 + beta * g) for a in p0}

    _SIG.abs_tv_sum += 0.5 * sum(abs(new[a] - node.prior[a]) for a in node.prior)
    node.prior = new
    node.explore_mult = 1.0 + _SIG.abs_kappa * g          # c(s) = c_puct * (1 + kappa g_s)
    _SIG.abs_g_sum += g; _SIG.abs_g_count += 1






def _flatten_prior(node: "Node", goal: mm.GroundConjunctiveCondition) -> None:
    """SIGNAL-FREE FLATTENING CONTROL:  prior'(a) = (1-w)P(a) + w/K

    The same amount of perturbation at every node, chosen without any model call. This is
    what separates "the signal's placement matters" from "any perturbation of this size
    helps" -- on goldminer it beat every signal arm (coverage 337 -> 478) and on rovers it
    matched the best one (head-to-head p=0.7359). No-op when const_w is 0."""
    if not _SIG.flatten_active or len(node.prior) <= 1:
        return
    w = max(0.0, min(1.0, _SIG.const_w))
    _SIG.w_sum += w
    _SIG.w_count += 1
    if w <= 0.0:
        return
    uniform = 1.0 / len(node.prior)
    for a in node.prior:
        node.prior[a] = (1.0 - w) * node.prior[a] + w * uniform


class _ValueNormalizer:
    def __init__(self) -> None:
        self._min = float("inf")
        self._max = -float("inf")

    def update(self, value: float) -> None:
        if value < self._min:
            self._min = value
        if value > self._max:
            self._max = value

    def normalize(self, value: float) -> float:
        if self._max > self._min:
            return (value - self._min) / (self._max - self._min)
        return value


class Node:
    __slots__ = (
        "state", "state_key", "is_goal",
        "expanded", "is_dead_end",
        "children", "prior", "edge_N", "edge_W", "visit_count",
        "value", "explore_mult",
    )

    def __init__(self, state: mm.State, state_key, is_goal: bool) -> None:
        self.state = state
        self.state_key = state_key
        self.is_goal = is_goal
        self.expanded = False
        self.is_dead_end = False
        self.children: Dict[mm.GroundAction, "Node"] = {}
        self.prior: Dict[mm.GroundAction, float] = {}
        self.edge_N: Dict[mm.GroundAction, int] = {}
        self.edge_W: Dict[mm.GroundAction, float] = {}
        self.value = -float("inf")
        self.explore_mult = 1.0    # width channel: <1 shrinks this node's exploration
        self.visit_count = 0

    def q(self, action):
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state: mm.State,
                goal: mm.GroundConjunctiveCondition,
                q1_model: ModelWrapper,
                q2_model: Optional[ModelWrapper]) -> float:
    # SELF-CONSISTENT MODE: use the QR-DQN (the same model as the width/Binc signal) as the
    # leaf value = max_a mean Z(s,a), so the uncertainty we widen at matches the value in use.
    if _SIG.qrdqn_value and _SIG.iqn is not None:
        q, _ = _SIG.iqn.forward([(state, goal)], taus=_SIG.taus)[0]
        if q.shape[0] == 0:
            return 0.0
        return q.mean(dim=1).max().item()
    q1_vals, _ = q1_model.forward([(state, goal)])[0]
    if q2_model is not None:
        q2_vals, _ = q2_model.forward([(state, goal)])[0]
        q_vals = torch.minimum(q1_vals, q2_vals)
    else:
        q_vals = q1_vals
    return q_vals.max().item()


def _expand(node: Node,
            tt: Dict[object, Node],
            policy_model: ModelWrapper,
            q1_model: ModelWrapper,
            q2_model: Optional[ModelWrapper],
            goal: mm.GroundConjunctiveCondition,
            dead_end_value: float) -> Tuple[float, int]:
    logits, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True

    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0

    probs = torch.softmax(logits, dim=0)
    generated = 0
    for i, action in enumerate(actions):
        successor = action.apply(node.state)
        key = get_state_key(successor)
        child = tt.get(key)
        if child is None:
            child = Node(successor, key, goal.holds(successor))
            tt[key] = child
            generated += 1
        node.children[action] = child
        node.prior[action] = probs[i].item()
        node.edge_N[action] = 0

    _flatten_prior(node, goal)
    # THE SIGNAL: rewrites the prior to P_+ (add) or P_x (mul) and sets
    # node.explore_mult = c(s)/c_puct = 1 + kappa*g_s.
    if _SIG.abs_active and len(node.prior) > 1:
        _SIG.n_expanded = len(tt)
        _compute_abs_signal(node, goal)
    return _leaf_value(node.state, goal, q1_model, q2_model), generated


class _SelectDiag:
    """Relative influence of the prior term vs the value term inside _select.

    Enabled by --diag_select. Costs two list appends per selection, so it is off by default.
    """
    __slots__ = ("on", "n", "dq", "du", "u_wins", "all_unvisited", "ratios")

    def __init__(self):
        self.on = False
        self.n = 0
        self.dq = 0.0
        self.du = 0.0
        self.u_wins = 0
        self.all_unvisited = 0
        self.ratios = []

    def report(self):
        if not self.on or self.n == 0:
            return
        import statistics as _st
        fin = [r for r in self.ratios if r != float("inf")]
        print(f"[Select] decisions {self.n}")
        print(f"[Select] mean spread  q_norm {self.dq/self.n:.4f}   u {self.du/self.n:.4f}")
        if fin:
            print(f"[Select] spread ratio u/q  median {_st.median(fin):.3f}   "
                  f"p10 {_st.quantiles(fin, n=10)[0]:.3f}  "
                  f"p90 {_st.quantiles(fin, n=10)[8]:.3f}" if len(fin) >= 10 else
                  f"[Select] spread ratio u/q  median {_st.median(fin):.3f}")
        print(f"[Select] u spread exceeds q spread on {100.0*self.u_wins/self.n:.1f}% of decisions")
        print(f"[Select] all siblings unvisited (prior alone decides) on "
              f"{100.0*self.all_unvisited/self.n:.1f}% of decisions")


_SEL = _SelectDiag()


def _select(node: Node,
            c_puct: float,
            value_norm: _ValueNormalizer,
            blocked: Optional[set] = None) -> Tuple[Optional[mm.GroundAction], Optional[Node]]:
    best_score = -float("inf")
    best_action: Optional[mm.GroundAction] = None
    best_child: Optional[Node] = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))
    _qs, _us = [], []
    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0
        # pUCT. node.explore_mult is c(s)/c_puct = 1 + kappa*g_s when the exploration
        # channel is on and exactly 1.0 otherwise, so this is standard pUCT for the
        # baseline, for the flattening control, and for prior-only arms.
        u = c_puct * node.explore_mult * node.prior[action] * sqrt_parent / (1 + n)
        score = q_norm + u
        if _SEL.on:
            _qs.append(q_norm); _us.append(u)
        if score > best_score:
            best_score, best_action, best_child = score, action, child
    # WHO IS ACTUALLY DECIDING? The prior only enters through u, and q_norm is 0 for any
    # action with n=0, so the prior's real job is choosing which actions get a FIRST visit.
    # If the spread of u across siblings is small next to the spread of q_norm, the prior is
    # decorative at this node and perturbing it -- with signal or with noise -- cannot matter.
    # That is the hypothesis for why the random control matches the real signal on the
    # low-branching domains, and it is not something the search results can answer.
    if _SEL.on and len(_qs) >= 2:
        dq = max(_qs) - min(_qs)
        du = max(_us) - min(_us)
        _SEL.n += 1
        _SEL.dq += dq
        _SEL.du += du
        if du > dq:
            _SEL.u_wins += 1
        if all(q == 0.0 for q in _qs):        # nothing visited yet: prior alone decides
            _SEL.all_unvisited += 1
        _SEL.ratios.append(du / dq if dq > 0 else float("inf"))
    return best_action, best_child


def _backup(path_nodes, path_edges, leaf_value, value_norm):
    path_nodes[-1].value = max(path_nodes[-1].value, leaf_value)
    for node in reversed(path_nodes):
        if node.children:
            best_child = max(c.value for c in node.children.values())
            node.value = max(node.value, best_child)
        node.visit_count += 1
    for node, action in path_edges:
        node.edge_N[action] += 1
        value_norm.update(node.q(action))


def _simulate(root: Node,
              tt: Dict[object, Node],
              policy_model: ModelWrapper,
              q1_model: ModelWrapper,
              q2_model: Optional[ModelWrapper],
              goal: mm.GroundConjunctiveCondition,
              c_puct: float,
              value_norm: _ValueNormalizer,
              dead_end_value: float) -> Tuple[Optional[List[mm.GroundAction]], int]:
    path_keys = {root.state_key}
    path_nodes: List[Node] = [root]
    path_edges: List[Tuple[Node, mm.GroundAction]] = []
    node = root

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys)
        if action is None:
            value = _leaf_value(node.state, goal, q1_model, q2_model)
            _backup(path_nodes, path_edges, value, value_norm)
            return None, 0
        path_edges.append((node, action))
        node = child
        path_nodes.append(node)
        path_keys.add(node.state_key)

    goal_plan: Optional[List[mm.GroundAction]] = None
    generated = 0

    if node.is_goal:
        value = 0.0
        goal_plan = [a for _, a in path_edges]
    elif node.is_dead_end:
        value = dead_end_value
    else:
        value, generated = _expand(node, tt, policy_model, q1_model, q2_model, goal, dead_end_value)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state: mm.State,
            root_key,
            policy_model: ModelWrapper,
            q1_model: ModelWrapper,
            q2_model: Optional[ModelWrapper],
            goal: mm.GroundConjunctiveCondition,
            max_simulations: int,
            max_time: Optional[float],
            c_puct: float,
            dead_end_value: float,
            stop_on_first_solution: bool) -> Tuple[Optional[List[mm.GroundAction]], int, int]:
    root = Node(root_state, root_key, goal.holds(root_state))
    tt: Dict[object, Node] = {root_key: root}
    value_norm = _ValueNormalizer()
    best_plan: Optional[List[mm.GroundAction]] = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        goal_plan, generated = _simulate(
            root, tt, policy_model, q1_model, q2_model, goal,
            c_puct, value_norm, dead_end_value,
        )
        total_generated += generated
        sims += 1

        if goal_plan is not None and (best_plan is None or len(goal_plan) < len(best_plan)):
            best_plan = goal_plan
            print(f"  [sim {sims}] found goal path of length {len(best_plan)}", flush=True)
            if stop_on_first_solution:
                break

        if sims % 500 == 0:
            print(f"  [sim {sims}] root visits={root.visit_count}, "
                  f"unique states={len(tt)}, generated={total_generated}, "
                  f"iqn_calls={_SIG.iqn_calls}", flush=True)

    return best_plan, sims, total_generated


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="AlphaZero + Bellman-consistency widening")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path)
    parser.add_argument("--iqn_model", default=None, type=Path,
                        help="IQN for the Bellman signal (required if --bellman_lambda > 0).")
    parser.add_argument("--signal", default="bellman",
                        choices=["bellman", "outcome", "constant"],
                        help="bellman: graded min-W1 error; outcome: binary rollout-reaches-goal; "
                             "constant: CONTROL, widen every node by --const_w with no signal.")
    parser.add_argument("--const_w", default=0.0, type=float,
                        help="Constant widening weight for --signal constant (no IQN used).")
    parser.add_argument("--sib_gate", default=0, type=int,
                        help="ROOM GATE for OPTION 5: activate the sibling channel only after "
                             "the search has expanded >= this many unique states (len(tt)). "
                             "Low-room probes solve before the gate opens (baseline, no "
                             "over-widening); high-room probes get the channel once they show "
                             "struggle. 0 = no gate. Try ~80-150.")
    parser.add_argument("--diag_select", action="store_true",
                        help="report how much the prior term (u) actually moves the pUCT "
                             "decision relative to the value term (q_norm). The prior only "
                             "enters through u, and q_norm is 0 for unvisited actions, so "
                             "this measures whether perturbing the prior can matter at all "
                             "on this domain -- the hypothesis behind random matching the "
                             "real signal where branching is low.")
    parser.add_argument("--sib_random", default="",
                        help="RANDOM control, stronger than --sib_shuffle. Discards the signal "
                             "values entirely and draws an independent weight per child "
                             "before the mean-1 normalisation. One of: uniform | exp | "
                             "lognormal:<sigma> (magnitude-matched -- pick sigma so the induced "
                             "CV of rel matches the real signal: 0.88 goldminer, 0.78 grid, 1.16 logistics). "
                             "Shuffle preserves the signal's spread and only scrambles placement; "
                             "random strips the spread too. Takes precedence over --sib_shuffle.")
    parser.add_argument("--sib_shuffle", action="store_true",
                        help="CONTROL for OPTION 5/6: shuffle the per-child signal among siblings "
                             "(same multiplier multiset, signal-BLIND placement). If savings "
                             "survive, the effect is generic exploration redistribution, not the "
                             "signal. Applies to whichever of --sib_beta / --binc_beta is active.")
    parser.add_argument("--qrdqn_value", action="store_true",
                        help="SELF-CONSISTENT MODE: use the QR-DQN (--iqn_model) as the leaf "
                             "value (max_a mean Z(s,a)) instead of the SAC twin critics, so the "
                             "width/Binc uncertainty signal is about the SAME model whose value "
                             "drives search. Requires --iqn_model.")
    parser.add_argument("--abs_signal", default="off", choices=["off", "add", "mul"],
                        help="OPTION 9 (ABSOLUTE-SCALE signal; supervisor's reformulation). "
                             "No sibling division: x_a = e_a/(e_a+tau_step) from the RAW Bellman "
                             "residual, g_s = mean_a x_a. 'add' = prior-independent P_+(a) = "
                             "(P0+beta*x_a/K)/(1+beta*g_s) -- the only variant that can lift an "
                             "arm the policy gave ~0 prior. 'mul' = P_x(a) ~ P0(a)(1+beta*x_a) "
                             "-- near no-op at eps_p=0.001 because SAC saturates. Both also set "
                             "c(s)=c_puct*(1+kappa*g_s). Requires --iqn_model. Respects "
                             "--sib_gate/--sib_shuffle/--sib_random.")
    parser.add_argument("--tau_step", default=1.0, type=float,
                        help="OPTION 9 squash knee, in reward units (1 action = 1.0). e_a=tau "
                             "gives x_a=0.5. Sweep {0.5, 1, 2}.")
    parser.add_argument("--abs_beta", default=1.0, type=float,
                        help="OPTION 9 prior-tilt strength.")
    parser.add_argument("--abs_kappa", default=1.0, type=float,
                        help="OPTION 9 exploration-widening strength: c(s)=c_puct*(1+kappa*g_s). "
                             "0 = leave c_puct alone (prior channel only).")
    parser.add_argument("--eps_p", default=0.001, type=float,
                        help="OPTION 9 prior floor: P0=(1-eps_p)P+eps_p/K.")
    parser.add_argument("--max_simulations", default=100000000, type=int)
    parser.add_argument("--max_time", default=None, type=float)
    parser.add_argument("--c_puct", default=1.5, type=float)
    parser.add_argument("--dead_end_value", default=-1000.0, type=float)
    parser.add_argument("--keep_searching", action="store_true")
    return parser.parse_args()


def _plan(problem: mm.Problem,
          policy_model: ModelWrapper,
          q1_model: ModelWrapper,
          q2_model: Optional[ModelWrapper],
          args: argparse.Namespace) -> Optional[List[mm.GroundAction]]:
    with torch.no_grad():
        goal = problem.get_goal_condition()
        initial = problem.get_initial_state()
        if goal.holds(initial):
            return []

        plan, sims, generated = _search(
            initial, get_state_key(initial),
            policy_model, q1_model, q2_model, goal,
            args.max_simulations, args.max_time, args.c_puct, args.dead_end_value,
            stop_on_first_solution=not args.keep_searching,
        )
        print(f"[Final] Expanded: {generated}, Generated: {generated}", flush=True)
        _SEL.report()
        print(f"[Cost] IQN forward calls: {_SIG.iqn_calls}", flush=True)
        mean_w = (_SIG.w_sum / _SIG.w_count) if _SIG.w_count else 0.0
        print(f"[Widen] nodes widened: {_SIG.w_count}, mean w: {mean_w:.4f}", flush=True)
        if _SIG.abs_g_count:
            print(f"[Signal] nodes modulated: {_SIG.abs_g_count}, mean g_s: "
                  f"{_SIG.abs_g_sum/_SIG.abs_g_count:.4f} "
                  f"(=> mean c(s)/c_puct {1 + _SIG.abs_kappa*_SIG.abs_g_sum/_SIG.abs_g_count:.3f}), "
                  f"mean prior mass moved: {_SIG.abs_tv_sum/_SIG.abs_g_count:.4f} "
                  f"(0 = prior untouched)", flush=True)
        print(f"[search done] simulations={sims}, unique states generated={generated}", flush=True)

        if plan is None:
            return None

        state = initial
        for action in plan:
            state = action.apply(state)
        assert goal.holds(state), "Extracted plan does not reach the goal!"
        return plan


def _main(args: argparse.Namespace) -> None:
    print(f"Torch: {torch.__version__}", flush=True)
    _SEL.on = args.diag_select
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    device = create_device(False)

    policy_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    q1_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    policy_model = ModelWrapper(policy_raw, "policy")
    q1_model = ModelWrapper(q1_raw, "q")

    q2_model = None
    if args.q2_model is not None:
        q2_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
        q2_model = ModelWrapper(q2_raw, "q")

    # Signal-free flattening control. --signal constant flattens every prior by a fixed w
    # with no model call; --signal bellman with the default lambda=0 is the plain baseline.
    if args.signal == "constant":
        _SIG.const_w = args.const_w
        print(f"[Flatten] CONTROL const_w={args.const_w} "
              f"(prior'(a) = (1-w)P(a) + w/K at every node; no IQN, no signal)", flush=True)

    # THE SIGNAL. Rewrites the prior to P_+ / P_x and sets c(s).
    if args.abs_signal != "off":
        assert args.iqn_model is not None, "--abs_signal requires --iqn_model (the QR-DQN)"
        if _SIG.iqn is None:
            iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
            iqn.eval()
            _SIG.iqn = iqn
            _SIG.taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
        _SIG.abs_mode = args.abs_signal
        _SIG.tau_step = args.tau_step
        _SIG.abs_beta = args.abs_beta
        _SIG.abs_kappa = args.abs_kappa
        _SIG.eps_p = args.eps_p
        _SIG.sib_gate = args.sib_gate
        _SIG.sib_shuffle = args.sib_shuffle
        _SIG.sib_random = args.sib_random
        tag = (f" [RANDOM CONTROL: {args.sib_random} weights, signal discarded]" if args.sib_random
               else " [SHUFFLE CONTROL: signal-blind placement]" if args.sib_shuffle else "")
        print(f"[Signal] mode={args.abs_signal} tau_step={args.tau_step} "
              f"beta={args.abs_beta} kappa={args.abs_kappa} eps_p={args.eps_p} "
              f"(x_a=e_a/(e_a+tau), NO sibling division; prior -> "
              f"{'P_+' if args.abs_signal == 'add' else 'P_x'}, c(s)=c_puct*(1+kappa*g_s)){tag}",
              flush=True)

    # SELF-CONSISTENT VALUE: route the leaf value through the QR-DQN (same model as the signal).
    if args.qrdqn_value:
        assert args.iqn_model is not None, "--qrdqn_value requires --iqn_model (the QR-DQN)"
        if _SIG.iqn is None:
            iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
            iqn.eval()
            _SIG.iqn = iqn
            _SIG.taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
        _SIG.qrdqn_value = True
        print("[Value] SELF-CONSISTENT: leaf value = QR-DQN max_a mean Z(s,a) "
              "(SAC critics bypassed; prior still SAC policy)", flush=True)

    solution = _plan(problem, policy_model, q1_model, q2_model, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())
