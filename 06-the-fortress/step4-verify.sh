#!/bin/bash
set -euo pipefail

# Verify that the compliant-nginx pod is still running
POD_STATUS=$(kubectl get pod compliant-nginx -n secure-apps -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")

if [ "$POD_STATUS" != "Running" ] && [ "$POD_STATUS" != "Succeeded" ]; then
  echo "The compliant-nginx pod should still be running in secure-apps"
  exit 1
fi

# Verify that root-pod is NOT in secure-apps (was rejected)
SECURE_POD=$(kubectl get pod root-pod -n secure-apps --ignore-not-found -o jsonpath='{.metadata.name}')

if [ "$SECURE_POD" = "root-pod" ]; then
  echo "The root-pod should not exist in secure-apps (it should have been rejected)"
  exit 1
fi

echo "Success: PSS enforcement is working correctly"
exit 0
