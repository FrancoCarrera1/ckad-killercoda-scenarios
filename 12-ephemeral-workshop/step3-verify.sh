#!/bin/bash
set -euo pipefail

# Check if ConfigMap exists
if ! kubectl get configmap template-config -n workshop &>/dev/null; then
  echo "ConfigMap 'template-config' does not exist in namespace 'workshop'"
  exit 1
fi

# Check if pod exists
if ! kubectl get pod template-renderer -n workshop &>/dev/null; then
  echo "Pod 'template-renderer' does not exist in namespace 'workshop'"
  exit 1
fi

# Check if pod is running
POD_STATUS=$(kubectl get pod template-renderer -n workshop -o jsonpath='{.status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
  echo "Pod 'template-renderer' is not running (current status: $POD_STATUS)"
  exit 1
fi

# Check if init container completed successfully
INIT_STATUS=$(kubectl get pod template-renderer -n workshop -o jsonpath='{.status.initContainerStatuses[0].state.terminated.reason}')
if [ "$INIT_STATUS" != "Completed" ]; then
  echo "Init container 'renderer' did not complete successfully (status: $INIT_STATUS)"
  exit 1
fi

# Check if the rendered file exists
if ! kubectl exec template-renderer -n workshop -- test -f /usr/share/nginx/html/index.html 2>/dev/null; then
  echo "Rendered file /usr/share/nginx/html/index.html does not exist"
  exit 1
fi

# Check if the rendered content contains "Hello Kubernetes"
RENDERED_CONTENT=$(kubectl exec template-renderer -n workshop -- cat /usr/share/nginx/html/index.html 2>/dev/null)
if ! echo "$RENDERED_CONTENT" | grep -q "Hello Kubernetes"; then
  echo "Rendered content does not contain 'Hello Kubernetes'"
  echo "Found: $RENDERED_CONTENT"
  exit 1
fi

# Verify that the placeholder was replaced (should not contain {{NAME}})
if echo "$RENDERED_CONTENT" | grep -q "{{NAME}}"; then
  echo "Template placeholder {{NAME}} was not replaced"
  exit 1
fi

echo "Verification passed: Pod is running with rendered template containing 'Hello Kubernetes'"
exit 0
