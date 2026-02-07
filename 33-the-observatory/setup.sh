#!/bin/bash
set -euo pipefail

# Create namespace
kubectl create namespace observatory

# Deploy metrics-server (required for kubectl top)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml 2>/dev/null || true

# Patch metrics-server to work in test environments
kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' 2>/dev/null || true

# Wait for metrics-server to be ready
sleep 15

# Multi-container pod for log exercises
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-logger
  namespace: observatory
  labels:
    app: logger
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["sh", "-c", "while true; do echo '[APP] Processing request'; sleep 3; done"]
  - name: sidecar
    image: busybox:1.36
    command: ["sh", "-c", "while true; do echo '[SIDECAR] Streaming logs'; sleep 5; done"]
EOF

# CPU hog pod
kubectl run cpu-hog --image=busybox:1.36 -n observatory \
  -- sh -c "while true; do :; done"

# Pod that will OOMKill
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: mystery-crash
  namespace: observatory
  labels:
    app: crash-test
spec:
  containers:
  - name: memory-eater
    image: busybox:1.36
    command: ["sh", "-c", "dd if=/dev/zero of=/dev/null bs=1M"]
    resources:
      limits:
        memory: "32Mi"
      requests:
        memory: "16Mi"
EOF

# Normal web pods
kubectl run web-1 --image=nginx:1.24 -n observatory --labels="app=web,tier=frontend"
kubectl run web-2 --image=nginx:1.24 -n observatory --labels="app=web,tier=frontend"

# API pod
kubectl run api-1 --image=nginx:1.24 -n observatory --labels="app=api,tier=backend"

# Wait for pods to start
sleep 10

echo "Observatory environment is ready for monitoring!"
