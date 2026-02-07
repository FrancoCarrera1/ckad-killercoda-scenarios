#!/bin/bash
set -euo pipefail

# Create namespace for legacy application
kubectl create namespace legacy

# Deploy a "legacy" application without probes or sidecars
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-app
  namespace: legacy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy-app
  template:
    metadata:
      labels:
        app: legacy-app
    spec:
      containers:
      - name: app
        image: nginx:1.24
        ports:
        - containerPort: 80
EOF

# Wait for deployment to be ready
kubectl wait --for=condition=Available deployment/legacy-app -n legacy --timeout=60s

echo "Legacy application deployed!"
echo "Namespace 'legacy' created with deployment 'legacy-app'"
