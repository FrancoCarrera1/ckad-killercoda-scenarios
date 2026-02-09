#!/bin/bash
set -euo pipefail

# Check if pod exists
if ! kubectl get pod secure-app -n vault &>/dev/null; then
  echo "❌ Pod 'secure-app' does not exist in namespace 'vault'"
  exit 1
fi

# Check if pod is running
POD_STATUS=$(kubectl get pod secure-app -n vault -o jsonpath='{.status.phase}')
if [[ "$POD_STATUS" != "Running" ]]; then
  echo "❌ Pod 'secure-app' is not running (status: $POD_STATUS)"
  echo "Check pod events: kubectl describe pod secure-app -n vault"
  exit 1
fi

# Check if secret volume is mounted
VOLUME_NAME=$(kubectl get pod secure-app -n vault -o jsonpath='{.spec.volumes[?(@.secret.secretName=="app-credentials")].name}')
if [[ -z "$VOLUME_NAME" ]]; then
  echo "❌ Pod 'secure-app' does not have a volume using secret 'app-credentials'"
  exit 1
fi

# Check imagePullSecrets
IMAGE_PULL_SECRET=$(kubectl get pod secure-app -n vault -o jsonpath='{.spec.imagePullSecrets[0].name}')
if [[ "$IMAGE_PULL_SECRET" != "registry-creds" ]]; then
  echo "❌ Pod 'secure-app' does not use imagePullSecret 'registry-creds' (found: $IMAGE_PULL_SECRET)"
  exit 1
fi

echo "✅ Step 2 complete! Pod deployed with correct secret configuration."
exit 0
