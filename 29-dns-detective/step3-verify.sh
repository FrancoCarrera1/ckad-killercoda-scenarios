#!/bin/bash
set -euo pipefail

# Check if StatefulSet exists and has 3 ready replicas
if ! kubectl get statefulset web -n dns-frontend &>/dev/null; then
  echo "StatefulSet 'web' not found in dns-frontend namespace"
  exit 1
fi

READY_REPLICAS=$(kubectl get statefulset web -n dns-frontend -o jsonpath='{.status.readyReplicas}')
if [ "$READY_REPLICAS" != "3" ]; then
  echo "StatefulSet 'web' does not have 3 ready replicas (found: $READY_REPLICAS)"
  exit 1
fi

# Check if headless service exists
if ! kubectl get svc web-headless -n dns-frontend &>/dev/null; then
  echo "Service 'web-headless' not found in dns-frontend namespace"
  exit 1
fi

# Check if service is headless (clusterIP: None)
CLUSTER_IP=$(kubectl get svc web-headless -n dns-frontend -o jsonpath='{.spec.clusterIP}')
if [ "$CLUSTER_IP" != "None" ]; then
  echo "Service 'web-headless' is not headless (clusterIP should be None)"
  exit 1
fi

echo "StatefulSet has 3 ready replicas AND headless service exists"
