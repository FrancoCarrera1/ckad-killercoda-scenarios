#!/bin/bash
set -euo pipefail

# Create the canary-test namespace
kubectl create namespace canary-test

echo "Namespace canary-test created successfully!"
