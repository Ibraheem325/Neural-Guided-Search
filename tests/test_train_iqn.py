from pathlib import Path

import pytest
import torch


class FakeGoal:
    pass


class FakeState:
    def __init__(self, actions):
        self._actions = list(actions)

    def generate_applicable_actions(self):
        return list(self._actions)


class FakeReadout:
    def __init__(self, embeddings):
        self._embeddings = embeddings

    def readout(self, key):
        assert key == 'action_embedding'
        return self._embeddings


class FakeBaseModel(torch.nn.Module):
    def __init__(self, embedding_size):
        super().__init__()
        self._hparams = type('HParams', (), {'embedding_size': embedding_size, 'num_layers': 6})()
        self.last_forward_inputs = None

    def get_hparam_config(self):
        return self._hparams

    def forward(self, inputs):
        self.last_forward_inputs = inputs
        embeddings = []
        for _, actions, _ in inputs:
            num_actions = len(actions)
            embeddings.append(torch.ones((num_actions, self._hparams.embedding_size), dtype=torch.float))
        return FakeReadout(tuple(embeddings))


@pytest.mark.parametrize(
    ('hindsight', 'expected_class', 'expected_args'),
    [
        ('lifted', 'LiftedHindsightTrajectoryRefiner', (['problem'], 7)),
        ('propositional', 'PropositionalHindsightTrajectoryRefiner', (['problem'], 7)),
        ('state', 'StateHindsightTrajectoryRefiner', (7,)),
        ('state_fluent', 'PartialStateHindsightTrajectoryRefiner', (7,)),
    ],
)
def test_create_trajectory_refiner_matches_hindsight_mode(load_module, hindsight, expected_class, expected_args):
    module = load_module('train_iqn')

    refiner = module._create_trajectory_refiner(hindsight, ['problem'], 7)

    assert type(refiner).__name__ == expected_class
    assert refiner.args == expected_args


def test_parse_instances_sorts_problem_files_and_excludes_domain(load_module, tmp_path):
    module = load_module('train_iqn')
    dataset_dir = tmp_path / 'dataset'
    dataset_dir.mkdir()
    (dataset_dir / 'domain.pddl').write_text('(domain)')
    (dataset_dir / 'c.pddl').write_text('(problem c)')
    (dataset_dir / 'a.pddl').write_text('(problem a)')

    domain, problems = module._parse_instances(dataset_dir)

    assert domain.path == str(dataset_dir / 'domain.pddl')
    assert [problem.path for problem in problems] == [
        str(dataset_dir / 'a.pddl'),
        str(dataset_dir / 'c.pddl'),
    ]


def test_create_model_accepts_sum_alias_and_uses_action_embedding_decoder(load_module):
    module = load_module('train_iqn')

    model = module._create_model(object(), 8, 3, 'sum', 16)

    assert type(model.model.module_config.aggregation_function).__name__ == 'SumAggregation'
    assert model.model.output_spec[0][0] == 'action_embedding'
    assert type(model.model.output_spec[0][1]).__name__ == 'ActionEmbeddingDecoder'


def test_iqn_wrapper_returns_scalar_values_without_taus(load_module):
    module = load_module('train_iqn')
    actions = ['a1', 'a2']
    state = FakeState(actions)
    wrapper = module.IQNModelWrapper(FakeBaseModel(embedding_size=4), num_cosines=8)

    outputs = wrapper.forward([(state, FakeGoal())], num_quantiles=5)

    quantiles, returned_actions = outputs[0]
    assert quantiles.shape == (2, 5)
    assert returned_actions == actions
    assert wrapper.model.last_forward_inputs[0][1] == actions


def test_iqn_wrapper_returns_quantile_matrix_when_taus_are_provided(load_module):
    module = load_module('train_iqn')
    actions = ['a1', 'a2', 'a3']
    state = FakeState(actions)
    wrapper = module.IQNModelWrapper(FakeBaseModel(embedding_size=4), num_cosines=8)
    taus = torch.rand(1, 7)

    outputs = wrapper.forward([(state, FakeGoal())], taus=taus)

    quantiles, returned_actions = outputs[0]
    assert quantiles.shape == (3, 7)
    assert returned_actions == actions
    assert wrapper.model.last_forward_inputs[0][1] == actions


def test_policy_wrapper_returns_scalar_values(load_module):
    module = load_module('train_iqn')
    actions = ['a1', 'a2', 'a3']
    state = FakeState(actions)
    quantile_model = module.IQNModelWrapper(FakeBaseModel(embedding_size=4), num_cosines=8)
    policy_model = module.RiskSensitivePolicyWrapper(quantile_model, risk_averseness=0.0, num_policy_quantiles=7)

    outputs = policy_model.forward([(state, FakeGoal())])

    values, returned_actions = outputs[0]
    assert values.shape == (3,)
    assert returned_actions == actions


def test_policy_wrapper_risk_averseness_changes_tau_support(load_module):
    module = load_module('train_iqn')
    base_model = FakeBaseModel(embedding_size=4)
    quantile_model = module.IQNModelWrapper(base_model, num_cosines=8)
    risk_neutral = module.RiskSensitivePolicyWrapper(quantile_model, risk_averseness=0.0, num_policy_quantiles=16)
    risk_averse = module.RiskSensitivePolicyWrapper(quantile_model, risk_averseness=0.75, num_policy_quantiles=16)

    neutral_taus = risk_neutral._sample_policy_taus(4, torch.device('cpu'))
    averse_taus = risk_averse._sample_policy_taus(4, torch.device('cpu'))

    assert float(neutral_taus.max()) <= 1.0
    assert float(averse_taus.max()) <= 0.25 + 1e-6


def test_save_checkpoint_stores_iqn_and_policy_state(load_module):
    module = load_module('train_iqn')

    model = module._create_model(object(), 8, 3, 'sum', 16)
    policy_model = module.RiskSensitivePolicyWrapper(model, risk_averseness=0.25, num_policy_quantiles=11)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.321)

    module._save_checkpoint(model, policy_model, optimizer, 'latest.pth')

    assert len(model.model.saved) == 1
    path, extras = model.model.saved[0]
    assert path == 'latest.pth'
    assert extras['optimizer']['param_groups'][0]['lr'] == pytest.approx(0.321)
    assert extras['iqn_wrapper']['num_cosines'] == 16
    assert 'cosine_projection.weight' in extras['iqn_wrapper']['state_dict']
    assert 'quantile_head.0.weight' in extras['iqn_wrapper']['state_dict']
    assert extras['policy_wrapper']['risk_averseness'] == pytest.approx(0.25)
    assert extras['policy_wrapper']['num_policy_quantiles'] == 11


def test_load_model_reconstructs_iqn_and_policy_wrappers(load_module, monkeypatch):
    module = load_module('train_iqn')

    saved_model = module._create_model(object(), 8, 3, 'sum', 16)
    saved_policy = module.RiskSensitivePolicyWrapper(saved_model, risk_averseness=0.25, num_policy_quantiles=11)
    optimizer = torch.optim.Adam(saved_model.parameters(), lr=0.321)
    module._save_checkpoint(saved_model, saved_policy, optimizer, 'latest.pth')
    _, extras = saved_model.model.saved[0]

    base_model = module._create_base_model(object(), 8, 3, 'sum')

    def fake_load(domain, path, device):
        return base_model, extras

    monkeypatch.setattr(module.rgnn.RelationalGraphNeuralNetwork, 'load', staticmethod(fake_load))

    loaded_model, loaded_policy, loaded_extras = module._load_model(object(), Path('latest.pth'), torch.device('cpu'))

    assert loaded_extras is extras
    assert loaded_model.num_cosines == 16
    assert loaded_policy.risk_averseness == pytest.approx(0.25)
    assert loaded_policy.num_policy_quantiles == 11


def test_load_model_allows_policy_overrides(load_module, monkeypatch):
    module = load_module('train_iqn')
    saved_model = module._create_model(object(), 8, 3, 'sum', 16)
    saved_policy = module.RiskSensitivePolicyWrapper(saved_model, risk_averseness=0.25, num_policy_quantiles=11)
    optimizer = torch.optim.Adam(saved_model.parameters(), lr=0.321)
    module._save_checkpoint(saved_model, saved_policy, optimizer, 'latest.pth')
    _, extras = saved_model.model.saved[0]

    base_model = module._create_base_model(object(), 8, 3, 'sum')

    def fake_load(domain, path, device):
        return base_model, extras

    monkeypatch.setattr(module.rgnn.RelationalGraphNeuralNetwork, 'load', staticmethod(fake_load))

    _, loaded_policy, _ = module._load_model(object(), Path('latest.pth'), torch.device('cpu'), risk_averseness=0.6, num_policy_quantiles=5)

    assert loaded_policy.risk_averseness == pytest.approx(0.6)
    assert loaded_policy.num_policy_quantiles == 5
