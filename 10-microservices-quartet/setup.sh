#!/bin/bash
set -euo pipefail

# Create namespace for microservices
kubectl create namespace microservices

# Deploy a simple "database" service that the init container will wait for
kubectl run mock-db --image=nginx:1.24 -n microservices --labels="app=database"
kubectl expose pod mock-db -n microservices --port=80 --name=database-service
kubectl wait --for=condition=Ready pod/mock-db -n microservices --timeout=60s

echo "Microservices environment ready with database service!"
