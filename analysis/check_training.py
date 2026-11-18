"""Did a training run actually converge? Reads train_sac.py / train_iqn.py stdout logs.

Both scripts print the same skeleton:
    [ep] > Train step: <loss> avg. loss.
    [ep] Best: <True|False>, Evaluation: [<a>, <b>]
    [ep] Saved new best model
and SAC additionally:
    [ep] > SAC: actor=.. q1=.. q2=.. entropy=.. alpha=.. target_scale=..

What this checks, and why each matters:
  finished        did the log stop mid-episode (killed / OOM / timeout)?
  loss trend      mean loss over the first vs last 10% of episodes. Flat or rising = not
                  learning. NaN/inf anywhere = diverged, model is garbage regardless of
                  what the evaluation says.
  evaluation      the number the checkpointer actually selects on. Flat at 0 for the whole
                  run means the model never solved anything on validation -- a run can have
                  a beautifully falling loss and still be useless, which is the failure
                  mode worth catching.
  last best       episode of the final 'Saved new best model'. If that is early and the run
                  continued for hundreds of episodes, the tail was wasted and the saved
                  checkpoint is old.
  SAC alpha       entropy coefficient. Collapsing to ~0 means the policy went deterministic
                  early (this is exactly how a confidently-wrong prior is produced);
                  exploding means the entropy target is mis-scaled.

Usage: venv/bin/python check_training.py <log-or-dir> [<log-or-dir> ...]
"""
import re, sys, os, glob, math, statistics as st

paths = []
for a in sys.argv[1:]:
    if os.path.isdir(a):
        paths += sorted(glob.glob(os.path.join(a, "*.out")) + glob.glob(os.path.join(a, "*.log")))
    else:
        paths += sorted(glob.glob(a))
if not paths:
    sys.exit("usage: check_training.py <log-or-dir> [...]   (no matching files)")

RE_LOSS = re.compile(r"^\[(\d+)\] > Train step: ([-\d.naif]+) avg\. loss\.", re.I)
RE_EVAL = re.compile(r"^\[(\d+)\] Best: (\w+), Evaluation: \[([^\]]*)\]")
RE_BEST = re.compile(r"^\[(\d+)\] Saved new best model")
RE_SAC = re.compile(r"^\[(\d+)\] > SAC: actor=(\S+) q1=(\S+) q2=(\S+) entropy=(\S+) alpha=(\S+)")


def num(s):
    try:
        return float(s)
    except ValueError:
        return float("nan")


for p in paths:
    ep_loss, evals, bests, alphas, sac_last = {}, [], [], {}, None
    bad = 0
    last_line = ""
    with open(p, errors="ignore") as fh:
        for line in fh:
            last_line = line.rstrip() or last_line
            m = RE_LOSS.match(line)
            if m:
                v = num(m.group(2))
                if math.isnan(v) or math.isinf(v):
                    bad += 1
                else:
                    ep_loss.setdefault(int(m.group(1)), []).append(v)
                continue
            m = RE_EVAL.match(line)
            if m:
                vals = [num(x) for x in m.group(3).split(",") if x.strip()]
                evals.append((int(m.group(1)), m.group(2) == "True", vals))
                continue
            m = RE_BEST.match(line)
            if m:
                bests.append(int(m.group(1)))
                continue
            m = RE_SAC.match(line)
            if m:
                alphas.setdefault(int(m.group(1)), []).append(num(m.group(6)))
                sac_last = m.groups()

    name = os.path.basename(p)
    print(f"\n{'='*72}\n{name}   ({sum(len(v) for v in ep_loss.values())} train steps, "
          f"{len(evals)} evaluations)\n{'='*72}")
    if not ep_loss and not evals:
        print("  no recognisable training output -- wrong file, or the run died at startup")
        print(f"  last line: {last_line[:160]}")
        continue

    kind = "SAC" if alphas else "QR-DQN / IQN"
    eps = sorted(ep_loss)
    per_ep = {e: st.mean(v) for e, v in ep_loss.items()}
    print(f"  type            {kind}")
    print(f"  episodes        {eps[0]}..{eps[-1]}  ({len(eps)} with train steps)")

    # --- loss trend
    if len(eps) >= 10:
        k = max(1, len(eps) // 10)
        a = st.mean([per_ep[e] for e in eps[:k]])
        b = st.mean([per_ep[e] for e in eps[-k:]])
        arrow = "falling" if b < a * 0.95 else ("FLAT" if b < a * 1.05 else "RISING")
        print(f"  loss            first10% {a:.4f} -> last10% {b:.4f}   [{arrow}]")
    else:
        print(f"  loss            too few episodes to trend ({len(eps)})")
    if bad:
        print(f"  !! NaN/inf loss on {bad} train steps -- DIVERGED")

    # --- evaluation
    if evals:
        series = [(e, v) for e, _, v in evals if v]
        if series:
            first, last = series[0][1], series[-1][1]
            width = len(last)
            bestv = [max(v[i] for _, v in series) for i in range(width)]
            print(f"  evaluation      first {first}  last {last}  best-seen {bestv}")
            flat0 = all(all(x == 0 for x in v) for _, v in series)
            if flat0:
                print("  !! evaluation is 0 for EVERY episode -- the model never solved a "
                      "validation instance.\n     A falling loss here means it learned to "
                      "predict its own targets, not to plan.")
        nbest = sum(1 for _, b, _ in evals if b)
        print(f"  'Best' flagged  {nbest}/{len(evals)} evaluations")
    if bests:
        print(f"  saved best      {len(bests)}x, last at episode {bests[-1]} "
              f"(run reached {eps[-1] if eps else '?'})")
        if eps and bests[-1] < 0.5 * eps[-1]:
            print(f"  !! last checkpoint saved in the first half -- the tail of the run "
                  f"({eps[-1]-bests[-1]} episodes) produced nothing better")
    else:
        print("  saved best      NEVER -- no checkpoint was ever written")

    # --- SAC specifics
    if alphas:
        ae = sorted(alphas)
        a0 = st.mean(alphas[ae[0]]); a1 = st.mean(alphas[ae[-1]])
        print(f"  SAC alpha       {a0:.5f} -> {a1:.5f}")
        if a1 < 0.01:
            print("  !! alpha collapsed to ~0 -- policy went deterministic; this is how an "
                  "over-confident\n     prior gets produced (see the goldminer P_max=0.94 "
                  "finding)")
        if sac_last:
            print(f"  SAC last        actor={sac_last[1]} q1={sac_last[2]} q2={sac_last[3]} "
                  f"entropy={sac_last[4]}")

    # --- did it finish cleanly
    tail = last_line[:120]
    print(f"  last log line   {tail}")
