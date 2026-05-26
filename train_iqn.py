import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
import random
import torch
import torch.optim as optim

from pathlib import Path
from utils import create_device


class IQNModelWrapper(rl.ActionQuantileModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, num_cosines: int = 64, random_layer_count: bool = False) -> None:
        super().__init__()
        self.model = model
        self.num_cosines = num_cosines
        self.random_layer_count = random_layer_count
        embedding_size = model.get_hparam_config().embedding_size
        self.cosine_projection = torch.nn.Linear(num_cosines, embedding_size)
        self.quantile_head = torch.nn.Sequential(
            torch.nn.Linear(embedding_size, embedding_size),
            torch.nn.ReLU(),
            torch.nn.Linear(embedding_size, 1),
        )
        self.register_buffer('cosine_basis', torch.arange(num_cosines, dtype=torch.float).view(1, 1, -1) * torch.pi)

    def _encode_taus(self, taus: torch.Tensor) -> torch.Tensor:
        cosines = torch.cos(taus.unsqueeze(-1) * self.cosine_basis)  # type: ignore
        return torch.relu(self.cosine_projection(cosines))

    def forward(
        self,
        state_goals: list[tuple[mm.State, mm.GroundConjunctiveCondition]],
        taus: torch.Tensor | None = None,
        num_quantiles: int = 32,
    ) -> list[tuple[torch.Tensor, list[mm.GroundAction]]]:
        input_list: list[tuple[mm.State, list[mm.GroundAction], mm.GroundConjunctiveCondition]] = []
        actions_list: list[list[mm.GroundAction]] = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)

        if self.random_layer_count:
            original_layer_count = self.model.get_hparam_config().num_layers
            new_layer_count = random.randint(original_layer_count // 2, original_layer_count)
            self.model.get_hparam_config().num_layers = new_layer_count
            action_embeddings_batch = self.model.forward(input_list).readout('action_embedding')
            self.model.get_hparam_config().num_layers = original_layer_count
        else:
            action_embeddings_batch = self.model.forward(input_list).readout('action_embedding')

        assert isinstance(action_embeddings_batch, tuple), 'Model should return a tuple of action embeddings.'

        device = next(self.parameters()).device
        if taus is None:
            taus = torch.rand(len(state_goals), num_quantiles, device=device)
        else:
            taus = taus.to(device)

        tau_embeddings = self._encode_taus(taus)
        outputs: list[tuple[torch.Tensor, list[mm.GroundAction]]] = []
        for action_embeddings, actions, tau_embedding in zip(action_embeddings_batch, actions_list, tau_embeddings):
            if action_embeddings.shape[0] == 0:
                q_values = torch.empty((0, tau_embedding.shape[0]), device=device)
            else:
                q_values = self.quantile_head(action_embeddings.unsqueeze(1) * tau_embedding.unsqueeze(0)).squeeze(-1)
            outputs.append((q_values, actions))
        return outputs


class RiskSensitivePolicyWrapper(rl.ActionScalarModel):
    def __init__(
        self,
        model: IQNModelWrapper,
        risk_averseness: float = 0.0,
        num_policy_quantiles: int = 32,
    ) -> None:
        super().__init__()
        assert 0.0 <= risk_averseness <= 1.0, 'Risk averseness must be in [0, 1].'
        assert num_policy_quantiles > 0, 'Number of policy quantiles must be positive.'
        self.model = model
        self.risk_averseness = risk_averseness
        self.num_policy_quantiles = num_policy_quantiles

    def get_tau_upper_bound(self) -> float:
        return max(1e-3, 1.0 - self.risk_averseness)

    def _sample_policy_taus(self, batch_size: int, device: torch.device) -> torch.Tensor:
        return torch.rand(batch_size, self.num_policy_quantiles, device=device) * self.get_tau_upper_bound()

    def reduce_quantiles(self, q_values: torch.Tensor) -> torch.Tensor:
        if q_values.shape[0] == 0:
            return torch.empty((0,), device=q_values.device)
        return q_values.mean(dim=1)

    def forward(self, state_goals: list[tuple[mm.State, mm.GroundConjunctiveCondition]]) -> list[tuple[torch.Tensor, list[mm.GroundAction]]]:
        device = next(self.parameters()).device
        taus = self._sample_policy_taus(len(state_goals), device)
        quantile_outputs = self.model.forward(state_goals, taus=taus)
        outputs: list[tuple[torch.Tensor, list[mm.GroundAction]]] = []
        for q_values, actions in quantile_outputs:
            scalar_values = self.reduce_quantiles(q_values)
            outputs.append((scalar_values, actions))
        return outputs


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for training with IQN')
    parser.add_argument('--train', required=True, type=Path, help='Path to directory with training instances')
    parser.add_argument('--validation', required=True, type=Path, help='Path to directory with validation instances')
    parser.add_argument('--hindsight', required=True, type=str, choices=['lifted', 'propositional', 'state', 'state_fluent'], help='Type of hindsight to use')
    parser.add_argument('--aggregation', default='smax', type=str, help='Aggregation function used by the model ("add", "mean", "smax", "hmax")')
    parser.add_argument('--embedding_size', default=32, type=int, help='Dimension of the embedding vector for each object')
    parser.add_argument('--layers', default=12, type=int, help='Number of layers in the model')
    parser.add_argument('--random_layer_count', action='store_true', help='At each forward pass, randomly use between num_layers//2 and num_layers layers (acts as a depth dropout regularizer)')
    parser.add_argument('--batch_size', default=32, type=int, help='Number of samples per batch')
    parser.add_argument('--bt_initial', default=1.0, type=float, help='Initial Boltzmann temperature')
    parser.add_argument('--bt_final', default=0.1, type=float, help='Final Boltzmann temperature')
    parser.add_argument('--bt_steps', default=600, type=int, help='Number of steps for the Boltzmann temperature to decrease from the initial value to the final value')
    parser.add_argument('--discount_factor', default=0.999, type=float, help='Discount factor')
    parser.add_argument('--train_horizon', default=100, type=int, help='Maximum rollout length for the training set')
    parser.add_argument('--validation_horizon', default=400, type=int, help='Maximum rollout length for the validation set')
    parser.add_argument('--lr_initial', default=0.001, type=float, help='Initial learning rate')
    parser.add_argument('--lr_final', default=0.000001, type=float, help='Final learning rate')
    parser.add_argument('--lr_steps', default=300, type=float, help='Steps to reach the final learning rate')
    parser.add_argument('--max_new_trajectories', default=100, type=int, help='Max number of new trajectories to derive')
    parser.add_argument('--min_buffer_size', default=100, type=int, help='Minimum size of the experience buffer to update model')
    parser.add_argument('--max_buffer_size', default=1000, type=int, help='Maximum size of the experience buffer')
    parser.add_argument('--num_rollouts', default=4, type=int, help='Number of trajectories to compute in parallel')
    parser.add_argument('--train_steps', default=32, type=int, help='Number of training steps per iteration')
    parser.add_argument('--num_cosines', default=64, type=int, help='Number of cosine basis features used for tau embeddings')
    parser.add_argument('--num_quantiles', default=64, type=int, help='Number of quantiles used for the online IQN loss')
    parser.add_argument('--num_target_quantiles', default=64, type=int, help='Number of quantiles used for the target distribution')
    parser.add_argument('--num_selection_quantiles', default=32, type=int, help='Number of quantiles used for greedy target action selection')
    parser.add_argument('--num_policy_quantiles', default=32, type=int, help='Number of quantiles used to derive scalar policy values for rollouts')
    parser.add_argument('--risk_averseness', default=0.0, type=float, help='Risk averseness in [0, 1]; 0 is risk-neutral and 1 is maximally pessimistic')
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


def _create_base_model(domain: mm.Domain, embedding_size: int, num_layers: int, aggregation: str) -> rgnn.RelationalGraphNeuralNetwork:
    if aggregation == 'smax': aggregation_function = rgnn.SmoothMaximumAggregation()
    elif aggregation == 'hmax': aggregation_function = rgnn.HardMaximumAggregation()
    elif aggregation == 'mean': aggregation_function = rgnn.MeanAggregation()
    elif aggregation in ('add', 'sum'): aggregation_function = rgnn.SumAggregation()
    else: raise RuntimeError(f'Unknown aggregation function: {aggregation}.')

    hparam_config = rgnn.HyperparameterConfig(
        domain=domain,
        embedding_size=embedding_size,
        num_layers=num_layers
    )

    input_spec = (rgnn.StateEncoder(), rgnn.GroundActionsEncoder(), rgnn.GoalEncoder())
    output_spec = [('action_embedding', rgnn.ActionEmbeddingDecoder())]

    module_config = rgnn.ModuleConfig(
        aggregation_function=aggregation_function,
        message_function=rgnn.PredicateMLPMessages(hparam_config, input_spec),
        update_function=rgnn.MLPUpdates(hparam_config)
    )

    return rgnn.RelationalGraphNeuralNetwork(hparam_config, module_config, input_spec, output_spec)  # type: ignore


def _create_model(domain: mm.Domain, embedding_size: int, num_layers: int, aggregation: str, num_cosines: int, random_layer_count: bool = False) -> IQNModelWrapper:
    base_model = _create_base_model(domain, embedding_size, num_layers, aggregation)
    return IQNModelWrapper(base_model, num_cosines, random_layer_count)


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


def _get_iqn_head_state(model: IQNModelWrapper) -> dict[str, torch.Tensor]:
    return {
        key: value.detach().clone()
        for key, value in model.state_dict().items()
        if not key.startswith('model.')
    }


def _load_iqn_head_state(model: IQNModelWrapper, state_dict: dict[str, torch.Tensor]) -> None:
    missing_keys, unexpected_keys = model.load_state_dict(state_dict, strict=False)
    unexpected_non_model = [key for key in unexpected_keys if not key.startswith('model.')]
    missing_non_model = [key for key in missing_keys if not key.startswith('model.')]
    if unexpected_non_model or missing_non_model:
        raise RuntimeError(
            f'Failed to load IQN wrapper state. Missing keys: {missing_non_model}; unexpected keys: {unexpected_non_model}'
        )


def _save_checkpoint(
    model: IQNModelWrapper,
    policy_model: RiskSensitivePolicyWrapper,
    optimizer: torch.optim.Optimizer,
    path: Path | str,
) -> None:
    model.model.save(
        path,
        {
            'optimizer': optimizer.state_dict(),
            'iqn_wrapper': {
                'num_cosines': model.num_cosines,
                'state_dict': _get_iqn_head_state(model),
            },
            'policy_wrapper': {
                'risk_averseness': policy_model.risk_averseness,
                'num_policy_quantiles': policy_model.num_policy_quantiles,
            },
        },
    )


def _load_model(
    domain: mm.Domain,
    path: Path,
    device: torch.device,
    risk_averseness: float | None = None,
    num_policy_quantiles: int | None = None,
) -> tuple[IQNModelWrapper, RiskSensitivePolicyWrapper, dict]:
    base_model, extras = rgnn.RelationalGraphNeuralNetwork.load(domain, path, device)
    iqn_wrapper_extras = extras.get('iqn_wrapper')
    if iqn_wrapper_extras is None:
        raise RuntimeError(f'Checkpoint {path} does not contain IQN wrapper state.')

    num_cosines = iqn_wrapper_extras.get('num_cosines')
    iqn_state_dict = iqn_wrapper_extras.get('state_dict')
    if not isinstance(num_cosines, int) or iqn_state_dict is None:
        raise RuntimeError(f'Checkpoint {path} is missing IQN wrapper metadata.')

    model = IQNModelWrapper(base_model, num_cosines).to(device)
    _load_iqn_head_state(model, iqn_state_dict)

    policy_wrapper_extras = extras.get('policy_wrapper', {})
    resolved_risk_averseness = risk_averseness if risk_averseness is not None else policy_wrapper_extras.get('risk_averseness', 0.0)
    resolved_num_policy_quantiles = num_policy_quantiles if num_policy_quantiles is not None else policy_wrapper_extras.get('num_policy_quantiles', 32)
    policy_model = RiskSensitivePolicyWrapper(model, resolved_risk_averseness, resolved_num_policy_quantiles).to(device)
    return model, policy_model, extras


def _train(
    model: IQNModelWrapper,
    policy_model: RiskSensitivePolicyWrapper,
    optimizer: torch.optim.Optimizer,
    lr_scheduler: torch.optim.lr_scheduler.LRScheduler,
    train_problems: list[mm.Problem],
    validation_problems: list[mm.Problem],
    args: argparse.Namespace,
):
    loss_function = rl.IQNOptimization(
        model,
        optimizer,
        lr_scheduler,
        model,
        args.discount_factor,
        args.num_quantiles,
        args.num_target_quantiles,
        args.num_selection_quantiles,
        True,
    )
    reward_function = rl.ConstantRewardFunction(-1)
    replay_buffer = rl.PrioritizedReplayBuffer(args.max_buffer_size)
    trajectory_sampler = rl.BoltzmannTrajectorySampler(policy_model, reward_function, args.bt_initial)
    problem_sampler = rl.UniformProblemSampler()
    initial_state_sampler = rl.OriginalInitialStateSampler()
    goal_sampler = rl.OriginalGoalConditionSampler()
    trajectory_refiner = _create_trajectory_refiner(args.hindsight, train_problems, args.max_new_trajectories)
    rl_algorithm = rl.OffPolicyAlgorithm(
        train_problems,
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
        trajectory_refiner,
    )
    evaluation_criteras = [rl.CoverageCriteria(), rl.LengthCriteria()]
    evaluation_trajectory_sampler = rl.GreedyPolicyTrajectorySampler(policy_model, reward_function)
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
    while True:
        bt_ratio = min(1.0, episode / args.bt_steps)
        bt_temp = bt_ratio * args.bt_final + (1.0 - bt_ratio) * args.bt_initial
        trajectory_sampler.set_temperature(bt_temp)
        print(f'[{episode}] Boltzmann Exploration: {bt_temp:.5f}', flush=True)
        rl_algorithm.fit()
        best, evaluation = rl_evaluator.evaluate()
        print(f'[{episode}] Best: {best}, Evaluation: {evaluation}', flush=True)
        _save_checkpoint(model, policy_model, optimizer, 'latest.pth')
        if best:
            _save_checkpoint(model, policy_model, optimizer, 'best.pth')
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
    model = _create_model(domain, args.embedding_size, args.layers, args.aggregation, args.num_cosines, args.random_layer_count).to(device)
    policy_model = RiskSensitivePolicyWrapper(model, args.risk_averseness, args.num_policy_quantiles).to(device)
    optimizer = optim.Adam(model.parameters(), lr=args.lr_initial)
    lr_scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, args.lr_steps, args.lr_final)
    print('Training model...', flush=True)
    _train(model, policy_model, optimizer, lr_scheduler, train_problems, validation_problems, args)


if __name__ == '__main__':
    _main(_parse_arguments())
