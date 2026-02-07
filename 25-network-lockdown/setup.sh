#!/bin/bash
set -euo pipefail

# Create namespace
kubectl create namespace lockdown

# Deploy three-tier application
kubectl run frontend --image=nginx:1.24 -n lockdown --labels="tier=frontend" --port=80
kubectl run backend --image=nginx:1.24 -n lockdown --labels="tier=backend" --port=8080
kubectl expose pod backend -n lockdown --port=8080 --target-port=80 --name=backend-svc
kubectl run database --image=nginx:1.24 -n lockdown --labels="tier=database" --port=5432
kubectl expose pod database -n lockdown --port=5432 --target-port=80 --name=database-svc

# Wait for all pods to be ready
kubectl wait --for=condition=Ready pod -l tier -n lockdown --timeout=60s

echo "Three-tier application deployed successfully in namespace 'lockdown'!"
echo ""
echo "Application architecture:"
echo "  frontend (tier=frontend) -> backend-svc:8080 -> database-svc:5432"
echo ""
echo "Current state: All pods can communicate freely (no NetworkPolicies applied)"
