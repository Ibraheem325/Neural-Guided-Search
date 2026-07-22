"""
Aggregate results/qrdqn_search_signal.jsonl: AUC(signal -> ensemble disagreement) by TRUE
distance on search-visited states. Pure CPU (no models). (July 2026)

Each record: {"dist": int, "cv": float, "width": float, "disagree": float}.
AUC = P(disagreement higher at HIGH-signal than LOW-signal node), tercile split, per band.
'disagree CV' = dynamic range of the LABEL at that distance (if it collapses, AUC untrustworthy).
"""
import argparse, json, statistics
from bellman_epsilon_label import rank_auc


def auc_band(rows, key):
    if len(rows) < 30:
        return None
    s = sorted(r[key] for r in rows); loq, hiq = s[len(s)//3], s[2*len(s)//3]
    hi_d = [r["disagree"] for r in rows if r[key] >= hiq]
    lo_d = [r["disagree"] for r in rows if r[key] <= loq]
    if len(hi_d) < 6 or len(lo_d) < 6:
        return None
    return rank_auc(hi_d, lo_d)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", default="results/qrdqn_search_signal.jsonl")
    ap.add_argument("--bins", default="1,5,10,15,20,25,30,100",
                    help="comma-separated true-distance bin edges")
    a = ap.parse_args()
    rec = [json.loads(l) for l in open(a.file) if l.strip()]
    print(f"{len(rec)} search-visited nodes with exact distance.")
    print(f"distance range {min(r['dist'] for r in rec)}..{max(r['dist'] for r in rec)}\n")
    edges = [int(x) for x in a.bins.split(",")]
    bands = list(zip(edges[:-1], edges[1:]))
    print("AUC(signal -> ensemble disagreement) by TRUE distance. 0.5 = no signal.")
    print(f"{'true dist':>12}{'n':>7}{'cv AUC':>9}{'width AUC':>11}{'disagree CV':>13}{'width CV':>11}")
    for lo, hi in bands:
        g = [r for r in rec if lo <= r["dist"] < hi]
        if len(g) < 30:
            print(f"{f'{lo}-{hi}':>12}{len(g):>7}{'(<30)':>9}")
            continue
        ac, aw = auc_band(g, "cv"), auc_band(g, "width")
        dis = [r["disagree"] for r in g]; wid = [r["width"] for r in g]
        dcv = statistics.pstdev(dis) / (abs(statistics.mean(dis)) + 1e-9)
        wcv = statistics.pstdev(wid) / (abs(statistics.mean(wid)) + 1e-9)
        acs = f"{ac:.3f}" if ac is not None else "-"
        aws = f"{aw:.3f}" if aw is not None else "-"
        print(f"{f'{lo}-{hi}':>12}{len(g):>7}{acs:>9}{aws:>11}{dcv:>13.3f}{wcv:>11.3f}")


if __name__ == "__main__":
    main()
