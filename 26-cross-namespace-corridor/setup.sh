#!/bin/bash
set -euo pipefail

kubectl create namespace api-gateway
kubectl label namespace api-gateway team=gateway
kubectl create namespace backend
kubectl label namespace backend team=backend
kubectl create namespace monitoring
kubectl label namespace monitoring team=monitoring

kubectl run gateway-pod --image=nginx:1.24 -n api-gateway --labels="app=gateway" --port=80
kubectl run backend-pod --image=nginx:1.24 -n backend --labels="app=backend" --port=8080
kubectl expose pod backend-pod -n backend --port=8080 --target-port=80 --name=backend-svc
kubectl run monitor-pod --image=nginx:1.24 -n monitoring --labels="app=monitor" --port=9090

kubectl wait --for=condition=Ready pod gateway-pod -n api-gateway --timeout=60s
kubectl wait --for=condition=Ready pod backend-pod -n backend --timeout=60s
kubectl wait --for=condition=Ready pod monitor-pod -n monitoring --timeout=60s
