"""
How does the QR-DQN uncertainty signal behave on SEARCH-VISITED states at each TRUE
distance to goal?  (July 2026)

The prior offline/online tests binned by the -QRDQN value PROXY (circular: the proxy is
the signal). This uses ENUMERABLE instances so every search-visited node gets an EXACT
distance from the state space. Runs a BASELINE AlphaZero search (no modulation, so the
state distribution is the search's own), and per expanded node logs
(exact_distance, cv, width, ensemble_disagreement). Then AUC(signal -> disagreement) by
TRUE distance band tells us where, if anywhere, the width/cv signal actually tracks
uncertainty on the states search visits.

Cluster-friendly: enumerates + searches many instances; ~10 ensemble forwards/node so it is
slow -> run on the cluster. Prints the table and dumps raw records to --out (jsonl).

Usage (cluster):
  venv/bin/python qrdqn_search_signal.py --max_instances 60 --max_states 600000 \
      --sims 400 --out results/qrdqn_search_signal.jsonl
"""
import argparse, glob, json, random, statistics
from pathlib import Path
import torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import rank_auc


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain", default="example/grid_dataset/domain.pddl")
    ap.add_argument("--inst_glob", default="example/grid_dataset/*/*.pddl")
    ap.add_argument("--qrdqn", default="models/grid_iqn_qrdqn_best.pth")
    ap.add_argument("--policy", default="models/grid_sac_policy.pth")
    ap.add_argument("--q1", default="models/grid_sac_q1.pth")
    ap.add_argument("--q2", default="models/grid_sac_q2.pth")
    ap.add_argument("--ens_prefix", default="models/grid_sac_ens_")
    ap.add_argument("--ens_n", default=5, type=int)
    ap.add_argument("--max_instances", default=60, type=int)
    ap.add_argument("--max_states", default=600000, type=int)
    ap.add_argument("--min_dmax", default=8, type=int, help="only instances reaching >= this distance")
    ap.add_argument("--sims", default=400, type=int)
    ap.add_argument("--seed", default=0, type=int)
    ap.add_argument("--out", default="results/qrdqn_search_signal.jsonl")
    a = ap.parse_args()

    dev = create_device(False)
    domain = mm.Domain(a.domain)
    qr, _, _ = _load_iqn(domain, Path(a.qrdqn), dev); qr.eval()
    policy = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(a.policy), dev)[0], "policy")
    q1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(a.q1), dev)[0], "q")
    q2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(a.q2), dev)[0], "q")
    ens = []
    for i in range(1, a.ens_n + 1):
        e1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"{a.ens_prefix}{i}_q1_best.pth"), dev)[0], "q")
        e2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"{a.ens_prefix}{i}_q2_best.pth"), dev)[0], "q")
        ens.append((e1, e2))

    AZ._SIG.iqn = qr
    AZ._SIG.taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
    AZ._SIG.diag_ens = ens
    AZ._SIG.signal_diag = True
    # baseline search: no modulation
    AZ._SIG.width_beta = 0.0
    AZ._SIG.ens_beta = 0.0

    class A: pass
    args = A(); args.max_simulations = a.sims; args.max_time = None
    args.c_puct = 1.5; args.dead_end_value = -1000.0; args.keep_searching = False

    files = sorted(f for f in glob.glob(a.inst_glob) if "domain" not in f)
    random.Random(a.seed).shuffle(files)
    used = 0
    with torch.no_grad():
        for f in files:
            if used >= a.max_instances:
                break
            try:
                ss = mm.StateSpaceSampler.new(mm.Problem(domain, f), a.max_states)
            except Exception:
                continue
            if ss is None or ss.max_steps_to_goal() < a.min_dmax:
                continue

            def dist_fn(state, _ss=ss):
                lab = _ss.get_state_label(state)
                if lab.is_goal or lab.is_dead_end:
                    return None
                return lab.steps_to_goal

            AZ._SIG.dist_fn = dist_fn
            AZ._plan(mm.Problem(domain, f), policy, q1, q2, args)
            used += 1
            print(f"  [{used}] {Path(f).name[:40]:40} d_max={ss.max_steps_to_goal()} "
                  f"records={len(AZ._SIG.sig_records)}", flush=True)

    rec = AZ._SIG.sig_records
    Path(a.out).parent.mkdir(parents=True, exist_ok=True)
    with open(a.out, "w") as fh:
        for d, cv, w, dis in rec:
            fh.write(json.dumps({"dist": d, "cv": cv, "width": w, "disagree": dis}) + "\n")
    print(f"\n{len(rec)} search-visited nodes with EXACT distance, {used} instances. Dumped to {a.out}.")

    def auc_band(rows, sidx):
        if len(rows) < 30:
            return None, len(rows)
        s = sorted(r[sidx] for r in rows); loq, hiq = s[len(s)//3], s[2*len(s)//3]
        hi_d = [r[3] for r in rows if r[sidx] >= hiq]; lo_d = [r[3] for r in rows if r[sidx] <= loq]
        if len(hi_d) < 6 or len(lo_d) < 6:
            return None, len(rows)
        return rank_auc(hi_d, lo_d), len(rows)

    print("\nAUC(signal -> ensemble disagreement) by TRUE distance. 0.5 = no signal.")
    print(f"{'true dist':>12}{'n':>7}{'cv AUC':>9}{'width AUC':>11}{'disagree CV':>13}")
    bands = [(1, 5), (5, 10), (10, 15), (15, 20), (20, 30), (30, 100)]
    for lo, hi in bands:
        g = [r for r in rec if lo <= r[0] < hi]
        (ac, _), (aw, _) = auc_band(g, 1), auc_band(g, 2)
        if len(g) < 30:
            continue
        dis = [r[3] for r in g]
        dcv = statistics.pstdev(dis) / (abs(statistics.mean(dis)) + 1e-9)
        acs = f"{ac:.3f}" if ac is not None else "-"
        aws = f"{aw:.3f}" if aw is not None else "-"
        print(f"{f'{lo}-{hi}':>12}{len(g):>7}{acs:>9}{aws:>11}{dcv:>13.3f}")


if __name__ == "__main__":
    main()
