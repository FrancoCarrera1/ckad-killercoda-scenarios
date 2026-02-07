#!/bin/bash
set -euo pipefail

# Check if Redis Helm release exists
if ! helm list -n fullstack | grep -q my-redis; then
  echo "Helm release 'my-redis' not found in namespace 'fullstack'."
  exit 1
fi

# Check if Redis pods are running and ready
redis_ready=$(kubectl get pods -n fullstack -l app.kubernetes.io/name=redis -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "False")

if [ "$redis_ready" != "True" ]; then
  echo "Redis pod is not ready. Please wait for the deployment to complete."
  exit 1
fi

# Check if Redis service exists
if ! kubectl get svc my-redis-master -n fullstack &> /dev/null; then
  echo "Redis service 'my-redis-master' not found in namespace 'fullstack'."
  exit 1
fi

echo "Success! Redis is deployed and running."
exit 0
