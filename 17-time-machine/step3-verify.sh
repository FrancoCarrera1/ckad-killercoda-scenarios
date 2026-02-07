#!/bin/bash
set -euo pipefail

# Check image is nginx:1.24
IMAGE=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE" != "nginx:1.24" ]; then
  echo "Expected image nginx:1.24, found $IMAGE"
  exit 1
fi

# Check rollout is complete
READY=$(kubectl get deployment payment-service -n payments -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "3" ]; then
  echo "Expected 3 ready replicas, found $READY"
  exit 1
fi

echo "Step 3 verification passed! Successfully rolled back to nginx:1.24."
exit 0
