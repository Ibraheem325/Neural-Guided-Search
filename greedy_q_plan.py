import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import List, Union
from utils import create_device, get_state_key, mask_visited_scores


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for greedy planning with a Q-value model')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--model', required=True, type=Path, help='Path to a pre-trained Q-value model')
    parser.add_argument('--disable_closed_set', action='store_true', help='Allow revisiting previously seen states even when unvisited successors exist')
    args = parser.parse_args()
    return args


def _read_q_values(model_output: object) -> torch.Tensor:
    if isinstance(model_output, list):
        assert len(model_output) == 1, 'Model should return one tensor of Q-values for the current state.'
        q_values = model_output[0]
    else:
        q_values = model_output
    assert isinstance(q_values, torch.Tensor), 'Model should return Q-values as tensors.'
    return q_values.cpu()


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
        while not goal.holds(current_state) and (len(solution) < 1_000):
            applicable_actions = current_state.generate_applicable_actions()
            if len(applicable_actions) == 0:
                return None
            successor_states = [action.apply(current_state) for action in applicable_actions]
            q_values = model.forward([(current_state, applicable_actions, goal)]).readout('q')
            q_values = _read_q_values(q_values)
            if use_closed_set:
                q_values = mask_visited_scores(successor_states, q_values, visited_states, float('-inf'))
            max_index = int(q_values.argmax().item())
            max_value = q_values[max_index].item()
            selected_action = applicable_actions[max_index]
            current_state = successor_states[max_index]
            visited_states.add(get_state_key(current_state))
            solution.append(selected_action)
            print(f'{max_value:.3f}: {str(selected_action)}')
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
