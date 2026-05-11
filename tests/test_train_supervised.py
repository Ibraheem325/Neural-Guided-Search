import builtins

from pathlib import Path

import pytest
import torch


class FakeProblem:
    def __init__(self, goal):
        self._goal = goal

    def get_goal_condition(self):
        return self._goal


class FakeState:
    def __init__(self, problem):
        self._problem = problem

    def get_problem(self):
        return self._problem


class FakeLabel:
    def __init__(self, is_dead_end, steps_to_goal):
        self.is_dead_end = is_dead_end
        self.steps_to_goal = steps_to_goal


class CyclingSampler:
    def __init__(self, samples):
        self._samples = list(samples)
        self._index = 0

    def sample(self):
        sample = self._samples[self._index]
        self._index = (self._index + 1) % len(self._samples)
        return sample


class FakeReadout:
    def __init__(self, tensor):
        self._tensor = tensor

    def readout(self, key):
        assert key == 'value'
        return self._tensor


class FakeTrainModel(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.weight = torch.nn.Parameter(torch.tensor(1.0))
        self.saved = []

    def forward(self, inputs):
        return FakeReadout(self.weight.repeat(len(inputs)))

    def save(self, path, extras):
        self.saved.append((path, extras))


def test_create_model_accepts_sum_and_add_aliases(load_module):
    module = load_module('train_supervised')

    sum_model = module._create_model(object(), 8, 2, 'sum', torch.device('cpu'))
    add_model = module._create_model(object(), 8, 2, 'add', torch.device('cpu'))

    assert type(sum_model.module_config.aggregation_function).__name__ == 'SumAggregation'
    assert type(add_model.module_config.aggregation_function).__name__ == 'SumAggregation'


def test_get_instance_paths_handles_directory_and_single_problem_inputs(load_module, tmp_path):
    module = load_module('train_supervised')
    dataset_dir = tmp_path / 'dataset'
    dataset_dir.mkdir()
    (dataset_dir / 'domain.pddl').write_text('(domain)')
    (dataset_dir / 'b.pddl').write_text('(problem b)')
    (dataset_dir / 'a.pddl').write_text('(problem a)')

    domain_path, problem_paths = module._get_instance_paths(dataset_dir)
    assert domain_path == str(dataset_dir / 'domain.pddl')
    assert problem_paths == [str(dataset_dir / 'a.pddl'), str(dataset_dir / 'b.pddl')]

    single_problem = dataset_dir / 'b.pddl'
    domain_path, problem_paths = module._get_instance_paths(single_problem)
    assert domain_path == str(dataset_dir / 'domain.pddl')
    assert problem_paths == [str(single_problem)]


def test_create_datasets_rejects_empty_input_and_keeps_single_sampler_usable(load_module):
    module = load_module('train_supervised')

    with pytest.raises(ValueError, match='No state space samplers'):
        module._create_datasets([])

    sampler = object()
    train_dataset, validation_dataset = module._create_datasets([sampler])
    assert train_dataset._state_spaces == [sampler]
    assert validation_dataset._state_spaces == [sampler]


def test_sample_batch_maps_dead_ends_to_large_target_on_requested_device(load_module):
    module = load_module('train_supervised')
    goal = object()
    problem = FakeProblem(goal)
    samples = [
        (FakeState(problem), FakeLabel(True, 7)),
        (FakeState(problem), FakeLabel(False, 4)),
    ]

    inputs, targets = module._sample_batch(CyclingSampler(samples), 2, torch.device('cpu'))

    assert len(inputs) == 2
    assert inputs[0][1] is goal
    assert inputs[1][1] is goal
    assert targets.tolist() == [1000.0, 4.0]
    assert targets.device.type == 'cpu'
    assert not targets.requires_grad


def test_train_saves_latest_each_epoch_and_best_only_when_validation_improves(load_module, monkeypatch):
    module = load_module('train_supervised')
    model = FakeTrainModel()
    optimizer = torch.optim.SGD(model.parameters(), lr=0.0)

    def fake_sample_batch(state_sampler, batch_size, device):
        return [('state', 'goal')], torch.zeros(1, device=device)

    def limited_range(*args):
        if args == (0, 2):
            return builtins.range(0, 2)
        if args == (1000,):
            return builtins.range(2)
        if args == (100,):
            return builtins.range(2)
        return builtins.range(*args)

    monkeypatch.setattr(module, '_sample_batch', fake_sample_batch)
    monkeypatch.setattr(module, 'range', limited_range, raising=False)

    module._train(model, optimizer, object(), object(), 2, 1, torch.device('cpu'))

    saved_paths = [path for path, _ in model.saved]
    assert saved_paths.count('latest.pth') == 2
    assert saved_paths.count('best.pth') == 1


def test_load_optimizer_state_restores_saved_state_and_rejects_missing_payload(load_module):
    module = load_module('train_supervised')
    parameter = torch.nn.Parameter(torch.tensor(1.0))
    source_optimizer = torch.optim.Adam([parameter], lr=0.25)
    source_optimizer.zero_grad()
    parameter.grad = torch.tensor(1.0)
    source_optimizer.step()

    target_parameter = torch.nn.Parameter(torch.tensor(1.0))
    target_optimizer = torch.optim.Adam([target_parameter], lr=0.01)
    module._load_optimizer_state(target_optimizer, {'optimizer': source_optimizer.state_dict()}, Path('model.pth'))

    assert target_optimizer.state_dict()['param_groups'][0]['lr'] == pytest.approx(0.25)

    with pytest.raises(RuntimeError, match='does not contain optimizer state'):
        module._load_optimizer_state(target_optimizer, {}, Path('broken.pth'))
