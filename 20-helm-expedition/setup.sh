#!/bin/bash
set -euo pipefail

# Helm is usually pre-installed on Killercoda, but ensure it's available
if ! command -v helm &> /dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Create the namespace for our Helm experiments
kubectl create namespace helm-lab

echo "Setup complete! Helm is ready and namespace 'helm-lab' has been created."
