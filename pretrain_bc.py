"""Behavior-cloning pretrainer for the SAC policy network.

Motivation (barman): hindsight-RL fails on barman because random exploration almost
never performs the cocktail-assembly procedure, so the training data never contains it
and no relabeling/representation fix recovers it (see barman_failure_diagnosis.py and the
state-vs-lifted / warm-start experiments). This script instead injects the procedure
directly: it expands each training instance's state space, extracts the EXACT optimal
action(s) at every alive state (an action is optimal iff its successor's goal-distance is
one less than the state's), and trains a policy network by behavior cloning to put its
probability mass on optimal actions.

The produced policy has the SAME architecture as the SAC policy (input State+GroundActions
+Goal, per-action 'policy' scalar), so its checkpoint is a drop-in for greedy evaluation
(greedy_sac_plan.py) and for warm-starting SAC (train_sac.py --warm_start transfers every
matching name+shape parameter, which for an identical architecture is the whole network,
policy head included).
"""
import argparse
import glob
import random
import torch
import torch.optim as optim

import pymimir as mm
import pymimir_rgnn as rgnn

from pathlib import Path
from utils import create_device, get_state_key, mask_visited_scores


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Behavior-cloning pretrainer for a per-action policy network')
    parser.add_argument('--train', required=True, type=Path, help='Directory with training instances (expandable state spaces)')
    parser.add_argument('--test', required=True, type=Path, help='Directory with instances to greedily evaluate coverage on')
    parser.add_argument('--aggregation', default='smax', type=str, help='Aggregation function ("add", "mean", "smax", "hmax") — match the SAC run you will warm-start')
    parser.add_argument('--embedding_size', default=32, type=int)
    parser.add_argument('--layers', default=12, type=int)
    parser.add_argument('--batch_size', default=16, type=int, help='Number of states per optimisation step')
    parser.add_argument('--lr', default=0.0005, type=float)
    parser.add_argument('--steps', default=6000, type=int, help='Number of optimisation steps')
    parser.add_argument('--eval_every', default=500, type=int, help='Greedy-evaluate on --test every N steps')
    parser.add_argument('--eval_horizon', default=300, type=int)
    parser.add_argument('--max_train_instances', default=120, type=int, help='Cap on number of training instances to expand')
    parser.add_argument('--max_states_per_instance', default=400, type=int, help='Cap on alive states sampled per instance')
    parser.add_argument('--max_expand', default=100_000, type=int, help='State-space expansion cap; larger instances are skipped')
    parser.add_argument('--seed', default=42, type=int)
    parser.add_argument('--cpu', action='store_true')
    parser.add_argument('--output_prefix', default='barman_bc_', type=str)
    args = parser.parse_args()
    return args


def _create_aggregation(name: str):
    if name == 'smax': return rgnn.AggregationFunction.SmoothMaximum
    if name == 'hmax': return rgnn.AggregationFunction.HardMaximum
    if name == 'mean': return rgnn.AggregationFunction.Mean
    if name in ('add', 'sum'): return rgnn.AggregationFunction.Add
    raise RuntimeError(f'Unknown aggregation function: {name}.')


def _create_policy(domain: mm.Domain, embedding_size: int, num_layers: int, aggregation: str) -> rgnn.RelationalGraphNeuralNetwork:
    config = rgnn.RelationalGraphNeuralNetworkConfig(
        domain=domain,
        embedding_size=embedding_size,
        num_layers=num_layers,
        message_aggregation=_create_aggregation(aggregation),
        input_specification=(rgnn.InputType.State, rgnn.InputType.GroundActions, rgnn.InputType.Goal),
        output_specification=[('policy', rgnn.OutputNodeType.Action, rgnn.OutputValueType.Scalar)],
    )
    return rgnn.RelationalGraphNeuralNetwork(config)


def _canon(action) -> str:
    return str(action).lower().replace(' ', '')


def _build_dataset(domain: mm.Domain, train_paths: list[str], args: argparse.Namespace) -> list[tuple[mm.State, mm.GroundConjunctiveCondition, set[str]]]:
    """Each sample is (state, goal, {canonical strings of optimal actions})."""
    rng = random.Random(args.seed)
    dataset: list[tuple[mm.State, mm.GroundConjunctiveCondition, set[str]]] = []
    used = 0
    for path in train_paths:
        if used >= args.max_train_instances:
            break
        problem = mm.Problem(domain, path)
        sampler = mm.StateSpaceSampler.new(problem, args.max_expand)
        if sampler is None:
            continue  # unexpandable within the cap
        used += 1
        goal = problem.get_goal_condition()
        states = list(sampler.get_states())
        rng.shuffle(states)
        kept = 0
        for state in states:
            if kept >= args.max_states_per_instance:
                break
            label = sampler.get_state_label(state)
            if label.is_goal or label.is_dead_end:
                continue
            distance = label.steps_to_goal
            optimal: set[str] = set()
            for action in state.generate_applicable_actions():
                successor = action.apply(state)
                try:
                    successor_distance = sampler.get_state_label(successor).steps_to_goal
                except Exception:
                    continue
                if successor_distance == distance - 1:
                    optimal.add(_canon(action))
            if optimal:
                dataset.append((state, goal, optimal))
                kept += 1
    print(f'Built BC dataset: {len(dataset)} states from {used} instances.', flush=True)
    return dataset


def _bc_loss(policy: rgnn.RelationalGraphNeuralNetwork,
             batch: list[tuple[mm.State, mm.GroundConjunctiveCondition, set[str]]]) -> torch.Tensor:
    inputs = []
    action_lists = []
    for state, goal, _ in batch:
        actions = state.generate_applicable_actions()
        inputs.append((state, actions, goal))
        action_lists.append(actions)
    logits_list = policy.forward(inputs).readout('policy')  # list[Tensor], one per state
    losses = []
    for logits, actions, (_, _, optimal) in zip(logits_list, action_lists, batch):
        mask = torch.tensor([_canon(a) in optimal for a in actions], dtype=torch.bool, device=logits.device)
        if not bool(mask.any()):
            continue
        # positive-set cross entropy: -log( sum_{optimal} softmax(logits) )
        log_z = torch.logsumexp(logits, dim=0)
        log_pos = torch.logsumexp(logits[mask], dim=0)
        losses.append(log_z - log_pos)
    if not losses:
        return torch.zeros((), requires_grad=True)
    return torch.stack(losses).mean()


def _greedy_coverage(policy: rgnn.RelationalGraphNeuralNetwork, domain: mm.Domain, test_paths: list[str], horizon: int) -> tuple[int, int]:
    solved = 0
    with torch.no_grad():
        for path in test_paths:
            problem = mm.Problem(domain, path)
            goal = problem.get_goal_condition()
            state = problem.get_initial_state()
            visited = {get_state_key(state)}
            steps = 0
            while (not goal.holds(state)) and steps < horizon:
                actions = state.generate_applicable_actions()
                if not actions:
                    break
                successors = [a.apply(state) for a in actions]
                logits = policy.forward([(state, actions, goal)]).readout('policy')
                logits = (logits[0] if isinstance(logits, list) else logits).cpu()
                logits = mask_visited_scores(successors, logits, visited, float('-inf'))
                index = int(logits.argmax().item())
                state = successors[index]
                visited.add(get_state_key(state))
                steps += 1
            if goal.holds(state):
                solved += 1
    return solved, len(test_paths)


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}', flush=True)
    torch.manual_seed(args.seed)
    random.seed(args.seed)
    device = create_device(args.cpu)
    domain = mm.Domain(str(args.train / 'domain.pddl')) if (args.train / 'domain.pddl').exists() else mm.Domain(str(args.train.parent / 'domain.pddl'))
    train_paths = sorted(str(f) for f in args.train.glob('*.pddl') if f.name != 'domain.pddl')
    test_paths = sorted(str(f) for f in args.test.glob('*.pddl') if f.name != 'domain.pddl')
    print(f'{len(train_paths)} train instances, {len(test_paths)} test instances.', flush=True)

    dataset = _build_dataset(domain, train_paths, args)
    if not dataset:
        raise RuntimeError('Empty BC dataset — no expandable instances?')

    policy = _create_policy(domain, args.embedding_size, args.layers, args.aggregation).to(device)
    optimizer = optim.Adam(policy.parameters(), lr=args.lr)
    rng = random.Random(args.seed)

    best_cov = -1
    for step in range(1, args.steps + 1):
        batch = [dataset[rng.randrange(len(dataset))] for _ in range(args.batch_size)]
        loss = _bc_loss(policy, batch)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        if step % 100 == 0:
            print(f'[{step}/{args.steps}] bc_loss={loss.item():.4f}', flush=True)
        if step % args.eval_every == 0 or step == args.steps:
            solved, total = _greedy_coverage(policy, domain, test_paths, args.eval_horizon)
            print(f'[{step}/{args.steps}] greedy coverage: {solved}/{total} = {100*solved/total:.1f}%', flush=True)
            policy.save(f'{args.output_prefix}policy_latest.pth', {'optimizer': optimizer.state_dict()})
            if solved > best_cov:
                best_cov = solved
                policy.save(f'{args.output_prefix}policy_best.pth', {'optimizer': optimizer.state_dict()})
                print(f'[{step}/{args.steps}] saved new best ({solved}/{total}).', flush=True)


if __name__ == '__main__':
    _main(_parse_arguments())
