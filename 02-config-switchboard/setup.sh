#!/bin/bash
set -euo pipefail

# Wait for Kubernetes cluster to be ready
echo "Waiting for Kubernetes cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Create namespaces
echo "Creating staging and production namespaces..."
kubectl create namespace staging
kubectl create namespace production

echo "Setup complete! Namespaces ready."
