#!/bin/bash
set -euo pipefail

# Check Ingress backend port is correct
BACKEND_PORT=$(kubectl get ingress webapp-ingress -n broken-bridge -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}')
if [ "$BACKEND_PORT" != "80" ]; then
  echo "Ingress backend port is still incorrect. Expected '80', got '$BACKEND_PORT'"
  exit 1
fi

# Verify Service selector is still correct (sanity check)
SELECTOR=$(kubectl get svc webapp-svc -n broken-bridge -o jsonpath='{.spec.selector.app}')
if [ "$SELECTOR" != "webapp" ]; then
  echo "Service selector has changed. Expected 'webapp', got '$SELECTOR'"
  exit 1
fi

# Verify endpoints still exist
ENDPOINTS=$(kubectl get endpoints webapp-svc -n broken-bridge -o jsonpath='{.subsets[0].addresses}')
if [ -z "$ENDPOINTS" ] || [ "$ENDPOINTS" == "null" ]; then
  echo "Service endpoints are empty"
  exit 1
fi

echo "All networking bugs fixed! The bridge is repaired and traffic can flow."
exit 0
