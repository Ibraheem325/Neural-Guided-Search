import json
import os

# Define the file paths
file_paths = [
    "results/grid_bellman_consistency.json",
    "results/grid_bellman_consistency_ens.json",
    "results/grid_bellman_multistep.json",
    "results/grid_bellman_multistep_easy.json",
    "results/grid_bellman_multistep_smoke.json",
    "results/logi_bellman_multistep.json",
    "results/gold_bellman_multistep.json",
    "results/rovers_bellman_multistep.json",
    "results/sat_bellman_multistep.json",
]

# Function to load and summarize JSON data
def summarize_results(file_paths):
    summary = {}
    for file_path in file_paths:
        if os.path.exists(file_path):
            with open(file_path, "r") as file:
                try:
                    data = json.load(file)
                    # Extract relevant metrics (modify based on your JSON structure)
                    category = file_path.split("/")[-1].split("_")[0]  # Extract category (e.g., grid, logi)
                    summary[category] = summary.get(category, [])
                    summary[category].append(data)
                except json.JSONDecodeError:
                    print(f"Error decoding JSON in file: {file_path}")
        else:
            print(f"File not found: {file_path}")
    return summary

# Summarize the results
results_summary = summarize_results(file_paths)

# Print the summary
for category, results in results_summary.items():
    print(f"Category: {category}")
    for result in results:
        print(result)
    print("\n")