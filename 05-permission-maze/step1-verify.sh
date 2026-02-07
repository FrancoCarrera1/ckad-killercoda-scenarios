#!/bin/bash
set -euo pipefail

# Check that the Role now has the correct apiGroup for deployments
ROLE_YAML=$(kubectl get role deployer-role -n rbac-lab -o yaml)

# Check if the Role contains "apps" apiGroup for deployments
if echo "$ROLE_YAML" | grep -A 5 "resources:" | grep -q "deployments" && echo "$ROLE_YAML" | grep -B 5 "deployments" | grep -q "apiGroups:" | grep -q "apps"; then
  # More precise check: look for the deployments rule with apps apiGroup
  if kubectl get role deployer-role -n rbac-lab -o jsonpath='{.rules[*].apiGroups}' | grep -q "apps"; then
    echo "Success: Role has been fixed with the correct apiGroup"
    exit 0
  fi
fi

echo "The Role still has the wrong apiGroup for deployments. It should be 'apps', not 'extensions'."
exit 1
