#!/bin/bash
set -euo pipefail

# Create namespace
kubectl create namespace identity-lab

# Create ServiceAccount
kubectl create serviceaccount api-bot -n identity-lab

echo "Setup complete! Namespace 'identity-lab' and ServiceAccount 'api-bot' have been created."
