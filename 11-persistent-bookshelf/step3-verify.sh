#!/bin/bash
set -euo pipefail

# Get current pod name
POD_NAME=$(kubectl get pods -n bookshelf -l app=bookshelf -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD_NAME" ]; then
  echo "No pod found for bookshelf-app"
  exit 1
fi

# Check pod is running
POD_PHASE=$(kubectl get pod $POD_NAME -n bookshelf -o jsonpath='{.status.phase}')
if [ "$POD_PHASE" != "Running" ]; then
  echo "Pod is not running. Phase: $POD_PHASE"
  exit 1
fi

# Verify the data still exists
FILE_CONTENT=$(kubectl exec $POD_NAME -n bookshelf -- cat /usr/share/nginx/html/books/book1.txt 2>/dev/null || echo "not found")

if [[ ! "$FILE_CONTENT" =~ "Kubernetes In Action" ]]; then
  echo "Data persistence failed! File content: $FILE_CONTENT"
  exit 1
fi

# Additional check: verify PVC is still bound
PVC_STATUS=$(kubectl get pvc bookshelf-pvc -n bookshelf -o jsonpath='{.status.phase}')
if [ "$PVC_STATUS" != "Bound" ]; then
  echo "PVC is not bound. Status: $PVC_STATUS"
  exit 1
fi

echo "Data persistence verified successfully!"
exit 0
