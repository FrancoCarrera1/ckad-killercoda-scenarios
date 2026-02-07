#!/bin/bash
set -euo pipefail

# Check that the deployment is NOT using the broken image
current_image=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")

if [[ "$current_image" == *"1.99-broken"* ]]; then
  echo "Deployment is still using the broken image. Please rollback with 'kubectl rollout undo'."
  exit 1
fi

# Check if all replicas are ready (deployment is healthy)
ready_replicas=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
desired_replicas=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")

if [ "$ready_replicas" != "$desired_replicas" ] || [ "$ready_replicas" -eq 0 ]; then
  echo "Deployment is not healthy. Ready: $ready_replicas, Desired: $desired_replicas"
  echo "Please ensure the rollback completed successfully."
  exit 1
fi

# Verify no pods are in error state
error_pods=$(kubectl get pods -n fullstack -l app=webapp --field-selector=status.phase!=Running --no-headers 2>/dev/null | wc -l)
if [ "$error_pods" -gt 0 ]; then
  echo "Some webapp pods are not in Running state. Please check pod status."
  exit 1
fi

echo "Success! Deployment recovered from failed update."
exit 0
