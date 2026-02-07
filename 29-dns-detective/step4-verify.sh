#!/bin/bash
set -euo pipefail

# Check if dnsutils pod exists in dns-frontend
if ! kubectl get pod dnsutils -n dns-frontend &>/dev/null; then
  echo "Pod 'dnsutils' not found in dns-frontend namespace"
  exit 1
fi

echo "dnsutils pod exists in dns-frontend"
