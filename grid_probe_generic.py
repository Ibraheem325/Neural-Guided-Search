import argparse, json
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model

def atoms_by_pred(state):
    d={}
    for a in state.get_atoms():
        d.setdefault(a.get_predicate().get_name(),[]).append([str(t) for t in a.get_terms()])
    return d
def describe(state):
    a=atoms_by_pred(state); rob=a.get('at-robot',[['?']])[0][0]
    holding=[h[0] for h in a.get('holding',[])]
    return f"robot@{rob}, {'empty' if a.get('arm-empty') else 'holding '+str(holding)}"
def w1(a,b): return float(np.mean(np.abs(a-b)))
def find_action(acts,*subs):
    for a in acts:
        s=str(a).lower()
        if all(x in s for x in subs): return a
    return None

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--domain',required=True); ap.add_argument('--instance',required=True)
    ap.add_argument('--model',required=True); ap.add_argument('--plan',required=True,
        help='JSON list of action tuples, e.g. [["move","f0-0f","f1-0f"],["pickup","f5-0f","keyd"]]')
    ap.add_argument('--correct',default='',help='comma list: which key is correct at each decision, for annotation')
    args=ap.parse_args()
    dev=torch.device('cpu'); domain=mm.Domain(args.domain)
    model,_,_=_load_model(domain,Path(args.model),dev); model.eval()
    taus=torch.linspace(0.01,0.99,99,device=dev).unsqueeze(0)
    problem=mm.Problem(domain,args.instance); goal=problem.get_goal_condition()
    s=problem.get_initial_state()
    plan=[tuple(x) for x in json.loads(args.plan)]
    correct=set(args.correct.lower().split(',')) if args.correct else set()
    print("="*80)
    print(f"PROBE: {args.instance}")
    print("="*80)
    print(f"{'step':>4} {'state':<40} {'mean':>8} {'width':>7} {'W1':>7} {'best action':<22}")
    prev_q=None
    with torch.no_grad():
        for step,_ in enumerate([None]+plan):
            acts=s.generate_applicable_actions()
            qv,_=model.forward([(s,goal)],taus=taus.expand(1,taus.shape[1]))[0]
            qs,_=torch.sort(qv,dim=1); means=qs.mean(dim=1)
            best=int(means.argmax().item()); q_best=qs[best].cpu().numpy()
            width=q_best[90]-q_best[8]; shift=w1(prev_q,q_best) if prev_q is not None else 0.0
            print(f"{step:>4} {describe(s):<40} {means[best].item():8.3f} {width:7.3f} {shift:7.3f} {str(acts[best])[:22]:<22}")
            keyacts=[a for a in acts if str(a).lower().lstrip('(').startswith(('pickup ','pickup-and-loose'))]
            if len(keyacts)>=4:
                print("     -- key decision --")
                for ai,a in enumerate(acts):
                    low=str(a).lower()
                    if low.lstrip('(').startswith(('pickup ','pickup-and-loose')):
                        qa=qs[ai].cpu().numpy()
                        mark='  <- CORRECT' if any(c in low for c in correct) else ''
                        print(f"        {str(a)[:46]:<46} mean={means[ai].item():7.3f} width={qa[90]-qa[8]:6.3f}{mark}")
            prev_q=q_best
            if step<len(plan):
                nxt=plan[step]; a=find_action(acts,*nxt)
                if a is None:
                    print(f"   (action {nxt} not applicable; have {[str(x)[:28] for x in acts][:8]})"); break
                s=a.apply(s)
    print()
if __name__=='__main__':
    main()
