#!/bin/bash
set -euo pipefail

# Check app-credentials secret
if ! kubectl get secret app-credentials -n vault &>/dev/null; then
  echo "❌ Secret 'app-credentials' does not exist in namespace 'vault'"
  exit 1
fi

APP_CREDS_TYPE=$(kubectl get secret app-credentials -n vault -o jsonpath='{.type}')
if [[ "$APP_CREDS_TYPE" != "Opaque" ]]; then
  echo "❌ Secret 'app-credentials' has incorrect type (expected: Opaque, found: $APP_CREDS_TYPE)"
  exit 1
fi

# Verify username and password exist
USERNAME=$(kubectl get secret app-credentials -n vault -o jsonpath='{.data.username}' | base64 -d)
PASSWORD=$(kubectl get secret app-credentials -n vault -o jsonpath='{.data.password}' | base64 -d)

if [[ "$USERNAME" != "admin" ]]; then
  echo "❌ Secret 'app-credentials' has incorrect username (expected: admin, found: $USERNAME)"
  exit 1
fi

if [[ "$PASSWORD" != "S3cur3P@ss!" ]]; then
  echo "❌ Secret 'app-credentials' has incorrect password"
  exit 1
fi

# Check vault-tls secret
if ! kubectl get secret vault-tls -n vault &>/dev/null; then
  echo "❌ Secret 'vault-tls' does not exist in namespace 'vault'"
  exit 1
fi

TLS_TYPE=$(kubectl get secret vault-tls -n vault -o jsonpath='{.type}')
if [[ "$TLS_TYPE" != "kubernetes.io/tls" ]]; then
  echo "❌ Secret 'vault-tls' has incorrect type (expected: kubernetes.io/tls, found: $TLS_TYPE)"
  exit 1
fi

# Check registry-creds secret
if ! kubectl get secret registry-creds -n vault &>/dev/null; then
  echo "❌ Secret 'registry-creds' does not exist in namespace 'vault'"
  exit 1
fi

REGISTRY_TYPE=$(kubectl get secret registry-creds -n vault -o jsonpath='{.type}')
if [[ "$REGISTRY_TYPE" != "kubernetes.io/dockerconfigjson" ]]; then
  echo "❌ Secret 'registry-creds' has incorrect type (expected: kubernetes.io/dockerconfigjson, found: $REGISTRY_TYPE)"
  exit 1
fi

echo "✅ Step 1 complete! All three secret types created correctly."
exit 0
