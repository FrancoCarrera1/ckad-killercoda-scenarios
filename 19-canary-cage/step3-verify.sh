#!/bin/bash
set -euo pipefail

# Check that both deployments have running pods
STABLE_READY=$(kubectl get deployment frontend-stable -n canary-test -o jsonpath='{.status.readyReplicas}')
CANARY_READY=$(kubectl get deployment frontend-canary -n canary-test -o jsonpath='{.status.readyReplicas}')

if [ "$STABLE_READY" != "4" ]; then
  echo "Stable deployment should have 4 ready replicas (found: $STABLE_READY)"
  exit 1
fi

if [ "$CANARY_READY" != "1" ]; then
  echo "Canary deployment should have 1 ready replica (found: $CANARY_READY)"
  exit 1
fi

# Test traffic by making requests to the service
# Create a temporary pod to test traffic distribution
STABLE_COUNT=0
CANARY_COUNT=0

for i in {1..20}; do
  RESPONSE=$(kubectl run test-traffic-$i --image=curlimages/curl -n canary-test --rm --quiet --restart=Never -- curl -s http://frontend-svc 2>/dev/null || echo "error")

  if echo "$RESPONSE" | grep -q "Stable"; then
    STABLE_COUNT=$((STABLE_COUNT + 1))
  elif echo "$RESPONSE" | grep -q "Canary"; then
    CANARY_COUNT=$((CANARY_COUNT + 1))
  fi
done

# We expect roughly 80% stable, 20% canary
# Allow for variance - as long as we see BOTH versions, it's working
if [ "$STABLE_COUNT" -eq 0 ]; then
  echo "No requests reached stable version (expected ~16 out of 20)"
  exit 1
fi

if [ "$CANARY_COUNT" -eq 0 ]; then
  echo "No requests reached canary version (expected ~4 out of 20)"
  exit 1
fi

echo "Verification passed: Both deployments serving traffic (Stable: $STABLE_COUNT, Canary: $CANARY_COUNT out of 20 requests)"
exit 0
