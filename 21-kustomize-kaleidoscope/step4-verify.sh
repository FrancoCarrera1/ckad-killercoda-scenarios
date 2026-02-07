#!/bin/bash
set -euo pipefail

# Check if a ConfigMap with prefix "prod-app-config-" exists in prod namespace
configmap_count=$(kubectl get configmap -n prod -o name | grep -c "prod-app-config-" || true)
if [ "$configmap_count" -eq 0 ]; then
  echo "ConfigMap with prefix 'prod-app-config-' not found in namespace 'prod'."
  echo "Please add a configMapGenerator to the prod kustomization.yaml."
  exit 1
fi

# Check if a Secret with prefix "prod-app-secret-" exists in prod namespace
secret_count=$(kubectl get secret -n prod -o name | grep -c "prod-app-secret-" || true)
if [ "$secret_count" -eq 0 ]; then
  echo "Secret with prefix 'prod-app-secret-' not found in namespace 'prod'."
  echo "Please add a secretGenerator to the prod kustomization.yaml."
  exit 1
fi

# Verify the ConfigMap has the expected data
configmap_name=$(kubectl get configmap -n prod -o name | grep "prod-app-config-" | head -1 | cut -d'/' -f2)
app_env=$(kubectl get configmap "$configmap_name" -n prod -o jsonpath='{.data.APP_ENV}')
if [ "$app_env" != "production" ]; then
  echo "ConfigMap does not contain expected APP_ENV=production."
  exit 1
fi

echo "Success! ConfigMap and Secret generated with hash suffixes."
exit 0
