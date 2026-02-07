#!/bin/bash
set -euo pipefail

# Create namespace for health lab
kubectl create namespace health-lab

echo "Health lab namespace created. Ready to begin!"
