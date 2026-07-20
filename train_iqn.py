import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
import random
import torch
import torch.optim as optim

from pathlib import Path
from pymimir_rgnn.modules import SumReadout
from utils import create_device

# Requesting BOTH action and object embeddings needs >=2 readouts, which hits a late-binding
# closure bug in pymimir_rgnn that makes every output return the last readout's tensor.
# Importing this applies the fix; it is a no-op for single-output models. See the module docstring.
import rgnn_readout_fix  # noqa: F401


class IQNModelWrapper(rl.ActionQuantileModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, num_cosines: int = 64, random_layer_count: bool = False, embedding_size: int = 32, tau_conditioning: str = 'multiply', use_object_context: bool = False, num_atoms: int = 64) -> None:
        super().__init__()
        assert tau_conditioning in ('multiply', 'film', 'qrdqn'), f'Unknown tau_conditioning: {tau_conditioning}.'
        self.model = model
        self.num_cosines = num_cosines
        self.random_layer_count = random_layer_count
        self.tau_conditioning = tau_conditioning
        self.embedding_size = embedding_size
        self.use_object_context = use_object_context
        # The head operates on the per-action FEATURE: the action embedding alone (E), or the
        # action embedding concatenated with the global object context (2E), matching the DQN.
        feature_size = embedding_size * (2 if use_object_context else 1)
        self.feature_size = feature_size
        if use_object_context:
            # Mirrors the DQN's ActionScalarReadout: aggregate object embeddings per state with
            # a SumReadout, then concatenate onto each action embedding before the head.
            self.object_readout = SumReadout(embedding_size, embedding_size)
        self.num_atoms = num_atoms
        if tau_conditioning == 'qrdqn':
            # QR-DQN: tau does NOT condition the network at all. The head simply emits
            # num_atoms quantile values on the FIXED grid tau_i = (i + 0.5)/num_atoms, and
            # requested taus are served by interpolating that grid.
            # This DELETES the tau-embedding machinery (cosine basis, projection, ReLU gate)
            # rather than repairing it, so the path from GNN embedding to output is exactly the
            # DQN's -- the architecture measured to reach -171 where the IQN ceilings at -21.
            # The probes only ever query a fixed grid (torch.linspace(0.01, 0.99, 99)), so
            # nothing downstream needs IQN's arbitrary-tau sampling.
            self.register_buffer('atom_taus', (torch.arange(num_atoms, dtype=torch.float) + 0.5) / num_atoms)
        elif tau_conditioning == 'film':
            # FiLM: tau produces a per-channel (scale, shift) applied as
            #   h = a * (1 + gamma) + beta.
            # No ReLU, so no channel is zeroed, and zero-init makes the layer start as the
            # IDENTITY (h = a) -- i.e. a direct readout like the DQN's, which can reach large
            # magnitudes immediately. Tau-dependence is then learned on top of that.
            self.film_projection = torch.nn.Linear(num_cosines, 2 * feature_size)
            torch.nn.init.zeros_(self.film_projection.weight)
            torch.nn.init.zeros_(self.film_projection.bias)
        else:
            # Original: h = a * relu(W cos(tau)). The ReLU zeroes ~half the channels for any
            # given tau and attenuates the signal before the head, ceiling the output range
            # (measured: IQN bottoms out at -16.7/-21.3 where the DQN reaches -171).
            self.cosine_projection = torch.nn.Linear(num_cosines, feature_size)
        # Activation matches the DQN's readout, which uses mish everywhere and no ReLU
        # (pymimir_rgnn.modules.MLP: Linear -> mish -> Linear). ReLU hard-zeroes negative
        # pre-activations; mish is smooth and keeps gradient there. Since the DQN drives to
        # -171 through this exact activation and the IQN ceilings at -21, aligning removes a
        # variable. 'relu' is kept so existing multiply-checkpoints reproduce bit-for-bit.
        activation = torch.nn.ReLU() if tau_conditioning == 'multiply' else torch.nn.Mish()
        # 'qrdqn' emits one value per atom; the tau-conditioned modes emit a single value for
        # the tau they were conditioned on.
        head_outputs = num_atoms if tau_conditioning == 'qrdqn' else 1
        self.quantile_head = torch.nn.Sequential(
            torch.nn.Linear(feature_size, feature_size),
            activation,
            torch.nn.Linear(feature_size, head_outputs),
        )
        self.register_buffer('cosine_basis', torch.arange(num_cosines, dtype=torch.float).view(1, 1, -1) * torch.pi)

    def _encode_taus(self, taus: torch.Tensor) -> torch.Tensor:
        if self.tau_conditioning == 'qrdqn':
            return taus  # passthrough: tau never enters the network, only the interpolation
        cosines = torch.cos(taus.unsqueeze(-1) * self.cosine_basis)  # type: ignore
        if self.tau_conditioning == 'film':
            return self.film_projection(cosines)  # [B, N, 2E], no ReLU
        return torch.relu(self.cosine_projection(cosines))

    def _combine(self, action_embeddings: torch.Tensor, tau_embedding: torch.Tensor) -> torch.Tensor:
        """Condition [A, E] action embeddings on [N, *] tau features -> [A, N, E]."""
        if self.tau_conditioning == 'film':
            gamma, beta = tau_embedding.chunk(2, dim=-1)  # each [N, E]
            return action_embeddings.unsqueeze(1) * (1.0 + gamma.unsqueeze(0)) + beta.unsqueeze(0)
        return action_embeddings.unsqueeze(1) * tau_embedding.unsqueeze(0)

    def _interpolate_atoms(self, atoms: torch.Tensor, taus: torch.Tensor) -> torch.Tensor:
        """[A, num_atoms] values on the fixed grid -> [A, len(taus)] values at the requested taus.

        Linear interpolation between neighbouring atoms; requests outside the grid clamp to the
        end atoms. Atoms are NOT sorted, matching standard QR-DQN (the quantile loss is what
        encourages them into order).
        """
        n = self.num_atoms
        pos = taus * n - 0.5                       # continuous index into the atom grid
        lo = pos.floor().clamp(0, n - 1).long()    # [T]
        hi = (lo + 1).clamp(0, n - 1)              # [T]
        w = (pos - lo.to(pos.dtype)).clamp(0.0, 1.0).unsqueeze(0)  # [1, T]
        return atoms[:, lo] * (1.0 - w) + atoms[:, hi] * w         # [A, T]

    def _quantiles_for_state(self, action_embeddings: torch.Tensor, tau_row: torch.Tensor) -> torch.Tensor:
        """[A, feature] embeddings + [T] tau features -> [A, T] quantile values."""
        if self.tau_conditioning == 'qrdqn':
            atoms = self.quantile_head(action_embeddings)  # [A, num_atoms]
            return self._interpolate_atoms(atoms, tau_row)
        return self.quantile_head(self._combine(action_embeddings, tau_row)).squeeze(-1)

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
            forward_state = self.model.forward(input_list)
            self.model.get_hparam_config().num_layers = original_layer_count
        else:
            forward_state = self.model.forward(input_list)
        flat_embeddings = forward_state.readout('action_embedding')

        # New API returns flat [total_actions, embedding_size] tensor; split per state
        action_counts = [len(actions) for actions in actions_list]
        action_embeddings_batch = torch.split(flat_embeddings, action_counts)

        if self.use_object_context:
            # Same construction as the DQN's ActionScalarReadout: aggregate this state's object
            # embeddings into one vector and concatenate it onto every action embedding, so the
            # head sees global problem context (plausibly what encodes distance SCALE).
            flat_objects = forward_state.readout('object_embedding')
            object_counts = torch.tensor(
                [len(state.get_problem().get_objects()) for state, _ in state_goals],
                device=flat_objects.device,
            )
            object_aggregation = self.object_readout(flat_objects, object_counts)  # [B, E]
            action_embeddings_batch = tuple(
                torch.cat((ae, agg.unsqueeze(0).expand(ae.shape[0], -1)), dim=1) if ae.shape[0] > 0 else ae
                for ae, agg in zip(action_embeddings_batch, object_aggregation)
            )

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
                q_values = self._quantiles_for_state(action_embeddings, tau_embedding)
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
    parser.add_argument('--no_use_bounds', dest='use_bounds', action='store_false',
                        help='Disable clamping IQN targets to [observed_return, -1]. Default is to '
                             'clamp (the original behaviour). The clamp is a correct bound but pins '
                             'targets into the short range seen in training, which is a suspect for '
                             'the value saturating at ~-9.5 on large instances.')
    parser.set_defaults(use_bounds=True)
    parser.add_argument('--train_horizon', default=100, type=int, help='Maximum rollout length for the training set')
    parser.add_argument('--validation_horizon', default=400, type=int, help='Maximum rollout length for the validation set')
    parser.add_argument('--lr_initial', default=0.001, type=float, help='Initial learning rate')
    parser.add_argument('--lr_final', default=0.000001, type=float, help='Final learning rate')
    parser.add_argument('--lr_steps', default=300, type=float, help='Number of episodes to reach the final learning rate. Internally multiplied by --train_steps to convert to optimization-step units (the LR scheduler is stepped once per train step).')
    parser.add_argument('--max_new_trajectories', default=100, type=int, help='Max number of new trajectories to derive')
    parser.add_argument('--min_buffer_size', default=100, type=int, help='Minimum size of the experience buffer to update model')
    parser.add_argument('--max_buffer_size', default=10000, type=int, help='Maximum size of the experience buffer')
    parser.add_argument('--num_rollouts', default=4, type=int, help='Number of trajectories to compute in parallel')
    parser.add_argument('--train_steps', default=32, type=int, help='Number of training steps per iteration')
    parser.add_argument('--num_cosines', default=64, type=int, help='Number of cosine basis features used for tau embeddings')
    parser.add_argument('--num_atoms', default=64, type=int,
                        help="Number of fixed quantile atoms for --tau_conditioning qrdqn.")
    parser.add_argument('--tau_conditioning', default='multiply', choices=['multiply', 'film', 'qrdqn'],
                        help="How tau conditions the action embedding. 'multiply' (default, original) uses "
                             "h = a * relu(W cos(tau)), whose ReLU zeroes ~half the channels and ceilings the "
                             "output range (IQN bottoms out at ~-21 where the DQN reaches -171). 'film' uses "
                             "h = a * (1 + gamma) + beta with zero-init, starting as a direct DQN-like readout.")
    parser.add_argument('--use_object_context', action='store_true',
                        help="Feed the head cat(action_embedding, SumReadout(object_embeddings)), the same global "
                             "object context the DQN's readout always gets. Plausibly encodes problem SCALE, a "
                             "candidate cause of the IQN's output-range ceiling (-21 vs the DQN's -171).")
    parser.add_argument('--bounds_weight', default=None, type=float,
                        help='If set, use SOFT bounds (a penalty of this weight, like the DQN) instead of the '
                             'hard target clamp. 0.0 disables bounds entirely. Overrides --no_use_bounds.')
    parser.add_argument('--num_quantiles', default=64, type=int, help='Number of quantiles used for the online IQN loss')
    parser.add_argument('--num_target_quantiles', default=64, type=int, help='Number of quantiles used for the target distribution')
    parser.add_argument('--num_selection_quantiles', default=32, type=int, help='Number of quantiles used for greedy target action selection')
    parser.add_argument('--num_policy_quantiles', default=32, type=int, help='Number of quantiles used to derive scalar policy values for rollouts')
    parser.add_argument('--risk_averseness', default=0.0, type=float, help='Risk averseness in [0, 1]; 0 is risk-neutral and 1 is maximally pessimistic')
    parser.add_argument('--seed', default=42, type=int, help='Random seed for reproducibility')
    parser.add_argument('--cpu', action='store_true', help='Force CPU to be used')
    parser.add_argument('--output_prefix', default='', type=str, help='Prefix for output model files')
    args = parser.parse_args()
    return args


def _parse_instances(input: Path) -> tuple[mm.Domain, list[mm.Problem]]:
    if input.is_file():
        domain_path = str(input.parent / 'domain.pddl')
        problem_paths = [str(input)]
    else:
        if (input / 'domain.pddl').exists():
            domain_path = str(input / 'domain.pddl')
        else:
            domain_path = str(input.parent / 'domain.pddl')
        problem_paths = [str(file) for file in input.glob('*.pddl') if file.name != 'domain.pddl']
        problem_paths.sort()
    domain = mm.Domain(domain_path)
    problems = [mm.Problem(domain, problem_path) for problem_path in problem_paths]
    return domain, problems


def _create_base_model(domain: mm.Domain, embedding_size: int, num_layers: int, aggregation: str, use_object_context: bool = False) -> rgnn.RelationalGraphNeuralNetwork:
    # The DQN's ActionScalarReadout feeds its head cat(action_embedding, SumReadout(objects)),
    # i.e. it always sees a GLOBAL OBJECT CONTEXT. The IQN historically saw only the action
    # embedding. That context plausibly encodes problem SCALE, which is what sets how large the
    # distance can be -- a candidate cause of the IQN's output-range ceiling (-21 vs the DQN's
    # -171). Requesting it needs a SECOND output, which is why rgnn_readout_fix is required.
    output_specification = [('action_embedding', rgnn.OutputNodeType.Action, rgnn.OutputValueType.Embeddings)]
    if use_object_context:
        output_specification.append(('object_embedding', rgnn.OutputNodeType.Objects, rgnn.OutputValueType.Embeddings))
    if aggregation == 'smax': aggregation_function = rgnn.AggregationFunction.SmoothMaximum
    elif aggregation == 'hmax': aggregation_function = rgnn.AggregationFunction.HardMaximum
    elif aggregation == 'mean': aggregation_function = rgnn.AggregationFunction.Mean
    elif aggregation in ('add', 'sum'): aggregation_function = rgnn.AggregationFunction.Add
    else: raise RuntimeError(f'Unknown aggregation function: {aggregation}.')

    config = rgnn.RelationalGraphNeuralNetworkConfig(
        domain=domain,
        embedding_size=embedding_size,
        num_layers=num_layers,
        message_aggregation=aggregation_function,
        input_specification=(rgnn.InputType.State, rgnn.InputType.GroundActions, rgnn.InputType.Goal),
        output_specification=output_specification,
    )
    return rgnn.RelationalGraphNeuralNetwork(config)


def _create_model(domain: mm.Domain, embedding_size: int, num_layers: int, aggregation: str, num_cosines: int, random_layer_count: bool = False, tau_conditioning: str = 'multiply', use_object_context: bool = False, num_atoms: int = 64) -> IQNModelWrapper:
    base_model = _create_base_model(domain, embedding_size, num_layers, aggregation, use_object_context)
    return IQNModelWrapper(base_model, num_cosines, random_layer_count, embedding_size, tau_conditioning, use_object_context, num_atoms)


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
                'tau_conditioning': model.tau_conditioning,
                'embedding_size': model.embedding_size,
                'use_object_context': model.use_object_context,
                'num_atoms': model.num_atoms,
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

    # Checkpoints written before the FiLM patch have neither key; they are all the original
    # multiplicative-ReLU variant at the default embedding size, so default to those and keep
    # loading them unchanged.
    tau_conditioning = iqn_wrapper_extras.get('tau_conditioning', 'multiply')
    embedding_size = iqn_wrapper_extras.get('embedding_size', 32)
    use_object_context = iqn_wrapper_extras.get('use_object_context', False)
    num_atoms = iqn_wrapper_extras.get('num_atoms', 64)
    model = IQNModelWrapper(base_model, num_cosines, False, embedding_size, tau_conditioning, use_object_context, num_atoms).to(device)
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
    # use_bounds clamps each target to [observed_return, -1] (ConstantRewardFunction
    # .get_value_bounds) for transitions on a solution. The bound is CORRECT -- the
    # true value does lie in that range -- but with short training trajectories it
    # pins every target into a short range, which may be why the IQN's output
    # saturates at ~-9.5 while the SAC critic (identical architecture + data, but no
    # clamp in its loss) still responds out to ~-65. --no_use_bounds tests that.
    if args.bounds_weight is not None:
        # Soft bounds: a penalty term like the DQN's, instead of hard-clamping the targets.
        # The hard clamp is the single largest fixable cause of the IQN's early saturation
        # (grid d=10-22 slope -0.421 clamped vs -0.683 unclamped vs -0.896 for the DQN).
        from iqn_soft_bounds import SoftBoundsIQNOptimization
        loss_function = SoftBoundsIQNOptimization(
            model,
            optimizer,
            lr_scheduler,
            model,
            args.discount_factor,
            args.num_quantiles,
            args.num_target_quantiles,
            args.num_selection_quantiles,
            bounds_weight=args.bounds_weight,
        )
    else:
        loss_function = rl.IQNOptimization(
            model,
            optimizer,
            lr_scheduler,
            model,
            args.discount_factor,
            args.num_quantiles,
            args.num_target_quantiles,
            args.num_selection_quantiles,
            args.use_bounds,
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
        valid = [t for t in ts if len(t) > 0]
        return sum(len(t[0].goal_condition) for t in valid) / len(valid) if valid else 0.0

    def avg_trajectory_length(ts: list[rl.Trajectory]) -> float:
        valid = [t for t in ts if len(t) > 0]
        return sum(len(t) for t in valid) / len(valid) if valid else 0.0

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
        _save_checkpoint(model, policy_model, optimizer, args.output_prefix + 'latest.pth')
        if best:
            _save_checkpoint(model, policy_model, optimizer, args.output_prefix + 'best.pth')
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
    model = _create_model(domain, args.embedding_size, args.layers, args.aggregation, args.num_cosines, args.random_layer_count, args.tau_conditioning, args.use_object_context, args.num_atoms).to(device)
    policy_model = RiskSensitivePolicyWrapper(model, args.risk_averseness, args.num_policy_quantiles).to(device)
    optimizer = optim.Adam(model.parameters(), lr=args.lr_initial)
    # lr_steps is in episode units; convert to optimization-step units (the scheduler is stepped
    # once per train step) by multiplying by train_steps.
    lr_scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, args.lr_steps * args.train_steps, args.lr_final)
    print('Training model...', flush=True)
    _train(model, policy_model, optimizer, lr_scheduler, train_problems, validation_problems, args)


if __name__ == '__main__':
    _main(_parse_arguments())
