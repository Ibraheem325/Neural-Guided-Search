import pytest
import torch


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
    module = load_module('train_dqn')

    refiner = module._create_trajectory_refiner(hindsight, ['problem'], 7)

    assert type(refiner).__name__ == expected_class
    assert refiner.args == expected_args


def test_parse_instances_sorts_problem_files_and_excludes_domain(load_module, tmp_path):
    module = load_module('train_dqn')
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


def test_create_model_accepts_sum_alias(load_module):
    module = load_module('train_dqn')

    model = module._create_model(object(), 8, 3, 'sum')

    assert type(model.module_config.aggregation_function).__name__ == 'SumAggregation'
