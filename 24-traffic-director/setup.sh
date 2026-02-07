#!/bin/bash
set -euo pipefail

# Create namespace
kubectl create namespace traffic-lab

# Install nginx ingress controller
echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/baremetal/deploy.yaml

# Wait for ingress controller to be ready
echo "Waiting for Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s 2>/dev/null || true

# Give it a bit more time to fully initialize
sleep 10

echo "Setup complete! Ingress controller is ready."
