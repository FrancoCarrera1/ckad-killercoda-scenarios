#!/bin/bash
set -euo pipefail

kubectl create namespace dns-frontend
kubectl create namespace dns-backend

kubectl run frontend-app --image=nginx:1.24 -n dns-frontend --labels="app=frontend"
kubectl expose pod frontend-app -n dns-frontend --port=80 --name=frontend-svc

kubectl run backend-app --image=nginx:1.24 -n dns-backend --labels="app=backend"
kubectl expose pod backend-app -n dns-backend --port=80 --name=backend-svc

kubectl wait --for=condition=Ready pod frontend-app -n dns-frontend --timeout=60s
kubectl wait --for=condition=Ready pod backend-app -n dns-backend --timeout=60s
