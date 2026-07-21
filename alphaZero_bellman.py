"""
AlphaZero + Bellman-consistency exploration widening.

Motivation (thesis, July 2026): a narrow IQN distribution means "confident",
NOT "correct". Every self-reported-uncertainty signal (width/W1/spread) failed
because the model is narrowly-confidently-wrong at the states where the policy
errs. The multi-step Bellman check instead catches the model contradicting its
OWN k-step-ahead prediction against the true deterministic transition. Offline
that error discriminates mistake from correct nodes on Goldminer (AUC ~0.85)
and Rovers (~0.65), and grows with the lookahead horizon k.

INTEGRATION (node-level widening, orientation-safe): at each expanded node s we
take the policy's top action a*, roll the IQN's OWN greedy story forward k steps
from s'=a*.apply(s), and measure the Bellman inconsistency
    err(s) = min_{b in B_good(s_k)} W1( Z(s,a*),  sum_i gamma^i r + gamma^k Z(s_k,b) )
(same quantity as grid_bellman_multistep.py). Where err is large the policy is
untrustworthy, so we FLATTEN its prior toward uniform at that node:
    prior'(a) = (1-w)*prior(a) + w*(1/|A|),   w = clamp(lambda * err/err_scale, 0, w_max)
At consistent nodes (err~0) w~0 and the prior is untouched -> no tax on the
confident-correct majority. We do NOT boost a specific action's prior: the
within-node action ranking of this error is near chance (and inverted at mistake
nodes), so only the node-level "is this node trustworthy" signal is used.

    --signal outcome : ablation. w = lambda if the greedy rollout does NOT reach
    the goal within k steps (loops/dead-ends/alive), else 0. Binary, cruder.

lambda = 0 reproduces the baseline exactly (and skips all IQN work).

Cost accounting: reducing node expansions is the metric, but this signal spends
extra IQN forward passes (the rollout). We count BOTH: [Final] prints Expanded
and Generated as before, plus total IQN forward calls, so the comparison is
honest about compute, not just expansion count.

Usage (single problem):
  venv/bin/python alphaZero_bellman.py --domain D --problem P \
    --policy_model models/rovers_sac_policy.pth \
    --q1_model models/rovers_sac_q1.pth --q2_model models/rovers_sac_q2.pth \
    --iqn_model models/rovers_iqn.pth \
    --bellman_lambda 1.0 --bellman_k 4
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
        self.lam = 0.0
        self.k = 4
        self.err_scale = 3.0
        self.w_max = 0.95
        self.mode = "bellman"      # bellman | outcome | constant
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
        self.adaptive = False
        self.err_hist: list[float] = []
        self.warmup = 32           # use err_scale until we have this many samples
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
        self.value_lam = 0.0       # 0 = value channel off
        self.q1 = None
        self.q2 = None
        self.verr_hist: list[float] = []
        self.vdist_hist: list[float] = []   # forensic: est. distance-to-goal of scored states
        self.vw_sum = 0.0; self.vw_count = 0   # forensic: actual value-discount applied
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
        self.width_beta = 0.0      # 0 = width channel off
        self.cv_hist: list[float] = []
        self.wmult_sum = 0.0; self.wmult_count = 0
        # --- diagnostic: does the width signal fire where the model is UNCERTAIN,
        #     measured on the states SEARCH ACTUALLY VISITS (not sampled states)?
        #     If diag_ens (list of (q1,q2) SAC members) is set, record per expanded
        #     node (cv, ensemble_disagreement, dist_estimate) so we can check whether
        #     low-cv (=confident) nodes really are low-disagreement nodes IN SEARCH. ---
        self.diag_ens = None
        self.diag_records: list[tuple] = []
        # --- diagnostic: log the distance (=-QRDQN value) of EVERY expanded node,
        #     for baseline AND width runs, to see WHERE (near/far goal) the width
        #     channel removes expansions. Needs iqn set even in baseline. ---
        self.log_dist = False
        self.dist_log: list[float] = []
        # --- OPTION 4: ENSEMBLE-disagreement exploration channel (leaves the prior
        #     untouched). Same modulation as OPTION 3 but the confidence comes from
        #     the DISAGREEMENT of N independently-trained SAC critics instead of the
        #     single-model width. Motivation: ensemble disagreement KEEPS its dynamic
        #     range far from the goal (CV 0.44) where the width collapses (CV 0.21) --
        #     independent models diverge OOD, which is what epistemic uncertainty is.
        #     Cost: 2*N forward passes per node. ens_members = list of (q1,q2). ---
        self.ens_beta = 0.0
        self.ens_members = None
        self.ens_cv_hist: list[float] = []
        self.ens_sum = 0.0; self.ens_count = 0

    def ensemble_explore_mult(self, state, goal) -> float:
        """Per-node exploration multiplier in [1-ens_beta, 1] from ensemble disagreement.
        <1 at LOW-disagreement (confident) nodes so search commits there. 2*N forwards."""
        if self.ens_beta <= 0.0 or self.ens_members is None:
            return 1.0
        vs = []
        for q1, q2 in self.ens_members:
            v1, acts = q1.forward([(state, goal)])[0]
            if len(acts) == 0:
                return 1.0
            v2, _ = q2.forward([(state, goal)])[0]
            vs.append(torch.minimum(v1, v2).max().item())
        self.iqn_calls += 2 * len(self.ens_members)
        import statistics as _st
        disagree = _st.pstdev(vs)
        # normalize like the width channel: disagreement relative to |value|, then to
        # the running median (distance-invariant -- both grow with distance).
        cv = disagree / (abs(_st.mean(vs)) + 1.0)
        self.ens_cv_hist.append(cv)
        if len(self.ens_cv_hist) < self.warmup:
            return 1.0
        med = sorted(self.ens_cv_hist)[len(self.ens_cv_hist) // 2]
        confidence = max(0.0, 1.0 - cv / max(med, 1e-6))
        mult = 1.0 - self.ens_beta * confidence
        self.ens_sum += mult; self.ens_count += 1
        return mult

    def width_explore_mult(self, state, goal) -> float:
        """Per-node multiplier in [1-width_beta, 1] on the exploration term.
        <1 at CONFIDENT (narrow-width) nodes so search commits there. One IQN
        forward pass per call (counted). 1.0 (no-op) while the channel warms up."""
        if self.width_beta <= 0.0 or self.iqn is None:
            return 1.0
        qs, actions = _iqn_curves(state, goal)          # counts one IQN call
        if qs is None or len(actions) == 0:
            return 1.0
        means = qs.mean(dim=1)
        ai = int(means.argmax())
        curve = qs[ai]                                   # sorted ascending, 99 quantiles
        width = (curve[89] - curve[9]).item()            # q90 - q10 (taus 0.01..0.99)
        cv = width / (abs(means[ai].item()) + 1.0)
        if self.diag_ens is not None:
            vs = []
            for q1, q2 in self.diag_ens:
                e1, acts = q1.forward([(state, goal)])[0]
                if len(acts) == 0:
                    break
                e2, _ = q2.forward([(state, goal)])[0]
                vs.append(torch.minimum(e1, e2).max().item())
            if len(vs) == len(self.diag_ens) and len(vs) > 1:
                import statistics as _st
                self.diag_records.append((cv, width, _st.pstdev(vs), -means[ai].item()))
        self.cv_hist.append(cv)
        if len(self.cv_hist) < self.warmup:
            return 1.0
        med = sorted(self.cv_hist)[len(self.cv_hist) // 2]
        confidence = max(0.0, 1.0 - cv / max(med, 1e-6))  # 1 when cv<<median
        mult = 1.0 - self.width_beta * confidence
        self.wmult_sum += mult; self.wmult_count += 1
        return mult

    def scale(self, err: float) -> float:
        """Denominator for w. Adaptive: running median of this search's errors."""
        if not self.adaptive:
            return self.err_scale
        self.err_hist.append(err)
        if len(self.err_hist) < self.warmup:
            return self.err_scale
        h = sorted(self.err_hist)
        med = h[len(h) // 2]
        return max(med, 1e-6)

    def vscale(self) -> float:
        """Adaptive denominator for the value channel: running median of verrs."""
        if len(self.verr_hist) < self.warmup:
            return self.err_scale
        h = sorted(self.verr_hist)
        return max(h[len(h) // 2], 1e-6)

    @property
    def active(self) -> bool:
        if self.mode == "constant":
            return self.const_w > 0.0     # signal-free control: no IQN needed
        return self.lam > 0.0 and self.iqn is not None

    @property
    def value_active(self) -> bool:
        return self.value_lam > 0.0 and self.iqn is not None and self.q1 is not None

    @property
    def width_active(self) -> bool:
        return self.width_beta > 0.0 and self.iqn is not None

    @property
    def ens_active(self) -> bool:
        return self.ens_beta > 0.0 and self.ens_members is not None


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


def _bellman_err(state: mm.State,
                 goal: mm.GroundConjunctiveCondition,
                 top_action: mm.GroundAction) -> Tuple[Optional[float], str]:
    """min-W1 Bellman inconsistency of `top_action` at `state` over a k-step
    IQN-greedy rollout (same definition as grid_bellman_multistep.py, eps=0).
    Returns (err or None, outcome in {goal,loop,deadend,alive})."""
    qs, actions = _iqn_curves(state, goal)
    if qs is None:
        return None, "deadend"
    amap = {_canon(str(a)): i for i, a in enumerate(actions)}
    ti = amap.get(_canon(str(top_action)))
    if ti is None:
        return None, "deadend"
    z_sa = qs[ti]

    cur = top_action.apply(state)
    visited = {get_state_key(cur)}
    acc, disc = 0.0, 1.0
    err: Optional[float] = None
    outcome = "alive"
    for m in range(1, _SIG.k + 1):
        acc += disc * _SIG.reward
        disc *= _SIG.gamma
        if goal.holds(cur):
            err = (z_sa - torch.full_like(z_sa, acc)).abs().mean().item()
            return err, "goal"
        cqs, cactions = _iqn_curves(cur, goal)
        if cqs is None:
            return err, "deadend"
        scores = cqs.mean(dim=1)
        if m == _SIG.k:
            targets = acc + disc * cqs
            w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)
            err = w1[scores >= scores.max()].min().item()   # eps=0 B_good
        nxt = cactions[int(scores.argmax())].apply(cur)
        key = get_state_key(nxt)
        if key in visited:
            if err is None:                                 # looped before reaching k
                targets = acc + disc * cqs
                w1 = (z_sa.unsqueeze(0) - targets).abs().mean(dim=1)
                err = w1[scores >= scores.max()].min().item()
            return err, "loop"
        visited.add(key)
        cur = nxt
    return err, outcome


def _qcritic_value(state: mm.State, goal: mm.GroundConjunctiveCondition) -> Optional[float]:
    """State value V(s) = max_a min(q1,q2)(s,a) from the SAC critic. None at a
    dead end. Counts toward the cost accounting (2 forward passes)."""
    _SIG.iqn_calls += 2
    v1, acts = _SIG.q1.forward([(state, goal)])[0]
    if len(acts) == 0:
        return None
    v2, _ = _SIG.q2.forward([(state, goal)])[0]
    return torch.minimum(v1, v2).max().item()


def _value_err_from_parent(v_par: float, first_succ: mm.State,
                           goal: mm.GroundConjunctiveCondition) -> Optional[float]:
    """| v_par - (accumulated cost + gamma^k * V_Qcritic(s_k)) | over a k-step
    IQN-greedy rollout from `first_succ`. The offline check showed the signal
    comes from the INDEPENDENT Q-critic endpoint, not the depth, so k=1 works
    and skips the rollout entirely (1 Q-critic eval, no IQN calls)."""
    cur = first_succ
    visited = {get_state_key(cur)}
    acc, disc = 0.0, 1.0
    for step in range(1, _SIG.k + 1):
        acc += disc * _SIG.reward
        disc *= _SIG.gamma
        if goal.holds(cur):
            return abs(v_par - acc)                      # grounded target
        if step == _SIG.k:                               # endpoint: no IQN needed
            vq = _qcritic_value(cur, goal)
            return None if vq is None else abs(v_par - (acc + disc * vq))
        cq, cact = _iqn_curves(cur, goal)                # only to continue rollout
        if cq is None:
            return None
        nxt = cact[int(cq.mean(dim=1).argmax())].apply(cur)
        key = get_state_key(nxt)
        if key in visited:
            vq = _qcritic_value(cur, goal)
            return None if vq is None else abs(v_par - (acc + disc * vq))
        visited.add(key)
        cur = nxt
    return None


def _compute_value_errs(node: "Node", goal: mm.GroundConjunctiveCondition) -> None:
    """Fill node.verr with per-action value-inconsistency (IQN parent value vs
    Q-critic-endpoint Bellman target). Parent IQN curves computed ONCE per node.
    No-op if the channel is off."""
    if not _SIG.value_active or len(node.prior) <= 1:
        return
    qs, actions = _iqn_curves(node.state, goal)          # once per node
    if qs is None:
        return
    amap = {_canon(str(a)): i for i, a in enumerate(actions)}
    for a in node.children:
        ai = amap.get(_canon(str(a)))
        if ai is None:
            continue
        v_par = qs[ai].mean().item()
        e = _value_err_from_parent(v_par, a.apply(node.state), goal)
        if e is not None:
            node.verr[a] = e
            _SIG.verr_hist.append(e)
            # FORENSIC: the IQN value is ~ -(steps to goal), so -v_par estimates
            # this state's distance. The offline AUC was only validated at d<=17;
            # record what distances search ACTUALLY visits.
            _SIG.vdist_hist.append(-v_par)


def _value_discount(node: "Node", action) -> float:
    """Multiplier in [1-w_max, 1] applied to q_norm: shrinks the value of
    Bellman-inconsistent actions toward the pessimistic floor. 1.0 = unchanged."""
    if not _SIG.value_active or action not in node.verr:
        return 1.0
    w = _SIG.value_lam * (node.verr[action] / _SIG.vscale())
    w = max(0.0, min(_SIG.w_max, w))
    _SIG.vw_sum += w; _SIG.vw_count += 1
    return 1.0 - w


def _widen_prior(node: "Node", goal: mm.GroundConjunctiveCondition) -> None:
    """Flatten node.prior toward uniform in proportion to the Bellman
    inconsistency of the node's top action. No-op if the signal is off."""
    if not _SIG.active or len(node.prior) <= 1:
        return

    if _SIG.mode == "constant":
        # CONTROL: same flattening everywhere, no Bellman check. Tests whether
        # the signal's *placement* matters or merely the amount of widening.
        w = _SIG.const_w
    else:
        top_action = max(node.prior, key=node.prior.get)
        err, outcome = _bellman_err(node.state, goal, top_action)
        if _SIG.mode == "outcome":
            w = _SIG.lam if outcome != "goal" else 0.0
        else:
            if err is None:
                return
            w = _SIG.lam * (err / _SIG.scale(err))

    w = max(0.0, min(_SIG.w_max, w))
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
        "value", "verr", "explore_mult",
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
        self.verr: Dict[mm.GroundAction, float] = {}   # per-action value inconsistency
        self.explore_mult = 1.0    # width channel: <1 shrinks this node's exploration
        self.visit_count = 0

    def q(self, action):
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state: mm.State,
                goal: mm.GroundConjunctiveCondition,
                q1_model: ModelWrapper,
                q2_model: Optional[ModelWrapper]) -> float:
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

    # Option 1: Bellman-consistency widening (prior channel).
    _widen_prior(node, goal)
    # Option 2: value-distrust (value channel; leaves the prior untouched).
    _compute_value_errs(node, goal)
    # Option 3: width-confidence exploration modulation (leaves the prior untouched).
    if _SIG.width_active and len(node.prior) > 1:
        node.explore_mult = _SIG.width_explore_mult(node.state, goal)
    # Option 4: ensemble-disagreement exploration modulation (leaves the prior untouched).
    elif _SIG.ens_active and len(node.prior) > 1:
        node.explore_mult = _SIG.ensemble_explore_mult(node.state, goal)
    # Diagnostic: record distance (=-QRDQN value) of every expanded node.
    if _SIG.log_dist and _SIG.iqn is not None:
        qd, ad = _iqn_curves(node.state, goal)
        if qd is not None and len(ad) > 0:
            _SIG.dist_log.append(-qd.mean(dim=1).max().item())

    return _leaf_value(node.state, goal, q1_model, q2_model), generated


def _select(node: Node,
            c_puct: float,
            value_norm: _ValueNormalizer,
            blocked: Optional[set] = None) -> Tuple[Optional[mm.GroundAction], Optional[Node]]:
    best_score = -float("inf")
    best_action: Optional[mm.GroundAction] = None
    best_child: Optional[Node] = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))
    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0
        # Option 2: shrink the value of Bellman-inconsistent actions toward the
        # pessimistic floor. No-op (factor 1.0) when the value channel is off.
        q_norm *= _value_discount(node, action)
        # Option 3: shrink exploration at confident (narrow-width) nodes. The prior
        # P(action) is untouched; only the c*P*sqrt(N)/(1+n) term is scaled. 1.0 off.
        u = c_puct * node.explore_mult * node.prior[action] * sqrt_parent / (1 + n)
        score = q_norm + u
        if score > best_score:
            best_score, best_action, best_child = score, action, child
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
    parser.add_argument("--bellman_lambda", default=0.0, type=float,
                        help="Widening strength. 0 = exact baseline (no IQN work).")
    parser.add_argument("--bellman_k", default=4, type=int,
                        help="Rollout horizon for the consistency check.")
    parser.add_argument("--err_scale", default=3.0, type=float,
                        help="Fixed normalizer: w = lambda * err/err_scale. NOTE this is a "
                             "domain-specific magnitude (err scales with plan length); a value "
                             "tuned on one domain saturates w on another. Prefer --adaptive_scale.")
    parser.add_argument("--adaptive_scale", action="store_true",
                        help="Normalize err by the RUNNING MEDIAN of this search's own errors "
                             "instead of --err_scale. Makes the scale domain- and instance-"
                             "independent. With this on, lambda has a direct meaning: it is the "
                             "widening applied at the MEDIAN node (w = lambda * err/median), so "
                             "use lambda ~0.2-0.8, NOT the 2-8 range used with a fixed scale.")
    parser.add_argument("--w_max", default=0.95, type=float,
                        help="Max fraction of prior mass moved to uniform at a node.")
    parser.add_argument("--signal", default="bellman",
                        choices=["bellman", "outcome", "constant"],
                        help="bellman: graded min-W1 error; outcome: binary rollout-reaches-goal; "
                             "constant: CONTROL, widen every node by --const_w with no signal.")
    parser.add_argument("--const_w", default=0.0, type=float,
                        help="Constant widening weight for --signal constant (no IQN used).")
    parser.add_argument("--value_lambda", default=0.0, type=float,
                        help="OPTION 2 (value channel, leaves prior untouched). Strength of "
                             "value-distrust: q_norm(a) *= (1 - clamp(value_lambda*verr/median, 0, "
                             "w_max)), where verr is the IQN-parent / Q-critic-endpoint Bellman "
                             "error. 0 = off. Uses an adaptive (running-median) scale, so "
                             "value_lambda ~0.2-0.8 = discount at the median-error action. Requires "
                             "--iqn_model, --q1_model, --q2_model.")
    parser.add_argument("--width_beta", default=0.0, type=float,
                        help="OPTION 3 (width-confidence EXPLORATION channel, leaves prior "
                             "untouched). At CONFIDENT (narrow-width) nodes, scale the pUCT "
                             "exploration term by (1 - width_beta*confidence) so search commits "
                             "and expands fewer siblings; UNCERTAIN nodes keep baseline "
                             "exploration. confidence in [0,1] from the QR-DQN width's coefficient "
                             "of variation vs the running-median. 0 = off (exact baseline). Try "
                             "0.3-0.8. Requires --iqn_model (point it at the calibrated QR-DQN).")
    parser.add_argument("--ens_beta", default=0.0, type=float,
                        help="OPTION 4 (ENSEMBLE-disagreement EXPLORATION channel, leaves prior "
                             "untouched). Like --width_beta but confidence comes from the "
                             "disagreement of N independently-trained SAC critics (survives far "
                             "from goal where width collapses). 0 = off. Try 0.3-0.9. Requires "
                             "--ens_prefix + --ens_n.")
    parser.add_argument("--ens_prefix", default=None, type=str,
                        help="Prefix for ensemble members; member i loads {prefix}{i}_q1_best.pth "
                             "and {prefix}{i}_q2_best.pth. E.g. models/grid_sac_ens_")
    parser.add_argument("--ens_n", default=5, type=int, help="Number of ensemble members.")
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
        print(f"[Cost] IQN forward calls (Bellman signal): {_SIG.iqn_calls}", flush=True)
        mean_w = (_SIG.w_sum / _SIG.w_count) if _SIG.w_count else 0.0
        print(f"[Widen] nodes widened: {_SIG.w_count}, mean w: {mean_w:.4f}", flush=True)
        if _SIG.wmult_count:
            print(f"[Width] nodes modulated: {_SIG.wmult_count}, mean explore_mult: "
                  f"{_SIG.wmult_sum/_SIG.wmult_count:.4f} (1.0 = no change; lower = more committed)",
                  flush=True)
        if _SIG.ens_count:
            print(f"[Ens] nodes modulated: {_SIG.ens_count}, mean explore_mult: "
                  f"{_SIG.ens_sum/_SIG.ens_count:.4f} (1.0 = no change; lower = more committed)",
                  flush=True)
        if _SIG.verr_hist:
            vh = sorted(_SIG.verr_hist)
            print(f"[Value] actions scored: {len(vh)}, median verr: "
                  f"{vh[len(vh)//2]:.4f}", flush=True)
        if _SIG.vw_count:
            print(f"[Forensic] value discount actually applied: mean w = "
                  f"{_SIG.vw_sum/_SIG.vw_count:.4f} over {_SIG.vw_count} selection evals", flush=True)
        if _SIG.vdist_hist:
            dh = sorted(_SIG.vdist_hist)
            q = lambda f: dh[min(len(dh)-1, int(f*len(dh)))]
            inreg = sum(1 for d in dh if d <= 17)
            print(f"[Forensic] est. distance-to-goal of states the signal scored: "
                  f"p10 {q(.10):.0f}  median {q(.50):.0f}  p90 {q(.90):.0f}  max {dh[-1]:.0f}", flush=True)
            print(f"[Forensic] fraction INSIDE the validated regime (d<=17): "
                  f"{100*inreg/len(dh):.1f}%  ({inreg}/{len(dh)})", flush=True)
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

    if args.signal == "constant":
        _SIG.mode = "constant"
        _SIG.const_w = args.const_w
        _SIG.w_max = args.w_max
        print(f"[Bellman] CONTROL signal=constant const_w={args.const_w} (no IQN, no Bellman check)",
              flush=True)
    elif args.bellman_lambda > 0.0:
        assert args.iqn_model is not None, "--bellman_lambda > 0 requires --iqn_model"
        iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
        iqn.eval()
        _SIG.iqn = iqn
        _SIG.taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
        _SIG.lam = args.bellman_lambda
        _SIG.k = args.bellman_k
        _SIG.err_scale = args.err_scale
        _SIG.w_max = args.w_max
        _SIG.mode = args.signal
        _SIG.adaptive = args.adaptive_scale
        scale_desc = ("adaptive (running median of this search's errors)"
                      if args.adaptive_scale else f"fixed {args.err_scale}")
        print(f"[Bellman] signal={args.signal} lambda={args.bellman_lambda} k={args.bellman_k} "
              f"scale={scale_desc} w_max={args.w_max}", flush=True)
    else:
        print("[Bellman] lambda=0 -> baseline (no widening signal)", flush=True)

    # OPTION 2: value-distrust channel. Independent of the widening above; can be
    # used alone (bellman_lambda=0). Needs the IQN (parent) + Q-critics (endpoint).
    if args.value_lambda > 0.0:
        assert args.iqn_model is not None and q2_model is not None, \
            "--value_lambda > 0 requires --iqn_model, --q1_model, --q2_model"
        if _SIG.iqn is None:
            iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
            iqn.eval()
            _SIG.iqn = iqn
            _SIG.taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
            _SIG.k = args.bellman_k
        _SIG.q1 = q1_model
        _SIG.q2 = q2_model
        _SIG.value_lam = args.value_lambda
        _SIG.w_max = args.w_max
        _SIG.err_scale = args.err_scale
        print(f"[Value] OPTION2 value_lambda={args.value_lambda} k={args.bellman_k} "
              f"endpoint=Qcritic w_max={args.w_max} (adaptive median scale)", flush=True)

    # OPTION 3: width-confidence exploration channel. Point --iqn_model at the
    # calibrated QR-DQN; its distribution width is the uncertainty signal.
    if args.width_beta > 0.0:
        assert args.iqn_model is not None, "--width_beta > 0 requires --iqn_model (the QR-DQN)"
        if _SIG.iqn is None:
            iqn, _, _ = _load_iqn_model(domain, args.iqn_model, device)
            iqn.eval()
            _SIG.iqn = iqn
            _SIG.taus = torch.linspace(0.01, 0.99, 99, device=device).unsqueeze(0)
        _SIG.width_beta = args.width_beta
        print(f"[Width] OPTION3 width_beta={args.width_beta} signal=QR-DQN width "
              f"(shrinks exploration at confident nodes; prior untouched)", flush=True)

    # OPTION 4: ensemble-disagreement exploration channel.
    if args.ens_beta > 0.0:
        assert args.ens_prefix is not None, "--ens_beta > 0 requires --ens_prefix"
        members = []
        for i in range(1, args.ens_n + 1):
            m1, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"{args.ens_prefix}{i}_q1_best.pth"), device)
            m2, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"{args.ens_prefix}{i}_q2_best.pth"), device)
            members.append((ModelWrapper(m1, "q"), ModelWrapper(m2, "q")))
        _SIG.ens_members = members
        _SIG.ens_beta = args.ens_beta
        print(f"[Ens] OPTION4 ens_beta={args.ens_beta} members={len(members)} "
              f"signal=SAC-ensemble disagreement (shrinks exploration at agreeing nodes; "
              f"prior untouched)", flush=True)

    solution = _plan(problem, policy_model, q1_model, q2_model, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())
