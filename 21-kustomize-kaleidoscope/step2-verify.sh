#!/bin/bash
set -euo pipefail

# Check if overlay directories exist
if [ ! -d /root/kustomize-app/overlays/dev ]; then
  echo "Directory /root/kustomize-app/overlays/dev not found."
  exit 1
fi

if [ ! -d /root/kustomize-app/overlays/prod ]; then
  echo "Directory /root/kustomize-app/overlays/prod not found."
  exit 1
fi

# Check if kustomization.yaml exists in both overlays
if [ ! -f /root/kustomize-app/overlays/dev/kustomization.yaml ]; then
  echo "File /root/kustomize-app/overlays/dev/kustomization.yaml not found."
  exit 1
fi

if [ ! -f /root/kustomize-app/overlays/prod/kustomization.yaml ]; then
  echo "File /root/kustomize-app/overlays/prod/kustomization.yaml not found."
  exit 1
fi

# Verify kubectl kustomize works for both overlays
if ! kubectl kustomize /root/kustomize-app/overlays/dev/ > /dev/null 2>&1; then
  echo "kubectl kustomize failed for dev overlay. Check your configuration."
  exit 1
fi

if ! kubectl kustomize /root/kustomize-app/overlays/prod/ > /dev/null 2>&1; then
  echo "kubectl kustomize failed for prod overlay. Check your configuration."
  exit 1
fi

# Verify dev overlay has correct namespace and prefix
dev_output=$(kubectl kustomize /root/kustomize-app/overlays/dev/)
if ! echo "$dev_output" | grep -q "namespace: dev"; then
  echo "Dev overlay does not set namespace to 'dev'."
  exit 1
fi

if ! echo "$dev_output" | grep -q "name: dev-webapp"; then
  echo "Dev overlay does not use namePrefix 'dev-'."
  exit 1
fi

# Verify prod overlay has correct namespace, prefix, and replicas
prod_output=$(kubectl kustomize /root/kustomize-app/overlays/prod/)
if ! echo "$prod_output" | grep -q "namespace: prod"; then
  echo "Prod overlay does not set namespace to 'prod'."
  exit 1
fi

if ! echo "$prod_output" | grep -q "name: prod-webapp"; then
  echo "Prod overlay does not use namePrefix 'prod-'."
  exit 1
fi

if ! echo "$prod_output" | grep -q "replicas: 5"; then
  echo "Prod overlay does not set replicas to 5."
  exit 1
fi

echo "Success! Both overlays are configured correctly."
exit 0
