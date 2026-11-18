"""Greedy Best-First Search on a learned value function.

f(s) = h(s) only. The g term is never consulted -- that is the whole definition, and it is
what separates this from search.py (f = g + h) and wastar.py (f = g + w*h). It is also what
separates it from greedy_value_plan.py and beam.py --beam 1, which are hill-climbing: they
score only the successors of the CURRENT state, commit, and cannot go back. GBFS keeps a
global open list, so when a branch turns bad it resumes from the best-h state generated
anywhere earlier in the search.

FAITHFULNESS NOTES, since the point of this script is to be a real GBFS:
  * ordering        strictly h(s); ties broken FIFO by insertion counter, the usual choice
                    and the same convention qstar.py uses.
  * open list       every generated state is a candidate, not just the current node's children.
  * duplicate       a state is entered into `seen` when first generated and never re-inserted,
    detection       and re-expansion is blocked by `closed`. GBFS is not optimal, so there is
                    no reason to re-open a state at a better g -- g plays no role at all.
  * goal test       on GENERATION, the standard choice for satisficing search: it returns as
                    soon as a goal successor appears rather than waiting for it to be popped.
  * dead ends       a state with no applicable actions is simply not expanded; the search
                    continues from the rest of the open list, unlike hill-climbing which stops.
  * termination     Solved / Exhausted (open list empty -- the reachable space is closed) /
                    Timeout. The status is PRINTED: qstar.py omits it, which made "ran out of
                    time" and "ran out of states" indistinguishable in the Phase I logs.

BATCHING. Successors of an expanded node are evaluated in one forward pass, which is where
essentially all the wall time goes.

Usage mirrors search.py / wastar.py:
  gbfs.py --domain D --problem P --model M [--max_time S] [--max_expansions N]
"""
# _NGS_PATH_BOOTSTRAP: make the repo root, training/ and analysis/ importable from any CWD.
import sys as _sys, os as _os
_ROOT = _os.path.dirname(_os.path.dirname(_os.path.abspath(__file__)))
_sys.path[:0] = [_ROOT, _os.path.join(_ROOT, 'training'), _os.path.join(_ROOT, 'analysis')]

import argparse
import heapq
import itertools
import time
from pathlib import Path
from typing import List, Optional, Tuple

import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from utils import create_device, get_state_key


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Greedy best-first search with a value model')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--model', required=True, type=Path, help='Path to a pre-trained value model')
    parser.add_argument('--max_time', default=None, type=float, help='Wall-clock budget in seconds')
    parser.add_argument('--max_expansions', default=None, type=int, help='Cap on expanded states')
    return parser.parse_args()


class ValueHeuristic:
    """h(s) = V(s), evaluated for a whole list of states in one forward pass."""

    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, goal) -> None:
        self._model = model
        self._goal = goal

    def __call__(self, states: List[mm.State]) -> List[float]:
        with torch.no_grad():
            values = self._model.forward([(s, self._goal) for s in states]).readout('value')
        assert isinstance(values, torch.Tensor), 'Model should return a tensor of values.'
        return values.cpu().tolist()


def _reconstruct(parent, key) -> List[mm.GroundAction]:
    plan = []
    while parent[key][0] is not None:
        parent_key, action = parent[key]
        plan.append(action)
        key = parent_key
    plan.reverse()
    return plan


def gbfs_search(problem: mm.Problem,
                initial_state: mm.State,
                heuristic: ValueHeuristic,
                on_expand=None,
                on_generate=None,
                on_new_best=None,
                max_time: Optional[float] = None,
                max_expansions: Optional[int] = None
                ) -> Tuple[str, Optional[List[mm.GroundAction]]]:
    start = time.time()
    goal = problem.get_goal_condition()
    initial_key = get_state_key(initial_state)
    if goal.holds(initial_state):
        return 'Solved', []

    open_list: list = []
    counter = itertools.count()
    closed = set()
    seen = {initial_key}
    parent = {initial_key: (None, None)}
    best_h = float('inf')
    expansions = 0

    heapq.heappush(open_list, (heuristic([initial_state])[0], next(counter), initial_state))

    while open_list:
        if max_time is not None and (time.time() - start) > max_time:
            return 'Timeout', None
        if max_expansions is not None and expansions >= max_expansions:
            return 'ExpansionLimit', None

        h, _, state = heapq.heappop(open_list)
        key = get_state_key(state)
        if key in closed:
            continue
        closed.add(key)
        expansions += 1
        if on_expand is not None:
            on_expand(state)
        if h < best_h:
            best_h = h
            if on_new_best is not None:
                on_new_best(h)

        actions = state.generate_applicable_actions()
        if len(actions) == 0:
            continue  # dead end: nothing to expand, but the open list carries on

        fresh_states, fresh_actions = [], []
        for action in actions:
            successor = action.apply(state)
            if on_generate is not None:
                on_generate(state, action, 1.0, successor)
            successor_key = get_state_key(successor)
            if goal.holds(successor):
                parent[successor_key] = (key, action)
                return 'Solved', _reconstruct(parent, successor_key)
            if successor_key in seen:
                continue
            seen.add(successor_key)
            parent[successor_key] = (key, action)
            fresh_states.append(successor)
            fresh_actions.append(action)

        if fresh_states:
            for successor, value in zip(fresh_states, heuristic(fresh_states)):
                heapq.heappush(open_list, (value, next(counter), successor))

    return 'Exhausted', None


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}', flush=True)
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    print(f'Loading model... ({args.model})', flush=True)
    model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.model, create_device(False))

    num_expanded = 0
    num_generated = 0

    def on_expand(_state):
        nonlocal num_expanded
        num_expanded += 1

    def on_generate(_state, _action, _cost, _successor):
        nonlocal num_generated
        num_generated += 1

    def on_new_best(h: float):
        # The GBFS analogue of search.py's f-layer trace: h is non-monotone here, so what is
        # informative is each new minimum and the work done to reach it.
        print(f'[h={h:.3f}] Expanded: {num_expanded}, Generated: {num_generated}', flush=True)

    print('Starting GBFS...', flush=True)
    started = time.time()
    status, plan = gbfs_search(
        problem,
        problem.get_initial_state(),
        ValueHeuristic(model, problem.get_goal_condition()),
        on_expand=on_expand,
        on_generate=on_generate,
        on_new_best=on_new_best,
        max_time=args.max_time,
        max_expansions=args.max_expansions,
    )

    elapsed = time.time() - started
    print(f'[Final] Expanded: {num_expanded}, Generated: {num_generated}', flush=True)
    # Elapsed is logged because the Phase I runs did not. qstar.py and search.py print no
    # timing, no .err files were kept, and Slurm accounting has expired, so the runtime of
    # every A*, W-A*, Q* and W-Q* run in the archive is permanently unrecoverable.
    print(f'[Time] {elapsed:.1f}s ({num_expanded / max(elapsed, 1e-9):.1f} expansions/s)',
          flush=True)
    print(f'[Status] {status}', flush=True)
    if status == 'Solved':
        print(f'Found a solution of length {len(plan)}!', flush=True)
        for index, action in enumerate(plan):
            print(f'{index + 1:>4}: {str(action)}')
    else:
        print('Failed to find a solution!', flush=True)


if __name__ == '__main__':
    _main(_parse_arguments())
