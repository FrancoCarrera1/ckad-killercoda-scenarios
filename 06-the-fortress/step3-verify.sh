#!/bin/bash
set -euo pipefail

# Check that root-pod exists in legacy-apps
LEGACY_POD=$(kubectl get pod root-pod -n legacy-apps --ignore-not-found -o jsonpath='{.metadata.name}')

if [ "$LEGACY_POD" != "root-pod" ]; then
  echo "Pod 'root-pod' should exist in legacy-apps namespace but was not found"
  exit 1
fi

# Check that root-pod does NOT exist in secure-apps
SECURE_POD=$(kubectl get pod root-pod -n secure-apps --ignore-not-found -o jsonpath='{.metadata.name}')

if [ "$SECURE_POD" = "root-pod" ]; then
  echo "Pod 'root-pod' should NOT exist in secure-apps namespace (it should have been rejected)"
  exit 1
fi

echo "Success: root-pod is running in legacy-apps but was correctly rejected in secure-apps"
exit 0
