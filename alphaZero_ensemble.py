"""
AlphaZero (transposition-table DAG) guided by an IQN ENSEMBLE VOTE.

Motivation (grid_ensemble_disagreement.py, July 2026): at the 321 nodes of
the 22 hard Grid instances where the policy confidently picks the wrong
action, the 6-model IQN ensemble's value comparison prefers the correct
successor 59% of the time (policy: 0%), while at correct nodes it agrees
with the policy 65% of the time. First signal measured on Grid that
discriminates in BOTH directions (W1: 20%/20%, width: 15%/23%).
Disagreement magnitude carries no information (same spread at mistake and
correct nodes) -- the usable signal is the vote DIRECTION.

Signal: when a node is expanded, every ensemble member values every child
(mean of the best action's sorted quantile curve; goal children count as
+inf, dead ends as -inf). Each member votes for its top child. The signal
of child a is its vote share:

    vote(a) = (# models whose top-valued child is a) / M          in [0, 1]

Selection (same validated machinery as alphaZero_w1_ramp.py):

    P'(a) = ( P(a) * (1 + lambda * vote(a)) + beta * min(1, N(s)/N0) * vote(a) ) / Z
    U(s,a) = Q_norm(s,a) + c_puct * P'(a) * sqrt(N(s)) / (1 + N(s,a))

lambda: immediate multiplicative boost (acts at flat decision nodes).
beta / N0: delayed additive floor (opens P=0 siblings at peaked nodes once
the node has been visited N0 times; 83% of policy mistakes sit at peaked
nodes, which the multiplicative part cannot reach).
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


class PolicyEnsemble:
    """Averages the softmax priors of M seed-diverse SAC policies.
    M=1 reproduces the single-policy behaviour exactly."""

    def __init__(self, policies):
        self.policies = policies

    @torch.no_grad()
    def forward(self, state_goals):
        out = []
        per_policy = [pol.forward(state_goals) for pol in self.policies]
        for i in range(len(state_goals)):
            actions = per_policy[0][i][1]
            acc = None
            for pp in per_policy:
                logits = pp[i][0]
                p = torch.softmax(logits, dim=0)
                acc = p.clone() if acc is None else acc + p
            acc = acc / len(self.policies)
            out.append((acc, actions))       # (averaged probabilities, actions)
        return out


class EnsembleOracle:
    """Votes of M IQN models over a node's children."""

    def __init__(self, iqn_models, device: torch.device, num_quantiles: int = 99) -> None:
        self._models = iqn_models
        self._device = device
        self._taus = torch.linspace(0.01, 0.99, num_quantiles, device=device).unsqueeze(0)

    @torch.no_grad()
    def _values(self, model, states_goals):
        """Batched: value of each state = mean of best action's sorted curve."""
        n = len(states_goals)
        taus = self._taus.expand(n, self._taus.shape[1])
        out = model.forward(states_goals, taus=taus)
        values = []
        for q_values, _ in out:
            if q_values.shape[0] == 0:
                values.append(float("-inf"))       # dead end
                continue
            qs, _ = torch.sort(q_values, dim=1)
            values.append(qs.mean(dim=1).max().item())
        return values

    @torch.no_grad()
    def votes(self, children, goal):
        """children: list of (action, child_node). Returns {action: vote share}."""
        idx_of = {}
        batch = []
        for i, (action, child) in enumerate(children):
            idx_of[action] = i
            batch.append((child.state, goal))

        counts = {action: 0 for action, _ in children}
        m_used = 0
        goal_actions = [a for a, c in children if c.is_goal]
        if goal_actions:
            # A goal child outranks anything a value model could say.
            for a in goal_actions:
                counts[a] = len(self._models)
            m_used = len(self._models)
        else:
            for model in self._models:
                vals = self._values(model, batch)
                best_i = max(range(len(vals)), key=lambda i: vals[i])
                if vals[best_i] == float("-inf"):
                    continue
                best_action = children[best_i][0]
                counts[best_action] += 1
                m_used += 1
        if m_used == 0:
            return {a: 0.0 for a, _ in children}
        return {a: c / m_used for a, c in counts.items()}


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
        "children", "prior", "edge_N", "vote", "visit_count",
        "value",
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
        self.vote: Dict[mm.GroundAction, float] = {}
        self.value = -float("inf")
        self.visit_count = 0

    def q(self, action):
        child = self.children[action]
        return child.value if child.value > -float("inf") else 0.0


def _leaf_value(state, goal, q1_model, q2_model) -> float:
    q1_vals, _ = q1_model.forward([(state, goal)])[0]
    if q2_model is not None:
        q2_vals, _ = q2_model.forward([(state, goal)])[0]
        q_vals = torch.minimum(q1_vals, q2_vals)
    else:
        q_vals = q1_vals
    return q_vals.max().item()


def _expand(node, tt, policy_model, q1_model, q2_model, goal, dead_end_value,
            oracle) -> Tuple[float, int]:
    probs, actions = policy_model.forward([(node.state, goal)])[0]
    node.expanded = True
    if len(actions) == 0:
        node.is_dead_end = True
        return dead_end_value, 0

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

    if oracle is not None:
        node.vote = oracle.votes(list(node.children.items()), goal)

    return _leaf_value(node.state, goal, q1_model, q2_model), generated


def _select(node, c_puct, value_norm, blocked=None,
            v_lambda=0.0, v_beta=0.0, v_n0=256, boost_active=True, v_floor_thresh=0.0,
            v_floor_disagree=False):
    boosted_prior = None
    if boost_active and (v_lambda != 0.0 or v_beta != 0.0) and node.vote:
        ramp = min(1.0, node.visit_count / float(v_n0)) if v_beta != 0.0 else 0.0
        # Disagreement gate: the additive floor fires at a node only when the
        # ensemble's plurality vote goes to a child OTHER than the policy's
        # chosen (argmax-prior) child -- i.e. the value models collectively
        # disagree with the policy. At easy/correct nodes the ensemble votes
        # for the dominant child (agreement) -> floor stays off, no tax. At
        # hard mistake nodes the ensemble votes for a sibling -> floor opens it.
        floor_on = ramp
        if v_floor_disagree and node.vote:
            dom_action = max(node.prior, key=node.prior.get)
            top_vote_action = max(node.vote, key=node.vote.get)
            if top_vote_action == dom_action:
                floor_on = 0.0
        raw = {}
        total = 0.0
        for action in node.children:
            v = node.vote.get(action, 0.0)
            floor_v = v if v >= v_floor_thresh else 0.0
            pb = node.prior[action] * (1.0 + v_lambda * v) + v_beta * floor_on * floor_v
            raw[action] = pb
            total += pb
        if total > 0.0:
            boosted_prior = {a: p / total for a, p in raw.items()}

    best_score = -float("inf")
    best_action = None
    best_child = None
    sqrt_parent = math.sqrt(max(1, node.visit_count))

    for action, child in node.children.items():
        if blocked is not None and child.state_key in blocked:
            continue
        n = node.edge_N[action]
        q_norm = value_norm.normalize(node.q(action)) if n > 0 else 0.0
        p_use = boosted_prior[action] if boosted_prior is not None else node.prior[action]
        u = c_puct * p_use * sqrt_parent / (1 + n)
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


def _simulate(root, tt, policy_model, q1_model, q2_model, goal,
              c_puct, value_norm, dead_end_value, oracle, v_lambda, v_beta, v_n0, boost_active, v_floor_thresh, v_floor_disagree):
    path_keys = {root.state_key}
    path_nodes = [root]
    path_edges = []
    node = root

    while node.expanded and not node.is_goal and not node.is_dead_end:
        action, child = _select(node, c_puct, value_norm, blocked=path_keys,
                                v_lambda=v_lambda, v_beta=v_beta, v_n0=v_n0,
                                boost_active=boost_active, v_floor_thresh=v_floor_thresh,
                                v_floor_disagree=v_floor_disagree)
        if action is None:
            value = _leaf_value(node.state, goal, q1_model, q2_model)
            _backup(path_nodes, path_edges, value, value_norm)
            return None, 0
        path_edges.append((node, action))
        node = child
        path_nodes.append(node)
        path_keys.add(node.state_key)

    goal_plan = None
    generated = 0

    if node.is_goal:
        value = 0.0
        goal_plan = [a for _, a in path_edges]
    elif node.is_dead_end:
        value = dead_end_value
    else:
        value, generated = _expand(node, tt, policy_model, q1_model, q2_model, goal,
                                   dead_end_value, oracle)
        for child_action, child in node.children.items():
            if child.is_goal:
                goal_plan = [a for _, a in path_edges] + [child_action]
                break

    _backup(path_nodes, path_edges, value, value_norm)
    return goal_plan, generated


def _search(root_state, root_key, policy_model, q1_model, q2_model, goal,
            max_simulations, max_time, c_puct, dead_end_value,
            stop_on_first_solution, oracle, v_lambda, v_beta, v_n0, v_warmup, v_floor_thresh, v_floor_disagree):
    root = Node(root_state, root_key, goal.holds(root_state))
    tt = {root_key: root}
    value_norm = _ValueNormalizer()
    best_plan = None
    total_generated = 0
    start = time.time()
    sims = 0

    while sims < max_simulations:
        if max_time is not None and (time.time() - start) > max_time:
            break
        boost_active = total_generated >= v_warmup
        goal_plan, generated = _simulate(
            root, tt, policy_model, q1_model, q2_model, goal,
            c_puct, value_norm, dead_end_value, oracle, v_lambda, v_beta, v_n0,
            boost_active, v_floor_thresh, v_floor_disagree,
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
                  f"unique states={len(tt)}, generated={total_generated}", flush=True)

    return best_plan, sims, total_generated


def _parse_arguments():
    parser = argparse.ArgumentParser(description="AlphaZero guided by an IQN ensemble vote")
    parser.add_argument("--domain", required=True, type=Path)
    parser.add_argument("--problem", required=True, type=Path)
    parser.add_argument("--policy_model", required=True, type=Path)
    parser.add_argument("--policy_models", nargs="+", default=None, type=Path,
                        help="If given, average these seed-diverse policies' priors "
                             "(de-peaks confidently-wrong mistake nodes). Overrides --policy_model.")
    parser.add_argument("--q1_model", required=True, type=Path)
    parser.add_argument("--q2_model", default=None, type=Path)
    parser.add_argument("--iqn_models", required=True, nargs="+", type=Path,
                        help="Paths of the ensemble members (2+ IQN checkpoints)")
    parser.add_argument("--max_simulations", default=100000000, type=int)
    parser.add_argument("--max_time", default=None, type=float)
    parser.add_argument("--c_puct", default=1.5, type=float)
    parser.add_argument("--v_lambda", default=1.5, type=float,
                        help="Multiplicative vote boost strength (0 = off)")
    parser.add_argument("--v_beta", default=0.0, type=float,
                        help="Delayed additive floor strength (0 = off)")
    parser.add_argument("--v_n0", default=256, type=int,
                        help="Parent visits at which the additive floor saturates")
    parser.add_argument("--v_warmup", default=0, type=int,
                        help="Global: keep pure-baseline selection until the search has "
                             "generated this many states (protects easy instances). 0 = off.")
    parser.add_argument("--v_floor_thresh", default=0.0, type=float,
                        help="Additive floor only opens siblings with vote share >= this "
                             "(discriminative gate; 0.5 = majority-backed only).")
    parser.add_argument("--v_floor_disagree", action="store_true",
                        help="Floor fires only at nodes where the ensemble plurality vote "
                             "disagrees with the policy argmax (targets mistake nodes).")
    parser.add_argument("--dead_end_value", default=-1000.0, type=float)
    parser.add_argument("--keep_searching", action="store_true")
    return parser.parse_args()


def _plan(problem, policy_model, q1_model, q2_model, oracle, args):
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
            oracle=oracle, v_lambda=args.v_lambda, v_beta=args.v_beta, v_n0=args.v_n0,
            v_warmup=args.v_warmup, v_floor_thresh=args.v_floor_thresh,
            v_floor_disagree=args.v_floor_disagree,
        )
        print(f"[Final] Expanded: {generated}, Generated: {generated}", flush=True)
        print(f"[search done] simulations={sims}, unique states generated={generated}", flush=True)
        if plan is None:
            return None
        state = initial
        for action in plan:
            state = action.apply(state)
        assert goal.holds(state), "Extracted plan does not reach the goal!"
        return plan


def _main(args):
    print(f"Torch: {torch.__version__}", flush=True)
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    device = create_device(False)

    policy_paths = args.policy_models if args.policy_models else [args.policy_model]
    policies = []
    for pp in policy_paths:
        praw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, pp, device)
        policies.append(ModelWrapper(praw, "policy"))
    policy_model = PolicyEnsemble(policies)
    q1_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    q1_model = ModelWrapper(q1_raw, "q")
    print(f"[config] policy ensemble: {len(policies)} policies", flush=True)

    q2_model = None
    if args.q2_model is not None:
        q2_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q2_model, device)
        q2_model = ModelWrapper(q2_raw, "q")

    members = []
    for p in args.iqn_models:
        m, _, _ = _load_iqn_model(domain, p, device)
        m.eval()
        members.append(m)
    oracle = EnsembleOracle(members, device)
    print(f"[config] ensemble vote: M={len(members)} members, "
          f"v_lambda={args.v_lambda} v_beta={args.v_beta} v_n0={args.v_n0} "
          f"v_warmup={args.v_warmup} v_floor_thresh={args.v_floor_thresh} c_puct={args.c_puct}", flush=True)

    solution = _plan(problem, policy_model, q1_model, q2_model, oracle, args)
    if solution is None:
        print("Failed to find a solution!")
    else:
        print(f"Found a solution of length {len(solution)}!")
        for index, action in enumerate(solution):
            print(f"{index + 1:>4}: {str(action)}")


if __name__ == "__main__":
    _main(_parse_arguments())
