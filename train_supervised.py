import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import queue
import random
import threading
import torch
import torch.optim as optim

from pathlib import Path
from utils import create_device
import time


class StateDataset:
    def __init__(self, state_space_samplers: list[mm.StateSpaceSampler]) -> None:
        self._state_spaces = state_space_samplers

    def sample(self) -> tuple[mm.State, mm.StateLabel]:
        # To achieve a good distribution, we uniformly sample a state space and select a valid goal-distance within that space.
        # Finally, we randomly sample a state from the selected state space and with the goal-distance.
        state_space_index = random.randint(0, len(self._state_spaces) - 1)
        state_space = self._state_spaces[state_space_index]
        lower_bound = -1 if (state_space.num_dead_end_states() > 0) else 0
        upper_bound = state_space.max_steps_to_goal()
        goal_distance = random.randint(lower_bound, upper_bound)  # -1 means dead-end state, 0 means goal state, and positive values mean distance to goal.
        sampled_state = state_space.sample_dead_end_state() if goal_distance < 0 else state_space.sample_state_n_steps_from_goal(goal_distance)
        sampled_label = state_space.get_state_label(sampled_state)
        return (sampled_state, sampled_label)


class BatchPrefetcher:
    def __init__(self, state_sampler: StateDataset, batch_size: int, device: torch.device, queue_size: int = 4):
        self._queue: queue.Queue = queue.Queue(maxsize=queue_size)
        self._stop_event = threading.Event()
        self._thread = threading.Thread(
            target=self._worker, args=(state_sampler, batch_size, device), daemon=True
        )
        self._thread.start()

    def _worker(self, state_sampler: StateDataset, batch_size: int, device: torch.device) -> None:
        while not self._stop_event.is_set():
            batch = _sample_batch(state_sampler, batch_size, device)
            while not self._stop_event.is_set():
                try:
                    self._queue.put(batch, timeout=0.1)
                    break
                except queue.Full:
                    continue

    def next(self) -> tuple:
        return self._queue.get()

    def stop(self) -> None:
        self._stop_event.set()
        self._thread.join(timeout=5.0)


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for training')
    parser.add_argument('--input', default=Path('examples'), type=Path, help='Path to the folder containing all domain folders')
    parser.add_argument('--domain', required=True, type=str, help='Name of the domain folder under --input (e.g., "grid", "blocks")')
    parser.add_argument('--model', default=None, type=Path, help='Path to a pre-trained model to continue training from')
    parser.add_argument('--embedding_size', default=32, type=int, help='Dimension of the embedding vector for each object')
    parser.add_argument('--aggregation', default='hmax', type=str, help='Aggregation function ("smax", "hmax", "sum"/"add", or "mean")')
    parser.add_argument('--layers', default=30, type=int, help='Number of layers in the model')
    parser.add_argument('--batch_size', default=64, type=int, help='Number of samples per batch')
    parser.add_argument('--learning_rate', default=0.0002, type=float, help='Learning rate for the training process')
    parser.add_argument('--num_epochs', default=1_000, type=int, help='Number of epochs for the training process')
    parser.add_argument('--seed', default=42, type=int, help='Random seed for reproducibility')
    args = parser.parse_args()
    return args


def _get_instance_paths(input: Path) -> tuple[str, list[str], list[str]]:
    print('Finding paths...')
    if input.is_file():
        domain_file = str(input.parent / 'domain.pddl')
        train_problem_files = [str(input)]
        val_problem_files = []
    else:
        domain_file = str(input / 'domain.pddl')
        train_dir = input / 'train'
        val_dir = input / 'val'
        if train_dir.is_dir():
            # New layout: domain.pddl at root, instances under train/ and val/
            train_problem_files = [str(f) for f in train_dir.glob('*.pddl') if f.name != 'domain.pddl']
            train_problem_files.sort()
            if val_dir.is_dir():
                val_problem_files = [str(f) for f in val_dir.glob('*.pddl') if f.name != 'domain.pddl']
                val_problem_files.sort()
            else:
                val_problem_files = []
        else:
            # Old layout: domain.pddl and instances in the same folder
            train_problem_files = [str(f) for f in input.glob('*.pddl') if f.name != 'domain.pddl']
            train_problem_files.sort()
            val_problem_files = []
    return domain_file, train_problem_files, val_problem_files



def _parse_instances(domain_path: str, train_paths: list[str], val_paths: list[str]) -> tuple[mm.Domain, list[mm.Problem], list[mm.Problem]]:
    print('Parsing instances...')
    domain = mm.Domain(domain_path)
    train_problems = [mm.Problem(domain, p) for p in train_paths]
    val_problems = [mm.Problem(domain, p) for p in val_paths]
    print(f'- Domain: {domain.get_name()}')
    print(f'- # Train problems: {len(train_problems)}')
    print(f'- # Val problems: {len(val_problems)}')
    return domain, train_problems, val_problems


def _generate_state_spaces(problems: list[mm.Problem], seed: int) -> list[mm.StateSpaceSampler]:
    print('Generating state spaces...')
    state_space_samplers: list[mm.StateSpaceSampler] = []
    for problem in problems:
        print(f'> Expanding: {problem.get_name()}')
        state_space_sampler = mm.StateSpaceSampler.new(problem, 10_000_000)
        if state_space_sampler is not None:
            state_space_sampler.set_seed(seed)
            state_space_samplers.append(state_space_sampler)
            print(f'- Added with {state_space_sampler.num_states()} states')
        else:
            print('- Skipped')
    return state_space_samplers


def _create_datasets(train_samplers: list[mm.StateSpaceSampler],
                    val_samplers: list[mm.StateSpaceSampler]) -> tuple[StateDataset, StateDataset]:
    print('Creating state samplers...')
    if len(train_samplers) == 0:
        raise ValueError('No training state space samplers were generated.')
    if len(val_samplers) == 0:
        # Fall back: use train set for validation (or do the old 80/20 split)
        if len(train_samplers) == 1:
            return StateDataset(train_samplers.copy()), StateDataset(train_samplers.copy())
        split = max(1, min(len(train_samplers) - 1, int(len(train_samplers) * 0.8)))
        return StateDataset(train_samplers[:split]), StateDataset(train_samplers[split:])
    return StateDataset(train_samplers), StateDataset(val_samplers)


def _create_model(domain: mm.Domain, embedding_size: int, num_layers: int, aggregation: str, device: torch.device) -> rgnn.RelationalGraphNeuralNetwork:
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
        input_specification=(rgnn.InputType.State, rgnn.InputType.Goal),
        output_specification=[('value', rgnn.OutputNodeType.Objects, rgnn.OutputValueType.Scalar)],
    )
    return rgnn.RelationalGraphNeuralNetwork(config).to(device)


def _sample_batch(state_sampler: StateDataset, batch_size: int, device: torch.device) -> tuple[list[tuple[mm.State, mm.GroundConjunctiveCondition]], torch.Tensor]:
    inputs: list[tuple[mm.State, mm.GroundConjunctiveCondition]] = []
    targets: list[float]  = []
    for _ in range(batch_size):
        state, label = state_sampler.sample()
        problem = state.get_problem()
        goal = problem.get_goal_condition()
        inputs.append((state, goal))
        targets.append(1000.0 if label.is_dead_end else label.steps_to_goal)
    return inputs, torch.tensor(targets,  dtype=torch.float, requires_grad=False, device=device)


def _load_optimizer_state(optimizer: optim.Optimizer, extras: dict, model_path: Path) -> None:
    optimizer_state = extras.get('optimizer')
    if optimizer_state is None:
        raise RuntimeError(f'Checkpoint {model_path} does not contain optimizer state.')
    optimizer.load_state_dict(optimizer_state)


def _train(model: rgnn.RelationalGraphNeuralNetwork,
           optimizer: optim.Adam,
           train_states: StateDataset,
           validation_states: StateDataset,
           num_epochs: int,
           batch_size: int,
           device: torch.device) -> None:
    TRAIN_SIZE = 1000
    VALIDATION_SIZE = 100
    best_error = None  # Track the best validation loss to detect overfitting.
    print('Training model...')
    train_prefetcher = BatchPrefetcher(train_states, batch_size, device)
    try:
        for epoch in range(0, num_epochs):
            last_print_time = time.time()
            # Train step
            for index in range(TRAIN_SIZE):
                inputs, targets = train_prefetcher.next()
                outputs: torch.Tensor = model.forward(inputs).readout('value')
                loss = (outputs - targets).abs().mean()
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
                # Print loss every 100 steps (printing every step forces synchronization with CPU)
                if (index + 1) % 100 == 0:
                    current_time = time.time()
                    elapsed = current_time - last_print_time
                    print(f'[{epoch + 1}/{num_epochs}; {index + 1}/{TRAIN_SIZE}] Loss: {loss.item():.4f} ({elapsed:.2f} seconds)')
                    last_print_time = current_time
            # Validation step
            with torch.no_grad():
                error = torch.zeros([1], dtype=torch.float, device=device)
                for index in range(VALIDATION_SIZE):
                    inputs, targets = _sample_batch(validation_states, batch_size, device)
                    outputs = model.forward(inputs).readout('value')
                    error += (outputs - targets).abs().sum()
                total_samples = VALIDATION_SIZE * batch_size
                error = error / total_samples
                print(f'[{epoch + 1}/{num_epochs}] Absolute error: {error.item():.4f}')
                model.save('latest.pth', { 'optimizer': optimizer.state_dict() })
                if (best_error is None) or (error < best_error):
                    best_error = error
                    model.save('best.pth', { 'optimizer': optimizer.state_dict() })
                    print(f'[{epoch + 1}/{num_epochs}] Saved new best model')
    finally:
        train_prefetcher.stop()


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    device = create_device(False)
    domain_dir = args.input / args.domain
    if not domain_dir.is_dir():
        raise FileNotFoundError(f'Domain folder not found: {domain_dir}')
    print(f'Using domain folder: {domain_dir}')
    domain_path, train_paths, val_paths = _get_instance_paths(domain_dir)
    domain, train_problems, val_problems = _parse_instances(domain_path, train_paths, val_paths)
    train_state_spaces = _generate_state_spaces(train_problems, args.seed)
    val_state_spaces = _generate_state_spaces(val_problems, args.seed)
    train_dataset, validation_dataset = _create_datasets(train_state_spaces, val_state_spaces)
    if args.model is None:
        print('Creating a new model and optimizer...')
        model = _create_model(domain, args.embedding_size, args.layers, args.aggregation, device)
        optimizer = optim.Adam(model.parameters(), lr=args.learning_rate)
    else:
        print(f'Loading an existing model and optimizer... ({args.model})')
        model, extras = rgnn.RelationalGraphNeuralNetwork.load(domain, args.model, device)
        optimizer = optim.Adam(model.parameters(), lr=args.learning_rate)
        _load_optimizer_state(optimizer, extras, args.model)
    _train(model, optimizer, train_dataset, validation_dataset, args.num_epochs, args.batch_size, device)


if __name__ == "__main__":
    _main(_parse_arguments())
