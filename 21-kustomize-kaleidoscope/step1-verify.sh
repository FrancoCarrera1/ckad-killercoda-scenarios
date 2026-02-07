#!/bin/bash
set -euo pipefail

# Check if base directory exists
if [ ! -d /root/kustomize-app/base ]; then
  echo "Directory /root/kustomize-app/base not found."
  exit 1
fi

# Check if all required files exist
for file in deployment.yaml service.yaml kustomization.yaml; do
  if [ ! -f /root/kustomize-app/base/$file ]; then
    echo "File /root/kustomize-app/base/$file not found."
    exit 1
  fi
done

# Verify kubectl kustomize works without errors
if ! kubectl kustomize /root/kustomize-app/base/ > /dev/null 2>&1; then
  echo "kubectl kustomize command failed. Please check your kustomization.yaml syntax."
  exit 1
fi

# Verify the output contains expected resources
output=$(kubectl kustomize /root/kustomize-app/base/)
if ! echo "$output" | grep -q "kind: Deployment"; then
  echo "Deployment not found in kustomize output."
  exit 1
fi

if ! echo "$output" | grep -q "kind: Service"; then
  echo "Service not found in kustomize output."
  exit 1
fi

echo "Success! Base configuration is valid."
exit 0
