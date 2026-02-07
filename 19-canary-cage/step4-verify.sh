#!/bin/bash
set -euo pipefail

# Check that stable deployment is scaled to 0
STABLE_REPLICAS=$(kubectl get deployment frontend-stable -n canary-test -o jsonpath='{.spec.replicas}')
STABLE_READY=$(kubectl get deployment frontend-stable -n canary-test -o jsonpath='{.status.readyReplicas}')

if [ "$STABLE_REPLICAS" != "0" ]; then
  echo "Stable deployment should be scaled to 0 replicas (found: $STABLE_REPLICAS)"
  exit 1
fi

# Note: readyReplicas might be null/empty when scaled to 0, so we check for 0 or empty
if [ ! -z "$STABLE_READY" ] && [ "$STABLE_READY" != "0" ]; then
  echo "Stable deployment should have 0 ready replicas (found: $STABLE_READY)"
  exit 1
fi

# Check that canary deployment is scaled to 5
CANARY_REPLICAS=$(kubectl get deployment frontend-canary -n canary-test -o jsonpath='{.spec.replicas}')
CANARY_READY=$(kubectl get deployment frontend-canary -n canary-test -o jsonpath='{.status.readyReplicas}')

if [ "$CANARY_REPLICAS" != "5" ]; then
  echo "Canary deployment should be scaled to 5 replicas (found: $CANARY_REPLICAS)"
  exit 1
fi

if [ "$CANARY_READY" != "5" ]; then
  echo "Canary deployment should have 5 ready replicas (found: $CANARY_READY)"
  exit 1
fi

# Verify Service has 5 endpoints (all from canary)
ENDPOINT_COUNT=$(kubectl get endpoints frontend-svc -n canary-test -o jsonpath='{.subsets[0].addresses[*].ip}' | wc -w)
if [ "$ENDPOINT_COUNT" != "5" ]; then
  echo "Service should have 5 endpoints (all canary, found: $ENDPOINT_COUNT)"
  exit 1
fi

# Verify no stable pods are running
STABLE_PODS=$(kubectl get pods -n canary-test -l track=stable --no-headers 2>/dev/null | wc -l)
if [ "$STABLE_PODS" != "0" ]; then
  echo "No stable pods should be running (found: $STABLE_PODS)"
  exit 1
fi

# Verify 5 canary pods are running
CANARY_PODS=$(kubectl get pods -n canary-test -l track=canary --no-headers | wc -l)
if [ "$CANARY_PODS" != "5" ]; then
  echo "5 canary pods should be running (found: $CANARY_PODS)"
  exit 1
fi

echo "Verification passed: Stable scaled to 0, Canary scaled to 5 (promotion complete)"
exit 0
