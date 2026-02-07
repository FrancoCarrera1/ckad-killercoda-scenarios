#!/bin/bash
set -euo pipefail

# Check if NetworkPolicy exists
if ! kubectl get networkpolicy allow-frontend-to-backend -n lockdown &>/dev/null; then
  echo "NetworkPolicy 'allow-frontend-to-backend' does not exist in namespace 'lockdown'"
  exit 1
fi

# Verify the policy selects tier=backend pods
POD_SELECTOR=$(kubectl get networkpolicy allow-frontend-to-backend -n lockdown -o jsonpath='{.spec.podSelector.matchLabels.tier}')
if [ "$POD_SELECTOR" != "backend" ]; then
  echo "NetworkPolicy should select pods with tier=backend"
  exit 1
fi

# Verify the policy has Ingress type
POLICY_TYPES=$(kubectl get networkpolicy allow-frontend-to-backend -n lockdown -o jsonpath='{.spec.policyTypes}')
if ! echo "$POLICY_TYPES" | grep -q "Ingress"; then
  echo "NetworkPolicy should have policyType 'Ingress'"
  exit 1
fi

# Verify the ingress rule allows from tier=frontend
FROM_SELECTOR=$(kubectl get networkpolicy allow-frontend-to-backend -n lockdown -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.tier}')
if [ "$FROM_SELECTOR" != "frontend" ]; then
  echo "NetworkPolicy should allow ingress from pods with tier=frontend"
  exit 1
fi

# Verify the ingress rule specifies port 8080
PORT=$(kubectl get networkpolicy allow-frontend-to-backend -n lockdown -o jsonpath='{.spec.ingress[0].ports[0].port}')
if [ "$PORT" != "8080" ]; then
  echo "NetworkPolicy should allow traffic on port 8080 (found: $PORT)"
  exit 1
fi

# Verify the protocol is TCP
PROTOCOL=$(kubectl get networkpolicy allow-frontend-to-backend -n lockdown -o jsonpath='{.spec.ingress[0].ports[0].protocol}')
if [ "$PROTOCOL" != "TCP" ]; then
  echo "NetworkPolicy should use TCP protocol (found: $PROTOCOL)"
  exit 1
fi

echo "Verification passed: NetworkPolicy allows frontend->backend on port 8080"
exit 0
