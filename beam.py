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
    parser.add_argument('--beam', default=1, type=int, help='The beam size for exploitation')
    args = parser.parse_args()
    return args


def _plan(
    problem: mm.Problem,
    model: rgnn.RelationalGraphNeuralNetwork,
    beam: int,
    use_closed_set: bool = True,
) -> Union[None, List[mm.GroundAction]]:
    with torch.no_grad():
        goal = problem.get_goal_condition()
        current_beam = [problem.get_initial_state()]
        visited_states = {get_state_key(current_beam[0])}
        parent_map = {current_beam[0]: (None, None)}
        finished = False
        count = 0
        num_expanded = 0
        num_generated = 0
        while not finished and count<1000:
            inputs = []
            successor_states = []
            successor_with_parent = []
            num_expanded += len(current_beam)
            for i in range(len(current_beam)):
                
                applicable_actions = current_beam[i].generate_applicable_actions()
                
                if len(applicable_actions) == 0:
                    continue

                new_entries = [(action.apply(current_beam[i]), action, current_beam[i]) for action in applicable_actions]
                num_generated += len(new_entries)
                successor_with_parent += new_entries
                inputs += [(state, goal) for state, action, parent in new_entries]
                successor_states += [state for state, action, parent in new_entries]

            if(len(inputs)==0):
                return None
            values = model.forward(inputs).readout('value')
            assert isinstance(values, torch.Tensor), 'Model should return a tensor of values.'
            values = values.cpu()
            if use_closed_set:
                values = mask_visited_scores(successor_states, values, visited_states, float('inf'))
            min_indices = torch.argsort(values)[:min(beam, len(successor_states))].tolist()

            top_k = [successor_with_parent[i] for i in min_indices]
            current_beam = [state for state, action, parent in top_k]
            for state, action, parent in top_k:
                parent_map[state] = (parent, action)
            for j in range(len(current_beam)):
                state, action, parent = top_k[j]
                print(f'{values[min_indices[j]].item():.3f}: {str(action)}')
                
                visited_states.add(get_state_key(current_beam[j]))

                if goal.holds(current_beam[j]):
                    finished = True

                    current = current_beam[j]
                    solution = []
                    while current != problem.get_initial_state():
                        solution.append(parent_map[current][1])
                        current = parent_map[current][0]
            count+=1
        solution.reverse()
        print(f'[Final] Expanded: {num_expanded}, Generated: {num_generated}')
        return solution


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    domain = mm.Domain(args.domain)
    problem = mm.Problem(domain, args.problem)
    model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.model, create_device(False))


    solution = _plan(problem, model, args.beam, use_closed_set=not args.disable_closed_set)
    if solution is None:
        print('Failed to find a solution!')
    else:
        print(f'Found a solution of length {len(solution)}!')
        for index, action in enumerate(solution):
            print(f'{index + 1:>4}: {str(action)}')


if __name__ == '__main__':
    _main(_parse_arguments())
