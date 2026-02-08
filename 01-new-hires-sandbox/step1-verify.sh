#!/bin/bash
set -euo pipefail

# Check if namespace exists
if ! kubectl get namespace dev-angelica &>/dev/null; then
  echo "❌ Namespace 'dev-angelica' does not exist"
  exit 1
fi

# Check namespace labels
TEAM_LABEL=$(kubectl get namespace dev-angelica -o jsonpath='{.metadata.labels.team}')
ENV_LABEL=$(kubectl get namespace dev-angelica -o jsonpath='{.metadata.labels.env}')

if [[ "$TEAM_LABEL" != "frontend" ]]; then
  echo "❌ Namespace 'dev-angelica' missing label team=frontend (found: team=$TEAM_LABEL)"
  exit 1
fi

if [[ "$ENV_LABEL" != "dev" ]]; then
  echo "❌ Namespace 'dev-angelica' missing label env=dev (found: env=$ENV_LABEL)"
  exit 1
fi

# Check if ServiceAccount exists
if ! kubectl get serviceaccount angelica-sa -n dev-angelica &>/dev/null; then
  echo "❌ ServiceAccount 'angelica-sa' does not exist in namespace 'dev-angelica'"
  exit 1
fi

echo "✅ Step 1 complete! Namespace and ServiceAccount created successfully."
exit 0
