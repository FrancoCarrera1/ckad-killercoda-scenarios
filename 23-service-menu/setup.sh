#!/bin/bash
set -euo pipefail

# Create namespace and base deployment
kubectl create namespace service-menu

# Create a deployment with 2 replicas
kubectl create deployment web --image=nginx:1.24 -n service-menu --replicas=2

# Wait for deployment to be available
kubectl wait --for=condition=Available deployment/web -n service-menu --timeout=60s

echo "Setup complete! Namespace and deployment ready."
