"""
Does RAW WIDTH still track uncertainty PAST d=22?  (July 2026)

Search doesn't visit d>~25 states (it descends toward the goal), so to get exact distances
out there we SAMPLE states at each exact distance from deep enumerable instances (via
StateSpaceSampler.sample_states_n_steps_from_goal). For each state: raw width = q90-q10 of
the QR-DQN's best-action distribution; uncertainty label = std over 5 independent SAC
critics. AUC(raw width -> disagreement) at each EXACT distance.

CAVEAT: sampled states, NOT the search-visited distribution (which is unreachable that far
out). This answers "does width track uncertainty at large distance in general", not "on the
search tree". Deep instances need large state spaces -> raise --max_states; run on cluster.

Usage (cluster):
  venv/bin/python deep_width_auc.py --min_dmax 28 --max_states 3000000 \
      --max_instances 60 --out results/deep_width_auc.jsonl
"""
import argparse, glob, json, random, statistics
from pathlib import Path
import torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
import alphaZero_bellman as AZ
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves, rank_auc


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain", default="example/grid_dataset/domain.pddl")
    ap.add_argument("--inst_glob", default="example/grid_dataset/*/*.pddl")
    ap.add_argument("--qrdqn", default="models/grid_iqn_qrdqn_best.pth")
    ap.add_argument("--ens_prefix", default="models/grid_sac_ens_")
    ap.add_argument("--ens_n", default=5, type=int)
    ap.add_argument("--min_dmax", default=28, type=int)
    ap.add_argument("--max_states", default=3000000, type=int)
    ap.add_argument("--max_instances", default=60, type=int)
    ap.add_argument("--per_d", default=4, type=int)
    ap.add_argument("--seed", default=0, type=int)
    ap.add_argument("--out", default="results/deep_width_auc.jsonl")
    a = ap.parse_args()

    dev = create_device(False)
    domain = mm.Domain(a.domain)
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
    qr, _, _ = _load_iqn(domain, Path(a.qrdqn), dev); qr.eval()
    ens = []
    for i in range(1, a.ens_n + 1):
        e1 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"{a.ens_prefix}{i}_q1_best.pth"), dev)[0], "q")
        e2 = AZ.ModelWrapper(rgnn.RelationalGraphNeuralNetwork.load(domain, Path(f"{a.ens_prefix}{i}_q2_best.pth"), dev)[0], "q")
        ens.append((e1, e2))

    def disagree(s, g):
        vs = []
        for q1, q2 in ens:
            v1, ac = q1.forward([(s, g)])[0]
            if len(ac) == 0:
                return None
            v2, _ = q2.forward([(s, g)])[0]
            vs.append(torch.minimum(v1, v2).max().item())
        return statistics.pstdev(vs)

    files = sorted(f for f in glob.glob(a.inst_glob) if "domain" not in f)
    random.Random(a.seed).shuffle(files)
    rec = []; used = 0
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
            ss.set_seed(a.seed)
            g = mm.Problem(domain, f).get_goal_condition()
            for d in range(10, ss.max_steps_to_goal() + 1):
                try:
                    sts = list(ss.sample_states_n_steps_from_goal(d, a.per_d))
                except Exception:
                    continue
                for s in sts:
                    lab = ss.get_state_label(s)
                    if lab.is_goal or lab.is_dead_end:
                        continue
                    qs, acts = iqn_curves(qr, s, g, taus)
                    if qs is None or not acts:
                        continue
                    ai = int(qs.mean(1).argmax()); curve = qs[ai]
                    width = (curve[89] - curve[9]).item()
                    dv = disagree(s, g)
                    if dv is not None:
                        rec.append({"dist": lab.steps_to_goal, "width": width, "disagree": dv})
            used += 1
            print(f"  {used} instances (d_max {ss.max_steps_to_goal()}), {len(rec)} states", flush=True)

    Path(a.out).parent.mkdir(parents=True, exist_ok=True)
    with open(a.out, "w") as fh:
        for r in rec:
            fh.write(json.dumps(r) + "\n")
    print(f"\n{len(rec)} sampled states, {used} instances. Dumped to {a.out}.")

    print("\nAUC(raw width -> ensemble disagreement) by TRUE distance. 0.5 = no signal.")
    print(f"{'true dist':>12}{'n':>7}{'width AUC':>11}{'disagree CV':>13}{'width CV':>10}")
    for lo, hi in [(10, 15), (15, 20), (20, 25), (25, 30), (30, 35), (35, 45)]:
        g = [r for r in rec if lo <= r["dist"] < hi]
        if len(g) < 30:
            print(f"{f'{lo}-{hi}':>12}{len(g):>7}{'(<30)':>11}")
            continue
        s = sorted(r["width"] for r in g); loq, hiq = s[len(s)//3], s[2*len(s)//3]
        hi_d = [r["disagree"] for r in g if r["width"] >= hiq]
        lo_d = [r["disagree"] for r in g if r["width"] <= loq]
        auc = rank_auc(hi_d, lo_d) if len(hi_d) > 5 and len(lo_d) > 5 else None
        dis = [r["disagree"] for r in g]; wid = [r["width"] for r in g]
        dcv = statistics.pstdev(dis) / (abs(statistics.mean(dis)) + 1e-9)
        wcv = statistics.pstdev(wid) / (abs(statistics.mean(wid)) + 1e-9)
        print(f"{f'{lo}-{hi}':>12}{len(g):>7}{(f'{auc:.3f}' if auc else '-'):>11}{dcv:>13.3f}{wcv:>10.3f}")


if __name__ == "__main__":
    main()
