#!/bin/bash
set -euo pipefail

# Create namespace
kubectl create namespace rbac-lab

# Create ServiceAccount
kubectl create serviceaccount deploy-bot -n rbac-lab

# Create BROKEN Role (Bug #1: wrong apiGroup for deployments)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: deployer-role
  namespace: rbac-lab
rules:
- apiGroups: ["extensions"]
  resources: ["deployments"]
  verbs: ["get", "list", "create", "update", "delete"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
EOF

# Create BROKEN RoleBinding (Bug #2: wrong ServiceAccount name)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: deployer-binding
  namespace: rbac-lab
subjects:
- kind: ServiceAccount
  name: deployment-bot
  namespace: rbac-lab
roleRef:
  kind: Role
  name: deployer-role
  apiGroup: rbac.authorization.k8s.io
EOF

echo "Setup complete! The rbac-lab namespace is ready with broken RBAC configuration."
