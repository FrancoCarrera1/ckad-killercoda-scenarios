#!/bin/bash
set -euo pipefail

# Wait for Kubernetes cluster to be ready
echo "Waiting for Kubernetes cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Create namespace
echo "Creating vault namespace..."
kubectl create namespace vault

# Generate self-signed TLS certificate
echo "Generating self-signed TLS certificate..."
mkdir -p /root/certs
openssl req -x509 -newkey rsa:2048 -keyout /root/certs/tls.key -out /root/certs/tls.crt -days 365 -nodes -subj "/CN=vault.example.com"

echo "Setup complete! TLS certificates generated at /root/certs/"
ls -la /root/certs/
