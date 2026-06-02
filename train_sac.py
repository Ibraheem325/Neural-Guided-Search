import argparse
import math
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
import random
import torch
import torch.optim as optim

from pathlib import Path
from utils import create_device


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, readout_name: str, random_layer_count: bool = False) -> None:
        super().__init__()
        self.model = model
        self.readout_name = readout_name
        self.random_layer_count = random_layer_count

    def forward(self, state_goals: list[tuple[mm.State, mm.GroundConjunctiveCondition]]) -> list[tuple[torch.Tensor, list[mm.GroundAction]]]:
        input_list: list[tuple[mm.State, list[mm.GroundAction], mm.GroundConjunctiveCondition]] = []
        actions_list: list[list[mm.GroundAction]] = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        if True:
            values_list = self.model.forward(input_list).readout(self.readout_name)  # type: ignore
        output = list(zip(values_list, actions_list))
        return output


class _AlphaClampedSAC(rl.DiscreteSoftActorCriticOptimization):
    # Clamps log_entropy_alpha after each step so the per-step entropy bonus α·H[π] cannot
    # grow larger than the per-step reward magnitude. Without this clamp, SAC's auto-tuning
    # can raise α until the entropy bonus dominates the reward signal and the agent loses
    # incentive to reach goals (the runaway-α failure mode for sparse-reward planning).
    def __init__(self, *args, max_log_alpha: float, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self._max_log_alpha = max_log_alpha

    def __call__(self, transitions, weights):
        result = super().__call__(transitions, weights)
        with torch.no_grad():
            self.log_entropy_alpha.clamp_(max=self._max_log_alpha)
        return result


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for training with SAC')
    parser.add_argument('--train', required=True, type=Path, help='Path to directory with training instances')
    parser.add_argument('--validation', required=True, type=Path, help='Path to directory with validation instances')
    parser.add_argument('--hindsight', required=True, type=str, choices=['lifted', 'propositional', 'state', 'state_fluent'], help='Type of hindsight to use')
    parser.add_argument('--aggregation', default='smax', type=str, help='Aggregation function used by the model ("add", "mean", "smax", "hmax")')
    parser.add_argument('--embedding_size', default=32, type=int, help='Dimension of the embedding vector for each object')
    parser.add_argument('--layers', default=12, type=int, help='Number of layers in the model')
    parser.add_argument('--random_layer_count', action='store_true', help='At each forward pass, randomly use between num_layers//2 and num_layers layers (acts as a depth dropout regularizer)')
    parser.add_argument('--batch_size', default=32, type=int, help='Number of samples per batch')
    parser.add_argument('--discount_factor', default=0.999, type=float, help='Discount factor')
    parser.add_argument('--polyak_factor', default=0.005, type=float, help='Polyak averaging factor for target critic updates')
    parser.add_argument('--entropy_lr', default=0.0003, type=float, help='Learning rate for the entropy temperature optimizer')
    parser.add_argument('--entropy_target_scale', default=0.98, type=float, help='Target entropy scale in [0, 1] for SAC auto-tuning (target entropy = scale * log|A|). Fixed; with the alpha cap below, no annealing schedule is needed.')
    parser.add_argument('--entropy_alpha_max', default=0.1, type=float, help='Hard upper bound on the SAC entropy temperature alpha. The per-step entropy bonus alpha*H[pi] should not dominate the per-step reward magnitude or the agent loses incentive to optimise reward; pick alpha_max <= |max_per_step_reward| / max_policy_entropy. Defaults to 0.1 for r=-1/step domains.')
    parser.add_argument('--train_horizon', default=100, type=int, help='Maximum rollout length for the training set')
    parser.add_argument('--validation_horizon', default=400, type=int, help='Maximum rollout length for the validation set')
    parser.add_argument('--lr_initial', default=0.001, type=float, help='Initial learning rate')
    parser.add_argument('--lr_final', default=0.000001, type=float, help='Final learning rate')
    parser.add_argument('--lr_steps', default=300, type=float, help='Steps to reach the final learning rate')
    parser.add_argument('--max_new_trajectories', default=100, type=int, help='Max number of new trajectories to derive')
    parser.add_argument('--min_buffer_size', default=100, type=int, help='Minimum size of the experience buffer to update model')
    parser.add_argument('--max_buffer_size', default=10000, type=int, help='Maximum size of the experience buffer')
    parser.add_argument('--num_rollouts', default=4, type=int, help='Number of trajectories to compute in parallel')
    parser.add_argument('--train_steps', default=32, type=int, help='Number of training steps per iteration')
    parser.add_argument('--seed', default=42, type=int, help='Random seed for reproducibility')
    parser.add_argument('--cpu', action='store_true', help='Force CPU to be used')
    args = parser.parse_args()
    return args


def _parse_instances(input: Path) -> tuple[mm.Domain, list[mm.Problem]]:
    if input.is_file():
        domain_path = str(input.parent / 'domain.pddl')
        problem_paths = [str(input)]
    else:
        domain_path = str(input / 'domain.pddl')
        problem_paths = [str(file) for file in input.glob('*.pddl') if file.name != 'domain.pddl']
        problem_paths.sort()
    domain = mm.Domain(domain_path)
    problems = [mm.Problem(domain, problem_path) for problem_path in problem_paths]
    return domain, problems


def _create_aggregation(name: str):
    if name == 'smax': return rgnn.AggregationFunction.SmoothMaximum
    elif name == 'hmax': return rgnn.AggregationFunction.HardMaximum
    elif name == 'mean': return rgnn.AggregationFunction.Mean
    elif name in ('add', 'sum'): return rgnn.AggregationFunction.Add
    else: raise RuntimeError(f'Unknown aggregation function: {name}.')


def _create_rgnn(domain: mm.Domain,
                 embedding_size: int,
                 num_layers: int,
                 aggregation: str,
                 readout_name: str) -> rgnn.RelationalGraphNeuralNetwork:
    aggregation_function = _create_aggregation(aggregation)
    config = rgnn.RelationalGraphNeuralNetworkConfig(
        domain=domain,
        embedding_size=embedding_size,
        num_layers=num_layers,
        message_aggregation=aggregation_function,
        input_specification=(rgnn.InputType.State, rgnn.InputType.GroundActions, rgnn.InputType.Goal),
        output_specification=[(readout_name, rgnn.OutputNodeType.Action, rgnn.OutputValueType.Scalar)],
    )
    return rgnn.RelationalGraphNeuralNetwork(config)


def _create_trajectory_refiner(hindsight: str, train_problems: list[mm.Problem], max_new_trajectories: int) -> rl.TrajectoryRefiner:
    if hindsight == 'lifted':
        return rl.LiftedHindsightTrajectoryRefiner(train_problems, max_new_trajectories)
    if hindsight == 'propositional':
        return rl.PropositionalHindsightTrajectoryRefiner(train_problems, max_new_trajectories)
    if hindsight == 'state':
        return rl.StateHindsightTrajectoryRefiner(max_new_trajectories)
    if hindsight == 'state_fluent':
        return rl.PartialStateHindsightTrajectoryRefiner(max_new_trajectories)
    raise RuntimeError(f'Unknown hindsight mode: {hindsight}.')


def _save_checkpoints(policy_model: rgnn.RelationalGraphNeuralNetwork,
                      q1_model: rgnn.RelationalGraphNeuralNetwork,
                      q2_model: rgnn.RelationalGraphNeuralNetwork,
                      policy_optimizer: torch.optim.Optimizer,
                      q1_optimizer: torch.optim.Optimizer,
                      q2_optimizer: torch.optim.Optimizer,
                      loss_function: rl.DiscreteSoftActorCriticOptimization,
                      suffix: str) -> None:
    policy_model.save(f'policy_{suffix}.pth', {
        'optimizer': policy_optimizer.state_dict(),
        'log_entropy_alpha': loss_function.log_entropy_alpha.detach().cpu(),
        'entropy_optimizer': loss_function.entropy_optimizer.state_dict(),
    })
    q1_model.save(f'q1_{suffix}.pth', {'optimizer': q1_optimizer.state_dict()})
    q2_model.save(f'q2_{suffix}.pth', {'optimizer': q2_optimizer.state_dict()})


def _train(policy_model: rgnn.RelationalGraphNeuralNetwork,
           q1_model: rgnn.RelationalGraphNeuralNetwork,
           q2_model: rgnn.RelationalGraphNeuralNetwork,
           policy_optimizer: torch.optim.Optimizer,
           q1_optimizer: torch.optim.Optimizer,
           q2_optimizer: torch.optim.Optimizer,
           policy_scheduler: torch.optim.lr_scheduler.LRScheduler,
           q1_scheduler: torch.optim.lr_scheduler.LRScheduler,
           q2_scheduler: torch.optim.lr_scheduler.LRScheduler,
           train_problems: list[mm.Problem],
           validation_problems: list[mm.Problem],
           args: argparse.Namespace,
           device: torch.device):
    policy_wrapper = ModelWrapper(policy_model, 'policy', args.random_layer_count).to(device)
    q1_wrapper = ModelWrapper(q1_model, 'q', args.random_layer_count).to(device)
    q2_wrapper = ModelWrapper(q2_model, 'q', args.random_layer_count).to(device)
    q1_target_wrapper = ModelWrapper(q1_model.clone(), 'q', args.random_layer_count)
    q2_target_wrapper = ModelWrapper(q2_model.clone(), 'q', args.random_layer_count)

    loss_function = _AlphaClampedSAC(
        policy_wrapper, policy_optimizer, policy_scheduler,
        q1_target_wrapper, q1_wrapper, q1_optimizer, q1_scheduler,
        q2_target_wrapper, q2_wrapper, q2_optimizer, q2_scheduler,
        args.discount_factor, args.polyak_factor, args.entropy_target_scale, args.entropy_lr,
        use_bounds_loss=True,
        max_log_alpha=math.log(args.entropy_alpha_max),
    )

    reward_function = rl.ConstantRewardFunction(-1)
    replay_buffer = rl.PrioritizedReplayBuffer(args.max_buffer_size)
    # Temperature 1.0 reduces BoltzmannTrajectorySampler to plain categorical sampling
    # from softmax(logits) — exactly the SAC stochastic policy.
    trajectory_sampler = rl.BoltzmannTrajectorySampler(policy_wrapper, reward_function, 1.0)
    problem_sampler = rl.UniformProblemSampler()
    initial_state_sampler = rl.OriginalInitialStateSampler()
    goal_sampler = rl.OriginalGoalConditionSampler()
    trajectory_refiner = _create_trajectory_refiner(args.hindsight, train_problems, args.max_new_trajectories)
    rl_algorithm = rl.OffPolicyAlgorithm(train_problems,
                                         loss_function,
                                         reward_function,
                                         replay_buffer,
                                         replay_buffer,
                                         trajectory_sampler,
                                         args.train_horizon,
                                         args.num_rollouts,
                                         args.batch_size,
                                         args.train_steps,
                                         problem_sampler,
                                         initial_state_sampler,
                                         goal_sampler,
                                         trajectory_refiner)
    evaluation_criteras = [rl.CoverageCriteria(), rl.LengthCriteria()]
    evaluation_trajectory_sampler = rl.GreedyPolicyTrajectorySampler(policy_wrapper, reward_function)
    rl_evaluator = rl.PolicyEvaluation(validation_problems, evaluation_criteras, evaluation_trajectory_sampler, args.validation_horizon)
    episode = 0
    def avg_num_objects(ps: list[mm.Problem]) -> float:
        return sum(len(p.get_objects()) for p in ps) / len(ps)
    def avg_goal_size(ts: list[rl.Trajectory]) -> float:
        return sum(len(t[0].goal_condition) for t in ts if len(t) > 0) / len(ts)
    def avg_trajectory_length(ts: list[rl.Trajectory]) -> float:
        return sum(len(t) for t in ts if len(t) > 0) / len(ts)
    rl_algorithm.register_on_pre_collect_experience(lambda: print(f'[{episode}] Collecting Experience.', flush=True))
    rl_algorithm.register_on_sample_problems(lambda ps: print(f'[{episode}] > Sampled Problems; {avg_num_objects(ps):.1f} avg. object count.', flush=True))
    rl_algorithm.register_on_sample_initial_states(lambda x: print(f'[{episode}] > Sampled Initial States.', flush=True))
    rl_algorithm.register_on_sample_goal_conditions(lambda x: print(f'[{episode}] > Sampled Goals.', flush=True))
    rl_algorithm.register_on_sample_trajectories(lambda ts: print(f'[{episode}] > Sampled Trajectories; {avg_goal_size(ts):.1f} avg. goal size; {avg_trajectory_length(ts):.1f} avg. trajectory length', flush=True))
    rl_algorithm.register_on_refine_trajectories(lambda ts: print(f'[{episode}] > Refined Trajectories; {avg_goal_size(ts):.1f} avg. goal size; {avg_trajectory_length(ts):.1f} avg. trajectory length.', flush=True))
    rl_algorithm.register_on_post_collect_experience(lambda: print(f'[{episode}] Collected Experience.', flush=True))
    rl_algorithm.register_on_pre_optimize_model(lambda: print(f'[{episode}] Optimizing Model.', flush=True))
    rl_algorithm.register_on_train_step(lambda ts, loss: print(f'[{episode}] > Train step: {loss.mean().item():.5f} avg. loss.'))
    rl_algorithm.register_on_post_optimize_model(lambda: print(f'[{episode}] Optimized Model.', flush=True))
    loss_function.register_on_losses(lambda actor, c1, c2, ent: print(
        f'[{episode}] > SAC: actor={actor.mean().item():.5f} q1={c1.mean().item():.5f} q2={c2.mean().item():.5f} entropy={ent.mean().item():.5f} alpha={loss_function.get_entropy_alpha():.5f}', flush=True))
    while True:
        rl_algorithm.fit()
        best, evaluation = rl_evaluator.evaluate()
        print(f'[{episode}] Best: {best}, Evaluation: {evaluation}', flush=True)
        _save_checkpoints(policy_model, q1_model, q2_model,
                          policy_optimizer, q1_optimizer, q2_optimizer,
                          loss_function, 'latest')
        if best:
            _save_checkpoints(policy_model, q1_model, q2_model,
                              policy_optimizer, q1_optimizer, q2_optimizer,
                              loss_function, 'best')
            print(f'[{episode}] Saved new best model', flush=True)
        episode += 1


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}', flush=True)
    device = create_device(args.cpu)
    domain, train_problems = _parse_instances(args.train)
    print(f'Parsed {len(train_problems)} training instances.', flush=True)
    _, validation_problems = _parse_instances(args.validation)
    print(f'Parsed {len(validation_problems)} validation instances.', flush=True)
    print('Creating model...', flush=True)
    policy_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, 'policy')
    q1_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, 'q')
    q2_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, 'q')
    policy_optimizer = optim.Adam(policy_model.parameters(), lr=args.lr_initial)
    q1_optimizer = optim.Adam(q1_model.parameters(), lr=args.lr_initial)
    q2_optimizer = optim.Adam(q2_model.parameters(), lr=args.lr_initial)
    policy_scheduler = optim.lr_scheduler.CosineAnnealingLR(policy_optimizer, args.lr_steps, args.lr_final)
    q1_scheduler = optim.lr_scheduler.CosineAnnealingLR(q1_optimizer, args.lr_steps, args.lr_final)
    q2_scheduler = optim.lr_scheduler.CosineAnnealingLR(q2_optimizer, args.lr_steps, args.lr_final)
    print('Training model...', flush=True)
    _train(policy_model, q1_model, q2_model,
           policy_optimizer, q1_optimizer, q2_optimizer,
           policy_scheduler, q1_scheduler, q2_scheduler,
           train_problems, validation_problems, args, device)


if __name__ == "__main__":
    _main(_parse_arguments())
