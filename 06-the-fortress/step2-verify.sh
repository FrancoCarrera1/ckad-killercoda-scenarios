#!/bin/bash
set -euo pipefail

# Check if the compliant-nginx pod exists and is running
POD_STATUS=$(kubectl get pod compliant-nginx -n secure-apps -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")

if [ "$POD_STATUS" = "NotFound" ]; then
  echo "Pod 'compliant-nginx' not found in secure-apps namespace"
  exit 1
fi

if [ "$POD_STATUS" != "Running" ] && [ "$POD_STATUS" != "Succeeded" ]; then
  echo "Pod 'compliant-nginx' exists but is not running (status: $POD_STATUS)"
  exit 1
fi

echo "Success: compliant-nginx pod is running in secure-apps namespace"
exit 0
