#!/bin/bash
set -euo pipefail

kubectl create namespace payments

# Create initial working deployment (revision 1)
kubectl create deployment payment-service --image=nginx:1.24 -n payments --replicas=3
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Initial deployment with nginx 1.24"
kubectl rollout status deployment/payment-service -n payments --timeout=60s

# Update to 1.25 (revision 2)
kubectl set image deployment/payment-service payment-service=nginx:1.25 -n payments
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Updated to nginx 1.25" --overwrite
kubectl rollout status deployment/payment-service -n payments --timeout=60s

# Break it with bad image (revision 3)
kubectl set image deployment/payment-service payment-service=nginx:1.99-nonexistent -n payments
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Updated to nginx 1.99" --overwrite

# Don't wait - it will be broken
sleep 5
