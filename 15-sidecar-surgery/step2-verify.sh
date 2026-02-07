#!/bin/bash
set -euo pipefail

# Check if deployment has 2 containers
container_count=$(kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[*].name}' | wc -w)
if [[ "$container_count" -ne 2 ]]; then
    echo "Error: Deployment should have 2 containers, found $container_count"
    exit 1
fi

# Check if log-collector container exists
if ! kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[*].name}' | grep -q "log-collector"; then
    echo "Error: log-collector container not found"
    exit 1
fi

# Check if shared-logs volume exists
if ! kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.volumes[*].name}' | grep -q "shared-logs"; then
    echo "Error: shared-logs volume not found"
    exit 1
fi

# Wait for rollout to complete
if ! kubectl rollout status deployment/legacy-app -n legacy --timeout=60s >/dev/null 2>&1; then
    echo "Error: Deployment rollout did not complete"
    exit 1
fi

# Check if Pods are 2/2 Ready
ready_pods=$(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[*].status.containerStatuses[*].ready}' | grep -o "true" | wc -l)
total_containers=$(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[*].status.containerStatuses[*].name}' | wc -w)

if [[ "$ready_pods" -ne "$total_containers" ]]; then
    echo "Error: Not all containers are ready. Expected $total_containers, got $ready_pods ready"
    exit 1
fi

echo "Success: Deployment has sidecar container and shared volumes, Pods are 2/2 Ready"
exit 0
