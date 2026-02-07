#!/bin/bash
set -euo pipefail

kubectl create namespace autopsy

# Database - Pending because PVC doesn't exist
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: database
  namespace: autopsy
  labels:
    tier: database
spec:
  containers:
  - name: db
    image: nginx:1.24
    ports:
    - containerPort: 80
    volumeMounts:
    - name: db-data
      mountPath: /var/lib/data
  volumes:
  - name: db-data
    persistentVolumeClaim:
      claimName: db-pvc
EOF

# Backend - Error due to bad command
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: autopsy
  labels:
    tier: backend
spec:
  containers:
  - name: backend
    image: nginx:1.24
    command: ["nginx", "-g", "daemon off;", "--bad-flag"]
    ports:
    - containerPort: 80
    env:
    - name: DB_HOST
      value: database-svc
EOF

# Frontend - CrashLoopBackOff because it tries to reach backend-svc
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: autopsy
  labels:
    tier: frontend
spec:
  containers:
  - name: frontend
    image: busybox:1.36
    command: ["sh", "-c", "wget -q -O- http://backend-svc.autopsy.svc.cluster.local --timeout=3 || exit 1"]
    ports:
    - containerPort: 80
EOF

sleep 5

echo "Broken application stack deployed. Begin the autopsy!"
