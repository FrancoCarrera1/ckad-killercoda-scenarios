#!/bin/bash
set -euo pipefail

# Check if backend pod is Running
POD_STATUS=$(kubectl get pod backend -n autopsy -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [ "$POD_STATUS" != "Running" ]; then
  echo "Backend pod is not Running (current status: $POD_STATUS)"
  exit 1
fi

echo "Backend pod is Running!"
