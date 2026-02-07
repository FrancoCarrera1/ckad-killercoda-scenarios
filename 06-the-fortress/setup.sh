#!/bin/bash
set -euo pipefail

# Create namespaces without labels (user will add them)
kubectl create namespace secure-apps
kubectl create namespace legacy-apps

echo "Setup complete! Namespaces 'secure-apps' and 'legacy-apps' have been created."
echo "They are currently unrestricted. You will configure Pod Security Standards."
