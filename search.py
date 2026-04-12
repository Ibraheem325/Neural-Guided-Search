import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import torch

from pathlib import Path
from typing import Union
from utils import create_device


class NeuralHeuristic(mm.Heuristic):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork):
        super().__init__()
        self._model = model

    def compute_value(self, state: mm.State, goal: Union[mm.GroundConjunctiveCondition, None] = None) -> float:
        if goal is None:
            goal = state.get_problem().get_goal_condition()
        if goal.holds(state):
            return 0.0
        with torch.no_grad():
            self._model.eval()
            problem = state.get_problem()
            goal = problem.get_goal_condition()
            value = self._model.forward([(state, goal)]).readout('value')[0]
            return value

    def get_preferred_actions(self) -> set[mm.GroundAction]:
        return set()  # No preferred actions for this heuristic.


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for testing')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--model', required=True, type=Path, help='Path to a pre-trained model')
    parser.add_argument('--optimize', action='store_true', help='Whether to optimize the model with torch.compile and TF32')
    args = parser.parse_args()
    return args


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    domain = mm.Domain(args.domain)
    problem = mm.Problem(domain, args.problem)
    print(f'Loading model... ({args.model})')
    device = create_device(False)
    model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.model, device)
    # Compile the model for faster inference, and use TF32 for faster computation.
    if args.optimize:
        rgnn.set_tf32_enabled(True)
        compile_mode = model.enable_torch_compile('inference')
        print(f'Model loaded and compiled with mode: {compile_mode}')
    initial_state = problem.get_initial_state()
    neural_heuristic = NeuralHeuristic(model)
    # Initialize counters for statistics.
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
    # Start the A* search with eager evaluation.
    result = mm.astar_eager(
        problem,
        initial_state,
        neural_heuristic,
        on_expand_state=increment_expanded,
        on_generate_state=increment_generated,
        on_finish_f_layer=print_f_layer,
    )
    # Print the statistics.
    print(f'[Final] Expanded: {num_expanded}, Generated: {num_generated}')
    # Print the result of the search.
    if result.status == "solved":
        assert result.solution is not None
        print(f'Found a solution of length {len(result.solution)}!')
        for index, action in enumerate(result.solution):
            print(f'{index + 1:>4}: {str(action)}')
    else:
        print('Failed to find a solution!')


if __name__ == '__main__':
    _main(_parse_arguments())
