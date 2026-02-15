#!/bin/bash
set -euo pipefail

# Check that the Role now has the correct apiGroup for deployments
if kubectl get role deployer-role -n rbac-lab -o jsonpath='{.rules[*].apiGroups}' | grep -q "apps"; then
  echo "Success: Role has been fixed with the correct apiGroup"
  exit 0
fi

echo "The Role still has the wrong apiGroup for deployments. It should be 'apps', not 'extensions'."
exit 1
