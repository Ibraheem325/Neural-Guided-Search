import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import List, Union
from utils import create_device, get_state_key, mask_visited_scores


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for greedy planning with a value model')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--model', required=True, type=Path, help='Path to a pre-trained value model')
    parser.add_argument('--disable_closed_set', action='store_true', help='Allow revisiting previously seen states even when unvisited successors exist')
    args = parser.parse_args()
    return args


def _plan(
    problem: mm.Problem,
    model: rgnn.RelationalGraphNeuralNetwork,
    use_closed_set: bool = True,
) -> Union[None, List[mm.GroundAction]]:
    with torch.no_grad():
        solution = []
        goal = problem.get_goal_condition()
        current_state = problem.get_initial_state()
        visited_states = {get_state_key(current_state)}
        num_expanded= 0
        num_generated = 0
        while not goal.holds(current_state) and (len(solution) < 1_000):
            applicable_actions = current_state.generate_applicable_actions()
            if len(applicable_actions) == 0:
                return None
            inputs = [(action.apply(current_state), goal) for action in applicable_actions]
            num_generated += len(inputs)
            successor_states = [state for state, _ in inputs]
            values = model.forward(inputs).readout('value')
            assert isinstance(values, torch.Tensor), 'Model should return a tensor of values.'
            values = values.cpu()
            if use_closed_set:
                values = mask_visited_scores(successor_states, values, visited_states, float('inf'))
            min_index = int(values.argmin().item())
            min_value = values[min_index].item()
            selected_action = applicable_actions[min_index]
            current_state = successor_states[min_index]
            visited_states.add(get_state_key(current_state))
            solution.append(selected_action)
            num_expanded+=1
            print(f'{min_value:.3f}: {str(selected_action)}')
        print(f'[Final] Expanded: {num_expanded}, Generated: {num_generated}')
        return solution if goal.holds(current_state) else None


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    domain = mm.Domain(args.domain)
    problem = mm.Problem(domain, args.problem)
    model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.model, create_device(False))
    solution = _plan(problem, model, use_closed_set=not args.disable_closed_set)
    if solution is None:
        print('Failed to find a solution!')
    else:
        print(f'Found a solution of length {len(solution)}!')
        for index, action in enumerate(solution):
            print(f'{index + 1:>4}: {str(action)}')


if __name__ == '__main__':
    _main(_parse_arguments())
