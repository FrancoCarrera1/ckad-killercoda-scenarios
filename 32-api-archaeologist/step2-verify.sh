#!/bin/bash
set -euo pipefail

# Verify fixed manifest directory and files exist
if [ ! -d /root/fixed-manifests ]; then
  echo "fixed-manifests directory not found"
  exit 1
fi

if [ ! -f /root/fixed-manifests/deployment.yaml ]; then
  echo "fixed deployment.yaml not found"
  exit 1
fi

if [ ! -f /root/fixed-manifests/ingress.yaml ]; then
  echo "fixed ingress.yaml not found"
  exit 1
fi

if [ ! -f /root/fixed-manifests/cronjob.yaml ]; then
  echo "fixed cronjob.yaml not found"
  exit 1
fi

# Verify correct API versions
if ! grep -q "apiVersion: apps/v1" /root/fixed-manifests/deployment.yaml; then
  echo "Deployment does not use apps/v1 API version"
  exit 1
fi

if ! grep -q "apiVersion: networking.k8s.io/v1" /root/fixed-manifests/ingress.yaml; then
  echo "Ingress does not use networking.k8s.io/v1 API version"
  exit 1
fi

if ! grep -q "apiVersion: batch/v1" /root/fixed-manifests/cronjob.yaml; then
  echo "CronJob does not use batch/v1 API version"
  exit 1
fi

echo "All fixed manifests are present with correct API versions"
