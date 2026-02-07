#!/bin/bash
set -euo pipefail

# Wait for Kubernetes cluster to be ready
echo "Waiting for Kubernetes cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "Cluster is ready!"
