#!/bin/bash
set -euo pipefail

# Check if NetworkPolicy exists
if ! kubectl get networkpolicy allow-backend-to-database -n lockdown &>/dev/null; then
  echo "NetworkPolicy 'allow-backend-to-database' does not exist in namespace 'lockdown'"
  exit 1
fi

# Verify the policy selects tier=database pods
POD_SELECTOR=$(kubectl get networkpolicy allow-backend-to-database -n lockdown -o jsonpath='{.spec.podSelector.matchLabels.tier}')
if [ "$POD_SELECTOR" != "database" ]; then
  echo "NetworkPolicy should select pods with tier=database"
  exit 1
fi

# Verify the policy has Ingress type
POLICY_TYPES=$(kubectl get networkpolicy allow-backend-to-database -n lockdown -o jsonpath='{.spec.policyTypes}')
if ! echo "$POLICY_TYPES" | grep -q "Ingress"; then
  echo "NetworkPolicy should have policyType 'Ingress'"
  exit 1
fi

# Verify the ingress rule allows from tier=backend
FROM_SELECTOR=$(kubectl get networkpolicy allow-backend-to-database -n lockdown -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.tier}')
if [ "$FROM_SELECTOR" != "backend" ]; then
  echo "NetworkPolicy should allow ingress from pods with tier=backend"
  exit 1
fi

# Verify the ingress rule specifies port 5432
PORT=$(kubectl get networkpolicy allow-backend-to-database -n lockdown -o jsonpath='{.spec.ingress[0].ports[0].port}')
if [ "$PORT" != "5432" ]; then
  echo "NetworkPolicy should allow traffic on port 5432 (found: $PORT)"
  exit 1
fi

# Verify the protocol is TCP
PROTOCOL=$(kubectl get networkpolicy allow-backend-to-database -n lockdown -o jsonpath='{.spec.ingress[0].ports[0].protocol}')
if [ "$PROTOCOL" != "TCP" ]; then
  echo "NetworkPolicy should use TCP protocol (found: $PROTOCOL)"
  exit 1
fi

echo "Verification passed: NetworkPolicy allows backend->database on port 5432"
exit 0
