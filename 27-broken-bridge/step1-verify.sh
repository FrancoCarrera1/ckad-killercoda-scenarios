#!/bin/bash
set -euo pipefail

# Check that the broken resources exist
if ! kubectl get deployment webapp -n broken-bridge &>/dev/null; then
  echo "Deployment webapp not found"
  exit 1
fi

if ! kubectl get svc webapp-svc -n broken-bridge &>/dev/null; then
  echo "Service webapp-svc not found"
  exit 1
fi

if ! kubectl get ingress webapp-ingress -n broken-bridge &>/dev/null; then
  echo "Ingress webapp-ingress not found"
  exit 1
fi

echo "Investigation resources are in place. Continue tracing the bugs!"
exit 0
