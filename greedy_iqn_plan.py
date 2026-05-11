import argparse
import pymimir as mm
import torch

from pathlib import Path
from typing import List, Union

from train_iqn import IQNModelWrapper, RiskSensitivePolicyWrapper, _load_model
from utils import create_device


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for greedy planning with an IQN model')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--model', required=True, type=Path, help='Path to a pre-trained IQN model')
    parser.add_argument('--risk_averseness', default=None, type=float, help='Override the checkpoint risk averseness in [0, 1]')
    parser.add_argument('--num_quantiles', default=None, type=int, help='Override the number of quantiles used for planning and printed distributions')
    args = parser.parse_args()
    return args


def _create_planning_taus(num_quantiles: int, tau_upper_bound: float, device: torch.device) -> torch.Tensor:
    assert num_quantiles > 0, 'Number of planning quantiles must be positive.'
    assert tau_upper_bound > 0.0, 'Tau upper bound must be positive.'
    return torch.linspace(0.0, tau_upper_bound, steps=num_quantiles + 2, device=device)[1:-1].unsqueeze(0)


def _format_distribution(quantiles: torch.Tensor) -> str:
    return '[' + ', '.join(f'{value:.3f}' for value in quantiles.tolist()) + ']'


def _plan(
    problem: mm.Problem,
    model: IQNModelWrapper,
    policy_model: RiskSensitivePolicyWrapper,
) -> Union[None, List[mm.GroundAction]]:
    with torch.no_grad():
        solution = []
        goal = problem.get_goal_condition()
        current_state = problem.get_initial_state()
        device = next(model.parameters()).device
        taus = _create_planning_taus(policy_model.num_policy_quantiles, policy_model.get_tau_upper_bound(), device)
        while not goal.holds(current_state) and (len(solution) < 1_000):
            quantile_outputs = model.forward([(current_state, goal)], taus=taus)
            q_quantiles, applicable_actions = quantile_outputs[0]
            if len(applicable_actions) == 0:
                return None
            action_scores = policy_model.reduce_quantiles(q_quantiles).cpu()
            q_quantiles = q_quantiles.cpu()
            max_index = int(action_scores.argmax().item())
            max_value = action_scores[max_index].item()
            selected_action = applicable_actions[max_index]
            selected_distribution = q_quantiles[max_index]
            current_state = selected_action.apply(current_state)
            solution.append(selected_action)
            print(f'{max_value:.3f}: {str(selected_action)}')
            print(f'  distribution: {_format_distribution(selected_distribution)}')
        return solution if goal.holds(current_state) else None


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    domain = mm.Domain(args.domain)
    problem = mm.Problem(domain, args.problem)
    device = create_device(False)
    model, policy_model, _ = _load_model(domain, args.model, device, args.risk_averseness, args.num_quantiles)
    solution = _plan(problem, model, policy_model)
    if solution is None:
        print('Failed to find a solution!')
    else:
        print(f'Found a solution of length {len(solution)}!')
        for index, action in enumerate(solution):
            print(f'{index + 1:>4}: {str(action)}')


if __name__ == '__main__':
    _main(_parse_arguments())
