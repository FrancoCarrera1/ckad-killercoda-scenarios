#!/bin/bash
set -euo pipefail

# Verify mystery-crash pod exists
if ! kubectl get pod mystery-crash -n observatory &> /dev/null; then
  echo "Pod mystery-crash not found in observatory namespace"
  exit 1
fi

# Get pod status
status=$(kubectl get pod mystery-crash -n observatory -o jsonpath='{.status.phase}')

# Check if pod is running
if [ "$status" != "Running" ]; then
  echo "Pod mystery-crash is not in Running state (current: $status)"
  exit 1
fi

# Verify memory limit is at least 64Mi
memory_limit=$(kubectl get pod mystery-crash -n observatory -o jsonpath='{.spec.containers[0].resources.limits.memory}')

# Convert to numeric value for comparison (removing Mi suffix)
numeric_limit=$(echo "$memory_limit" | sed 's/Mi$//')

if [ -z "$numeric_limit" ]; then
  echo "Pod does not have a memory limit set"
  exit 1
fi

if [ "$numeric_limit" -lt 64 ]; then
  echo "Memory limit ($memory_limit) is too low, must be at least 64Mi"
  exit 1
fi

echo "Pod mystery-crash is running with sufficient memory limit ($memory_limit)"
