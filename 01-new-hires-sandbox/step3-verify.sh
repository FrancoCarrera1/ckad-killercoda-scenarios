#!/bin/bash
set -euo pipefail

# Check if nginx-test pod exists and is running
if ! kubectl get pod nginx-test -n dev-angelica &>/dev/null; then
  echo "❌ Pod 'nginx-test' does not exist in namespace 'dev-angelica'"
  exit 1
fi

POD_STATUS=$(kubectl get pod nginx-test -n dev-angelica -o jsonpath='{.status.phase}')
if [[ "$POD_STATUS" != "Running" ]]; then
  echo "❌ Pod 'nginx-test' is not running (status: $POD_STATUS)"
  exit 1
fi

# Check if pod uses the correct ServiceAccount
SA_NAME=$(kubectl get pod nginx-test -n dev-angelica -o jsonpath='{.spec.serviceAccountName}')
if [[ "$SA_NAME" != "angelica-sa" ]]; then
  echo "❌ Pod 'nginx-test' does not use ServiceAccount 'angelica-sa' (found: $SA_NAME)"
  exit 1
fi

# Check if LimitRange defaults were injected
LIMIT_CPU=$(kubectl get pod nginx-test -n dev-angelica -o jsonpath='{.spec.containers[0].resources.limits.cpu}')
LIMIT_MEM=$(kubectl get pod nginx-test -n dev-angelica -o jsonpath='{.spec.containers[0].resources.limits.memory}')
REQUEST_CPU=$(kubectl get pod nginx-test -n dev-angelica -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
REQUEST_MEM=$(kubectl get pod nginx-test -n dev-angelica -o jsonpath='{.spec.containers[0].resources.requests.memory}')

if [[ "$LIMIT_CPU" != "250m" ]]; then
  echo "❌ Pod 'nginx-test' does not have correct CPU limit (expected: 250m, found: $LIMIT_CPU)"
  exit 1
fi

if [[ "$LIMIT_MEM" != "256Mi" ]]; then
  echo "❌ Pod 'nginx-test' does not have correct memory limit (expected: 256Mi, found: $LIMIT_MEM)"
  exit 1
fi

if [[ "$REQUEST_CPU" != "100m" ]]; then
  echo "❌ Pod 'nginx-test' does not have correct CPU request (expected: 100m, found: $REQUEST_CPU)"
  exit 1
fi

if [[ "$REQUEST_MEM" != "128Mi" ]]; then
  echo "❌ Pod 'nginx-test' does not have correct memory request (expected: 128Mi, found: $REQUEST_MEM)"
  exit 1
fi

echo "✅ Step 3 complete! Pod running with correct defaults and ServiceAccount."
exit 0
