#!/bin/bash
set -euo pipefail

# Check deployment exists
if ! kubectl get deployment payment-service -n payments &>/dev/null; then
  echo "Deployment payment-service not found in payments namespace"
  exit 1
fi

# Verify the broken state exists (deployment should have the bad image)
IMAGE=$(kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$IMAGE" != *"1.99"* ]]; then
  echo "Deployment should still have the broken image (1.99) at this point"
  exit 1
fi

echo "Step 1 verification passed! You've identified the broken deployment."
exit 0
