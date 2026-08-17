# Bellman inconsistency signal

As implemented in `alphaZero_bellman.py`. Selected with `--abs_signal add|mul`.

Transitions are deterministic. Let

$$
s' = T(s,a),
\qquad
b^*(s') \in \arg\max_b \mathbb{E}[Z(s',b)]
$$

with a deterministic tie-break.

The target is

$$
Y_a =
\begin{cases}
\delta_{r}, & s' \text{ is a goal},\\[1ex]
r + \gamma\, Z_{\bar{\theta}}(s', b^*), & \text{otherwise},
\end{cases}
\qquad r = -1,\ \gamma = 0.999 .
$$

For $M = 99$ equal-weight quantiles on the grid $\tau \in \{0.01,\dots,0.99\}$,

$$
e_a
=
W_1\!\left(Z_\theta(s,a),\,Y_a\right)
=
\frac{1}{M}
\sum_{i=1}^{M}
\left|
z_{(i)}(s,a)
-
y_{(i),a}
\right| ,
$$

after sorting the quantile values.

$b^*$ is the plain arg-max. Ties break to the smallest $W_1$. No minimisation over $B_{\mathrm{good}}$.

$e_a$ is computed in decoded return units, so one unit is one action.

---

# Error scaling

$$
x_a
=
\frac{e_a}{e_a+\tau_{\mathrm{step}}},
\qquad
\tau_{\mathrm{step}} = 1 .
$$

- One-step inconsistency gives $x_a = 0.5$.
- Two-step gives $x_a = 2/3$.
- Large errors saturate near one.

Sweep $\tau_{\mathrm{step}} \in \{0.5,\,1,\,2\}$.

The state signal uses the locally applicable actions:

$$
g_s
=
\frac{1}{K_s}
\sum_{a\in A(s)}
x_a,
\qquad
K_s = |A(s)| .
$$

No global branching factor is needed.

---

# Common pUCT scale

$$
P_0(a)
=
(1-\epsilon_p)P(a)
+
\frac{\epsilon_p}{K_s},
\qquad
c(s)
=
c_0\left(1+\kappa g_s\right),
\qquad c_0 = 1.5 .
$$

$P(a)$ is the SAC policy softmax. The same $c(s)$ is used for both variants.

---

## Multiplicative

$$
P_\times(a)
=
\frac{
P_0(a)\left(1+\beta x_a\right)
}{
\sum_b
P_0(b)\left(1+\beta x_b\right)
} .
$$

$$
\boxed{
\operatorname{score}_\times(a)
=
Q_{\mathrm{norm}}(a)
+
c(s)\,
P_\times(a)\,
\frac{\sqrt{N}}{1+n_a}
}
$$

## Additive

$$
P_+(a)
=
\frac{
P_0(a)
+
\beta x_a/K_s
}{
1+\beta g_s
},
\qquad\text{since}\quad
\sum_a
\frac{x_a}{K_s}
=
g_s .
$$

$$
\boxed{
\operatorname{score}_+(a)
=
Q_{\mathrm{norm}}(a)
+
c(s)\,
P_+(a)\,
\frac{\sqrt{N}}{1+n_a}
}
$$

The local $1/K_s$ prevents the injected mass growing with the number of applicable operators.

---

# Equivalent form, and the signal-free control

Define

$$
W = \frac{\beta g_s}{1+\beta g_s} .
$$

Then $1-W = 1/(1+\beta g_s)$, and the additive prior rewrites exactly as

$$
P_+(a) = (1-W)\,P_0(a) + W\,q(a),
\qquad
q(a) = \frac{x_a}{K_s\, g_s} .
$$

$W$ is how much prior mass is redistributed. $q$ is who receives it. Both sum to one.

The signal-free control replaces both:

$$
\operatorname{prior}(a) = (1-w)\,P(a) + w\,u(a),
\qquad
u(a) = \frac{1}{K_s},
$$

with $w$ a fixed constant, swept. This is `--signal constant --const_w w`. No IQN is loaded.

Setting $w$ to the measured median of $W$ makes the two arms move the same mass, so only $q$ vs $u$ differs.

Measured $W$ at $\beta=1,\ \tau=1$: 0.26 grid, 0.27 goldminer, 0.28 logistics (means).

If all $x_a$ are equal then $x_a = g_s$, so $q = u$ and $P_+$ collapses onto the control.

---

# Implementation notes

Where the code differs from the equations above, or resolves something they leave open.

- **Exploration term is $\sqrt{N}$, not $\sqrt{N+1}$**, with $N = \max(1, \text{visits}(s))$.
- **$Q_{\mathrm{norm}}$ is 0 on unvisited edges** (pessimistic FPU), otherwise a running min-max normalisation of the child value.
- **$\gamma = 0.999$**, not 1, matching every other probe script in the repo.
- **Applied once, at expansion.** `node.prior` is overwritten with $P_+$ or $P_\times$; $c(s)$ is stored as a per-node multiplier on the exploration term. Selection itself is unchanged.
- **Dead-end children are skipped.** If $Z(s',\cdot)$ has no applicable actions, no $e_a$ is computed and that action takes $x_a = 0$ — never boosted, never penalised.
- **$K_s$ counts all applicable actions**, including any whose $e_a$ was skipped. So skipped actions lower $g_s$.
- **A node with fewer than two residuals is left untouched.**
- **Successor curves are batched and cached.** One forward for the parent, then a single
  batched forward for the successors not already in the cache. Only the rows tied for the
  highest mean are kept (~400 bytes per state instead of ~116 KB), which is all
  $w_1.\min()$ needs. Dead ends are cached as such. The cache is safe because $Z$ depends
  only on $(s, g)$ and the model is frozen for the run. Measured on `sext_abs_t1b1k1`:
  124,326 evaluations for 78,709 unique states, i.e. 1.58x rather than the 2x you get
  without it (each state is otherwise evaluated once as a successor and once as a parent).

## Controls

- `--sib_shuffle` — permute the $e_a$ among siblings. Preserves $g_s$ and the within-state spread; destroys only the per-action placement.
- `--sib_random lognormal:$\sigma$:$\mu$` — redraw each $e_a$ from a fitted marginal. Destroys the per-state structure too. $\sigma$ and $\mu$ are fitted per domain to the real $e$ marginal; reusing another domain's values mismatches the magnitude.
- `--signal constant --const_w w` — the signal-free control above.

## Defaults

```text
tau_step = 1.0
kappa    = 1.0
beta     = 1.0
eps_p    = 0.001
c_puct   = 1.5
```

At $\epsilon_p = 0.001$ the multiplicative variant barely moves the prior, because the SAC
policy is saturated. It is not inert: where $P(a)$ is exactly 0 the floor lifts it to
$\epsilon_p/K_s$, which changes the action from unselectable to selectable. Raising
$\epsilon_p$ to the flattening weight makes $P_0$ identical to the control's prior, leaving
the tilt as the only difference.
