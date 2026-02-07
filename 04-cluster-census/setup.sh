#!/bin/bash
set -euo pipefail

# Wait for Kubernetes cluster to be ready
echo "Waiting for Kubernetes cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Create namespaces
echo "Creating namespaces..."
kubectl create namespace app-team
kubectl create namespace monitoring

# Deploy some pods
echo "Deploying sample pods..."
kubectl run web-server --image=nginx:1.24 -n app-team
kubectl run metrics-collector --image=busybox:1.36 -n monitoring -- sleep 3600
kubectl run cache --image=redis:7 -n app-team

# Wait a moment for pods to start
sleep 5

echo "Setup complete! Sample resources deployed."
kubectl get pods --all-namespaces
