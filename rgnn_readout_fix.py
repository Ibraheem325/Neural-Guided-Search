"""
Fix a late-binding closure bug in pymimir_rgnn that silently breaks MULTI-OUTPUT models.
(July 2026)

THE BUG. pymimir_rgnn/model.py, RelationalGraphNeuralNetwork.forward (and the hook path):

    curried_readouts = { name: lambda: readout(node_embeddings, input)
                         for name, readout in self._readouts.items() }

Each lambda closes over the LOOP VARIABLE `readout`, not over its value at that iteration.
By the time any lambda runs, the loop has finished and `readout` holds the LAST readout in
the dict -- so EVERY named output returns the LAST readout's tensor.

DEMONSTRATED. With output_specification
    [('action_embedding', Action, Embeddings), ('object_embedding', Objects, Embeddings)]
on a 2-state batch with 8 applicable actions and 149 objects:
    readout('action_embedding').shape == (149, 32)   <- WRONG, should be (8, 32)
    readout('object_embedding').shape == (149, 32)
    torch.equal(action_embedding, object_embedding) == True
Both names returned the object readout. It fails SILENTLY -- no error, just wrong tensors.

SCOPE. Only models with >= 2 outputs are affected; with one readout the loop variable
happens to hold the right value. Every training script in this repo (train_dqn/train_sac/
train_supervised/train_iqn) uses a SINGLE-output specification, so no existing model or
result here is affected. It matters as soon as a model needs two outputs -- e.g. giving the
IQN the global object context that the DQN's ActionScalarReadout gets for free by
concatenating SumReadout(object_embeddings) onto the action embedding. (Note the config
docstring advertises exactly this multi-output use case: actor + critic sharing weights.)

THE FIX. Bind the readout per-iteration via a default argument, which evaluates at
definition time:

    { name: (lambda r=readout: r(node_embeddings, input)) for ... }

This module monkey-patches the corrected forward over the installed class, so the fix
travels with this repo and no venv edit is needed on the cluster. Behaviour for
single-output models is bit-for-bit unchanged.

USAGE. Import once, before building any model:

    import rgnn_readout_fix  # noqa: F401  (applies the patch on import)
"""
from __future__ import annotations

import pymimir_rgnn as rgnn
from pymimir_rgnn.model import ForwardState
from pymimir_rgnn.encodings import encode_input


def _patched_forward(self, x: list) -> ForwardState:
    # Faithful copy of RelationalGraphNeuralNetwork.forward with the closure bug fixed
    # (see module docstring). The ONLY change is `lambda r=readout: r(...)`.
    assert isinstance(x, list), 'Expected input to be a list.'
    input = encode_input(x, self._config.input_specification, self.get_device())
    if len(self._hooks) > 0:
        def hook_function(layer_index: int, node_embeddings) -> None:
            nonlocal self, input
            curried = {
                name: (lambda r=readout: r(node_embeddings, input))
                for name, readout in self._readouts.items()
            }
            self._notify_hooks(ForwardState(layer_index, curried))
        self._mpnn_module.add_hook(hook_function)
    node_embeddings = self._mpnn_module.forward(input)
    if len(self._hooks) > 0:
        self._mpnn_module.clear_hooks()
    curried = {
        name: (lambda r=readout: r(node_embeddings, input))
        for name, readout in self._readouts.items()
    }
    return ForwardState(self._config.num_layers - 1, curried)


def apply() -> None:
    """Idempotently install the corrected forward."""
    cls = rgnn.RelationalGraphNeuralNetwork
    if getattr(cls.forward, '_readout_fix_applied', False):
        return
    _patched_forward._readout_fix_applied = True  # type: ignore[attr-defined]
    cls.forward = _patched_forward  # type: ignore[assignment]


apply()
