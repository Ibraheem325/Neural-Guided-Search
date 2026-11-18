# Beyond Greedy Execution: Neural-Guided Search in Classical Planning

Code, trained models and datasets for my Bachelor's thesis at the
Chair of Machine Learning and Reasoning, RWTH Aachen University
(supervised by Dr. Simon Ståhlberg, examined by Prof. Hector Geffner and Prof. Christopher Morris).

📄 **Thesis:** [`thesis.pdf`](thesis.pdf)

---

## In short

Learned value functions and policies (here: relational graph neural networks) can solve
classical-planning problems by **greedily** following their predictions. But they are imperfect,
especially on instances larger than the ones they were trained on. A greedy executor cannot tell
when its guidance has gone wrong, and it has no way to recover.

This thesis asks two questions:

1. **Which search algorithm best compensates for imperfect learned guidance?** I benchmark A\*,
   Weighted A\*, GBFS, Beam Search, Q\*, Weighted Q\* and AlphaZero-style MCTS on six domains
   (Barman, Grid, Logistics, Rovers, Satellite, Goldminer). Each algorithm is compared with greedy
   execution of the model that guides it.
2. **Can the strongest search, AlphaZero-style MCTS, be improved?** First by flattening its policy
   prior, and then by redistributing the prior towards actions where a distributional (QR-DQN)
   model is **least self-consistent**, as measured by its one-step Bellman residual.

### Key findings

- **Robustness to value scale decides the benchmark.** A\* and Q\* often solve *fewer* instances than
  greedy execution of the same model. Learned estimates are compressed relative to the path cost
  `g(s)`, so many states receive near-identical `f`-values. Beam Search and AlphaZero only use the
  *ordering* of estimates (min-max normalised in MCTS), and they give the strongest results.
- **AlphaZero-style MCTS is the only method that improves on its greedy baseline in both coverage
  and plan length.** For example, Satellite coverage rises from 45.8% to 74.2% and plan length drops
  from 63.4 to 23.7 on matched instances.
- **Prior flattening is strongly domain-dependent.** It lifts Goldminer from 74.6% to 100% coverage,
  but it only hurts Satellite, where the learned prior is already reliable.
- **The Bellman-residual signal carries real information in 3 of 5 domains.** The action with the
  largest residual lies on the plan 4.4× (Satellite), 2.9× (Rovers) and 2.5× (Logistics) more often
  than chance, but only 1.0× in Grid and Goldminer. Where it is informative, it beats matched
  *shuffled* and *random* controls. Satellite needs 34% of the baseline's expansions (controls: about
  63%), and Rovers needs 34% with higher coverage.
- **Its cost is the limit.** The signal needs two network calls per expansion, so it only pays off
  on searches that need few expansions. It keeps 100% coverage on unbounded Satellite, but it times
  out on long Rovers searches.

<details>
<summary>Coverage on the out-of-distribution test set (Table 5.5)</summary>

| Algorithm      | Satellite | Rovers | Logistics | Grid  | Barman | Goldminer |
|----------------|----------:|-------:|----------:|------:|-------:|----------:|
| GBFS           | 24.2%     | 14.2%  | 90.0%     | 39.8% | 10.1%  | 0.8%      |
| Beam Search    | 45.0%     | 45.8%  | 88.3%     | 64.6% | 45.9%  | **94.2%** |
| Weighted Q\*   | 38.3%     | 25.8%  | 83.3%     | **90.3%** | **50.5%** | 0.8% |
| Greedy-SAC     | 45.8%     | 42.5%  | 90.0%     | 82.3% | 0.0%   | 70.0%     |
| AlphaZero MCTS | **74.2%** | **54.2%** | **92.5%** | 89.4% | —   | 93.3%     |

With prior flattening, AlphaZero reaches 100% on Satellite, 84.2% on Rovers and 95.0% on
Logistics (Table 7.4).
</details>

---

## Repository layout

```
alphaZero_bellman.py   AlphaZero-style MCTS with prior flattening + the Bellman-inconsistency signal
                       (additive / multiplicative injection, shuffle and random controls)
utils.py               shared helpers (device, state keys, ...)
rgnn_readout_fix.py    patch for a multi-output readout bug in pymimir-rgnn (required)

benchmark/             the Chapter 5 algorithms
  search.py              A*                     wastar.py         Weighted A*
  gbfs.py                Greedy Best-First      beam.py           Beam Search (also Greedy-V at k=1)
  qstar.py               Q* / Weighted Q*       alphaZero.py      plain AlphaZero-style MCTS
  greedy_value_plan.py   greedy execution of V(s)
  greedy_q_plan.py       greedy execution of Q(s,a)
  greedy_sac_plan.py     greedy execution of the SAC policy

training/              model training (all R-GNN based)
  train_supervised.py    V(s) from optimal distances (Fast Downward labels)
  train_dqn.py           Q(s,a) via DQN
  train_sac.py           discrete Soft Actor-Critic policy + two critics
  train_iqn.py           distributional Z(s,a), trained as QR-DQN (file name is historical)

data_generation/       instance generation, Fast Downward solving/verification,
                       and the bounded-distance probe sets (Section 4.3)
analysis/              aggregation scripts that produce the thesis tables, plus model diagnostics
slurm/                 the SLURM launchers and per-domain sweeps that were run on the cluster

datasets/              PDDL datasets (train/val/test) and bounded-distance probe sets
models/                trained checkpoints (.pth)
thesis.pdf             the thesis
```

## Setup

```bash
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt      # torch, pymimir, pymimir-rgnn, pymimir-rl
```

Fast Downward is only needed to regenerate optimal plans (`data_generation/solve_dataset.py`,
`slurm/run_fd_*.sh`).

## Quick start

Run everything **from the repository root**.

```bash
D=datasets/probeGold_near_goal_d5-20
P=$D/000_d05_003_p-6x8-5.pddl

# Beam Search guided by the supervised value function
python benchmark/beam.py --domain $D/domain.pddl --problem $P \
    --model models/goldminer_supervised.pth --beam 20

# AlphaZero-style MCTS with the additive Bellman signal (QR-DQN supplies leaf values)
python alphaZero_bellman.py --domain $D/domain.pddl --problem $P \
    --policy_model models/goldminer_sac_policy.pth \
    --q1_model models/goldminer_sac_q1.pth --q2_model models/goldminer_sac_q2.pth \
    --iqn_model models/goldminer_iqn.pth --qrdqn_value \
    --abs_signal add --abs_beta 1 --abs_kappa 1 --eps_p 0.9 --max_time 1800
```

Variants of `alphaZero_bellman.py` used in Chapter 7:

| Configuration                  | Flags                                                        |
|--------------------------------|--------------------------------------------------------------|
| Baseline (learned prior)       | `--abs_signal off`                                           |
| Prior flattening with weight w | `--signal constant --const_w w`                              |
| Additive / multiplicative      | `--abs_signal add` / `--abs_signal mul`, with `--abs_beta`, `--abs_kappa`, `--eps_p` |
| Shuffle control                | add `--sib_shuffle`                                          |
| Random control                 | add `--sib_random lognormal:SIGMA:MU` (fitted by `analysis/fit_random_control.py`) |

Training example:

```bash
python training/train_supervised.py --help
python training/train_sac.py --help
```

## Models

| Domain    | V(s) / Q(s,a) (Ch. 5)              | SAC policy + critics                                   | QR-DQN Z(s,a) (Ch. 7)           |
|-----------|------------------------------------|--------------------------------------------------------|---------------------------------|
| Barman    | `barman_v2_{supervised,dqn}.pth`   | did not converge (see §4.1)                            | –                               |
| Goldminer | `goldminer_{supervised,dqn}.pth`   | `goldminer_sac_*.pth`                                  | `goldminer_iqn.pth`             |
| Grid      | `grid_{supervised,dqn}.pth`        | `grid_sac_*.pth`                                       | `grid_iqn_qrdqn_best.pth`       |
| Logistics | `logistics_{supervised,dqn}.pth`   | `logistics_sac_*.pth` (Ch. 5), `logistics_topo_sac_*_best.pth` (Ch. 7) | `logistics_topo_frozen.pth` |
| Rovers    | `rovers_{supervised,dqn}.pth`      | `rovers_sac_*.pth` (Ch. 5)                             | –                               |
| Satellite | `satellite_{supervised,dqn}.pth`   | `satellite_sac_*.pth` (Ch. 5)                          | `satellite_s18_qrdqn_best.pth`  |

The Chapter 7 Rovers models and Satellite SAC models were trained on the cluster and are not included here.

## Notes

- The `slurm/` scripts were written for the RWTH HPC cluster. Partition names are cluster-specific,
  and absolute paths are replaced with `/path/to/...` placeholders.
- Built on [`relational-neural-network-python`](https://github.com/simon-stahlberg/relational-neural-network-python)
  by Simon Ståhlberg, using [`pymimir`](https://github.com/simon-stahlberg/mimir) and
  [`pymimir-rgnn`](https://github.com/simon-stahlberg/mimir-rgnn).
  Instances come from the [AI-Planning PDDL generators](https://github.com/AI-Planning/pddl-generators).

## License

See [LICENSE](LICENSE).
