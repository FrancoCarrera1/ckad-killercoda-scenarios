#!/bin/bash
set -euo pipefail

# Check if custom-token-pod exists and is running
POD_STATUS=$(kubectl get pod custom-token-pod -n identity-lab -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")

if [ "$POD_STATUS" = "NotFound" ]; then
  echo "Pod 'custom-token-pod' not found in identity-lab namespace"
  exit 1
fi

if [ "$POD_STATUS" != "Running" ]; then
  echo "Pod 'custom-token-pod' exists but is not running (status: $POD_STATUS)"
  exit 1
fi

# Verify the projected volume is configured
VOLUME_TYPE=$(kubectl get pod custom-token-pod -n identity-lab -o jsonpath='{.spec.volumes[?(@.name=="custom-token")].projected}' 2>/dev/null)

if [ -z "$VOLUME_TYPE" ]; then
  echo "Pod 'custom-token-pod' should have a projected volume named 'custom-token'"
  exit 1
fi

echo "Success: custom-token-pod is running with projected volume"
exit 0
