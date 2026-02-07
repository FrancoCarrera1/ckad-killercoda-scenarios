#!/bin/bash
set -euo pipefail

# Check Deployment exists
if ! kubectl get deployment bookshelf-app -n bookshelf &>/dev/null; then
  echo "Deployment bookshelf-app not found in namespace bookshelf"
  exit 1
fi

# Check pod is running
POD_READY=$(kubectl get deployment bookshelf-app -n bookshelf -o jsonpath='{.status.readyReplicas}')
if [ -z "$POD_READY" ] || [ "$POD_READY" -lt "1" ]; then
  echo "No ready pods found for bookshelf-app deployment"
  exit 1
fi

# Check PVC is Bound
PVC_STATUS=$(kubectl get pvc bookshelf-pvc -n bookshelf -o jsonpath='{.status.phase}')
if [ "$PVC_STATUS" != "Bound" ]; then
  echo "PVC is not bound yet. Status: $PVC_STATUS"
  exit 1
fi

# Check test file exists
POD_NAME=$(kubectl get pods -n bookshelf -l app=bookshelf -o jsonpath='{.items[0].metadata.name}')
if [ -z "$POD_NAME" ]; then
  echo "No pod found for bookshelf-app"
  exit 1
fi

FILE_CONTENT=$(kubectl exec $POD_NAME -n bookshelf -- cat /usr/share/nginx/html/books/book1.txt 2>/dev/null || echo "not found")
if [[ ! "$FILE_CONTENT" =~ "Kubernetes In Action" ]]; then
  echo "Test file not found or has wrong content: $FILE_CONTENT"
  exit 1
fi

echo "Deployment running with persistent storage!"
exit 0
