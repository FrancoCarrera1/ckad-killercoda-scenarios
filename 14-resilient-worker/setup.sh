#!/bin/bash
set -euo pipefail

# Create namespace for batch processing
kubectl create namespace batch-processing

echo "Batch processing environment ready!"
echo "Namespace 'batch-processing' created."
