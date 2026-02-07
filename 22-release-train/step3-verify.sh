#!/bin/bash
set -euo pipefail

# Check if webapp deployment is using nginx:1.25
current_image=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")

if [[ "$current_image" != *"nginx:1.25"* ]]; then
  echo "Expected webapp to use nginx:1.25, but found: $current_image"
  exit 1
fi

# Check if all replicas are ready
ready_replicas=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
desired_replicas=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")

if [ "$ready_replicas" != "$desired_replicas" ]; then
  echo "Not all replicas are ready. Ready: $ready_replicas, Desired: $desired_replicas"
  exit 1
fi

echo "Success! Webapp updated to nginx:1.25."
exit 0
