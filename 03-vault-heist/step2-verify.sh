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

# Check SecurityContext - runAsUser
RUN_AS_USER=$(kubectl get pod secure-app -n vault -o jsonpath='{.spec.containers[0].securityContext.runAsUser}')
if [[ "$RUN_AS_USER" != "1000" ]]; then
  echo "❌ Pod 'secure-app' does not have runAsUser=1000 (found: $RUN_AS_USER)"
  exit 1
fi

# Check SecurityContext - runAsGroup
RUN_AS_GROUP=$(kubectl get pod secure-app -n vault -o jsonpath='{.spec.containers[0].securityContext.runAsGroup}')
if [[ "$RUN_AS_GROUP" != "1000" ]]; then
  echo "❌ Pod 'secure-app' does not have runAsGroup=1000 (found: $RUN_AS_GROUP)"
  exit 1
fi

# Check SecurityContext - runAsNonRoot
RUN_AS_NON_ROOT=$(kubectl get pod secure-app -n vault -o jsonpath='{.spec.containers[0].securityContext.runAsNonRoot}')
if [[ "$RUN_AS_NON_ROOT" != "true" ]]; then
  echo "❌ Pod 'secure-app' does not have runAsNonRoot=true (found: $RUN_AS_NON_ROOT)"
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

echo "✅ Step 2 complete! Pod deployed with correct security settings and secrets."
exit 0
