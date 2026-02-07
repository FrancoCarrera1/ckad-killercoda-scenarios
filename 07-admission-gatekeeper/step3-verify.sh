#!/bin/bash
set -euo pipefail

# Check if the deployment exists
if ! kubectl get deployment efficient-app -n controlled &>/dev/null; then
  echo "Deployment 'efficient-app' not found in controlled namespace"
  exit 1
fi

# Check if the deployment has 3 ready replicas
READY_REPLICAS=$(kubectl get deployment efficient-app -n controlled -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

if [ "$READY_REPLICAS" -ne 3 ]; then
  echo "Deployment 'efficient-app' should have 3 ready replicas, found $READY_REPLICAS"
  echo "You may need to delete some pods to make room for the deployment within the quota"
  exit 1
fi

echo "Success: Deployment 'efficient-app' is running with 3 ready replicas"
exit 0
