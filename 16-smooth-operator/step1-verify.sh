#!/bin/bash
set -euo pipefail

# Check deployment exists
if ! kubectl get deployment payment-service -n payments &>/dev/null; then
  echo "Deployment payment-service not found in payments namespace"
  exit 1
fi

# Check replica count
REPLICAS=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.replicas}')
if [ "$REPLICAS" != "4" ]; then
  echo "Expected 4 replicas, found $REPLICAS"
  exit 1
fi

# Check strategy type
STRATEGY=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.strategy.type}')
if [ "$STRATEGY" != "RollingUpdate" ]; then
  echo "Expected RollingUpdate strategy, found $STRATEGY"
  exit 1
fi

# Check maxUnavailable
MAX_UNAVAILABLE=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
if [ "$MAX_UNAVAILABLE" != "1" ]; then
  echo "Expected maxUnavailable=1, found $MAX_UNAVAILABLE"
  exit 1
fi

# Check maxSurge
MAX_SURGE=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
if [ "$MAX_SURGE" != "1" ]; then
  echo "Expected maxSurge=1, found $MAX_SURGE"
  exit 1
fi

# Check ready replicas
READY=$(kubectl get deployment payment-service -n payments -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "4" ]; then
  echo "Expected 4 ready replicas, found $READY"
  exit 1
fi

echo "Step 1 verification passed!"
exit 0
