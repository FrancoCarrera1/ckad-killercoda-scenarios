#!/bin/bash
set -euo pipefail

# Wait a moment for pod to be ready
sleep 2

# Check pod is running
POD_PHASE=$(kubectl get pod webapp -n microservices -o jsonpath='{.status.phase}')
if [ "$POD_PHASE" != "Running" ]; then
  echo "Pod is not running. Phase: $POD_PHASE"
  exit 1
fi

# Check 2/2 containers ready
READY=$(kubectl get pod webapp -n microservices -o jsonpath='{.status.containerStatuses[?(@.ready==true)]' | jq '. | length')
if [ "$READY" != "2" ]; then
  echo "Expected 2/2 containers ready, got: $READY"
  exit 1
fi

# Check init container completed
INIT_STATE=$(kubectl get pod webapp -n microservices -o jsonpath='{.status.initContainerStatuses[0].state}')
if [[ ! "$INIT_STATE" =~ "terminated" ]]; then
  echo "Init container has not completed yet"
  exit 1
fi

INIT_REASON=$(kubectl get pod webapp -n microservices -o jsonpath='{.status.initContainerStatuses[0].state.terminated.reason}')
if [ "$INIT_REASON" != "Completed" ]; then
  echo "Init container did not complete successfully. Reason: $INIT_REASON"
  exit 1
fi

echo "Pod ready and init container completed successfully!"
exit 0
