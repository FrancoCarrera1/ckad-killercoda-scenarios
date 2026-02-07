#!/bin/bash
set -euo pipefail

# Create namespaces for dev and prod environments
kubectl create namespace dev
kubectl create namespace prod

# Create the working directory for Kustomize
mkdir -p /root/kustomize-app

echo "Setup complete! Namespaces 'dev' and 'prod' created, working directory ready."
