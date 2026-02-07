#!/bin/bash
set -euo pipefail

# Check StorageClass exists
if ! kubectl get storageclass local-fast &>/dev/null; then
  echo "StorageClass local-fast not found"
  exit 1
fi

# Verify StorageClass binding mode
BINDING_MODE=$(kubectl get storageclass local-fast -o jsonpath='{.volumeBindingMode}')
if [ "$BINDING_MODE" != "WaitForFirstConsumer" ]; then
  echo "Expected volumeBindingMode: WaitForFirstConsumer, got: $BINDING_MODE"
  exit 1
fi

# Check PersistentVolume exists
if ! kubectl get pv bookshelf-pv &>/dev/null; then
  echo "PersistentVolume bookshelf-pv not found"
  exit 1
fi

# Verify PV capacity
CAPACITY=$(kubectl get pv bookshelf-pv -o jsonpath='{.spec.capacity.storage}')
if [ "$CAPACITY" != "1Gi" ]; then
  echo "Expected PV capacity: 1Gi, got: $CAPACITY"
  exit 1
fi

# Verify PV access mode
ACCESS_MODE=$(kubectl get pv bookshelf-pv -o jsonpath='{.spec.accessModes[0]}')
if [ "$ACCESS_MODE" != "ReadWriteOnce" ]; then
  echo "Expected accessMode: ReadWriteOnce, got: $ACCESS_MODE"
  exit 1
fi

# Check PersistentVolumeClaim exists
if ! kubectl get pvc bookshelf-pvc -n bookshelf &>/dev/null; then
  echo "PersistentVolumeClaim bookshelf-pvc not found in namespace bookshelf"
  exit 1
fi

# Verify PVC storage request
STORAGE_REQUEST=$(kubectl get pvc bookshelf-pvc -n bookshelf -o jsonpath='{.spec.resources.requests.storage}')
if [ "$STORAGE_REQUEST" != "500Mi" ]; then
  echo "Expected PVC storage request: 500Mi, got: $STORAGE_REQUEST"
  exit 1
fi

# PVC can be Pending or Bound (WaitForFirstConsumer means it may be Pending)
PVC_STATUS=$(kubectl get pvc bookshelf-pvc -n bookshelf -o jsonpath='{.status.phase}')
if [ "$PVC_STATUS" != "Pending" ] && [ "$PVC_STATUS" != "Bound" ]; then
  echo "PVC is in unexpected state: $PVC_STATUS"
  exit 1
fi

echo "Storage resources created successfully!"
exit 0
