#!/bin/bash
set -euo pipefail

# Check if backend-svc exists in dns-backend
if ! kubectl get svc backend-svc -n dns-backend &>/dev/null; then
  echo "Service 'backend-svc' not found in dns-backend namespace"
  exit 1
fi

echo "backend-svc exists in dns-backend"
