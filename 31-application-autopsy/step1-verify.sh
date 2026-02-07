#!/bin/bash
set -euo pipefail

# Check if database pod is Running
POD_STATUS=$(kubectl get pod database -n autopsy -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [ "$POD_STATUS" != "Running" ]; then
  echo "Database pod is not Running (current status: $POD_STATUS)"
  exit 1
fi

echo "Database pod is Running!"
