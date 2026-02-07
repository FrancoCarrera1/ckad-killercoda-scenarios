#!/bin/bash
set -euo pipefail

# Check if ResourceQuota exists
if ! kubectl get resourcequota dev-quota -n dev-priya &>/dev/null; then
  echo "❌ ResourceQuota 'dev-quota' does not exist in namespace 'dev-priya'"
  exit 1
fi

# Check ResourceQuota values
CPU_QUOTA=$(kubectl get resourcequota dev-quota -n dev-priya -o jsonpath='{.spec.hard.requests\.cpu}')
MEMORY_QUOTA=$(kubectl get resourcequota dev-quota -n dev-priya -o jsonpath='{.spec.hard.requests\.memory}')
PODS_QUOTA=$(kubectl get resourcequota dev-quota -n dev-priya -o jsonpath='{.spec.hard.pods}')

if [[ "$CPU_QUOTA" != "2" ]]; then
  echo "❌ ResourceQuota 'dev-quota' has incorrect requests.cpu (expected: 2, found: $CPU_QUOTA)"
  exit 1
fi

if [[ "$MEMORY_QUOTA" != "2Gi" ]]; then
  echo "❌ ResourceQuota 'dev-quota' has incorrect requests.memory (expected: 2Gi, found: $MEMORY_QUOTA)"
  exit 1
fi

if [[ "$PODS_QUOTA" != "10" ]]; then
  echo "❌ ResourceQuota 'dev-quota' has incorrect pods limit (expected: 10, found: $PODS_QUOTA)"
  exit 1
fi

# Check if LimitRange exists
if ! kubectl get limitrange dev-limits -n dev-priya &>/dev/null; then
  echo "❌ LimitRange 'dev-limits' does not exist in namespace 'dev-priya'"
  exit 1
fi

# Check LimitRange values
DEFAULT_CPU=$(kubectl get limitrange dev-limits -n dev-priya -o jsonpath='{.spec.limits[0].default.cpu}')
DEFAULT_MEM=$(kubectl get limitrange dev-limits -n dev-priya -o jsonpath='{.spec.limits[0].default.memory}')
REQUEST_CPU=$(kubectl get limitrange dev-limits -n dev-priya -o jsonpath='{.spec.limits[0].defaultRequest.cpu}')
REQUEST_MEM=$(kubectl get limitrange dev-limits -n dev-priya -o jsonpath='{.spec.limits[0].defaultRequest.memory}')

if [[ "$DEFAULT_CPU" != "250m" ]]; then
  echo "❌ LimitRange 'dev-limits' has incorrect default cpu (expected: 250m, found: $DEFAULT_CPU)"
  exit 1
fi

if [[ "$DEFAULT_MEM" != "256Mi" ]]; then
  echo "❌ LimitRange 'dev-limits' has incorrect default memory (expected: 256Mi, found: $DEFAULT_MEM)"
  exit 1
fi

if [[ "$REQUEST_CPU" != "100m" ]]; then
  echo "❌ LimitRange 'dev-limits' has incorrect defaultRequest cpu (expected: 100m, found: $REQUEST_CPU)"
  exit 1
fi

if [[ "$REQUEST_MEM" != "128Mi" ]]; then
  echo "❌ LimitRange 'dev-limits' has incorrect defaultRequest memory (expected: 128Mi, found: $REQUEST_MEM)"
  exit 1
fi

echo "✅ Step 2 complete! ResourceQuota and LimitRange configured correctly."
exit 0
