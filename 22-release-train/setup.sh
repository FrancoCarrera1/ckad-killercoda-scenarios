#!/bin/bash
set -euo pipefail

# Install Helm if not present
if ! command -v helm &> /dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Create namespace for the full-stack application
kubectl create namespace fullstack

# Create working directory for Kustomize
mkdir -p /root/webapp-kustomize/base

echo "Setup complete! Namespace 'fullstack' created and Kustomize directory ready."
