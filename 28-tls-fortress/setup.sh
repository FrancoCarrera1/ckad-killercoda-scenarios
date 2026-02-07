#!/bin/bash
set -euo pipefail

kubectl create namespace tls-lab

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/baremetal/deploy.yaml 2>/dev/null || true
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s 2>/dev/null || true
sleep 5

kubectl create deployment secure-app --image=nginx:1.24 -n tls-lab --replicas=2
kubectl expose deployment secure-app -n tls-lab --port=80 --target-port=80 --name=secure-app-svc
kubectl wait --for=condition=Available deployment/secure-app -n tls-lab --timeout=60s
