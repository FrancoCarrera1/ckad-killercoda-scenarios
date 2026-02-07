#!/bin/bash
set -euo pipefail

# Create the workshop namespace
kubectl create namespace workshop

echo "Workshop namespace created successfully!"
