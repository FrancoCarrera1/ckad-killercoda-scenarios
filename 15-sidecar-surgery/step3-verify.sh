#!/bin/bash
set -euo pipefail

# Check if readiness probe is configured
readiness_probe=$(kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}')
if [[ -z "$readiness_probe" ]]; then
    echo "Error: Readiness probe not configured on app container"
    exit 1
fi

# Check if liveness probe is configured
liveness_probe=$(kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}')
if [[ -z "$liveness_probe" ]]; then
    echo "Error: Liveness probe not configured on app container"
    exit 1
fi

# Wait for rollout to complete
if ! kubectl rollout status deployment/legacy-app -n legacy --timeout=60s >/dev/null 2>&1; then
    echo "Error: Deployment rollout did not complete"
    exit 1
fi

# Check if all Pods are 2/2 Ready
pods_ready=$(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' | grep -o "True" | wc -l)
replicas=$(kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.replicas}')

if [[ "$pods_ready" -ne "$replicas" ]]; then
    echo "Error: Not all Pods are Ready. Expected $replicas, got $pods_ready"
    exit 1
fi

# Check that containers are 2/2
containers_ready=true
for pod in $(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[*].metadata.name}'); do
    ready=$(kubectl get pod $pod -n legacy -o jsonpath='{.status.containerStatuses[*].ready}' | grep -o "true" | wc -l)
    if [[ "$ready" -ne 2 ]]; then
        echo "Error: Pod $pod is not 2/2 Ready"
        containers_ready=false
    fi
done

if [[ "$containers_ready" != "true" ]]; then
    exit 1
fi

echo "Success: Deployment has health probes configured and all Pods are 2/2 Ready"
exit 0
