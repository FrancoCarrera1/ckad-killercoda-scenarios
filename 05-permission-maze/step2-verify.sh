#!/bin/bash
set -euo pipefail

# Check that the RoleBinding has the correct subject name
SUBJECT_NAME=$(kubectl get rolebinding deployer-binding -n rbac-lab -o jsonpath='{.subjects[0].name}')

if [ "$SUBJECT_NAME" != "deploy-bot" ]; then
  echo "The RoleBinding subject name is incorrect. Expected 'deploy-bot', got '$SUBJECT_NAME'"
  exit 1
fi

# Verify that the ServiceAccount can now create deployments
if kubectl auth can-i create deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab 2>/dev/null | grep -q "yes"; then
  echo "Success: RoleBinding is fixed and deploy-bot can create deployments"
  exit 0
else
  echo "The deploy-bot ServiceAccount still cannot create deployments. Check both the Role and RoleBinding."
  exit 1
fi
