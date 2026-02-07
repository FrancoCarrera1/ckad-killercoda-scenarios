#!/bin/bash
set -euo pipefail

# Check that the ServiceAccount can get pod logs
if kubectl auth can-i get pods/log --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab 2>/dev/null | grep -q "yes"; then
  echo "Success: deploy-bot can now access pod logs"
  exit 0
else
  echo "The deploy-bot ServiceAccount cannot access pod logs. Add a rule for 'pods/log' resource."
  exit 1
fi
