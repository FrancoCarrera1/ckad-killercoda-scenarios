#!/bin/bash
set -euo pipefail

# Check if pod is Ready
POD_READY=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
if [ "$POD_READY" != "True" ]; then
  echo "Pod healthy-app is not Ready"
  exit 1
fi

# Check if Service has endpoints
ENDPOINTS=$(kubectl get endpoints healthy-svc -n health-lab -o jsonpath='{.subsets[*].addresses[*].ip}')
if [ -z "$ENDPOINTS" ]; then
  echo "Service healthy-svc has no endpoints"
  exit 1
fi

echo "Pod is Ready and Service has endpoints!"
