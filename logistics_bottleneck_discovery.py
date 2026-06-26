#!/usr/bin/env python3
"""
logistics_bottleneck_discovery.py
============================================================================
LEVEL 2 for logistics: let model ERROR reveal the expressivity bottleneck,
to test (not assume) the supervisor's guess that it's "deciding where to fly
the airplane once a package is loaded."

Descriptors (read from PDDL atoms only):
  pkg_in_airplane        : some package is currently inside an airplane
  pkg_in_truck           : some package is inside a truck
  pkg_in_airplane_wrong_city : a package is in an airplane that is NOT at the
                           airport of the package's goal city (the routing
                           decision is still open / can be gotten wrong) -- the
                           supervisor's hypothesized hard case
  pkg_at_airport_needs_fly : package sitting at an airport but its goal is in a
                           different city (needs to be flown)
  multi_city_goal        : goal spans >=2 cities (cross-city routing needed)
  num_packages_ge4 / ge6 : instance package-count complexity
  num_airplanes_ge2      : multiple airplanes (which-airplane disambiguation)
  any_in_vehicle         : any package loaded (in a truck or airplane)

Method identical to grid discovery: rank states by model error, report LIFT of
each descriptor among the high-error states. High lift => candidate bottleneck.

Usage:
  venv/bin/python logistics_bottleneck_discovery.py \
    --domain example/logistics_dataset/domain.pddl \
    --instances example/logistics_dataset/train \
    --model models/logistics_iqn.pth \
    --seeds 42 43 44 --state-cap 20000 --max-instances 40 --states-per-instance 30
============================================================================
"""
import argparse, random
from pathlib import Path
import numpy as np, torch, pymimir as mm
from train_iqn import _load_model


def atoms_by_pred(state):
    d = {}
    for atom in state.get_atoms():
        d.setdefault(atom.get_predicate().get_name(), []).append([str(t) for t in atom.get_terms()])
    return d


def goal_at(goal):
    """Return dict obj -> goal location from the goal condition's 'at' atoms."""
    g = {}
    try:
        for lit in goal:
            a = lit.get_atom() if hasattr(lit, 'get_atom') else lit
            if a.get_predicate().get_name() == 'at':
                terms = [str(t) for t in a.get_terms()]
                if len(terms) == 2:
                    g[terms[0]] = terms[1]
    except Exception:
        pass
    return g


def descriptors(state, goal_locs, static):
    a = atoms_by_pred(state)
    OBJ = static['OBJ']; TRUCK = static['TRUCK']; AIRPLANE = static['AIRPLANE']
    AIRPORT = static['AIRPORT']; incity = static['in_city']  # loc -> city

    inrel = a.get('in', [])          # [obj, vehicle]
    at = a.get('at', [])             # [obj, loc]
    at_map = {x[0]: x[1] for x in at}

    pkg_in_airplane = []
    pkg_in_truck = []
    for obj, veh in inrel:
        if veh in AIRPLANE: pkg_in_airplane.append((obj, veh))
        elif veh in TRUCK: pkg_in_truck.append((obj, veh))

    # is a packed airplane NOT yet at the airport of the package's goal city?
    wrong_city = False
    for obj, veh in pkg_in_airplane:
        gloc = goal_locs.get(obj)
        if gloc is None: continue
        goal_city = incity.get(gloc)
        plane_loc = at_map.get(veh)
        plane_city = incity.get(plane_loc) if plane_loc else None
        if goal_city is not None and plane_city is not None and goal_city != plane_city:
            wrong_city = True

    # package at an airport but goal is in another city (needs to be flown)
    needs_fly = False
    for obj, loc in at:
        if obj in OBJ and loc in AIRPORT:
            gloc = goal_locs.get(obj)
            if gloc and incity.get(gloc) != incity.get(loc):
                needs_fly = True

    goal_cities = {incity.get(l) for l in goal_locs.values() if incity.get(l)}
    npkg = len(OBJ); nplane = len(AIRPLANE)

    return {
        'pkg_in_airplane'           : len(pkg_in_airplane) > 0,
        'pkg_in_truck'              : len(pkg_in_truck) > 0,
        'any_in_vehicle'            : len(inrel) > 0,
        'pkg_in_airplane_wrong_city': wrong_city,
        'pkg_at_airport_needs_fly'  : needs_fly,
        'multi_city_goal'           : len(goal_cities) >= 2,
        'num_packages_ge4'          : npkg >= 4,
        'num_packages_ge6'          : npkg >= 6,
        'num_airplanes_ge2'         : nplane >= 2,
    }


def static_info(problem):
    """Predicates that don't change across states: types + in-city."""
    init = problem.get_initial_state()
    d = atoms_by_pred(init)
    return {
        'OBJ'     : {x[0] for x in d.get('OBJ', [])},
        'TRUCK'   : {x[0] for x in d.get('TRUCK', [])},
        'AIRPLANE': {x[0] for x in d.get('AIRPLANE', [])},
        'AIRPORT' : {x[0] for x in d.get('AIRPORT', [])},
        'in_city' : {x[0]: x[1] for x in d.get('in-city', [])},  # loc -> city
    }


def collect(domain, model, instances, taus, seed, cap, maxi, sper):
    random.seed(seed)
    files = sorted(f for f in Path(instances).glob('*.pddl') if f.name != 'domain.pddl')
    errs, feats = [], []
    used = 0
    with torch.no_grad():
        for f in files:
            p = mm.Problem(domain, str(f))
            if len(p.get_goal_condition()) == 0: continue
            ss = mm.StateSpaceSampler.new(p, cap)
            if ss is None or ss.max_steps_to_goal() < 2: continue
            ss.set_seed(seed)
            goal = p.get_goal_condition()
            goal_locs = goal_at(goal)
            static = static_info(p)
            used += 1
            states = ss.get_states(); random.shuffle(states); taken = 0
            for s in states:
                if taken >= sper: break
                ls = ss.get_state_label(s)
                if ls.is_goal: continue
                acts = s.generate_applicable_actions()
                if len(acts) < 1: continue
                qv, _ = model.forward([(s, goal)], taus=taus.expand(1, taus.shape[1]))[0]
                qs, _ = torch.sort(qv, dim=1)
                means = qs.mean(dim=1)
                best = int(means.argmax().item())
                errs.append(abs(means[best].item() - (-float(ls.steps_to_goal))))
                feats.append(descriptors(s, goal_locs, static))
                taken += 1
            if used >= maxi: break
    return np.array(errs), feats


def report(tag, errs, feats, hq):
    n = len(errs); thr = np.quantile(errs, hq); high = errs >= thr
    keys = sorted({k for f in feats for k in f})
    print(f"\n================  {tag}  ================")
    print(f"states={n}  high-error cutoff(q{hq})={thr:.2f}  high n={int(high.sum())}")
    print(f"{'descriptor':28s} {'base%':>7} {'high%':>7} {'lift':>6}")
    rows = []
    for k in keys:
        v = np.array([1.0 if f.get(k) else 0.0 for f in feats])
        base = v.mean(); hi = v[high].mean() if high.sum() else float('nan')
        lift = hi / base if base > 0 else float('nan')
        rows.append((lift if lift == lift else -1, k, base, hi, lift))
    for lift, k, base, hi, l in sorted(rows, reverse=True):
        print(f"{k:28s} {100*base:7.1f} {100*hi:7.1f} {l:6.2f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--domain', required=True); ap.add_argument('--instances', required=True)
    ap.add_argument('--model', required=True); ap.add_argument('--seeds', type=int, nargs='+', default=[42])
    ap.add_argument('--state-cap', type=int, default=20000); ap.add_argument('--max-instances', type=int, default=40)
    ap.add_argument('--states-per-instance', type=int, default=30); ap.add_argument('--high-quantile', type=float, default=0.9)
    ap.add_argument('--num-quantiles', type=int, default=99)
    args = ap.parse_args()
    dev = torch.device('cpu'); domain = mm.Domain(args.domain)
    model, _, _ = _load_model(domain, Path(args.model), dev); model.eval()
    taus = torch.linspace(0.01, 0.99, args.num_quantiles, device=dev).unsqueeze(0)
    print("="*70); print("LEVEL 2 — error-driven bottleneck discovery (logistics)")
    print(f"model: {args.model}  seeds: {args.seeds}")
    print("lift>1 => structure OVER-represented among high-error states"); print("="*70)
    allE, allF = [], []
    for sd in args.seeds:
        E, F = collect(domain, model, args.instances, taus, sd, args.state_cap,
                       args.max_instances, args.states_per_instance)
        report(f"SEED {sd}", E, F, args.high_quantile); allE.append(E); allF += F
    if len(args.seeds) > 1:
        report("POOLED", np.concatenate(allE), allF, args.high_quantile)
    print("\nRead: highest-lift descriptor = discovered bottleneck. If")
    print("'pkg_in_airplane_wrong_city' tops it, the supervisor's airplane-routing")
    print("hypothesis is confirmed from data. Other high-lift descriptors = unassumed factors.")


if __name__ == '__main__':
    main()