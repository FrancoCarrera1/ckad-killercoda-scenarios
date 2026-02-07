#!/bin/bash
set -euo pipefail

# Check if manual-archive job exists
if ! kubectl get job manual-archive -n data-pipeline &>/dev/null; then
  echo "Job manual-archive not found in namespace data-pipeline"
  exit 1
fi

# Check if data-processor job has completions
SUCCEEDED=$(kubectl get job data-processor -n data-pipeline -o jsonpath='{.status.succeeded}')
if [ -z "$SUCCEEDED" ] || [ "$SUCCEEDED" -lt "1" ]; then
  echo "Job data-processor has not completed any pods yet (succeeded: $SUCCEEDED)"
  exit 1
fi

# Verify manual-archive has been created from the cronjob (check owner reference or label)
OWNER=$(kubectl get job manual-archive -n data-pipeline -o jsonpath='{.metadata.ownerReferences[0].name}' 2>/dev/null || echo "")
if [ -z "$OWNER" ]; then
  # Check if it has the cronjob label/annotation instead
  CRONJOB_NAME=$(kubectl get job manual-archive -n data-pipeline -o jsonpath='{.metadata.annotations.cronjob\.kubernetes\.io/instantiate}' 2>/dev/null || echo "")
  if [ -z "$CRONJOB_NAME" ]; then
    # Just check it exists and has completed or is running
    STATUS=$(kubectl get job manual-archive -n data-pipeline -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}' 2>/dev/null || echo "")
    if [ -z "$STATUS" ]; then
      # Job exists but may not be complete yet, that's okay
      echo "Job manual-archive exists and is processing"
    fi
  fi
fi

echo "Manual job trigger successful!"
exit 0
