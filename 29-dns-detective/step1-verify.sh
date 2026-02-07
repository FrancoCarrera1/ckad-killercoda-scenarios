#!/bin/bash
set -euo pipefail

# Check if frontend-svc service exists in dns-frontend
if ! kubectl get svc frontend-svc -n dns-frontend &>/dev/null; then
  echo "Service 'frontend-svc' not found in dns-frontend namespace"
  exit 1
fi

echo "frontend-svc service exists in dns-frontend"
