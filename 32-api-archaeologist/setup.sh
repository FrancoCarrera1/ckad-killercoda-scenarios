#!/bin/bash
set -euo pipefail

# Create namespace for the scenario
kubectl create namespace archaeology

# Create directory for old manifests
mkdir -p /root/old-manifests

# Create deprecated Deployment manifest
cat > /root/old-manifests/deployment.yaml << 'EOF'
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: legacy-app
  namespace: archaeology
spec:
  replicas: 2
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

# Create deprecated Ingress manifest
cat > /root/old-manifests/ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: legacy-ingress
  namespace: archaeology
spec:
  rules:
  - host: legacy.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: legacy-svc
          servicePort: 80
EOF

# Create deprecated CronJob manifest
cat > /root/old-manifests/cronjob.yaml << 'EOF'
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: legacy-cron
  namespace: archaeology
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cron
            image: busybox:1.36
            command: ["echo", "Running legacy cron"]
          restartPolicy: OnFailure
EOF

echo "Setup complete! Old manifests are ready in /root/old-manifests/"
