#!/bin/bash
set -euo pipefail

# Check if pod exists
if ! kubectl get pod webapp-prod -n production &>/dev/null; then
  echo "❌ Pod 'webapp-prod' does not exist in namespace 'production'"
  exit 1
fi

# Check if pod is running
POD_STATUS=$(kubectl get pod webapp-prod -n production -o jsonpath='{.status.phase}')
if [[ "$POD_STATUS" != "Running" ]]; then
  echo "❌ Pod 'webapp-prod' is not running (status: $POD_STATUS)"
  exit 1
fi

# Wait a bit for the pod to be fully ready
sleep 2

# Check if the file exists
if ! kubectl exec webapp-prod -n production -- test -f /etc/app-config/DB_HOST 2>/dev/null; then
  echo "❌ File /etc/app-config/DB_HOST does not exist in pod 'webapp-prod'"
  exit 1
fi

# Check file content
DB_HOST_CONTENT=$(kubectl exec webapp-prod -n production -- cat /etc/app-config/DB_HOST 2>/dev/null || echo "")
if [[ "$DB_HOST_CONTENT" != "prod-db.internal" ]]; then
  echo "❌ File /etc/app-config/DB_HOST has incorrect content (expected: prod-db.internal, found: $DB_HOST_CONTENT)"
  exit 1
fi

# Verify volume mount is used (not envFrom)
HAS_VOLUME=$(kubectl get pod webapp-prod -n production -o jsonpath='{.spec.volumes[?(@.configMap.name=="app-config")].name}')
if [[ -z "$HAS_VOLUME" ]]; then
  echo "❌ Pod 'webapp-prod' does not mount ConfigMap 'app-config' as a volume"
  exit 1
fi

echo "✅ Step 3 complete! ConfigMap mounted as volume with correct content."
exit 0
