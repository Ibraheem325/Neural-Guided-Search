import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import pymimir_rl as rl
import random
import torch
import torch.optim as optim

from pathlib import Path
from utils import create_device


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, readout_name: str) -> None:
        super().__init__()
        self.model = model
        self.readout_name = readout_name

    def forward(self, state_goals: list[tuple[mm.State, mm.GroundConjunctiveCondition]]) -> list[tuple[torch.Tensor, list[mm.GroundAction]]]:
        input_list: list[tuple[mm.State, list[mm.GroundAction], mm.GroundConjunctiveCondition]] = []
        actions_list: list[list[mm.GroundAction]] = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)
        original_layer_count = self.model.get_hparam_config().num_layers
        new_layer_count = random.randint(original_layer_count // 2, original_layer_count)
        self.model.get_hparam_config().num_layers = new_layer_count
        values_list: list[torch.Tensor] = self.model.forward(input_list).readout(self.readout_name)  # type: ignore
        self.model.get_hparam_config().num_layers = original_layer_count
        output = list(zip(values_list, actions_list))
        return output


class _SharedSACOptimization(rl.DiscreteSoftActorCriticOptimization):
    # Override of the SAC step for the shared-trunk case. The base class does three sequential
    # backward+step pairs on three different optimizers; when those optimizers all wrap the same
    # parameters (because the trunk is shared), the first step() modifies parameters in-place and
    # invalidates the saved forward graphs for the next backward() — PyTorch raises a version-counter
    # error. Here we sum the three losses and do a single backward + single step, which is the
    # correct multi-loss update for a shared backbone.
    def __call__(self, transitions, weights):
        self.policy_model.train()
        self.qvalue_model_1.train()
        self.qvalue_model_2.train()
        self.qvalue_target_1.eval()
        self.qvalue_target_2.eval()
        state_goals = [(t.current_state, t.goal_condition) for t in transitions]
        batch_policy_logits = self.policy_model.forward(state_goals)
        batch_qvalues_1 = self.qvalue_model_1.forward(state_goals)
        batch_qvalues_2 = self.qvalue_model_2.forward(state_goals)

        critic_losses_1, critic_losses_2 = self._compute_critic_losses(transitions, batch_qvalues_1, batch_qvalues_2)
        actor_losses = self._compute_actor_loss(batch_qvalues_1, batch_qvalues_2, batch_policy_logits)
        entropy_losses = self._compute_entropy_loss(batch_policy_logits)

        weights_dev = weights.to(critic_losses_1.device)
        critic_losses_1 = critic_losses_1 * weights_dev
        critic_losses_2 = critic_losses_2 * weights_dev
        actor_losses = actor_losses * weights_dev
        entropy_losses = entropy_losses * weights_dev

        total_loss = critic_losses_1.mean() + critic_losses_2.mean() + actor_losses.mean()
        self.policy_optimizer.zero_grad()
        total_loss.backward()
        self.policy_optimizer.step()
        self.policy_lr_scheduler.step()

        self.entropy_optimizer.zero_grad()
        entropy_losses.mean().backward()
        self.entropy_optimizer.step()

        self._update_target_critics(self.polyak_factor)
        self._notify_listeners_losses(actor_losses.detach(), critic_losses_1.detach(), critic_losses_2.detach(), entropy_losses.detach())
        return (critic_losses_1 + critic_losses_2 + actor_losses + entropy_losses).detach()

    def _update_target_critics(self, polyak_factor):
        # Shared target_model is wrapped twice (q1 and q2); polyak once instead of twice
        # to avoid the effective rate doubling.
        with torch.no_grad():
            for target_param, param in zip(self.qvalue_target_1.parameters(), self.qvalue_model_1.parameters()):
                target_param.copy_(polyak_factor * param + (1.0 - polyak_factor) * target_param)


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for training with SAC')
    parser.add_argument('--train', required=True, type=Path, help='Path to directory with training instances')
    parser.add_argument('--validation', required=True, type=Path, help='Path to directory with validation instances')
    parser.add_argument('--hindsight', required=True, type=str, choices=['lifted', 'propositional', 'state', 'state_fluent'], help='Type of hindsight to use')
    parser.add_argument('--shared_model', action='store_true', help='Use one R-GNN trunk with three readouts (policy, q1, q2) instead of three independent models')
    parser.add_argument('--aggregation', default='hmax', type=str, help='Aggregation function used by the model ("add", "mean", "smax", "hmax")')
    parser.add_argument('--embedding_size', default=32, type=int, help='Dimension of the embedding vector for each object')
    parser.add_argument('--layers', default=60, type=int, help='Number of layers in the model')
    parser.add_argument('--batch_size', default=32, type=int, help='Number of samples per batch')
    parser.add_argument('--discount_factor', default=0.999, type=float, help='Discount factor')
    parser.add_argument('--polyak_factor', default=0.005, type=float, help='Polyak averaging factor for target critic updates')
    parser.add_argument('--entropy_target_scale_initial', default=1.0, type=float, help='Initial target entropy scale in [0, 1]')
    parser.add_argument('--entropy_target_scale_final', default=0.1, type=float, help='Final target entropy scale in [0, 1]')
    parser.add_argument('--entropy_target_scale_steps', default=600, type=int, help='Number of episodes to interpolate the target entropy scale from initial to final')
    parser.add_argument('--entropy_lr', default=0.0003, type=float, help='Learning rate for the entropy temperature optimizer')
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
    if name == 'smax': return rgnn.SmoothMaximumAggregation()
    elif name == 'hmax': return rgnn.HardMaximumAggregation()
    elif name == 'mean': return rgnn.MeanAggregation()
    elif name in ('add', 'sum'): return rgnn.SumAggregation()
    else: raise RuntimeError(f'Unknown aggregation function: {name}.')


def _create_rgnn(domain: mm.Domain,
                 embedding_size: int,
                 num_layers: int,
                 aggregation: str,
                 readout_names: list[str]) -> rgnn.RelationalGraphNeuralNetwork:
    aggregation_function = _create_aggregation(aggregation)
    hparam_config = rgnn.HyperparameterConfig(domain=domain, embedding_size=embedding_size, num_layers=num_layers)
    input_spec = (rgnn.StateEncoder(), rgnn.GroundActionsEncoder(), rgnn.GoalEncoder())
    output_spec = [(name, rgnn.ActionScalarDecoder(hparam_config)) for name in readout_names]
    module_config = rgnn.ModuleConfig(
        aggregation_function=aggregation_function,
        message_function=rgnn.PredicateMLPMessages(hparam_config, input_spec),
        update_function=rgnn.MLPUpdates(hparam_config)
    )
    return rgnn.RelationalGraphNeuralNetwork(hparam_config, module_config, input_spec, output_spec)  # type: ignore


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


def _save_separate(policy_model: rgnn.RelationalGraphNeuralNetwork,
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


def _save_shared(shared_model: rgnn.RelationalGraphNeuralNetwork,
                 shared_optimizer: torch.optim.Optimizer,
                 loss_function: rl.DiscreteSoftActorCriticOptimization,
                 suffix: str) -> None:
    shared_model.save(f'shared_{suffix}.pth', {
        'optimizer': shared_optimizer.state_dict(),
        'log_entropy_alpha': loss_function.log_entropy_alpha.detach().cpu(),
        'entropy_optimizer': loss_function.entropy_optimizer.state_dict(),
    })


def _train(models: dict,
           optimizers: dict,
           schedulers: dict,
           train_problems: list[mm.Problem],
           validation_problems: list[mm.Problem],
           args: argparse.Namespace,
           device: torch.device):
    if args.shared_model:
        shared_model = models['shared']
        policy_wrapper = ModelWrapper(shared_model, 'policy').to(device)
        q1_wrapper = ModelWrapper(shared_model, 'q1').to(device)
        q2_wrapper = ModelWrapper(shared_model, 'q2').to(device)
        target_model = shared_model.clone()
        q1_target_wrapper = ModelWrapper(target_model, 'q1')
        q2_target_wrapper = ModelWrapper(target_model, 'q2')
        shared_optimizer = optimizers['shared']
        shared_scheduler = schedulers['shared']
        loss_function: rl.DiscreteSoftActorCriticOptimization = _SharedSACOptimization(
            policy_wrapper, shared_optimizer, shared_scheduler,
            q1_target_wrapper, q1_wrapper, shared_optimizer, shared_scheduler,
            q2_target_wrapper, q2_wrapper, shared_optimizer, shared_scheduler,
            args.discount_factor, args.polyak_factor, args.entropy_target_scale_initial, args.entropy_lr
        )
    else:
        policy_model = models['policy']
        q1_model = models['q1']
        q2_model = models['q2']
        policy_wrapper = ModelWrapper(policy_model, 'policy').to(device)
        q1_wrapper = ModelWrapper(q1_model, 'q').to(device)
        q2_wrapper = ModelWrapper(q2_model, 'q').to(device)
        q1_target_wrapper = ModelWrapper(q1_model.clone(), 'q')
        q2_target_wrapper = ModelWrapper(q2_model.clone(), 'q')
        loss_function = rl.DiscreteSoftActorCriticOptimization(
            policy_wrapper, optimizers['policy'], schedulers['policy'],
            q1_target_wrapper, q1_wrapper, optimizers['q1'], schedulers['q1'],
            q2_target_wrapper, q2_wrapper, optimizers['q2'], schedulers['q2'],
            args.discount_factor, args.polyak_factor, args.entropy_target_scale_initial, args.entropy_lr
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
        ratio = min(1.0, episode / args.entropy_target_scale_steps)
        target_scale = ratio * args.entropy_target_scale_final + (1.0 - ratio) * args.entropy_target_scale_initial
        loss_function.set_entropy_target_scale(target_scale)
        print(f'[{episode}] Entropy target scale: {target_scale:.5f}', flush=True)
        rl_algorithm.fit()
        best, evaluation = rl_evaluator.evaluate()
        print(f'[{episode}] Best: {best}, Evaluation: {evaluation}', flush=True)
        if args.shared_model:
            _save_shared(models['shared'], optimizers['shared'], loss_function, 'latest')
            if best:
                _save_shared(models['shared'], optimizers['shared'], loss_function, 'best')
                print(f'[{episode}] Saved new best model', flush=True)
        else:
            _save_separate(models['policy'], models['q1'], models['q2'],
                           optimizers['policy'], optimizers['q1'], optimizers['q2'],
                           loss_function, 'latest')
            if best:
                _save_separate(models['policy'], models['q1'], models['q2'],
                               optimizers['policy'], optimizers['q1'], optimizers['q2'],
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
    if args.shared_model:
        shared_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, ['policy', 'q1', 'q2'])
        shared_optimizer = optim.Adam(shared_model.parameters(), lr=args.lr_initial)
        shared_scheduler = optim.lr_scheduler.CosineAnnealingLR(shared_optimizer, args.lr_steps, args.lr_final)
        models = {'shared': shared_model}
        optimizers = {'shared': shared_optimizer}
        schedulers = {'shared': shared_scheduler}
    else:
        policy_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, ['policy'])
        q1_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, ['q'])
        q2_model = _create_rgnn(domain, args.embedding_size, args.layers, args.aggregation, ['q'])
        policy_optimizer = optim.Adam(policy_model.parameters(), lr=args.lr_initial)
        q1_optimizer = optim.Adam(q1_model.parameters(), lr=args.lr_initial)
        q2_optimizer = optim.Adam(q2_model.parameters(), lr=args.lr_initial)
        policy_scheduler = optim.lr_scheduler.CosineAnnealingLR(policy_optimizer, args.lr_steps, args.lr_final)
        q1_scheduler = optim.lr_scheduler.CosineAnnealingLR(q1_optimizer, args.lr_steps, args.lr_final)
        q2_scheduler = optim.lr_scheduler.CosineAnnealingLR(q2_optimizer, args.lr_steps, args.lr_final)
        models = {'policy': policy_model, 'q1': q1_model, 'q2': q2_model}
        optimizers = {'policy': policy_optimizer, 'q1': q1_optimizer, 'q2': q2_optimizer}
        schedulers = {'policy': policy_scheduler, 'q1': q1_scheduler, 'q2': q2_scheduler}
    print('Training model...', flush=True)
    _train(models, optimizers, schedulers, train_problems, validation_problems, args, device)


if __name__ == "__main__":
    _main(_parse_arguments())
