import torch


class FakeProblem:
    def __init__(self, goal, initial_state):
        self._goal = goal
        self._initial_state = initial_state

    def get_goal_condition(self):
        return self._goal

    def get_initial_state(self):
        return self._initial_state


class FakeGoal:
    def __init__(self, holds_result):
        self._holds_result = holds_result
        self.calls = []

    def holds(self, state):
        self.calls.append(state)
        return self._holds_result


class FakeState:
    def __init__(self, problem, actions):
        self._problem = problem
        self._actions = list(actions)

    def get_problem(self):
        return self._problem

    def generate_applicable_actions(self):
        return list(self._actions)


class FakeAction:
    def __init__(self, successor, label='(action)'):
        self._successor = successor
        self._label = label

    def apply(self, state):
        return self._successor

    def __str__(self):
        return self._label


class FakeReadout:
    def __init__(self, tensor):
        self._tensor = tensor

    def readout(self, key):
        return self._tensor


class RecordingModel:
    def __init__(self, tensor):
        self._tensor = tensor
        self.forward_calls = []
        self.eval_calls = 0

    def forward(self, inputs):
        self.forward_calls.append(inputs)
        return FakeReadout(self._tensor.clone())

    def eval(self):
        self.eval_calls += 1
        return self


def test_plan_returns_empty_solution_without_model_call_when_initial_state_is_goal(load_module):
    module = load_module('plan')
    goal = FakeGoal(True)
    initial_state = FakeState(None, [])
    problem = FakeProblem(goal, initial_state)
    model = RecordingModel(torch.tensor([]))

    solution = module._plan(problem, model)

    assert solution == []
    assert model.forward_calls == []


def test_plan_returns_none_when_state_has_no_applicable_actions(load_module):
    module = load_module('plan')
    goal = FakeGoal(False)
    initial_state = FakeState(None, [])
    problem = FakeProblem(goal, initial_state)
    model = RecordingModel(torch.tensor([]))

    solution = module._plan(problem, model)

    assert solution is None
    assert model.forward_calls == []


def test_neural_heuristic_returns_zero_for_goal_states_without_model_call(load_module):
    module = load_module('search')
    goal = FakeGoal(True)
    problem = type('Problem', (), {'get_goal_condition': lambda self: goal})()
    state = type('State', (), {'get_problem': lambda self: problem})()
    model = RecordingModel(torch.tensor([4.0]))
    heuristic = module.NeuralHeuristic(model)

    value = heuristic.compute_value(state)

    assert value == 0.0
    assert model.forward_calls == []
    assert model.eval_calls == 0


def test_neural_heuristic_uses_explicit_goal_and_returns_python_float(load_module):
    module = load_module('search')
    default_goal = FakeGoal(False)
    explicit_goal = FakeGoal(False)
    problem = type('Problem', (), {'get_goal_condition': lambda self: default_goal})()
    state = type('State', (), {'get_problem': lambda self: problem})()
    model = RecordingModel(torch.tensor([3.5]))
    heuristic = module.NeuralHeuristic(model)

    value = heuristic.compute_value(state, explicit_goal)

    assert isinstance(value, float)
    assert value == 3.5
    assert model.eval_calls == 1
    assert model.forward_calls[0][0][1] is explicit_goal
