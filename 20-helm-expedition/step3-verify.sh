#!/bin/bash
set -euo pipefail

# Check if the release has been uninstalled
if helm list -n helm-lab | grep -q my-web; then
  echo "Release 'my-web' still exists. Please uninstall it with 'helm uninstall'."
  exit 1
fi

# Also check if any pods from the release are still running
pod_count=$(kubectl get pods -n helm-lab -l app.kubernetes.io/instance=my-web --no-headers 2>/dev/null | wc -l)
if [ "$pod_count" -gt 0 ]; then
  echo "Pods from release 'my-web' are still running. Please wait for cleanup to complete."
  exit 1
fi

echo "Success! Release 'my-web' has been properly uninstalled."
exit 0
