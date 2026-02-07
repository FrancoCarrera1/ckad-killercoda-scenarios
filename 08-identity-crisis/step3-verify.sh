#!/bin/bash
set -euo pipefail

# Check if the Role exists
if ! kubectl get role pod-reader -n identity-lab &>/dev/null; then
  echo "Role 'pod-reader' not found in identity-lab namespace"
  exit 1
fi

# Check if the RoleBinding exists
if ! kubectl get rolebinding api-bot-binding -n identity-lab &>/dev/null; then
  echo "RoleBinding 'api-bot-binding' not found in identity-lab namespace"
  exit 1
fi

# Verify that api-bot can list pods
if kubectl auth can-i list pods --as=system:serviceaccount:identity-lab:api-bot -n identity-lab 2>/dev/null | grep -q "yes"; then
  echo "Success: api-bot ServiceAccount can list pods via RBAC"
  exit 0
else
  echo "The api-bot ServiceAccount should be able to list pods. Check Role and RoleBinding."
  exit 1
fi
