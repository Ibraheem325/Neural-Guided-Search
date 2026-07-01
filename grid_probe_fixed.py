import argparse
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model

def atoms_by_pred(state):
    d={}
    for a in state.get_atoms():
        d.setdefault(a.get_predicate().get_name(),[]).append([str(t) for t in a.get_terms()])
    return d

def describe(state):
    a=atoms_by_pred(state)
    rob=a.get('at-robot',[['?']])[0][0]
    holding=[h[0] for h in a.get('holding',[])]
    return f"robot@{rob}, {'empty' if a.get('arm-empty') else 'holding '+str(holding)}"

def w1(a,b): return float(np.mean(np.abs(a-b)))

def find_action(acts, *substrings):
    for a in acts:
        s=str(a).lower()
        if all(x in s for x in substrings): return a
    return None

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--domain',required=True); ap.add_argument('--instance',required=True)
    ap.add_argument('--model',required=True); ap.add_argument('--num-quantiles',type=int,default=99)
    args=ap.parse_args()
    dev=torch.device('cpu'); domain=mm.Domain(args.domain)
    model,_,_=_load_model(domain,Path(args.model),dev); model.eval()
    taus=torch.linspace(0.01,0.99,args.num_quantiles,device=dev).unsqueeze(0)
    problem=mm.Problem(domain,args.instance); goal=problem.get_goal_condition()
    s=problem.get_initial_state()
    # fixed optimal plan: walk f0..f5, pickup keyf, unlock f6, move in, putdown
    plan=[('move','f0-0f','f1-0f'),('move','f1-0f','f2-0f'),('move','f2-0f','f3-0f'),
          ('move','f3-0f','f4-0f'),('move','f4-0f','f5-0f'),
          ('pickup','f5-0f','keyf'),('unlock','f5-0f','f6-0f','keyf'),
          ('move','f5-0f','f6-0f'),('putdown','f6-0f','keyf')]
    print("="*82)
    print("HARD PROBE: 8 keys at f5-0f; lock at f6-0f needs shape5 (keyF). Fixed optimal path.")
    print("="*82)
    print(f"{'step':>4} {'state':<40} {'mean':>8} {'width':>7} {'W1_prev':>8} {'best action':<22}")
    prev_q=None
    with torch.no_grad():
        for step,pa in enumerate([None]+plan):
            acts=s.generate_applicable_actions()
            qv,_=model.forward([(s,goal)],taus=taus.expand(1,taus.shape[1]))[0]
            qs,_=torch.sort(qv,dim=1); means=qs.mean(dim=1)
            best=int(means.argmax().item()); q_best=qs[best].cpu().numpy()
            width=q_best[90]-q_best[8]; shift=w1(prev_q,q_best) if prev_q is not None else 0.0
            print(f"{step:>4} {describe(s):<40} {means[best].item():8.3f} {width:7.3f} {shift:8.3f} {str(acts[best])[:22]:<22}")
            # at the key room (8 pickups available), dump per-key distributions
            pickups=[a for a in acts if str(a).lower().lstrip('(').startswith('pickup ')]
            if len(pickups)>=4:
                print("     -- key room: per-pickup distributions (looking for keyF to separate) --")
                for ai,a in enumerate(acts):
                    if str(a).lower().lstrip('(').startswith('pickup '):
                        qa=qs[ai].cpu().numpy()
                        mark='  <-- CORRECT (shape5)' if 'keyf' in str(a).lower() else ''
                        print(f"        {str(a)[:40]:<40} mean={means[ai].item():7.3f} width={qa[90]-qa[8]:6.3f}{mark}")
            prev_q=q_best
            # advance by the planned action
            if step < len(plan):
                nxt=plan[step]
                a=find_action(acts,*nxt)
                if a is None:
                    print(f"   (could not find action {nxt}; applicable: {[str(x) for x in acts][:6]})"); break
                s=a.apply(s)
    print("\nWatch: does keyF still cleanly separate from the other 7 (high mean, others identical-low)?")
    print("Does width stay flat at the key room, or spike now that there are 8 options?")

if __name__=='__main__':
    main()
