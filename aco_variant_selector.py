import subprocess
import random
import time
import os

# List your compiled C variants here
executables = {
    'V1': './sum_v1',
    'V2': './sum_v2',
    'V3': './sum_v3',
}

# Initialize pheromone trust scores
pheromones = {v: 1.0 for v in executables}
evaporation_rate = 0.1
iterations = 50
num_selected = 3  # number of variants run in parallel per iteration

def run_variant(exe_path):
    try:
        result = subprocess.run([exe_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=1)
        output = result.stdout.decode().strip()
        return output
    except Exception as e:
        return "ERROR"

def evaluate(outputs):
    # Determine majority output
    values = list(outputs.values())
    majority = max(set(values), key=values.count)
    rewards = {v: 1 if out == majority else 0 for v, out in outputs.items()}
    return majority, rewards

def update_pheromones(rewards):
    for v in pheromones:
        pheromones[v] = (1 - evaporation_rate) * pheromones[v] + rewards.get(v, 0)

def ant_decision():
    total_pheromone = sum(pheromones.values())
    probabilities = [pheromones[v] / total_pheromone for v in executables]
    selected = random.choices(list(executables.keys()), weights=probabilities, k=num_selected)
    return list(set(selected))  # Avoid duplicate selections

for it in range(1, iterations + 1):
    selected = ant_decision()
    outputs = {}

    for v in selected:
        outputs[v] = run_variant(executables[v])

    majority, rewards = evaluate(outputs)
    update_pheromones(rewards)

   # print(f"[{it:02d}] Selected: {selected} | Outputs: {outputs} | Trust: {dict(round(pheromones[v], 2) for v in selected)}")

    time.sleep(0.3)  # Small delay for stability on Pi

# Final trust ranking
final = sorted(pheromones.items(), key=lambda x: x[1], reverse=True)
print("\n🏁 Final Trusted Order (High to Low):")
for i, (v, trust) in enumerate(final, 1):
    print(f"{i}. {v} (Trust Score: {trust:.2f})")
