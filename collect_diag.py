"""Aggregate run_diag_select.sh output: is DeltaU large enough to influence selection?

    score(a) = q_norm(a) + c_puct * explore_mult * P(a) * sqrt(N) / (1 + n_a)
    DeltaQ = max_{a,b} |q_norm(a) - q_norm(b)|     DeltaU = max_{a,b} |u(a) - u(b)|

The prior enters only through u, so DeltaU/DeltaQ is the prior's capacity to change the
decision. The criterion is DeltaU ~ DeltaQ; well below 1 means the prior cannot influence
selection whatever information it holds, and then a null result for the signal is
uninformative rather than negative.

Reports, over every probe in the directory:

  ratio          per-probe median DeltaU/DeltaQ, then the median and IQR ACROSS probes.
                 Probe-level medians first, so one long search cannot dominate.
  implied c_puct the c_puct that would bring the median ratio to 1.0, = c_puct / ratio.
                 This is the number to test, not just report.
  q flat         share of decisions where DeltaQ = 0. There the value function
                 discriminates nothing and the prior is the sole tiebreaker REGARDLESS of
                 how small DeltaU is -- a case the DeltaU ~ DeltaQ framing does not cover.
  prior alone    share where every sibling is unvisited, so all q_norm are 0.

Usage: venv/bin/python collect_diag.py <dir> [<dir> ...]
   e.g. venv/bin/python collect_diag.py results/diag_gold results/diag_sat
"""
import re, sys, glob, os, statistics as st

PAT = {
    "n":        re.compile(r"\[Select\] decisions (\d+)"),
    "dq":       re.compile(r"\[Select\] mean spread\s+q_norm ([\d.]+)\s+u ([\d.]+)"),
    "ratio":    re.compile(r"\[Select\] spread ratio u/q\s+median ([\d.]+)"),
    "uwin":     re.compile(r"u spread exceeds q spread on ([\d.]+)%"),
    "unvis":    re.compile(r"all siblings unvisited .* on ([\d.]+)%"),
    "qflat":    re.compile(r"q_norm identical across siblings .* on ([\d.]+)%"),
    "cpuct":    re.compile(r"c_puct[= ]([\d.]+)"),
    "expanded": re.compile(r"\[Final\] Expanded: (\d+)"),
}

if len(sys.argv) < 2:
    raise SystemExit(__doc__)

for d in sys.argv[1:]:
    rows = []
    for f in sorted(glob.glob(os.path.join(d, "*.out"))):
        s = open(f, errors="ignore").read()
        m_n, m_r = PAT["n"].search(s), PAT["ratio"].search(s)
        if not (m_n and m_r):
            continue                      # search never reported: crashed or no decisions
        m_dq = PAT["dq"].search(s)
        rows.append(dict(
            name=os.path.basename(f)[:-4],
            n=int(m_n.group(1)),
            ratio=float(m_r.group(1)),
            dq=float(m_dq.group(1)) if m_dq else None,
            du=float(m_dq.group(2)) if m_dq else None,
            uwin=float(PAT["uwin"].search(s).group(1)) if PAT["uwin"].search(s) else None,
            unvis=float(PAT["unvis"].search(s).group(1)) if PAT["unvis"].search(s) else None,
            qflat=float(PAT["qflat"].search(s).group(1)) if PAT["qflat"].search(s) else None,
            exp=int(PAT["expanded"].search(s).group(1)) if PAT["expanded"].search(s) else None,
        ))

    total = len(glob.glob(os.path.join(d, "*.out")))
    print(f"### {d}   {len(rows)}/{total} probes reported")
    if not rows:
        print("   nothing to aggregate -- check the .out files for errors\n")
        continue

    rs = sorted(r["ratio"] for r in rows)
    med = st.median(rs)
    q = st.quantiles(rs, n=4) if len(rs) >= 4 else [float("nan")] * 3
    dec = sum(r["n"] for r in rows)
    print(f"  decisions total            {dec:,}   (per probe: median "
          f"{st.median(r['n'] for r in rows):,.0f})")
    print(f"  DeltaU/DeltaQ  median      {med:.3f}   "
          f"p25 {q[0]:.3f}  p75 {q[2]:.3f}   min {rs[0]:.3f}  max {rs[-1]:.3f}")
    print(f"  probes with ratio >= 1.0   {sum(1 for r in rs if r >= 1.0)}/{len(rs)}")
    if med > 0:
        print(f"  -> c_puct for DeltaU ~ DeltaQ: 1.5 / {med:.3f} = {1.5/med:.2f}"
              f"   (assumes u scales linearly in c_puct, which it does)")
    for k, lab in (("qflat", "DeltaQ = 0, prior is sole tiebreak"),
                   ("unvis", "all siblings unvisited"),
                   ("uwin",  "DeltaU > DeltaQ")):
        vals = [r[k] for r in rows if r[k] is not None]
        if vals:
            print(f"  {lab:36} median {st.median(vals):5.1f}% of decisions")
    exps = [r["exp"] for r in rows if r["exp"] is not None]
    if exps:
        print(f"  states generated per probe   median {st.median(exps):,.0f}"
              f"   (NOTE: alphaZero prints this as 'Expanded' but it counts GENERATED"
              f" states -- one expansion emits K children)")
    print()
