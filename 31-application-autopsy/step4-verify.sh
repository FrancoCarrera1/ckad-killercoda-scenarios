#!/bin/bash
set -euo pipefail

# Check all three pods are Running
DATABASE_STATUS=$(kubectl get pod database -n autopsy -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
BACKEND_STATUS=$(kubectl get pod backend -n autopsy -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
FRONTEND_STATUS=$(kubectl get pod frontend -n autopsy -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")

if [ "$DATABASE_STATUS" != "Running" ]; then
  echo "Database pod is not Running (current status: $DATABASE_STATUS)"
  exit 1
fi

if [ "$BACKEND_STATUS" != "Running" ]; then
  echo "Backend pod is not Running (current status: $BACKEND_STATUS)"
  exit 1
fi

if [ "$FRONTEND_STATUS" != "Running" ]; then
  echo "Frontend pod is not Running (current status: $FRONTEND_STATUS)"
  exit 1
fi

echo "All three pods are Running! Application stack is healthy!"
