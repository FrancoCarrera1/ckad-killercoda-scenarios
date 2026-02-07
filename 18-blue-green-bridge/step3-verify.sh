#!/bin/bash
set -euo pipefail

# Check service now selects version=green
SELECTOR=$(kubectl get service webapp-svc -n web-app -o jsonpath='{.spec.selector.version}')
if [ "$SELECTOR" != "green" ]; then
  echo "Service should now select version=green, found version=$SELECTOR"
  exit 1
fi

# Check blue deployment is scaled to 0
BLUE_REPLICAS=$(kubectl get deployment webapp-blue -n web-app -o jsonpath='{.spec.replicas}')
if [ "$BLUE_REPLICAS" != "0" ]; then
  echo "Blue deployment should be scaled to 0 replicas, found $BLUE_REPLICAS"
  exit 1
fi

# Check green is still running with 3 replicas
GREEN_READY=$(kubectl get deployment webapp-green -n web-app -o jsonpath='{.status.readyReplicas}')
if [ "$GREEN_READY" != "3" ]; then
  echo "Expected 3 ready replicas for webapp-green, found $GREEN_READY"
  exit 1
fi

echo "Step 3 verification passed! Traffic switched to green, blue scaled down."
exit 0
