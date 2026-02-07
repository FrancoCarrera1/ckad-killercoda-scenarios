#!/bin/bash
set -euo pipefail

# Verify that old manifest files exist
if [ ! -f /root/old-manifests/deployment.yaml ]; then
  echo "deployment.yaml not found"
  exit 1
fi

if [ ! -f /root/old-manifests/ingress.yaml ]; then
  echo "ingress.yaml not found"
  exit 1
fi

if [ ! -f /root/old-manifests/cronjob.yaml ]; then
  echo "cronjob.yaml not found"
  exit 1
fi

echo "All old manifest files exist"
