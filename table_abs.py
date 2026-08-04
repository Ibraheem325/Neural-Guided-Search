"""Per-arm table for the OPTION 9 (absolute-scale) additive arms on goldminer,
in the same format as the binc/shuffle tables, plus the prior-peakedness split.

Columns (first six identical to table_random.py):
  cov        instances solved (count)
  net%       total expansions saved vs baseline on the shared-solved set
  mean       MEAN per-instance ratio expansions(arm)/expansions(baseline)
  improved   instances with fewer expansions than baseline
  regressed  instances with more
  win prior peaked / loss prior peaked
             of the improved / regressed instances, the % whose SAC prior is peaked.
             "Peaked" = P_max >= --peak_thresh, aggregated over the states on the
             instance's optimal plan by --peak_def:
               plan_min   P_max >= thresh at EVERY plan state       (default)
               plan_mean  mean P_max over plan states
               init       P_max at the initial state only
               plan_frac  >=50% of plan states have P_max >= thresh
             NOTE the goldminer SAC prior is saturated: median P_max over plan states
             is 1.0000 and p25 is also 1.0000. So plan_mean/init at 0.7 mark 100%/78%
             of instances peaked and the split carries no information -- hence the 0.88
             default rather than 0.7.

             CALIBRATION. The default (plan_mean >= 0.88) was fitted by reproducing the
             existing binc table on the same instances. The first five columns reproduce
             it EXACTLY on all six beta rows (improved 51/65/100/125/143/161, regressed
             18/6/15/14/18/18). The peakedness columns come within ~5pp on average and
             reproduce the trend (win% rising with beta, loss% flat near 40-50%), but are
             NOT the identical definition -- the original was most likely measured over
             states expanded DURING SEARCH, which the .out files do not record. Treat the
             last two columns as approximate unless the original definition is restored.
             Note also that a search-visited definition is arm-dependent, so it is not a
             clean instance-level covariate for comparing arms.
             The peakedness cache is instance-level and arm-independent, so it is
             computed once and reused (prior_peak_goldminer.json).

Usage: venv/bin/python table_abs.py [--peak_def plan_min|plan_mean|init|plan_frac]
                                    [--peak_thresh 0.7]
"""
import sys, re, glob, os, json, argparse, statistics as st

ap = argparse.ArgumentParser()
ap.add_argument("--peak_def", default="plan_mean",
                choices=["plan_min", "plan_mean", "init", "plan_frac"])
ap.add_argument("--peak_thresh", default=0.88, type=float)
ap.add_argument("--prefix", default="results")
ap.add_argument("--probe", default="example/probeGold_near_goal_d5-20")
ap.add_argument("--policy", default="models/goldminer_sac_policy.pth")
ap.add_argument("--cache", default="prior_peak_goldminer.json")
A_ = ap.parse_args()

BASE = f"{A_.prefix}/gm_base"
# (label, dir). Rows are the arms we have; beta is the sweep axis where it exists.
# MATCHED axis: each row perturbs the selection weights as hard as the binc arm of the
# same beta_old (median TV over the 905 goldminer states). kappa=0, since binc had no
# exploration-constant channel. Label is beta_old so the two tables line up row by row.
ARMS = [("1.0 (=0.005)",  f"{A_.prefix}/gm_abs_eqb1"),
        ("2.0 (=0.035)",  f"{A_.prefix}/gm_abs_eqb2"),
        ("4.0 (=0.065)",  f"{A_.prefix}/gm_abs_eqb4"),
        ("6.0 (=0.085)",  f"{A_.prefix}/gm_abs_eqb6"),
        ("8.0 (=0.110)",  f"{A_.prefix}/gm_abs_eqb8"),
        ("12.0 (=0.150)", f"{A_.prefix}/gm_abs_eqb12")]
# The regime binc cannot reach at any beta, because mult(a)*P(a) stays gated by P.
BEYOND = [("1.0",  f"{A_.prefix}/gm_abs_t1b1k1"),
          ("2.0",  f"{A_.prefix}/gm_abs_t1b2k1"),
          ("4.0",  f"{A_.prefix}/gm_abs_t1b4k1"),
          ("6.0",  f"{A_.prefix}/gm_abs_t1b6k1"),
          ("8.0",  f"{A_.prefix}/gm_abs_t1b8k1"),
          ("12.0", f"{A_.prefix}/gm_abs_t1b12k1")]
EXTRA = [("1.0 (kappa=0, prior only)", f"{A_.prefix}/gm_abs_t1b1k0"),
         ("1.0 (beta=0, c(s) only)",   f"{A_.prefix}/gm_abs_t1b0k1"),
         ("1.0 SHUFFLE",               f"{A_.prefix}/gm_abs_t1b1k1_shuf"),
         ("1.0 RANDOM",                f"{A_.prefix}/gm_abs_t1b1k1_rndm"),
         ("w=0.28 FLATTEN",            f"{A_.prefix}/gm_flat028")]


def load(d):
    o = {}
    for f in glob.glob(d + "/*.out"):
        n = os.path.basename(f)[:-4]
        s = open(f, errors="ignore").read()
        e = re.search(r"\[Final\] Expanded: (\d+)", s)
        if e:
            o[n] = (int(e.group(1)), "Found a solution" in s)
    return o


def build_cache():
    """P_max of the SAC prior along each instance's optimal plan. Instance-level and
    arm-independent, so this runs once."""
    import torch, pymimir as mm, pymimir_rgnn as rgnn
    from pathlib import Path
    from utils import create_device
    dev = create_device(False)
    dom = mm.Domain(A_.probe + "/domain.pddl")
    pol, _ = rgnn.RelationalGraphNeuralNetwork.load(dom, Path(A_.policy), dev)
    canon = lambda x: str(x).lower().replace(" ", "")
    out = {}
    files = sorted(f for f in glob.glob(A_.probe + "/*.pddl") if "domain" not in os.path.basename(f))
    for i, pf in enumerate(files):
        name = os.path.basename(pf)[:-5]
        if not os.path.exists(pf + ".plan"):
            continue
        prob = mm.Problem(dom, pf)
        s = prob.get_initial_state(); g = prob.get_goal_condition()
        plan = [l.strip() for l in open(pf + ".plan") if l.strip().startswith("(")]
        pmax = []
        with torch.no_grad():
            for line in [None] + plan:
                if line is not None:
                    nxt = next((a for a in s.generate_applicable_actions()
                                if canon(a) == canon(line)), None)
                    if nxt is None:
                        break
                    s = nxt.apply(s)
                acts = s.generate_applicable_actions()
                if len(acts) < 2:
                    continue
                lg = pol.forward([(s, list(acts), g)]).readout("policy")[0]
                pmax.append(torch.softmax(lg, dim=0).max().item())
        if pmax:
            out[name] = pmax
        if (i + 1) % 100 == 0:
            print(f"  ...{i+1}/{len(files)}", flush=True)
    json.dump(out, open(A_.cache, "w"))
    print(f"wrote {A_.cache} ({len(out)} instances)", flush=True)
    return out


if os.path.exists(A_.cache):
    PK = json.load(open(A_.cache))
else:
    print(f"building prior-peakedness cache ({A_.cache} not found)...", flush=True)
    PK = build_cache()


def peaked(inst):
    v = PK.get(inst)
    if not v:
        return None
    if A_.peak_def == "init":
        return v[0] >= A_.peak_thresh
    if A_.peak_def == "plan_frac":
        return sum(1 for x in v if x >= A_.peak_thresh) / len(v) >= 0.5
    if A_.peak_def == "plan_mean":
        return st.mean(v) >= A_.peak_thresh
    return min(v) >= A_.peak_thresh


B = load(BASE)
if not B:
    sys.exit(f"missing baseline {BASE}")
bs = {x for x in B if B[x][1]}
npk = sum(1 for x in bs if peaked(x))
print(f"\n### GOLDMINER  OPTION 9 additive, beta MATCHED to the binc axis "
      f"(tau=1, kappa=0)   arm = real ###")
print(f"baseline {BASE}: {len(bs)}/{len(B)} solved, median "
      f"{st.median([B[x][0] for x in bs]):.0f} expansions")
print(f"peakedness: def={A_.peak_def} thresh={A_.peak_thresh} -> "
      f"{npk}/{len(bs)} ({100*npk/len(bs):.0f}%) of solved baseline instances are peaked\n")

HDR = (f"| beta | real cov | real net% | real mean | No. instances improved | "
       f"No. instances regressed | win prior peaked (>={A_.peak_thresh}) | "
       f"loss prior peaked (>={A_.peak_thresh}) |")
SEP = "| ---- | -------- | --------- | --------- | ---------------------- | " \
      "----------------------- | ------------------------ | ------------------------- |"


def row(label, d):
    A = load(d)
    if not A:
        return None
    sv = {x for x in A if A[x][1]}
    k = sorted(sv & bs)
    if not k:
        return None
    tb = sum(B[x][0] for x in k); ta = sum(A[x][0] for x in k)
    r = [A[x][0] / B[x][0] for x in k]
    imp = [x for x in k if A[x][0] < B[x][0]]
    reg = [x for x in k if A[x][0] > B[x][0]]
    ip = [x for x in imp if peaked(x) is not None]
    rp = [x for x in reg if peaked(x) is not None]
    wp = (100 * sum(1 for x in ip if peaked(x)) / len(ip)) if ip else float("nan")
    lp = (100 * sum(1 for x in rp if peaked(x)) / len(rp)) if rp else float("nan")
    return (f"| {label} | {len(sv)} | {100*(tb-ta)/tb:+.1f}% | {sum(r)/len(r):.3f} | "
            f"{len(imp)} | {len(reg)} | {wp:.0f}% | {lp:.0f}% |")


print(HDR); print(SEP)
missing = []
for label, d in ARMS:
    out = row(label, d)
    print(out) if out else missing.append((label, d))
print()
if missing:
    print("not run yet: " + ", ".join(f"beta={l} ({os.path.basename(d)})" for l, d in missing))
print("\n### beta_new beyond the old formulation's reach (kappa=1) ###")
print(HDR); print(SEP)
for label, d in BEYOND:
    out = row(label, d)
    if out:
        print(out)
print("\n### channel-split and control arms (same columns) ###")
print(HDR); print(SEP)
for label, d in EXTRA:
    out = row(label, d)
    if out:
        print(out)
