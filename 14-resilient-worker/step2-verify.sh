#!/bin/bash
set -euo pipefail

# Check if Job exists
if ! kubectl get job flaky-worker -n batch-processing >/dev/null 2>&1; then
    echo "Error: Job 'flaky-worker' not found in namespace 'batch-processing'"
    exit 1
fi

# Check backoffLimit is 4
backoff=$(kubectl get job flaky-worker -n batch-processing -o jsonpath='{.spec.backoffLimit}')
if [[ "$backoff" != "4" ]]; then
    echo "Error: Job backoffLimit is '$backoff', expected '4'"
    exit 1
fi

# Check restartPolicy is Never
restart_policy=$(kubectl get job flaky-worker -n batch-processing -o jsonpath='{.spec.template.spec.restartPolicy}')
if [[ "$restart_policy" != "Never" ]]; then
    echo "Error: restartPolicy is '$restart_policy', expected 'Never'"
    exit 1
fi

echo "Success: Job 'flaky-worker' is correctly configured with backoffLimit=4"
exit 0
