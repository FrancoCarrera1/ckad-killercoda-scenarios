#!/bin/bash
set -euo pipefail

# Check if namespace exists
if ! kubectl get namespace dev-priya &>/dev/null; then
  echo "❌ Namespace 'dev-priya' does not exist"
  exit 1
fi

# Check namespace labels
TEAM_LABEL=$(kubectl get namespace dev-priya -o jsonpath='{.metadata.labels.team}')
ENV_LABEL=$(kubectl get namespace dev-priya -o jsonpath='{.metadata.labels.env}')

if [[ "$TEAM_LABEL" != "frontend" ]]; then
  echo "❌ Namespace 'dev-priya' missing label team=frontend (found: team=$TEAM_LABEL)"
  exit 1
fi

if [[ "$ENV_LABEL" != "dev" ]]; then
  echo "❌ Namespace 'dev-priya' missing label env=dev (found: env=$ENV_LABEL)"
  exit 1
fi

# Check if ServiceAccount exists
if ! kubectl get serviceaccount priya-sa -n dev-priya &>/dev/null; then
  echo "❌ ServiceAccount 'priya-sa' does not exist in namespace 'dev-priya'"
  exit 1
fi

echo "✅ Step 1 complete! Namespace and ServiceAccount created successfully."
exit 0
