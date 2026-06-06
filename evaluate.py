import argparse
import subprocess
import re
import csv
import json
from pathlib import Path
import time


def parse_output(output: str, algorithm: str) -> dict:
    result = {
        'solved': False,
        'solution_length': None,
        'expanded': None,
        'generated': None,
    }
    if 'Found a solution' in output:
        result['solved'] = True
        m = re.search(r'Found a solution of length (\d+)', output)
        if m:
            result['solution_length'] = int(m.group(1))
    m = re.search(r'\[Final\] Expanded: (\d+), Generated: (\d+)', output)
    if m:
        result['expanded'] = int(m.group(1))
        result['generated'] = int(m.group(2))

    # AlphaZero new format
    m = re.search(r'Found a solution of length (\d+)', output)
    if m and 'search done' in output:
        result['solved'] = True
        result['solution_length'] = int(m.group(1))
    m = re.search(r'simulations=(\d+), states generated=(\d+)', output)
    if m:
        result['expanded'] = int(m.group(1))
        result['generated'] = int(m.group(2))
    return result


import time

def run_algorithm(script, domain, problem, extra_args=[]):
    cmd = ['venv/bin/python', script, '--doma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in', domain, '--problem', problem] + extra_args
    t0 = time.time()
    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
        elapsed = time.time() - t0
        output = proc.stdout + proc.stderr
        result = parse_output(output, script)
        result['time'] = round(elapsed, 2)
        return result
    except subprocess.TimeoutExpired:
        return {'solved': False, 'solution_length': None, 'expanded': None, 'generated': None, 'timeout': True, 'time': 1800}
    except Exception as e:
        return {'solved': False, 'solution_length': None, 'expanded': None, 'generated': None, 'error': str(e), 'time': round(time.time()-t0, 2)}


def summarize(results: list) -> dict:
    solved = [r for r in results if r['solved']]
    coverage = len(solved) / len(results) * 100
    avg_len = sum(r['solution_length'] for r in solved) / len(solved) if solved else 0
    avg_exp = sum(r['expanded'] for r in solved if r['expanded']) / len(solved) if solved else 0
    return {
        'coverage': round(coverage, 1),
        'solved': len(solved),
        'total': len(results),
        'avg_solution_length': round(avg_len, 1),
        'avg_expanded': round(avg_exp, 1),
    }


def main():
    parser = argparse.ArgumentParser(description='Evaluate search algorithms on test problems')
    parser.add_argument('--domain', required=True, type=str, help='Path to domain.pddl')
    parser.add_argument('--test_dir', required=True, type=str, help='Path to test problems directory')
    parser.add_argument('--model', required=True, type=str, help='Path to supervised model .pth')
    parser.add_argument('--dqn_model', default=None, type=str, help='Path to DQN model .pth (enables Q*)')
    parser.add_argument('--sac_policy', default=None, type=str, help='Path to SAC policy model .pth (enables AlphaZero)')
    parser.add_argument('--sac_q1', default=None, type=str, help='Path to SAC q1 model .pth (enables AlphaZero)')
    parser.add_argument('--sac_q2', default=None, type=str, help='Path to SAC q2 model .pth (optional, improves AlphaZero)')
    parser.add_argument('--output', default='results.json', type=str, help='Output JSON file')
    parser.add_argument('--limit', default=None, type=int, help='Limit number of problems (for quick testing)')
    parser.add_argument('--algorithms', default=None, type=str, 
    help='Comma-separated list of algorithms to run (e.g. "alphazero,qstar"). If not set, runs all.')
    args = parser.parse_args()

    problems = sorted([str(f) for f in Path(args.test_dir).glob('*.pddl')])
    if args.limit:
        problems = problems[:args.limit]

    print(f'Found {len(problems)} test problems')

    algorithms = {
        'astar':      ('search.py', ['--model', args.model]),
        'wastar_2':   ('wastar.py', ['--model', args.model, '--weight', '2.0']),
        'wastar_5':   ('wastar.py', ['--model', args.model, '--weight', '5.0']),
        'greedy':     ('greedy_value_plan.py', ['--model', args.model]),
        'beam_1':     ('beam.py', ['--model', args.model, '--beam', '1']),
        'beam_5':     ('beam.py', ['--model', args.model, '--beam', '5']),
        'beam_10':    ('beam.py', ['--model', args.model, '--beam', '10']),
    }

    if args.dqn_model:
        algorithms['qstar'] = ('qstar.py', ['--model', args.dqn_model])

    if args.sac_policy and args.sac_q1:
        az_args = ['--policy_model', args.sac_policy, '--q1_model', args.sac_q1, '--max_time', '1800']
        if args.sac_q2:
            az_args += ['--q2_model', args.sac_q2]
        algorithms['alphazero'] = ('alphaZero.py', az_args)

    if args.algorithms:
        selected = [a.strip() for a in args.algorithms.split(',')]
        algorithms = {k: v for k, v in algorithms.items() if k in selected}

    all_results = {}
    for alg_name, (script, extra) in algorithms.items():
        print(f'\nRunning {alg_name}...')
        results = []
        for i, problem in enumerate(problems):
            print(f'  [{i+1}/{len(problems)}] {Path(problem).name}', end=' ', flush=True)
            r = run_algorithm(script, args.domain, problem, extra)
            results.append(r)
            print('✓' if r['solved'] else '✗')
        summary = summarize(results)
        all_results[alg_name] = {'summary': summary, 'results': results}
        print(f'  Coverage: {summary["coverage"]}% ({summary["solved"]}/{summary["total"]}), '
              f'Avg length: {summary["avg_solution_length"]}, '
              f'Avg expanded: {summary["avg_expanded"]}')

    with open(args.output, 'w') as f:
        json.dump(all_results, f, indent=2)
    print(f'\nResults saved to {args.output}')

    csv_path = args.output.replace('.json', '_summary.csv')
    with open(csv_path, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['Algorithm', 'Coverage (%)', 'Solved', 'Total', 'Avg Solution Length', 'Avg Expanded'])
        for alg_name, data in all_results.items():
            s = data['summary']
            writer.writerow([alg_name, s['coverage'], s['solved'], s['total'], s['avg_solution_length'], s['avg_expanded']])
    print(f'Summary CSV saved to {csv_path}')

    print('\n=== SUMMARY TABLE ===')
    print(f'{"Algorithm":<15} {"Coverage":>10} {"Solved":>8} {"Avg Len":>10} {"Avg Expanded":>14}')
    print('-' * 60)
    for alg_name, data in all_results.items():
        s = data['summary']
        print(f'{alg_name:<15} {s["coverage"]:>9}% {s["solved"]:>5}/{s["total"]:<3} '
              f'{s["avg_solution_length"]:>10} {s["avg_expanded"]:>14}')
        


if __name__ == '__main__':
    main()