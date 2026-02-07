#!/bin/bash
set -euo pipefail

# Count pods in the controlled namespace
POD_COUNT=$(kubectl get pods -n controlled --no-headers 2>/dev/null | wc -l)

if [ "$POD_COUNT" -ne 5 ]; then
  echo "Expected exactly 5 pods in the controlled namespace, found $POD_COUNT"
  echo "Create pods pod-1 through pod-5, and the 6th should be rejected by ResourceQuota"
  exit 1
fi

# Verify the pods are the expected ones
EXPECTED_PODS="pod-1 pod-2 pod-3 pod-4 pod-5"
for POD in $EXPECTED_PODS; do
  if ! kubectl get pod $POD -n controlled &>/dev/null; then
    echo "Expected pod $POD not found in controlled namespace"
    exit 1
  fi
done

echo "Success: Exactly 5 pods exist, demonstrating ResourceQuota enforcement"
exit 0
