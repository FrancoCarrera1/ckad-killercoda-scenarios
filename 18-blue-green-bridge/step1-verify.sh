#!/bin/bash
set -euo pipefail

# Check deployment exists
if ! kubectl get deployment webapp-blue -n web-app &>/dev/null; then
  echo "Deployment webapp-blue not found in web-app namespace"
  exit 1
fi

# Check 3 replicas are ready
READY=$(kubectl get deployment webapp-blue -n web-app -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "3" ]; then
  echo "Expected 3 ready replicas for webapp-blue, found $READY"
  exit 1
fi

# Check service exists
if ! kubectl get service webapp-svc -n web-app &>/dev/null; then
  echo "Service webapp-svc not found in web-app namespace"
  exit 1
fi

# Check service selector includes version=blue
SELECTOR=$(kubectl get service webapp-svc -n web-app -o jsonpath='{.spec.selector.version}')
if [ "$SELECTOR" != "blue" ]; then
  echo "Service selector should include version=blue, found version=$SELECTOR"
  exit 1
fi

# Check service selector includes app=webapp
APP_SELECTOR=$(kubectl get service webapp-svc -n web-app -o jsonpath='{.spec.selector.app}')
if [ "$APP_SELECTOR" != "webapp" ]; then
  echo "Service selector should include app=webapp, found app=$APP_SELECTOR"
  exit 1
fi

echo "Step 1 verification passed! Blue environment deployed."
exit 0
