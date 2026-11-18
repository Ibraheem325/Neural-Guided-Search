"""
Soft-penalty bounds for IQN training (July 2026).

WHY. pymimir_rl's IQNOptimization enforces the value bounds by HARD-clamping every
target distribution to [observed_return, -1]:

    updated_dist = torch.clamp(updated_dist, min=lower_bounds[i], max=upper_bounds[i])
    (loss_functions_iqn.py, _compute_target_distributions)

A hard clamp DESTROYS magnitude information: any target more negative than the observed
return is replaced by the bound, so the network never receives a gradient telling it to
go further negative. Because the observed return comes from short hindsight-relabelled
trajectories, the cap binds more often the further a state is from the goal -- producing
exactly the distance-progressive flattening measured in iqn_vs_dqn_calibration.py
(grid, d=10-22 slope: -0.421 clamped vs -0.683 unclamped vs -0.896 for the DQN).

The DQN does NOT do this. It applies the same bounds as an ADDITIVE SOFT PENALTY:

    bounds_errors = q - q.clamp(lower, upper).detach()
    losses += huber_loss(bounds_errors, 0, delta=1.0)
    (loss_functions_dqn.py)

which only NUDGES the prediction toward the bound and still lets the Bellman target pull
it past when the data demands. That difference is the single largest FIXABLE cause of the
IQN's early saturation, so this class gives the IQN the DQN's treatment.

WHAT THIS DOES. Subclasses rl.IQNOptimization, forces the parent to skip the hard clamp
(use_bounds=False), and re-implements the loss with the quantile Huber term unchanged plus
a soft bounds penalty on the PREDICTED quantiles. bounds_weight=0.0 reproduces plain
--no_use_bounds training; 1.0 matches the DQN's weighting.

CAVEAT (measured, do not over-claim). Removing/softening the clamp fixes the MID-range
(d=10-22) only. It does NOT restore slope beyond d~25: both the clamped and unclamped IQNs
are flat-to-inverted there (-10.9 -> -9.5 as true distance grows) and ceiling at -16.7 /
-21.3, versus the DQN's -171. The far-field ceiling is architectural -- see the FiLM
tau-conditioning patch in train_iqn.py (--tau_conditioning film). Both are needed.

USAGE (in train_iqn.py, replacing the rl.IQNOptimization construction):

    from iqn_soft_bounds import SoftBoundsIQNOptimization
    loss_function = SoftBoundsIQNOptimization(
        model, optimizer, lr_scheduler, model, args.discount_factor,
        args.num_quantiles, args.num_target_quantiles, args.num_selection_quantiles,
        bounds_weight=args.bounds_weight,
    )
"""
from __future__ import annotations

import torch
from torch.nn.functional import huber_loss

import pymimir_rl as rl
from pymimir_rl import Transition


class SoftBoundsIQNOptimization(rl.IQNOptimization):
    """IQN optimisation whose value bounds are a soft penalty instead of a hard target clamp."""

    def __init__(self, *args, bounds_weight: float = 1.0, **kwargs) -> None:
        # The parent must NOT hard-clamp the targets; we apply the bounds ourselves.
        kwargs['use_bounds'] = False
        super().__init__(*args, **kwargs)
        assert bounds_weight >= 0.0, 'bounds_weight must be non-negative.'
        self.bounds_weight = bounds_weight

    def __call__(self, transitions: list[Transition], weights: torch.Tensor) -> torch.Tensor:
        device = next(self.model.parameters()).device
        batch_size = len(transitions)

        taus = torch.rand(batch_size, self.num_quantiles, device=device)
        state_goals = [(t.current_state, t.goal_condition) for t in transitions]
        current_quantiles_batch = self.model.forward(state_goals, taus=taus)

        with torch.no_grad():
            # use_bounds is False, so these targets are UNCLAMPED.
            target_quantiles = self._compute_target_distributions(transitions, device)
            if self.bounds_weight > 0.0:
                lower_bounds, upper_bounds = self.get_value_bounds(transitions, device)
            else:
                lower_bounds, upper_bounds = None, None

        losses = []
        iterator = zip(current_quantiles_batch, target_quantiles, transitions)
        for i, ((pred_qs, pred_actions), target_dist, transition) in enumerate(iterator):
            try:
                action_idx = pred_actions.index(transition.selected_action)
                current_theta = pred_qs[action_idx]  # [N]
            except ValueError:
                # Failsafe for a corrupted replay buffer, same as the parent.
                losses.append(torch.tensor(0.0, device=device, requires_grad=True))
                continue

            # --- quantile Huber loss (identical to the parent) ---
            u = target_dist.unsqueeze(0) - current_theta.unsqueeze(1)     # [N, N']
            huber = huber_loss(u, torch.zeros_like(u), reduction='none')
            tau_expanded = taus[i].unsqueeze(1).expand_as(u)
            diff = torch.abs(tau_expanded - (u < 0).float())
            element_loss = (diff * huber).sum(dim=1).mean(dim=0)

            # --- soft bounds penalty (the DQN's treatment, applied to predictions) ---
            if lower_bounds is not None:
                clamped = current_theta.clamp(min=lower_bounds[i], max=upper_bounds[i]).detach()
                bounds_errors = current_theta - clamped
                penalty = huber_loss(
                    bounds_errors, torch.zeros_like(bounds_errors), delta=1.0, reduction='none'
                ).mean()
                element_loss = element_loss + self.bounds_weight * penalty

            losses.append(element_loss)

        loss_tensor = torch.stack(losses)
        weighted_loss = loss_tensor * weights.to(device)

        self.model_optimizer.zero_grad()
        weighted_loss.mean().backward()
        self.model_optimizer.step()
        self.model_lr_scheduler.step()

        return loss_tensor.detach()
