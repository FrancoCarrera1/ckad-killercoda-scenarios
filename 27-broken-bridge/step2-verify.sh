#!/bin/bash
set -euo pipefail

# Check Service selector is correct
SELECTOR=$(kubectl get svc webapp-svc -n broken-bridge -o jsonpath='{.spec.selector.app}')
if [ "$SELECTOR" != "webapp" ]; then
  echo "Service selector is still incorrect. Expected 'webapp', got '$SELECTOR'"
  exit 1
fi

# Check Service targetPort is correct
TARGET_PORT=$(kubectl get svc webapp-svc -n broken-bridge -o jsonpath='{.spec.ports[0].targetPort}')
if [ "$TARGET_PORT" != "80" ]; then
  echo "Service targetPort is still incorrect. Expected '80', got '$TARGET_PORT'"
  exit 1
fi

# Check that endpoints exist (not empty)
ENDPOINTS=$(kubectl get endpoints webapp-svc -n broken-bridge -o jsonpath='{.subsets[0].addresses}')
if [ -z "$ENDPOINTS" ] || [ "$ENDPOINTS" == "null" ]; then
  echo "Service endpoints are still empty. The selector or targetPort may still be wrong."
  exit 1
fi

echo "Service bugs fixed! Selector and targetPort are correct, and endpoints are populated."
exit 0
