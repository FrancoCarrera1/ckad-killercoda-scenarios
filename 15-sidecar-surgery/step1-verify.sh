#!/bin/bash
set -euo pipefail

# Check if deployment exists
if ! kubectl get deployment legacy-app -n legacy >/dev/null 2>&1; then
    echo "Error: Deployment 'legacy-app' not found in namespace 'legacy'"
    exit 1
fi

# Check if deployment is available
available=$(kubectl get deployment legacy-app -n legacy -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')
if [[ "$available" != "True" ]]; then
    echo "Error: Deployment 'legacy-app' is not available"
    exit 1
fi

echo "Success: Legacy deployment exists and is running"
exit 0
