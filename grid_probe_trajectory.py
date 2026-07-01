import argparse
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model

def atoms_by_pred(state):
    d = {}
    for a in state.get_atoms():
        d.setdefault(a.get_predicate().get_name(), []).append([str(t) for t in a.get_terms()])
    return d

def describe(state):
    a = atoms_by_pred(state)
    rob = a.get('at-robot', [['?']])[0][0]
    holding = [h[0] for h in a.get('holding', [])]
    arm = 'empty' if a.get('arm-empty') else f"holding {holding}"
    return f"robot@{rob}, {arm}"

def w1(q1, q2):
    return float(np.mean(np.abs(q1 - q2)))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True)
    ap.add_argument('--instance', required=True)
    ap.add_argument('--model', required=True)
    ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()
    dev = torch.device('cpu')
    domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)
    problem = mm.Problem(domain, args.instance)
    goal = problem.get_goal_condition()
    ss = mm.StateSpaceSampler.new(problem, 200000)
    if ss is None:
        print("state space too large"); return
    s = problem.get_initial_state()
    print("="*78)
    print("CONTROLLED PROBE: all keys at f3-0f; lock at f4-0f needs shape1 (keyB)")
    print("="*78)
    print(f"{'step':>4} {'state':<36} {'mean':>8} {'width':>7} {'W1_prev':>8} {'best action':<24}")
    prev_q = None
    with torch.no_grad():
        for step in range(40):
            ls = ss.get_state_label(s)
            if ls.is_goal:
                print(f"{step:>4} {describe(s):<36} {'GOAL':>8}"); break
            acts = s.generate_applicable_actions()
            qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
            qs, _ = torch.sort(qv, dim=1); means = qs.mean(dim=1)
            best = int(means.argmax().item())
            q_best = qs[best].cpu().numpy(); width = q_best[90]-q_best[8]
            shift = w1(prev_q, q_best) if prev_q is not None else 0.0
            print(f"{step:>4} {describe(s):<36} {means[best].item():8.3f} {width:7.3f} {shift:8.3f} {str(acts[best])[:24]:<24}")
            pickups = [a for a in acts if str(a).lower().lstrip('(').startswith('pickup')]
            if len(pickups) >= 2:
                print("     -- key room: per-action distributions --")
                for ai, a in enumerate(acts):
                    qa = qs[ai].cpu().numpy()
                    print(f"        {str(a)[:40]:<40} mean={means[ai].item():7.3f} width={qa[90]-qa[8]:6.3f}")
            best_succ=None; best_d=None
            for a in acts:
                s2=a.apply(s); l2=ss.get_state_label(s2)
                if l2 is None or l2.is_dead_end: continue
                d=l2.steps_to_goal
                if best_d is None or d<best_d: best_d=d; best_succ=s2
            if best_succ is None:
                print("   (no progressing successor)"); break
            s=best_succ; prev_q=q_best
    print("\nApproach steps: expect low/stable width + small W1. Key room: expect")
    print("width rise / W1 jump, and per-key distributions show if keyB separates from keyA/keyC.")

if __name__ == '__main__':
    main()
