#!/bin/bash

#echo "Enter the name of executable:"
#read exe_name
NUM_RUNS=5000  # Number of times to run the test program
PROGRAM="/bin/ls"  # Change this to any executable you want to test

echo "Measuring ASLR Entropy in Kali Linux..."
echo "Running $NUM_RUNS iterations to collect memory addresses."

# Collect stack addresses
echo "Collecting stack addresses..."
STACK_ADDRESSES=()
for i in $(seq 1 $NUM_RUNS); do
    STACK_ADDRESSES+=("$(cat /proc/self/maps | grep stack | awk '{print $1}')")
done

# Collect heap addresses
echo "Collecting heap addresses..."
HEAP_ADDRESSES=()
for i in $(seq 1 $NUM_RUNS); do
    HEAP_ADDRESSES+=("$(cat /proc/self/maps | grep heap | awk '{print $1}')")
done

# Collect shared library addresses (e.g., libc)
echo "Collecting shared library addresses..."
LIBC_ADDRESSES=()
for i in $(seq 1 $NUM_RUNS); do
    LIBC_ADDRESSES+=("$(ldd $PROGRAM | grep libc | awk '{print $3}')")
done

# Function to calculate entropy based on address variations
calculate_entropy() {
    local ADDRESSES=("$@")
    UNIQUE_COUNT=$(echo "${ADDRESSES[@]}" | tr ' ' '\n' | sort | uniq | wc -l)
    TOTAL_COUNT=${#ADDRESSES[@]}
    
    if [[ $TOTAL_COUNT -gt 1 && $UNIQUE_COUNT -gt 1 ]]; then
        ENTROPY=$(echo "scale=2; l($UNIQUE_COUNT)/l(2)" | bc -l)
        echo "Estimated Entropy: $ENTROPY bits"
    else
        echo "No variation detected. ASLR might be disabled."
    fi
}

# Display results
echo -e "\n📌 Stack ASLR Entropy:"
calculate_entropy "${STACK_ADDRESSES[@]}"

echo -e "\n📌 Heap ASLR Entropy:"
calculate_entropy "${HEAP_ADDRESSES[@]}"

echo -e "\n📌 Shared Library (libc) ASLR Entropy:"
calculate_entropy "${LIBC_ADDRESSES[@]}"
