#!/bin/bash
set -euo pipefail

# Check if pod exists
if ! kubectl get pod webapp -n microservices &>/dev/null; then
  echo "Pod webapp not found in namespace microservices"
  exit 1
fi

# Check for init container
INIT_CONTAINERS=$(kubectl get pod webapp -n microservices -o jsonpath='{.spec.initContainers[*].name}')
if [[ ! "$INIT_CONTAINERS" =~ "wait-for-db" ]]; then
  echo "Init container wait-for-db not found"
  exit 1
fi

# Check for main containers
CONTAINERS=$(kubectl get pod webapp -n microservices -o jsonpath='{.spec.containers[*].name}')
if [[ ! "$CONTAINERS" =~ "app" ]] || [[ ! "$CONTAINERS" =~ "log-streamer" ]]; then
  echo "Expected containers 'app' and 'log-streamer' not found. Got: $CONTAINERS"
  exit 1
fi

# Check for shared volume
VOLUMES=$(kubectl get pod webapp -n microservices -o jsonpath='{.spec.volumes[*].name}')
if [[ ! "$VOLUMES" =~ "shared-logs" ]]; then
  echo "Volume shared-logs not found"
  exit 1
fi

# Verify pod has at least started (may not be fully ready yet, but should exist)
POD_PHASE=$(kubectl get pod webapp -n microservices -o jsonpath='{.status.phase}')
if [ "$POD_PHASE" != "Running" ] && [ "$POD_PHASE" != "Pending" ]; then
  echo "Pod is in unexpected phase: $POD_PHASE"
  exit 1
fi

echo "Pod webapp created with correct configuration!"
exit 0
