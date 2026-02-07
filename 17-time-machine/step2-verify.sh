#!/bin/bash
set -euo pipefail

# Check all replicas are ready
READY=$(kubectl get deployment payment-service -n payments -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "3" ]; then
  echo "Expected 3 ready replicas, found $READY"
  exit 1
fi

# Check image is nginx:1.25
IMAGE=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE" != "nginx:1.25" ]; then
  echo "Expected image nginx:1.25, found $IMAGE"
  exit 1
fi

echo "Step 2 verification passed! Service restored to nginx:1.25."
exit 0
