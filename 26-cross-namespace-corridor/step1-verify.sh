#!/bin/bash
set -euo pipefail

# Check if default-deny-ingress policy exists in api-gateway
if ! kubectl get networkpolicy default-deny-ingress -n api-gateway &>/dev/null; then
  echo "NetworkPolicy 'default-deny-ingress' not found in api-gateway namespace"
  exit 1
fi

# Check if default-deny-ingress policy exists in backend
if ! kubectl get networkpolicy default-deny-ingress -n backend &>/dev/null; then
  echo "NetworkPolicy 'default-deny-ingress' not found in backend namespace"
  exit 1
fi

echo "Default deny policies exist in both namespaces"
