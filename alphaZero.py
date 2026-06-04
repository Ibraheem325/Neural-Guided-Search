import argparse
import pymimir as mm
import pymimir_rgnn as rgnn
import torch
import math
from pathlib import Path
from typing import List, Union
from utils import create_device, get_state_key
import pymimir_rl as rl


class ModelWrapper(rl.ActionScalarModel):
    def __init__(self, model: rgnn.RelationalGraphNeuralNetwork, readout_name: str, random_layer_count: bool = False) -> None:
        super().__init__()
        self.model = model
        self.readout_name = readout_name
        self.random_layer_count = random_layer_count

    def forward(self, state_goals: list[tuple[mm.State, mm.GroundConjunctiveCondition]]) -> list[tuple[torch.Tensor, list[mm.GroundAction]]]:
        input_list: list[tuple[mm.State, list[mm.GroundAction], mm.GroundConjunctiveCondition]] = []
        actions_list: list[list[mm.GroundAction]] = []
        for state, goal in state_goals:
            actions = state.generate_applicable_actions()
            input_list.append((state, actions, goal))
            actions_list.append(actions)

        values_list = self.model.forward(input_list).readout(self.readout_name)  # type: ignore
        output = list(zip(values_list, actions_list))
        return output



class Node:
    def __init__(self, state, prior):
        self.state = state
        self.prior = prior
        self.visit_count = 0
        self.value_sum = 0
        self.children: dict["mm.GroundAction", "Node"] = {}


    def q_value(self):
        if self.visit_count == 0:
            return 0
        return self.value_sum/self.visit_count
    

def _expansion(node: Node, prior):
    applicable_actions = node.state.generate_applicable_actions()
    if len(applicable_actions)==0:
        return None
    for action in applicable_actions:
        successor_state = action.apply(node.state)
        child = Node(successor_state, prior[action])
        node.children[action] = child

def _select_child(node: Node, c=1.25):
    bestEQ = -1
    best_action = None
    best_child = None
    for action, child in node.children.items():
         pUCT = child.q_value() + c * child.prior * (math.sqrt(node.visit_count)/(1+child.visit_count))
         if pUCT > bestEQ:
             bestEQ = pUCT
             best_action = action
             best_child = child
    return best_action, best_child


def _backprobagation(search_path: List[Node], value):
    for node in search_path:
        node.visit_count+=1
        node.value_sum += value



def _run_mcts(root_state, policy_model, q1_model, goal, n_simulations):
    root_node = Node(root_state, prior=1.0)
    num_expanded= 0
    num_generated =0
    for i in range(n_simulations):
        search_path = [root_node]
        node = root_node
        while len(node.children)!=0:
            _, child = _select_child(node)
            if child is None:
                break
            search_path.append(child)
            node = child

        output = policy_model.forward([(node.state, goal)])
        values_tensor, actions = output[0]
        probs = torch.softmax(values_tensor, dim=0)
        if goal.holds(node.state):
            values = 0
        else:
            if len(node.children) == 0:
                priors = {action: probs[i].item() for i, action in enumerate(actions)}
                _expansion(node, priors)
                num_expanded += 1
                num_generated += len(priors)
            output = q1_model.forward([(node.state, goal)])
            values_tensor, actions = output[0]
            values = values_tensor.max().item()
        _backprobagation(search_path, values)

    best = 0

    best_action = None
    for action, child in root_node.children.items():
        if child.visit_count > best:
            best = child.visit_count
            best_action = action

    return best_action, num_generated, num_expanded


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Settings for greedy planning with a value model')
    parser.add_argument('--domain', required=True, type=Path, help='Path to the domain file')
    parser.add_argument('--problem', required=True, type=Path, help='Path to the problem file')
    parser.add_argument('--policy_model', required=True, type=Path, help='Path to a pre-trained policy model')
    parser.add_argument('--q1_model', required=True, type=Path, help='Path to a pre-trained q1 model')
    parser.add_argument('--n_simulations', default=60, type=int, help='Number of MCTS simulations per step')
    args = parser.parse_args()
    return args

def _plan(problem: mm.Problem,
    policy_model: rgnn.RelationalGraphNeuralNetwork,
    q1_model : rgnn.RelationalGraphNeuralNetwork,
    n_simulations
) -> Union[None, List[mm.GroundAction]]:
    with torch.no_grad():
        solution = []
        goal = problem.get_goal_condition()
        current_state = problem.get_initial_state()
        visited_states = {get_state_key(current_state)}
        num_steps = 0
        total_gen = 0
        total_exp = 0
        while not goal.holds(current_state) and (len(solution) < 1_000):
            best_action, num_generated, num_expanded = _run_mcts(current_state, policy_model, q1_model, goal, n_simulations)
            total_gen += num_generated
            total_exp += num_expanded
            current_state = best_action.apply(current_state)
            visited_states.add(get_state_key(current_state))
            solution.append(best_action)
            num_steps+=1
            print(f'Steps {num_steps}: {str(best_action)}')
            print(f'Expanded: {total_exp}, Generated: {total_gen}')
        print(f'[Final] Steps: {num_steps}, Expanded: {total_exp}, Generated: {total_gen}')
        return solution if goal.holds(current_state) else None
    


def _main(args: argparse.Namespace) -> None:
    print(f'Torch: {torch.__version__}')
    domain = mm.Domain(str(args.domain))
    problem = mm.Problem(domain, str(args.problem))
    device = create_device(False)
    policy_model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.policy_model, device)
    q1_model, _ = rgnn.RelationalGraphNeuralNetwork.load(domain, args.q1_model, device)
    policy_model = ModelWrapper(policy_model, 'policy')
    q1_model = ModelWrapper(q1_model, 'q')
    solution = _plan(problem, policy_model, q1_model, args.n_simulations)
    if solution is None:
        print('Failed to find a solution!')
    else:
        print(f'Found a solution of length {len(solution)}!')
        for index, action in enumerate(solution):
            print(f'{index + 1:>4}: {str(action)}')


if __name__ == '__main__':
    _main(_parse_arguments())
