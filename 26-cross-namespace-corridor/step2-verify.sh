#!/bin/bash
set -euo pipefail

# Check if NetworkPolicy exists in backend namespace
if ! kubectl get networkpolicy -n backend -o json | jq -e '.items[] | select(.spec.ingress != null and .spec.ingress != [])' &>/dev/null; then
  echo "NetworkPolicy allowing ingress from api-gateway namespace not found in backend namespace"
  exit 1
fi

# Check if the policy has a namespaceSelector
if ! kubectl get networkpolicy -n backend -o json | jq -e '.items[].spec.ingress[].from[]? | select(.namespaceSelector != null)' &>/dev/null; then
  echo "NetworkPolicy does not have a namespaceSelector for api-gateway namespace"
  exit 1
fi

echo "NetworkPolicy in backend allows ingress from api-gateway namespace"
