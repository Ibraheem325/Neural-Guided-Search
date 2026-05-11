import importlib
import sys

from pathlib import Path
from types import ModuleType, SimpleNamespace

import pytest
import torch


PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


def _build_pymimir_stub() -> ModuleType:
    module = ModuleType('pymimir')

    class Heuristic:
        pass

    class Domain:
        def __init__(self, path):
            self.path = str(path)

        def get_name(self):
            return Path(self.path).stem

    class Problem:
        def __init__(self, domain, path):
            self.domain = domain
            self.path = str(path)

        def get_name(self):
            return Path(self.path).name

        def get_objects(self):
            return []

    class StateSpaceSampler:
        pass

    class State:
        pass

    class StateLabel:
        pass

    class GroundConjunctiveCondition:
        pass

    class GroundAction:
        pass

    def astar_eager(*args, **kwargs):
        return SimpleNamespace(status='failed', solution=None)

    module.Heuristic = Heuristic
    module.Domain = Domain
    module.Problem = Problem
    module.StateSpaceSampler = StateSpaceSampler
    module.State = State
    module.StateLabel = StateLabel
    module.GroundConjunctiveCondition = GroundConjunctiveCondition
    module.GroundAction = GroundAction
    module.astar_eager = astar_eager
    return module


def _build_rgnn_stub() -> ModuleType:
    module = ModuleType('pymimir_rgnn')

    class HyperparameterConfig:
        def __init__(self, domain, embedding_size, num_layers):
            self.domain = domain
            self.embedding_size = embedding_size
            self.num_layers = num_layers

    class SmoothMaximumAggregation:
        pass

    class HardMaximumAggregation:
        pass

    class MeanAggregation:
        pass

    class SumAggregation:
        pass

    class StateEncoder:
        pass

    class GoalEncoder:
        pass

    class GroundActionsEncoder:
        pass

    class ObjectsScalarDecoder:
        def __init__(self, hparam_config):
            self.hparam_config = hparam_config

    class ActionScalarDecoder:
        def __init__(self, hparam_config):
            self.hparam_config = hparam_config

    class AttentionMessages:
        def __init__(self, *args, **kwargs):
            self.args = args
            self.kwargs = kwargs

    class PredicateMLPMessages:
        def __init__(self, *args, **kwargs):
            self.args = args
            self.kwargs = kwargs

    class MLPUpdates:
        def __init__(self, hparam_config):
            self.hparam_config = hparam_config

    class ModuleConfig:
        def __init__(self, aggregation_function, message_function, update_function):
            self.aggregation_function = aggregation_function
            self.message_function = message_function
            self.update_function = update_function

    class ReadoutResult:
        def __init__(self, outputs):
            self._outputs = outputs

        def readout(self, key):
            return self._outputs

    class RelationalGraphNeuralNetwork(torch.nn.Module):
        def __init__(self, hparam_config, module_config, input_spec, output_spec):
            super().__init__()
            self._hparam_config = hparam_config
            self.module_config = module_config
            self.input_spec = input_spec
            self.output_spec = output_spec
            self.saved = []
            self.was_eval = False
            self.compile_mode = None
            self.weight = torch.nn.Parameter(torch.tensor(1.0))

        def to(self, device):
            self.device = device
            return self

        def get_hparam_config(self):
            return self._hparam_config

        def forward(self, inputs):
            return ReadoutResult(self.weight.repeat(len(inputs)))

        def save(self, path, extras):
            self.saved.append((path, extras))

        def eval(self):
            self.was_eval = True
            return self

        def enable_torch_compile(self, mode):
            self.compile_mode = mode
            return mode

        @classmethod
        def load(cls, domain, path, device):
            config = HyperparameterConfig(domain, 1, 1)
            model = cls(config, ModuleConfig(HardMaximumAggregation(), None, None), (), ())
            model.to(device)
            return model, {}

    def set_tf32_enabled(enabled):
        module.tf32_enabled = enabled

    module.RelationalGraphNeuralNetwork = RelationalGraphNeuralNetwork
    module.HyperparameterConfig = HyperparameterConfig
    module.SmoothMaximumAggregation = SmoothMaximumAggregation
    module.HardMaximumAggregation = HardMaximumAggregation
    module.MeanAggregation = MeanAggregation
    module.SumAggregation = SumAggregation
    module.StateEncoder = StateEncoder
    module.GoalEncoder = GoalEncoder
    module.GroundActionsEncoder = GroundActionsEncoder
    module.ObjectsScalarDecoder = ObjectsScalarDecoder
    module.ActionScalarDecoder = ActionScalarDecoder
    module.AttentionMessages = AttentionMessages
    module.PredicateMLPMessages = PredicateMLPMessages
    module.MLPUpdates = MLPUpdates
    module.ModuleConfig = ModuleConfig
    module.ReadoutResult = ReadoutResult
    module.set_tf32_enabled = set_tf32_enabled
    return module


def _build_rl_stub() -> ModuleType:
    module = ModuleType('pymimir_rl')

    class ActionScalarModel(torch.nn.Module):
        def __init__(self):
            super().__init__()

    class TrajectoryRefiner:
        pass

    class _Base:
        def __init__(self, *args, **kwargs):
            self.args = args
            self.kwargs = kwargs

    class DQNOptimization(_Base):
        pass

    class ConstantRewardFunction(_Base):
        pass

    class PrioritizedReplayBuffer(_Base):
        pass

    class BoltzmannTrajectorySampler(_Base):
        def set_temperature(self, temperature):
            self.temperature = temperature

    class UniformProblemSampler(_Base):
        pass

    class OriginalInitialStateSampler(_Base):
        pass

    class OriginalGoalConditionSampler(_Base):
        pass

    class LiftedHindsightTrajectoryRefiner(TrajectoryRefiner, _Base):
        pass

    class PropositionalHindsightTrajectoryRefiner(TrajectoryRefiner, _Base):
        pass

    class StateHindsightTrajectoryRefiner(TrajectoryRefiner, _Base):
        pass

    class PartialStateHindsightTrajectoryRefiner(TrajectoryRefiner, _Base):
        pass

    class OffPolicyAlgorithm(_Base):
        def register_on_pre_collect_experience(self, callback):
            self.on_pre_collect_experience = callback

        def register_on_sample_problems(self, callback):
            self.on_sample_problems = callback

        def register_on_sample_initial_states(self, callback):
            self.on_sample_initial_states = callback

        def register_on_sample_goal_conditions(self, callback):
            self.on_sample_goal_conditions = callback

        def register_on_sample_trajectories(self, callback):
            self.on_sample_trajectories = callback

        def register_on_refine_trajectories(self, callback):
            self.on_refine_trajectories = callback

        def register_on_post_collect_experience(self, callback):
            self.on_post_collect_experience = callback

        def register_on_pre_optimize_model(self, callback):
            self.on_pre_optimize_model = callback

        def register_on_train_step(self, callback):
            self.on_train_step = callback

        def register_on_post_optimize_model(self, callback):
            self.on_post_optimize_model = callback

        def fit(self):
            return None

    class CoverageCriteria(_Base):
        pass

    class LengthCriteria(_Base):
        pass

    class GreedyPolicyTrajectorySampler(_Base):
        pass

    class PolicyEvaluation(_Base):
        def evaluate(self):
            return False, {}

    module.ActionScalarModel = ActionScalarModel
    module.TrajectoryRefiner = TrajectoryRefiner
    module.DQNOptimization = DQNOptimization
    module.ConstantRewardFunction = ConstantRewardFunction
    module.PrioritizedReplayBuffer = PrioritizedReplayBuffer
    module.BoltzmannTrajectorySampler = BoltzmannTrajectorySampler
    module.UniformProblemSampler = UniformProblemSampler
    module.OriginalInitialStateSampler = OriginalInitialStateSampler
    module.OriginalGoalConditionSampler = OriginalGoalConditionSampler
    module.LiftedHindsightTrajectoryRefiner = LiftedHindsightTrajectoryRefiner
    module.PropositionalHindsightTrajectoryRefiner = PropositionalHindsightTrajectoryRefiner
    module.StateHindsightTrajectoryRefiner = StateHindsightTrajectoryRefiner
    module.PartialStateHindsightTrajectoryRefiner = PartialStateHindsightTrajectoryRefiner
    module.OffPolicyAlgorithm = OffPolicyAlgorithm
    module.CoverageCriteria = CoverageCriteria
    module.LengthCriteria = LengthCriteria
    module.GreedyPolicyTrajectorySampler = GreedyPolicyTrajectorySampler
    module.PolicyEvaluation = PolicyEvaluation
    module.Trajectory = list
    return module


@pytest.fixture
def load_module(monkeypatch):
    def _load(module_name: str):
        monkeypatch.setitem(sys.modules, 'pymimir', _build_pymimir_stub())
        monkeypatch.setitem(sys.modules, 'pymimir_rgnn', _build_rgnn_stub())
        monkeypatch.setitem(sys.modules, 'pymimir_rl', _build_rl_stub())
        sys.modules.pop(module_name, None)
        return importlib.import_module(module_name)

    return _load
