#!/bin/bash
set -euo pipefail

kubectl create namespace broken-bridge

# Install nginx ingress controller if not present
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/baremetal/deploy.yaml 2>/dev/null || true
sleep 5

# Deploy the actual pod with label "app=webapp"
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: broken-bridge
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
EOF

# BUG 1: Service selector uses "app: web-app" instead of "app: webapp"
# BUG 2: Service targetPort is 8081 instead of 80
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: webapp-svc
  namespace: broken-bridge
spec:
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 8081
EOF

# BUG 3: Ingress backend service port is 8080 instead of 80
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ingress
  namespace: broken-bridge
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: webapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-svc
            port:
              number: 8080
EOF

kubectl wait --for=condition=Available deployment/webapp -n broken-bridge --timeout=60s
