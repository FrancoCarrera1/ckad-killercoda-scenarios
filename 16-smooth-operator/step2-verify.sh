#!/bin/bash
set -euo pipefail

# Check image is nginx:1.25
IMAGE=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE" != "nginx:1.25" ]; then
  echo "Expected image nginx:1.25, found $IMAGE"
  exit 1
fi

# Check rollout is complete
READY=$(kubectl get deployment payment-service -n payments -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "4" ]; then
  echo "Expected 4 ready replicas, found $READY"
  exit 1
fi

# Check updated replicas
UPDATED=$(kubectl get deployment payment-service -n payments -o jsonpath='{.status.updatedReplicas}')
if [ "$UPDATED" != "4" ]; then
  echo "Expected 4 updated replicas, found $UPDATED"
  exit 1
fi

echo "Step 2 verification passed!"
exit 0
