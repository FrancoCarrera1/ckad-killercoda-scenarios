#!/bin/bash
set -euo pipefail

# Check if ConfigMap exists
if ! kubectl get configmap canary-page -n canary-test &>/dev/null; then
  echo "ConfigMap 'canary-page' does not exist in namespace 'canary-test'"
  exit 1
fi

# Check if Deployment exists
if ! kubectl get deployment frontend-canary -n canary-test &>/dev/null; then
  echo "Deployment 'frontend-canary' does not exist in namespace 'canary-test'"
  exit 1
fi

# Check if Deployment has 1 ready replica
READY_REPLICAS=$(kubectl get deployment frontend-canary -n canary-test -o jsonpath='{.status.readyReplicas}')
if [ "$READY_REPLICAS" != "1" ]; then
  echo "Deployment 'frontend-canary' does not have 1 ready replica (found: $READY_REPLICAS)"
  exit 1
fi

# Check if pod has correct labels
CANARY_PODS=$(kubectl get pods -n canary-test -l app=frontend,track=canary --no-headers | wc -l)
if [ "$CANARY_PODS" != "1" ]; then
  echo "Expected 1 pod with labels app=frontend,track=canary (found: $CANARY_PODS)"
  exit 1
fi

# Check if Service now has 5 endpoints total (4 stable + 1 canary)
ENDPOINT_COUNT=$(kubectl get endpoints frontend-svc -n canary-test -o jsonpath='{.subsets[0].addresses[*].ip}' | wc -w)
if [ "$ENDPOINT_COUNT" != "5" ]; then
  echo "Service 'frontend-svc' should have 5 endpoints (4 stable + 1 canary, found: $ENDPOINT_COUNT)"
  exit 1
fi

# Verify canary image is nginx:1.25
CANARY_IMAGE=$(kubectl get deployment frontend-canary -n canary-test -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$CANARY_IMAGE" != "nginx:1.25" ]; then
  echo "Canary deployment should use image nginx:1.25 (found: $CANARY_IMAGE)"
  exit 1
fi

echo "Verification passed: Canary deployment exists with 1 replica, Service has 5 endpoints total"
exit 0
