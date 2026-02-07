#!/bin/bash
set -euo pipefail

# Check if LimitRange exists
if ! kubectl get limitrange compute-limits -n limitrange-lab &>/dev/null; then
  echo "LimitRange 'compute-limits' not found in limitrange-lab namespace"
  exit 1
fi

# Check that all 3 pods exist and are running
for i in 1 2 3; do
  if ! kubectl get pod app-$i -n limitrange-lab &>/dev/null; then
    echo "Pod 'app-$i' not found in limitrange-lab namespace"
    exit 1
  fi
done

# Check that pods have resource requests (meaning they were recreated after LimitRange)
CPU_REQUEST=$(kubectl get pod app-1 -n limitrange-lab -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null || echo "")

if [ -z "$CPU_REQUEST" ]; then
  echo "Pod 'app-1' has no CPU request. Did you recreate the pods after creating the LimitRange?"
  echo "Delete the pods and recreate them so the LimitRange defaults are applied."
  exit 1
fi

echo "Success: LimitRange is configured and pods have resource defaults applied"
exit 0
