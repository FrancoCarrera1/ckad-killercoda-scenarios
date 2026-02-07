#!/bin/bash
set -euo pipefail

# Check if pod has been restarted at least once
RESTART_COUNT=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.status.containerStatuses[0].restartCount}')
if [ "$RESTART_COUNT" -eq 0 ]; then
  echo "Pod has not been restarted yet (restartCount is 0)"
  exit 1
fi

# Check if pod is Ready again after restart
POD_READY=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
if [ "$POD_READY" != "True" ]; then
  echo "Pod has restarted but is not Ready yet"
  exit 1
fi

echo "Pod has been restarted (count: $RESTART_COUNT) and has recovered to Ready state!"
