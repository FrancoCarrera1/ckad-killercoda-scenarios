#!/bin/bash
set -euo pipefail

# Check if frontend pod is Running
POD_STATUS=$(kubectl get pod frontend -n autopsy -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [ "$POD_STATUS" != "Running" ]; then
  echo "Frontend pod is not Running (current status: $POD_STATUS)"
  exit 1
fi

# Check if backend-svc Service exists
if ! kubectl get service backend-svc -n autopsy &>/dev/null; then
  echo "Service backend-svc does not exist in autopsy namespace"
  exit 1
fi

echo "Frontend pod is Running and backend-svc Service exists!"
