#!/bin/bash
set -euo pipefail

# Create namespace
kubectl create namespace controlled

# Create ResourceQuota
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: controlled
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 2Gi
    pods: "5"
EOF

# Create LimitRange
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
  namespace: controlled
spec:
  limits:
  - max:
      cpu: 256m
      memory: 256Mi
    default:
      cpu: 100m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 128Mi
    type: Container
EOF

echo "Setup complete! Namespace 'controlled' has been created with ResourceQuota and LimitRange."
