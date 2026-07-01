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
    ap.add_argument('--model',required=True); ap.add_argument('--num-quantiles',type=int,default=99)
    args=ap.parse_args()
    dev=torch.device('cpu'); domain=mm.Domain(args.domain)
    model,_,_=_load_model(domain,Path(args.model),dev); model.eval()
    taus=torch.linspace(0.01,0.99,args.num_quantiles,device=dev).unsqueeze(0)
    problem=mm.Problem(domain,args.instance); goal=problem.get_goal_condition()
    s=problem.get_initial_state()
    # plan: walk to f5, pick keyD(shape3 for f6), unlock f6, swap to keyF(shape5 for f7),
    # move to f6, unlock f7, move to f7, putdown keyF
    plan=[('move','f0-0f','f1-0f'),('move','f1-0f','f2-0f'),('move','f2-0f','f3-0f'),
          ('move','f3-0f','f4-0f'),('move','f4-0f','f5-0f'),
          ('pickup','f5-0f','keyd'),
          ('unlock','f5-0f','f6-0f','keyd'),
          ('pickup-and-loose','f5-0f','keyf','keyd'),
          ('move','f5-0f','f6-0f'),
          ('unlock','f6-0f','f7-0f','keyf'),
          ('move','f6-0f','f7-0f'),
          ('putdown','f7-0f','keyf')]
    print("="*86)
    print("TWO-LOCK PROBE: f6 needs shape3 (keyD), f7 needs shape5 (keyF).")
    print("Decision 1: at f5 must pick keyD (shape for the FIRST lock).")
    print("Decision 2: after unlocking f6, must SWAP to keyF (shape for the SECOND lock).")
    print("="*86)
    print(f"{'step':>4} {'state':<42} {'mean':>8} {'width':>7} {'W1_prev':>8} {'best action':<24}")
    prev_q=None
    with torch.no_grad():
        for step,pa in enumerate([None]+plan):
            acts=s.generate_applicable_actions()
            qv,_=model.forward([(s,goal)],taus=taus.expand(1,taus.shape[1]))[0]
            qs,_=torch.sort(qv,dim=1); means=qs.mean(dim=1)
            best=int(means.argmax().item()); q_best=qs[best].cpu().numpy()
            width=q_best[90]-q_best[8]; shift=w1(prev_q,q_best) if prev_q is not None else 0.0
            print(f"{step:>4} {describe(s):<42} {means[best].item():8.3f} {width:7.3f} {shift:8.3f} {str(acts[best])[:24]:<24}")
            # dump distributions whenever multiple pickup/pickup-and-loose are available
            keyacts=[a for a in acts if str(a).lower().lstrip('(').startswith(('pickup ','pickup-and-loose'))]
            if len(keyacts)>=4:
                # which shape is needed NEXT? annotate keyD (1st lock) and keyF (2nd lock)
                print("     -- key decision: per-key distributions (keyD=1st lock shape3, keyF=2nd lock shape5) --")
                for ai,a in enumerate(acts):
                    low=str(a).lower()
                    if low.lstrip('(').startswith(('pickup ','pickup-and-loose')):
                        qa=qs[ai].cpu().numpy(); mark=''
                        if 'keyd' in low: mark='  <- keyD (1st lock)'
                        elif 'keyf' in low: mark='  <- keyF (2nd lock)'
                        print(f"        {str(a)[:46]:<46} mean={means[ai].item():7.3f} width={qa[90]-qa[8]:6.3f}{mark}")
            prev_q=q_best
            if step<len(plan):
                nxt=plan[step]; a=find_action(acts,*nxt)
                if a is None:
                    print(f"   (action {nxt} not applicable; have: {[str(x)[:30] for x in acts][:8]})"); break
                s=a.apply(s)
    print("\nWatch decision 1 (empty arm at f5): does keyD win? (it should — first lock needs shape3)")
    print("Watch decision 2 (holding keyD, after f6 unlocked): does keyF win the swap?")
    print("If the model picks the WRONG key, or width/W1 spikes here, the two-lock")
    print("interaction is where expressivity breaks — unlike the single-lock case.")

if __name__=='__main__':
    main()
