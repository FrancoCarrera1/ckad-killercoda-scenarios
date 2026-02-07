#!/bin/bash
set -euo pipefail

# Check if pod exists and is running
if ! kubectl get pod memory-cache -n workshop &>/dev/null; then
  echo "Pod 'memory-cache' does not exist in namespace 'workshop'"
  exit 1
fi

POD_STATUS=$(kubectl get pod memory-cache -n workshop -o jsonpath='{.status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
  echo "Pod 'memory-cache' is not running (current status: $POD_STATUS)"
  exit 1
fi

# Check if the volume is configured correctly
VOLUME_MEDIUM=$(kubectl get pod memory-cache -n workshop -o jsonpath='{.spec.volumes[?(@.name=="cache")].emptyDir.medium}')
if [ "$VOLUME_MEDIUM" != "Memory" ]; then
  echo "Volume 'cache' is not memory-backed (medium: $VOLUME_MEDIUM)"
  exit 1
fi

VOLUME_SIZE=$(kubectl get pod memory-cache -n workshop -o jsonpath='{.spec.volumes[?(@.name=="cache")].emptyDir.sizeLimit}')
if [ "$VOLUME_SIZE" != "64Mi" ]; then
  echo "Volume 'cache' size limit is incorrect (expected: 64Mi, got: $VOLUME_SIZE)"
  exit 1
fi

# Check if the volume is mounted correctly
MOUNT_PATH=$(kubectl get pod memory-cache -n workshop -o jsonpath='{.spec.containers[0].volumeMounts[?(@.name=="cache")].mountPath}')
if [ "$MOUNT_PATH" != "/cache" ]; then
  echo "Volume 'cache' is not mounted at /cache (mountPath: $MOUNT_PATH)"
  exit 1
fi

echo "Verification passed: Pod is running with memory-backed emptyDir volume"
exit 0
