#!/bin/bash
set -euo pipefail

# Verify Deployment exists and is ready
if ! kubectl get deployment legacy-app -n archaeology &> /dev/null; then
  echo "Deployment legacy-app not found in archaeology namespace"
  exit 1
fi

# Verify Ingress exists
if ! kubectl get ingress legacy-ingress -n archaeology &> /dev/null; then
  echo "Ingress legacy-ingress not found in archaeology namespace"
  exit 1
fi

# Verify CronJob exists
if ! kubectl get cronjob legacy-cron -n archaeology &> /dev/null; then
  echo "CronJob legacy-cron not found in archaeology namespace"
  exit 1
fi

# Verify Service exists
if ! kubectl get service legacy-svc -n archaeology &> /dev/null; then
  echo "Service legacy-svc not found in archaeology namespace"
  exit 1
fi

echo "All resources successfully deployed!"
