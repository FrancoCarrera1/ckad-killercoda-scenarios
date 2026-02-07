#!/bin/bash
set -euo pipefail

# Check green deployment exists
if ! kubectl get deployment webapp-green -n web-app &>/dev/null; then
  echo "Deployment webapp-green not found in web-app namespace"
  exit 1
fi

# Check 3 replicas are ready
READY=$(kubectl get deployment webapp-green -n web-app -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "3" ]; then
  echo "Expected 3 ready replicas for webapp-green, found $READY"
  exit 1
fi

# Check blue deployment still exists
if ! kubectl get deployment webapp-blue -n web-app &>/dev/null; then
  echo "Deployment webapp-blue should still exist"
  exit 1
fi

# Verify service STILL selects version=blue
SELECTOR=$(kubectl get service webapp-svc -n web-app -o jsonpath='{.spec.selector.version}')
if [ "$SELECTOR" != "blue" ]; then
  echo "Service should STILL select version=blue at this point, found version=$SELECTOR"
  exit 1
fi

echo "Step 2 verification passed! Green deployed alongside blue."
exit 0
