#!/bin/bash
set -euo pipefail

# Check if CronJob exists
if ! kubectl get cronjob record-archiver -n data-pipeline &>/dev/null; then
  echo "CronJob record-archiver not found in namespace data-pipeline"
  exit 1
fi

# Verify schedule
SCHEDULE=$(kubectl get cronjob record-archiver -n data-pipeline -o jsonpath='{.spec.schedule}')
if [ "$SCHEDULE" != "*/15 * * * *" ]; then
  echo "Expected schedule: */15 * * * *, got: $SCHEDULE"
  exit 1
fi

# Verify concurrencyPolicy
POLICY=$(kubectl get cronjob record-archiver -n data-pipeline -o jsonpath='{.spec.concurrencyPolicy}')
if [ "$POLICY" != "Forbid" ]; then
  echo "Expected concurrencyPolicy: Forbid, got: $POLICY"
  exit 1
fi

# Verify successfulJobsHistoryLimit
SUCCESS_LIMIT=$(kubectl get cronjob record-archiver -n data-pipeline -o jsonpath='{.spec.successfulJobsHistoryLimit}')
if [ "$SUCCESS_LIMIT" != "3" ]; then
  echo "Expected successfulJobsHistoryLimit: 3, got: $SUCCESS_LIMIT"
  exit 1
fi

# Verify failedJobsHistoryLimit
FAILED_LIMIT=$(kubectl get cronjob record-archiver -n data-pipeline -o jsonpath='{.spec.failedJobsHistoryLimit}')
if [ "$FAILED_LIMIT" != "1" ]; then
  echo "Expected failedJobsHistoryLimit: 1, got: $FAILED_LIMIT"
  exit 1
fi

echo "CronJob record-archiver configured correctly!"
exit 0
