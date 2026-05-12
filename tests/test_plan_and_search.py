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
    def __init__(self, problem, actions, is_goal=False, key=None):
        self._problem = problem
        self._actions = list(actions)
        self.is_goal = is_goal
        self._key = object() if key is None else key

    def get_problem(self):
        return self._problem

    def generate_applicable_actions(self):
        return list(self._actions)

    def get_index(self):
        return self._key

    def __hash__(self):
        return hash(self._key)

    def __eq__(self, other):
        return isinstance(other, FakeState) and self._key == other._key


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


class RecordingQModel:
    def __init__(self, q_values):
        self._q_values = q_values
        self.forward_calls = []

    def forward(self, inputs):
        self.forward_calls.append(inputs)
        return FakeReadout([self._q_values.clone()])


class RecordingIQNModel:
    def __init__(self, q_quantiles):
        self._q_quantiles = q_quantiles
        self.forward_calls = []
        self.parameter = torch.nn.Parameter(torch.tensor(1.0))

    def forward(self, inputs, taus=None):
        self.forward_calls.append((inputs, taus))
        return [(self._q_quantiles.clone(), inputs[0][0].generate_applicable_actions())]

    def parameters(self):
        return iter([self.parameter])


class RecordingRiskPolicy:
    def __init__(self, risk_averseness=0.0, num_policy_quantiles=4):
        self.risk_averseness = risk_averseness
        self.num_policy_quantiles = num_policy_quantiles

    def get_tau_upper_bound(self):
        return max(1e-3, 1.0 - self.risk_averseness)

    def reduce_quantiles(self, q_values):
        return q_values.mean(dim=1)


def _create_revisit_problem():
    class StateGoal:
        def holds(self, state):
            return state.is_goal

    goal = StateGoal()
    goal_state = FakeState(None, [], is_goal=True, key='goal')
    revisit_state = FakeState(None, [], key='start')
    revisit_action = FakeAction(revisit_state, '(revisit)')
    goal_action = FakeAction(goal_state, '(goal)')
    initial_state = FakeState(None, [revisit_action, goal_action], key='start')
    problem = FakeProblem(goal, initial_state)
    initial_state._problem = problem
    revisit_state._problem = problem
    goal_state._problem = problem
    return problem, revisit_action, goal_action


def test_plan_returns_empty_solution_without_model_call_when_initial_state_is_goal(load_module):
    module = load_module('greedy_value_plan')
    goal = FakeGoal(True)
    initial_state = FakeState(None, [])
    problem = FakeProblem(goal, initial_state)
    model = RecordingModel(torch.tensor([]))

    solution = module._plan(problem, model)

    assert solution == []
    assert model.forward_calls == []


def test_plan_returns_none_when_state_has_no_applicable_actions(load_module):
    module = load_module('greedy_value_plan')
    goal = FakeGoal(False)
    initial_state = FakeState(None, [])
    problem = FakeProblem(goal, initial_state)
    model = RecordingModel(torch.tensor([]))

    solution = module._plan(problem, model)

    assert solution is None
    assert model.forward_calls == []


def test_value_plan_avoids_revisiting_states_by_default(load_module):
    module = load_module('greedy_value_plan')
    problem, _, goal_action = _create_revisit_problem()
    model = RecordingModel(torch.tensor([0.0, 1.0]))

    solution = module._plan(problem, model)

    assert [str(action) for action in solution] == [str(goal_action)]


def test_value_plan_can_disable_closed_set(load_module):
    module = load_module('greedy_value_plan')
    problem, _, _ = _create_revisit_problem()
    model = RecordingModel(torch.tensor([0.0, 1.0]))

    solution = module._plan(problem, model, use_closed_set=False)

    assert solution is None


def test_value_plan_falls_back_to_visited_successors_when_necessary(load_module):
    module = load_module('greedy_value_plan')
    goal = FakeGoal(False)
    revisit_state = FakeState(None, [], key='start')
    revisit_action = FakeAction(revisit_state, '(revisit)')
    initial_state = FakeState(None, [revisit_action], key='start')
    problem = FakeProblem(goal, initial_state)
    initial_state._problem = problem
    revisit_state._problem = problem
    model = RecordingModel(torch.tensor([0.0]))

    solution = module._plan(problem, model)

    assert solution is None


def test_q_plan_chooses_action_with_highest_q_value(load_module):
    module = load_module('greedy_q_plan')

    class StateGoal:
        def holds(self, state):
            return state.is_goal

    goal = StateGoal()
    terminal_state = FakeState(None, [], is_goal=True)
    problem = FakeProblem(goal, FakeState(None, []))
    good_action = FakeAction(terminal_state, '(good)')
    bad_action = FakeAction(FakeState(None, []), '(bad)')
    initial_state = FakeState(problem, [bad_action, good_action])
    problem._initial_state = initial_state
    model = RecordingQModel(torch.tensor([1.0, 5.0]))

    solution = module._plan(problem, model)

    assert [str(action) for action in solution] == ['(good)']
    assert model.forward_calls[0][0][0] is initial_state
    assert model.forward_calls[0][0][1] == [bad_action, good_action]
    assert model.forward_calls[0][0][2] is goal


def test_q_plan_returns_none_when_state_has_no_applicable_actions(load_module):
    module = load_module('greedy_q_plan')
    goal = FakeGoal(False)
    initial_state = FakeState(None, [])
    problem = FakeProblem(goal, initial_state)
    model = RecordingQModel(torch.tensor([]))

    solution = module._plan(problem, model)

    assert solution is None
    assert model.forward_calls == []


def test_q_plan_avoids_revisiting_states_by_default(load_module):
    module = load_module('greedy_q_plan')
    problem, _, goal_action = _create_revisit_problem()
    model = RecordingQModel(torch.tensor([5.0, 1.0]))

    solution = module._plan(problem, model)

    assert [str(action) for action in solution] == [str(goal_action)]


def test_q_plan_can_disable_closed_set(load_module):
    module = load_module('greedy_q_plan')
    problem, _, _ = _create_revisit_problem()
    model = RecordingQModel(torch.tensor([5.0, 1.0]))

    solution = module._plan(problem, model, use_closed_set=False)

    assert solution is None


def test_iqn_plan_chooses_action_with_highest_risk_adjusted_mean_and_prints_distribution(load_module, capsys):
    module = load_module('greedy_iqn_plan')

    class StateGoal:
        def holds(self, state):
            return state.is_goal

    goal = StateGoal()
    terminal_state = FakeState(None, [], is_goal=True)
    problem = FakeProblem(goal, FakeState(None, []))
    good_action = FakeAction(terminal_state, '(good)')
    bad_action = FakeAction(FakeState(None, []), '(bad)')
    initial_state = FakeState(problem, [bad_action, good_action])
    problem._initial_state = initial_state
    model = RecordingIQNModel(torch.tensor([[1.0, 1.5, 2.0, 2.5], [3.0, 3.5, 4.0, 4.5]]))
    policy_model = RecordingRiskPolicy(risk_averseness=0.25, num_policy_quantiles=4)

    solution = module._plan(problem, model, policy_model)
    output = capsys.readouterr().out

    assert [str(action) for action in solution] == ['(good)']
    assert 'distribution:' in output
    assert '[3.000, 3.500, 4.000, 4.500]' in output
    _, taus = model.forward_calls[0]
    assert taus.shape == (1, 4)
    assert float(taus.max()) <= 0.75 + 1e-6


def test_iqn_plan_avoids_revisiting_states_by_default(load_module):
    module = load_module('greedy_iqn_plan')
    problem, _, goal_action = _create_revisit_problem()
    model = RecordingIQNModel(torch.tensor([[5.0, 5.0, 5.0, 5.0], [1.0, 1.0, 1.0, 1.0]]))
    policy_model = RecordingRiskPolicy()

    solution = module._plan(problem, model, policy_model)

    assert [str(action) for action in solution] == [str(goal_action)]


def test_iqn_plan_can_disable_closed_set(load_module):
    module = load_module('greedy_iqn_plan')
    problem, _, _ = _create_revisit_problem()
    model = RecordingIQNModel(torch.tensor([[5.0, 5.0, 5.0, 5.0], [1.0, 1.0, 1.0, 1.0]]))
    policy_model = RecordingRiskPolicy()

    solution = module._plan(problem, model, policy_model, use_closed_set=False)

    assert solution is None


def test_iqn_plan_returns_none_when_state_has_no_applicable_actions(load_module):
    module = load_module('greedy_iqn_plan')
    goal = FakeGoal(False)
    initial_state = FakeState(None, [])
    problem = FakeProblem(goal, initial_state)
    model = RecordingIQNModel(torch.empty((0, 4)))
    policy_model = RecordingRiskPolicy()

    solution = module._plan(problem, model, policy_model)

    assert solution is None


def test_iqn_planning_taus_respect_risk_bound(load_module):
    module = load_module('greedy_iqn_plan')

    taus = module._create_planning_taus(5, 0.25, torch.device('cpu'))

    assert taus.shape == (1, 5)
    assert float(taus.min()) > 0.0
    assert float(taus.max()) < 0.25


def test_iqn_parse_arguments_accepts_num_quantiles(load_module, monkeypatch):
    module = load_module('greedy_iqn_plan')

    monkeypatch.setattr(
        'sys.argv',
        [
            'greedy_iqn_plan.py',
            '--domain', 'domain.pddl',
            '--problem', 'problem.pddl',
            '--model', 'best.pth',
            '--risk_averseness', '0.25',
            '--num_quantiles', '17',
        ],
    )

    args = module._parse_arguments()

    assert args.risk_averseness == 0.25
    assert args.num_quantiles == 17


def test_iqn_parse_arguments_accepts_disable_closed_set(load_module, monkeypatch):
    module = load_module('greedy_iqn_plan')

    monkeypatch.setattr(
        'sys.argv',
        [
            'greedy_iqn_plan.py',
            '--domain', 'domain.pddl',
            '--problem', 'problem.pddl',
            '--model', 'best.pth',
            '--disable_closed_set',
        ],
    )

    args = module._parse_arguments()

    assert args.disable_closed_set is True


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
