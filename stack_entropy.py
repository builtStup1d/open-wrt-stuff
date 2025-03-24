import os
import numpy as np
import subprocess

def get_stack_address():
    """Extract stack address from /proc/self/maps"""
    output = subprocess.getoutput("cat /proc/self/maps | grep stack | awk '{print $1}'")
    return output.strip().split('-')[0]  # Extract starting address

def collect_addresses(num_samples):
    """Collect real stack addresses multiple times."""
    addresses = []
    for _ in range(num_samples):
        addresses.append(get_stack_address())  # Get stack address
    return addresses

def calculate_entropy(addresses):
    """Compute Shannon entropy of address distribution."""
    unique, counts = np.unique(addresses, return_counts=True)
    probabilities = counts / len(addresses)
    entropy = -np.sum(probabilities * np.log2(probabilities))
    return entropy

# Number of samples for entropy estimation
num_samples = 1000

# Collect stack addresses and compute entropy
addresses = collect_addresses(num_samples)
entropy_value = calculate_entropy(addresses)

print(f"📊 Estimated ASLR Entropy: {entropy_value:.2f} bits (Stack)")
