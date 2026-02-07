#!/bin/bash
set -euo pipefail

# Check secure-apps namespace labels
SECURE_ENFORCE=$(kubectl get namespace secure-apps -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null || echo "")
SECURE_WARN=$(kubectl get namespace secure-apps -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/warn}' 2>/dev/null || echo "")

# Check legacy-apps namespace labels
LEGACY_ENFORCE=$(kubectl get namespace legacy-apps -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null || echo "")
LEGACY_WARN=$(kubectl get namespace legacy-apps -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/warn}' 2>/dev/null || echo "")

# Verify secure-apps
if [ "$SECURE_ENFORCE" != "restricted" ] || [ "$SECURE_WARN" != "restricted" ]; then
  echo "The secure-apps namespace needs both enforce and warn labels set to 'restricted'"
  exit 1
fi

# Verify legacy-apps
if [ "$LEGACY_ENFORCE" != "baseline" ] || [ "$LEGACY_WARN" != "baseline" ]; then
  echo "The legacy-apps namespace needs both enforce and warn labels set to 'baseline'"
  exit 1
fi

echo "Success: Both namespaces are properly labeled with Pod Security Standards"
exit 0
