#!/bin/bash
set -euo pipefail

# Check rollout history exists and has at least 2 revisions
REVISIONS=$(kubectl rollout history deployment/payment-service -n payments | grep -c "^[0-9]" || true)
if [ "$REVISIONS" -lt 2 ]; then
  echo "Expected at least 2 revisions in rollout history, found $REVISIONS"
  exit 1
fi

echo "Step 3 verification passed!"
exit 0
