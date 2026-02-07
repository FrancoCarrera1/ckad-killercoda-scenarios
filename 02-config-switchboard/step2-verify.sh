#!/bin/bash
set -euo pipefail

# Check if pod exists
if ! kubectl get pod webapp-staging -n staging &>/dev/null; then
  echo "❌ Pod 'webapp-staging' does not exist in namespace 'staging'"
  exit 1
fi

# Check if pod is running
POD_STATUS=$(kubectl get pod webapp-staging -n staging -o jsonpath='{.status.phase}')
if [[ "$POD_STATUS" != "Running" ]]; then
  echo "❌ Pod 'webapp-staging' is not running (status: $POD_STATUS)"
  exit 1
fi

# Wait a bit for the pod to be fully ready
sleep 2

# Check if environment variable DB_HOST is set correctly
DB_HOST=$(kubectl exec webapp-staging -n staging -- sh -c 'echo $DB_HOST' 2>/dev/null || echo "")
if [[ "$DB_HOST" != "staging-db.internal" ]]; then
  echo "❌ Environment variable DB_HOST is not set correctly (expected: staging-db.internal, found: $DB_HOST)"
  exit 1
fi

# Check if envFrom is used in pod spec (not individual env vars)
HAS_ENVFROM=$(kubectl get pod webapp-staging -n staging -o jsonpath='{.spec.containers[0].envFrom}')
if [[ -z "$HAS_ENVFROM" ]]; then
  echo "❌ Pod 'webapp-staging' does not use envFrom.configMapRef (use envFrom, not individual env vars)"
  exit 1
fi

echo "✅ Step 2 complete! ConfigMap injected as environment variables using envFrom."
exit 0
