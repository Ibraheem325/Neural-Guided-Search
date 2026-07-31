"""Is the SAC POLICY PRIOR the search bottleneck on multi-location logistics?

For every probe, walk its OPTIMAL plan. At each state on that path we know the
optimal action a*. We ask what the prior does with it:

    rank(a*)      1 = policy's top choice (ideal).  Search follows the prior, so a
                  routinely low-ranked a* means pUCT is steered away from the optimal path.
    P(a*)         the prior mass on the optimal action.
    P_max         the prior mass on the policy's favourite action.

Compared across topologies: c2s1 (the policy's training distribution) vs
multi-location c3s3/c4s2/c4s3 (never seen).
"""
import glob, os, re, csv, io, statistics as st, torch, pymimir as mm, pymimir_rgnn as rgnn
from pathlib import Path
from collections import defaultdict
from utils import create_device
import alphaZero_bellman as AZ

dev = create_device(False)
canon = lambda x: str(x).lower().replace(" ", "")

SETS = [("multi-loc", "example/probeLog_multiloc_d5-20"),
        ("c2s1 t3",   "example/probeLog_stratified_d5-20")]

pol_raw, _ = rgnn.RelationalGraphNeuralNetwork.load(
    mm.Domain("example/probeLog_multiloc_d5-20/domain.pddl"),
    Path("models/logistics_sac_policy.pth"), dev)
policy = AZ.ModelWrapper(pol_raw, "policy")

@torch.no_grad()
def probe(dom, pf, plan):
    prob = mm.Problem(dom, pf); s = prob.get_initial_state(); g = prob.get_goal_condition()
    out = []
    for line in plan:
        logits, acts = policy.forward([(s, g)])[0]
        if len(acts) == 0: break
        p = torch.softmax(logits, dim=0)
        idx = next((i for i, a in enumerate(acts) if canon(a) == canon(line)), None)
        if idx is None: break
        order = torch.argsort(p, descending=True)
        rank = int((order == idx).nonzero()[0, 0]) + 1
        out.append((rank, p[idx].item(), p.max().item(), len(acts)))
        s = acts[idx].apply(s)
    return out

for name, P in SETS:
    dom = mm.Domain(P + "/domain.pddl")
    files = sorted(f for f in glob.glob(P + "/*.pddl") if "domain" not in os.path.basename(f))
    if "stratified" in P:
        files = [f for f in files if "_t3_" in f]
    files = files[::max(1, len(files)//60)][:60]
    R = []
    for pf in files:
        if not os.path.exists(pf + ".plan"): continue
        plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
        R += probe(dom, pf, plan)
    if not R: continue
    ranks = [r[0] for r in R]; pa = [r[1] for r in R]; pm = [r[2] for r in R]; na = [r[3] for r in R]
    print(f"--- {name} --- {len(files)} probes, {len(R)} on-path states")
    print(f"    applicable actions   median {st.median(na):.0f}")
    print(f"    rank of optimal a*   median {st.median(ranks):.0f}   "
          f"top-1 {100*sum(1 for r in ranks if r==1)/len(ranks):.0f}%   "
          f"top-3 {100*sum(1 for r in ranks if r<=3)/len(ranks):.0f}%   "
          f"top-5 {100*sum(1 for r in ranks if r<=5)/len(ranks):.0f}%")
    print(f"    P(a*)   median {st.median(pa):.4f}     P_max median {st.median(pm):.4f}"
          f"     P(a*)/P_max median {st.median([a/b for a,b in zip(pa,pm)]):.3f}")
    print(f"    P(a*) == 0 exactly: {100*sum(1 for x in pa if x==0.0)/len(pa):.1f}%")
    print()
