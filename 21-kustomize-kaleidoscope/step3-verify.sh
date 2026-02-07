#!/bin/bash
set -euo pipefail

# Check if dev-webapp deployment exists in dev namespace
if ! kubectl get deployment dev-webapp -n dev &> /dev/null; then
  echo "Deployment 'dev-webapp' not found in namespace 'dev'."
  exit 1
fi

# Check if prod-webapp deployment exists in prod namespace
if ! kubectl get deployment prod-webapp -n prod &> /dev/null; then
  echo "Deployment 'prod-webapp' not found in namespace 'prod'."
  exit 1
fi

# Verify prod deployment has 5 replicas
prod_replicas=$(kubectl get deployment prod-webapp -n prod -o jsonpath='{.spec.replicas}')
if [ "$prod_replicas" != "5" ]; then
  echo "Expected prod-webapp to have 5 replicas, but found: $prod_replicas"
  exit 1
fi

# Verify dev deployment has 1 replica (optional but good to check)
dev_replicas=$(kubectl get deployment dev-webapp -n dev -o jsonpath='{.spec.replicas}')
if [ "$dev_replicas" != "1" ]; then
  echo "Expected dev-webapp to have 1 replica, but found: $dev_replicas"
  exit 1
fi

echo "Success! Both environments deployed correctly."
exit 0
