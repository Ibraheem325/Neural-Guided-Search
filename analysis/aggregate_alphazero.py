import os
import re
import csv
import sys


def aggregate(output_dir, csv_path):
    results = []
    for fname in sorted(os.listdir(output_dir)):
        if not fname.endswith('.out'):
            continue
        problem = fname.replace('.out', '')
        with open(os.path.join(output_dir, fname)) as f:
            content = f.read()
        
        solved = 'Found a solution' in content
        sol_len, sims, generated, expanded = None, None, None, None
        
        m = re.search(r'Found a solution of length (\d+)', content)
        if m: sol_len = int(m.group(1))
        m = re.search(r'simulations=(\d+), states generated=(\d+)', content)
        if m: sims, generated = int(m.group(1)), int(m.group(2))
        m = re.search(r'\[Final\] Expanded: (\d+), Generated: (\d+)', content)
        if m: expanded, generated = int(m.group(1)), int(m.group(2))
        
        results.append([problem, solved, sol_len, sims, expanded, generated])
    
    solved = [r for r in results if r[1]]
    total = len(results)
    coverage = round(100 * len(solved) / total, 1)
    avg_len = round(sum(r[2] for r in solved) / len(solved), 1) if solved else 0
    avg_sims = round(sum(r[3] for r in solved) / len(solved), 1) if solved else 0
    avg_exp = round(sum(r[4] for r in solved if r[4]) / len(solved), 1) if solved else 0
    avg_gen = round(sum(r[5] for r in solved if r[5]) / len(solved), 1) if solved else 0

    with open(csv_path, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['Problem', 'Solved', 'Solution Length', 'Simulations', 'Expanded', 'Generated'])
        for r in results:
            w.writerow(r)
        w.writerow([])
        w.writerow(['SUMMARY', f'{len(solved)}/{total}', avg_len, avg_sims, avg_exp, avg_gen])
        w.writerow(['Coverage', f'{coverage}%', '', '', '', ''])
    
    print(f'{csv_path}: {coverage}% coverage ({len(solved)}/{total}), avg_len={avg_len}, avg_exp={avg_exp}')


for domain in ['grid', 'rovers', 'satellite', 'logistics']:
    d = f'results/{domain}_alphazero'
    if os.path.exists(d):
        aggregate(d, f'results/{domain}_alphazero_summary.csv')
