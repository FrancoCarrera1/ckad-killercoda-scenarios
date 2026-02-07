#!/bin/bash
set -euo pipefail

# Check if Job exists
if ! kubectl get job index-processor -n batch-processing >/dev/null 2>&1; then
    echo "Error: Job 'index-processor' not found in namespace 'batch-processing'"
    exit 1
fi

# Check completionMode is Indexed
completion_mode=$(kubectl get job index-processor -n batch-processing -o jsonpath='{.spec.completionMode}')
if [[ "$completion_mode" != "Indexed" ]]; then
    echo "Error: Job completionMode is '$completion_mode', expected 'Indexed'"
    exit 1
fi

# Check completions is 4
completions=$(kubectl get job index-processor -n batch-processing -o jsonpath='{.spec.completions}')
if [[ "$completions" != "4" ]]; then
    echo "Error: Job completions is '$completions', expected '4'"
    exit 1
fi

# Check if ttlSecondsAfterFinished is set
ttl=$(kubectl get job index-processor -n batch-processing -o jsonpath='{.spec.ttlSecondsAfterFinished}')
if [[ -z "$ttl" ]]; then
    echo "Error: ttlSecondsAfterFinished is not set"
    exit 1
fi

echo "Success: Indexed Job 'index-processor' is correctly configured"
exit 0
