#!/bin/bash
set -euo pipefail

# Check if the Helm release exists
if ! helm list -n helm-lab | grep -q my-web; then
  echo "Helm release 'my-web' not found in namespace helm-lab."
  exit 1
fi

# Check if the deployment has 2 ready replicas
ready_replicas=$(kubectl get deployment -n helm-lab -l app.kubernetes.io/instance=my-web -o jsonpath='{.items[0].status.readyReplicas}' 2>/dev/null || echo "0")

if [ "$ready_replicas" != "2" ]; then
  echo "Expected 2 ready replicas, but found: $ready_replicas"
  echo "Please ensure the installation has replicaCount=2 and pods are ready."
  exit 1
fi

echo "Success! Release 'my-web' is installed with 2 ready replicas."
exit 0
