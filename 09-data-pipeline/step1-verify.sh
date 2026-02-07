#!/bin/bash
set -euo pipefail

# Check if Job exists
if ! kubectl get job data-processor -n data-pipeline &>/dev/null; then
  echo "Job data-processor not found in namespace data-pipeline"
  exit 1
fi

# Verify completions
COMPLETIONS=$(kubectl get job data-processor -n data-pipeline -o jsonpath='{.spec.completions}')
if [ "$COMPLETIONS" != "6" ]; then
  echo "Expected completions: 6, got: $COMPLETIONS"
  exit 1
fi

# Verify parallelism
PARALLELISM=$(kubectl get job data-processor -n data-pipeline -o jsonpath='{.spec.parallelism}')
if [ "$PARALLELISM" != "3" ]; then
  echo "Expected parallelism: 3, got: $PARALLELISM"
  exit 1
fi

# Verify backoffLimit
BACKOFF=$(kubectl get job data-processor -n data-pipeline -o jsonpath='{.spec.backoffLimit}')
if [ "$BACKOFF" != "2" ]; then
  echo "Expected backoffLimit: 2, got: $BACKOFF"
  exit 1
fi

# Verify activeDeadlineSeconds
DEADLINE=$(kubectl get job data-processor -n data-pipeline -o jsonpath='{.spec.activeDeadlineSeconds}')
if [ "$DEADLINE" != "120" ]; then
  echo "Expected activeDeadlineSeconds: 120, got: $DEADLINE"
  exit 1
fi

echo "Job data-processor configured correctly!"
exit 0
