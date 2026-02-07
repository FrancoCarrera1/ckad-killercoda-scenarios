#!/bin/bash
set -euo pipefail

# Create namespace for data pipeline
kubectl create namespace data-pipeline

echo "Data pipeline namespace ready!"
