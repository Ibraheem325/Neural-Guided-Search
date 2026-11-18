"""Aggregate the weighted-Q* sweep: coverage + median expansions/length per domain
and weight from results/<domain>_qstar_w<w*10>/. Dir tag is w*10 (w10=1.0 ... w120=12.0).
Run: venv/bin/python aggregate_qstar_weight.py"""
import glob, os, re, statistics
from collections import defaultdict

dirs = sorted(glob.glob("results/*_qstar_w*"))
# group by domain
bydom = defaultdict(dict)
for d in dirs:
    m = re.match(r"results/(.+)_qstar_w(\d+)$", d)
    dom, wtag = m.group(1), int(m.group(2))
    w = wtag/10.0
    bydom[dom][w] = d

def parse(d):
    solved=0; total=0; exps=[]; lens=[]; per={}
    for f in glob.glob(d+"/*.out"):
        total+=1; t=open(f,errors='ignore').read()
        name=os.path.basename(f)[:-4]
        sol = "Found a solution of length" in t
        me = re.findall(r"\[Final\] Expanded:\s*(\d+)", t)
        e = int(me[-1]) if me else None
        ml = re.search(r"Found a solution of length (\d+)", t)
        if sol:
            solved+=1
            if e is not None: exps.append(e)
            if ml: lens.append(int(ml.group(1)))
        per[name]=(sol,e)
    return solved,total,exps,lens,per

print(f"{'domain':<11}{'w':>6}{'solved':>9}{'cov%':>7}{'medExp(solved)':>16}{'medLen':>9}")
summary={}
for dom in sorted(bydom):
    for w in sorted(bydom[dom]):
        s,t,ex,ln,per = parse(bydom[dom][w])
        summary[(dom,w)]=(s,t,ex,ln,per)
        me = f"{statistics.median(ex):.0f}" if ex else "-"
        ml = f"{statistics.median(ln):.0f}" if ln else "-"
        print(f"{dom:<11}{w:>6.1f}{s:>6}/{t:<3}{100*s/t:>6.1f}{me:>16}{ml:>9}")
    print()
