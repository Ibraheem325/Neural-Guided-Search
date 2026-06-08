import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import Union
from utils import create_device, get_state_key
import heapq
import itertools


class NeuralQFunction():
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork):
        self._model = model
        self._model.eval()

    def compute_costs(self, state, goal=None):
        if goal is None:
            goal = state.get_problem().get_goal_condition()
        applicable_actions = state.generate_applicable_actions()
        if len(applicable_actions) == 0:
            return ([], [])
        with torch.no_grad():
            q_tensor = self._model.forward([(state, applicable_actions, goal)]).readout('q')
            q_tensor = q_tensor[0]
            costs = (-q_tensor).cpu().tolist()
        return (applicable_actions, costs)


def qstar_search(problem, initial_state, q_function,
                 on_expand_state=None,
                 on_generate_state=None,
                 on_finish_f_layer=None):
    goal = problem.get_goal_condition()
    if goal.holds(initial_state):
        return ("Solved", [])

    best_g = {}
    parent = {}
    best_g[get_state_key(initial_state)] = 0.0
    openlist = []
    counter = itertools.count()
    last_f = None

    # Expand the initial state.
    if on_expand_state is not None:
        on_expand_state(initial_state)
    actions, costs = q_function.compute_costs(initial_state, goal)
    for a, c in zip(actions, costs):
        f = 0.0 + c
        heapq.heappush(openlist, (f, next(counter), 0.0, initial_state, a))

    while openlist:
        f, _, g_of_s, current_state, action = heapq.heappop(openlist)
        if best_g[get_state_key(current_state)] < g_of_s:
            continue

        # f-layer callback: we just popped an entry with a strictly larger f
        # than the previous one, meaning the previous f-layer is finished.
        if on_finish_f_layer is not None and last_f is not None and f > last_f:
            on_finish_f_layer(last_f)
        last_f = f

        successor = action.apply(current_state)
        g_successor = g_of_s + 1
        if on_generate_state is not None:
            on_generate_state(current_state, action, 1.0, successor)

        key_successor = get_state_key(successor)
        if goal.holds(successor):
            parent[key_successor] = (get_state_key(current_state), action)
            # Fire one last f-layer callback for the layer we were in.
            if on_finish_f_layer is not None:
                on_finish_f_layer(last_f)
            solution = _reconstruct_plan(parent, successor)
            return ("Solved", solution)

        if key_successor in best_g and best_g[key_successor] <= g_successor:
            continue
        best_g[key_successor] = g_successor
        parent[key_successor] = (get_state_key(current_state), action)

        if on_expand_state is not None:
            on_expand_state(successor)
        actions, costs = q_function.compute_costs(successor, goal)
        for a, c in zip(actions, costs):
            g_successor = 0.0
            f_new = g_successor + c
            heapq.heappush(openlist, (f_new, next(counter), g_successor, successor, a))

    return ("Exhausted", None)


def _reconstruct_plan(parent, goal_state):
    current_state_key = get_state_key(goal_state)
    solution = []
    while current_state_key in parent:
        current_state_key, action = parent[current_state_key]
        solution.append(action)
    solution.reverse()
    return solution


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for Q* testing')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--model', required=True, type=Path, help='Path to a pre-trained Q model')
    args = parser.parse_args()
    return args


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    print(f'Loading model... ({args.model})')
    device = create_device(False)
    model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.model, device)
    initial_state = problem.get_initial_state()
    q_function = NeuralQFunction(model)

    num_expanded = 0
    num_generated = 0
    def increment_expanded(state):
        nonlocal num_expanded
        num_expanded += 1
    def increment_generated(state, action, cost, successor_state):
        nonlocal num_generated
        num_generated += 1
    def print_f_layer(f: float):
        print(f'[f={f:.3f}] Expanded: {num_expanded}, Generated: {num_generated}')

    print('Starting Q* search...')
    status, plan = qstar_search(
        problem,
        initial_state,
        q_function,
        on_expand_state=increment_expanded,
        on_generate_state=increment_generated,
        on_finish_f_layer=print_f_layer,
    )

    print(f'[Final] Expanded: {num_expanded}, Generated: {num_generated}')
    if status == "Solved":
        print(f'Found a solution of length {len(plan)}!')
        for i, action in enumerate(plan):
            print(f'{i + 1:>4}: {action}')
    else:
        print('Failed to find a solution!')


if __name__ == '__main__':
    _main(_parse_arguments())