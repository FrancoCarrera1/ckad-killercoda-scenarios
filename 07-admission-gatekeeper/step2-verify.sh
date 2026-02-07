#!/bin/bash
set -euo pipefail

# Check if ResourceQuota exists
if ! kubectl get resourcequota compute-quota -n quota-lab &>/dev/null; then
  echo "ResourceQuota 'compute-quota' not found in quota-lab namespace"
  exit 1
fi

# Check if LimitRange exists
if ! kubectl get limitrange compute-limits -n quota-lab &>/dev/null; then
  echo "LimitRange 'compute-limits' not found in quota-lab namespace"
  echo "You need a LimitRange to provide default resources so new pods aren't rejected by the quota"
  exit 1
fi

# Check that all 3 pods exist
for i in 1 2 3; do
  if ! kubectl get pod app-$i -n quota-lab &>/dev/null; then
    echo "Pod 'app-$i' not found in quota-lab namespace"
    exit 1
  fi
done

# Check that pods have resource requests (meaning they were recreated)
CPU_REQUEST=$(kubectl get pod app-1 -n quota-lab -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null || echo "")

if [ -z "$CPU_REQUEST" ]; then
  echo "Pod 'app-1' has no CPU request. Did you recreate the pods after creating the LimitRange?"
  echo "Delete the pods and recreate them so resources are tracked by the quota."
  exit 1
fi

# Verify quota is tracking usage
USED_PODS=$(kubectl get resourcequota compute-quota -n quota-lab -o jsonpath='{.status.used.pods}' 2>/dev/null || echo "0")
if [ "$USED_PODS" -lt 3 ]; then
  echo "ResourceQuota shows $USED_PODS pods used, expected at least 3"
  exit 1
fi

echo "Success: ResourceQuota and LimitRange configured, pods have resources and quota is tracking usage"
exit 0
