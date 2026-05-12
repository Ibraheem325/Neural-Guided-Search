import torch


def create_device(force_cpu: bool):
    if not force_cpu and torch.cuda.is_available():
        device = torch.device("cuda")
        print("Using GPU: ", torch.cuda.get_device_name(0))
    else:
        device = torch.device("cpu")
        print("Using CPU.")
    return device


def get_state_key(state):
    return state.get_index()


def mask_visited_scores(successor_states, scores: torch.Tensor, visited_states: set, revisit_score: float) -> torch.Tensor:
    assert scores.ndim == 1, 'Expected a flat tensor of action scores.'
    revisit_mask = torch.tensor(
        [get_state_key(successor_state) in visited_states for successor_state in successor_states],
        dtype=torch.bool,
        device=scores.device,
    )
    if not revisit_mask.any() or revisit_mask.all():
        return scores
    masked_scores = scores.clone()
    masked_scores[revisit_mask] = revisit_score
    return masked_scores
