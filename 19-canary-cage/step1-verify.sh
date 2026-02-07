#!/bin/bash
set -euo pipefail

# Check if ConfigMap exists
if ! kubectl get configmap stable-page -n canary-test &>/dev/null; then
  echo "ConfigMap 'stable-page' does not exist in namespace 'canary-test'"
  exit 1
fi

# Check if Deployment exists
if ! kubectl get deployment frontend-stable -n canary-test &>/dev/null; then
  echo "Deployment 'frontend-stable' does not exist in namespace 'canary-test'"
  exit 1
fi

# Check if Deployment has 4 ready replicas
READY_REPLICAS=$(kubectl get deployment frontend-stable -n canary-test -o jsonpath='{.status.readyReplicas}')
if [ "$READY_REPLICAS" != "4" ]; then
  echo "Deployment 'frontend-stable' does not have 4 ready replicas (found: $READY_REPLICAS)"
  exit 1
fi

# Check if pods have correct labels
STABLE_PODS=$(kubectl get pods -n canary-test -l app=frontend,track=stable --no-headers | wc -l)
if [ "$STABLE_PODS" != "4" ]; then
  echo "Expected 4 pods with labels app=frontend,track=stable (found: $STABLE_PODS)"
  exit 1
fi

# Check if Service exists
if ! kubectl get service frontend-svc -n canary-test &>/dev/null; then
  echo "Service 'frontend-svc' does not exist in namespace 'canary-test'"
  exit 1
fi

# Check if Service selector is correct (should only have app=frontend)
SERVICE_SELECTOR=$(kubectl get service frontend-svc -n canary-test -o jsonpath='{.spec.selector}')
if ! echo "$SERVICE_SELECTOR" | jq -e '.app == "frontend"' &>/dev/null; then
  echo "Service selector must include 'app: frontend'"
  exit 1
fi

# Ensure Service does NOT select on track label (important for canary)
if echo "$SERVICE_SELECTOR" | jq -e 'has("track")' &>/dev/null; then
  echo "Service selector should NOT include 'track' label (it should only select 'app: frontend')"
  exit 1
fi

# Check if Service has correct number of endpoints (should be 4 from stable deployment)
ENDPOINT_COUNT=$(kubectl get endpoints frontend-svc -n canary-test -o jsonpath='{.subsets[0].addresses[*].ip}' | wc -w)
if [ "$ENDPOINT_COUNT" != "4" ]; then
  echo "Service 'frontend-svc' should have 4 endpoints (found: $ENDPOINT_COUNT)"
  exit 1
fi

echo "Verification passed: Stable deployment with 4 replicas and Service exists"
exit 0
