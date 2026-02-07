#!/bin/bash
set -euo pipefail

# Check if webapp deployment exists
if ! kubectl get deployment webapp -n fullstack &> /dev/null; then
  echo "Deployment 'webapp' not found in namespace 'fullstack'."
  exit 1
fi

# Check if the deployment has the REDIS_HOST environment variable
redis_host=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="REDIS_HOST")].value}' 2>/dev/null || echo "")

if [ -z "$redis_host" ]; then
  echo "Environment variable REDIS_HOST not found in webapp deployment."
  exit 1
fi

if [[ "$redis_host" != *"my-redis-master"* ]]; then
  echo "REDIS_HOST does not point to my-redis-master service. Found: $redis_host"
  exit 1
fi

# Check if webapp pods are ready
ready_replicas=$(kubectl get deployment webapp -n fullstack -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$ready_replicas" -lt 1 ]; then
  echo "Webapp deployment has no ready replicas. Please wait for pods to be ready."
  exit 1
fi

echo "Success! Webapp deployed with Redis connectivity."
exit 0
