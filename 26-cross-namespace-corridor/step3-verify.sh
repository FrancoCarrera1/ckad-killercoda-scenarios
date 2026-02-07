#!/bin/bash
set -euo pipefail

# Check if monitoring NetworkPolicy exists in api-gateway
if ! kubectl get networkpolicy -n api-gateway -o json | jq -e '.items[] | select(.metadata.name == "allow-from-monitoring")' &>/dev/null; then
  echo "NetworkPolicy 'allow-from-monitoring' not found in api-gateway namespace"
  exit 1
fi

# Check if monitoring NetworkPolicy exists in backend
if ! kubectl get networkpolicy -n backend -o json | jq -e '.items[] | select(.metadata.name == "allow-from-monitoring")' &>/dev/null; then
  echo "NetworkPolicy 'allow-from-monitoring' not found in backend namespace"
  exit 1
fi

echo "NetworkPolicies exist allowing monitoring access to both namespaces"
