"""
Is the QR-DQN value->true-distance mapping INSTANCE-SIZE INVARIANT? (July 2026)

A value-based decompression (fit true_distance = f(value) on enumerable instances, apply
by value on big instances) generalizes ONLY IF a state's value predicts its true distance
independent of instance size. This tests that: sample states at EXACT distances from
enumerable instances, tag each by its instance's d_max (a size proxy), and compare the
value-at-distance curve across SMALL vs LARGE instances.

  same curve  -> mapping is instance-invariant -> a fit extrapolates to big instances.
  curve shifts with size -> a fit on small instances will NOT generalize; approach doomed.

Cheap: QR-DQN value only (no ensemble, no search). Enumeration is the cost -> raise
--max_states for deeper instances; run on cluster if slow.

Usage:
  venv/bin/python value_distance_invariance.py --max_instances 120 --max_states 2000000 \
      --out results/value_distance_invariance.jsonl
"""
import argparse, glob, json, random, statistics
from pathlib import Path
import torch, pymimir as mm, pymimir_rgnn as rgnn
from utils import create_device
from train_iqn import _load_model as _load_iqn
from bellman_epsilon_label import iqn_curves


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain", default="example/grid_dataset/domain.pddl")
    ap.add_argument("--inst_glob", default="example/grid_dataset/*/*.pddl")
    ap.add_argument("--qrdqn", default="models/grid_iqn_qrdqn_best.pth")
    ap.add_argument("--max_instances", default=120, type=int)
    ap.add_argument("--max_states", default=2000000, type=int)
    ap.add_argument("--per_d", default=3, type=int, help="states sampled per (instance, distance)")
    ap.add_argument("--seed", default=0, type=int)
    ap.add_argument("--out", default="results/value_distance_invariance.jsonl")
    a = ap.parse_args()

    dev = create_device(False)
    domain = mm.Domain(a.domain)
    taus = torch.linspace(0.01, 0.99, 99, device=dev).unsqueeze(0)
    qr, _, _ = _load_iqn(domain, Path(a.qrdqn), dev); qr.eval()

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
            if ss is None or ss.max_steps_to_goal() < 4:
                continue
            ss.set_seed(a.seed)
            dmax = ss.max_steps_to_goal()
            g = mm.Problem(domain, f).get_goal_condition()
            for d in range(1, dmax + 1):
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
                    v = qs.mean(1).max().item()
                    rec.append({"dmax": dmax, "dist": lab.steps_to_goal, "value": v})
            used += 1
            if used % 10 == 0:
                print(f"  {used} instances, {len(rec)} states", flush=True)

    Path(a.out).parent.mkdir(parents=True, exist_ok=True)
    with open(a.out, "w") as fh:
        for r in rec:
            fh.write(json.dumps(r) + "\n")
    print(f"\n{len(rec)} states from {used} instances. Dumped to {a.out}.")

    # SMALL = instances with d_max < 15 ; LARGE = d_max >= 25
    small = [r for r in rec if r["dmax"] < 15]
    large = [r for r in rec if r["dmax"] >= 25]
    print(f"\nmean QR-DQN value at each TRUE distance, SMALL (d_max<15) vs LARGE (d_max>=25) instances.")
    print(f"same curve => value<->distance is instance-invariant => a value-based fit generalizes.\n")
    print(f"{'true d':>7}{'small V (n)':>16}{'large V (n)':>16}")
    for d in range(1, 41):
        sg = [r["value"] for r in small if r["dist"] == d]
        lg = [r["value"] for r in large if r["dist"] == d]
        if len(sg) < 3 and len(lg) < 3:
            continue
        ss_ = f"{statistics.mean(sg):.1f} ({len(sg)})" if len(sg) >= 3 else f"- ({len(sg)})"
        ls_ = f"{statistics.mean(lg):.1f} ({len(lg)})" if len(lg) >= 3 else f"- ({len(lg)})"
        print(f"{d:>7}{ss_:>16}{ls_:>16}")
    print("\nCompare the overlapping-distance rows: if small V ~ large V at the same d, INVARIANT.")


if __name__ == "__main__":
    main()
