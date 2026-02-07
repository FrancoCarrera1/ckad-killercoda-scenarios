#!/bin/bash
set -euo pipefail

# Check if auto-mount-pod exists and is running
AUTO_POD_STATUS=$(kubectl get pod auto-mount-pod -n identity-lab -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [ "$AUTO_POD_STATUS" != "Running" ]; then
  echo "Pod 'auto-mount-pod' should be running in identity-lab namespace"
  exit 1
fi

# Check if no-mount-pod exists and is running
NO_MOUNT_POD_STATUS=$(kubectl get pod no-mount-pod -n identity-lab -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [ "$NO_MOUNT_POD_STATUS" != "Running" ]; then
  echo "Pod 'no-mount-pod' should be running in identity-lab namespace"
  exit 1
fi

# Verify auto-mount-pod has the token
if kubectl exec auto-mount-pod -n identity-lab -- test -f /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null; then
  echo "✓ auto-mount-pod has token"
else
  echo "auto-mount-pod should have token at /var/run/secrets/kubernetes.io/serviceaccount/token"
  exit 1
fi

# Verify no-mount-pod does NOT have the token
if kubectl exec no-mount-pod -n identity-lab -- test -f /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null; then
  echo "no-mount-pod should NOT have token (automountServiceAccountToken should be false)"
  exit 1
else
  echo "✓ no-mount-pod does not have token"
fi

echo "Success: Token auto-mount behavior verified"
exit 0
