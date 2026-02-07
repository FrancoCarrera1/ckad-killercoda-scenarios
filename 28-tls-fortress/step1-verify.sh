#!/bin/bash
set -euo pipefail

# Check if TLS Secret exists
if ! kubectl get secret secure-tls -n tls-lab &>/dev/null; then
  echo "Secret 'secure-tls' not found in tls-lab namespace"
  exit 1
fi

# Check if Secret is of type kubernetes.io/tls
SECRET_TYPE=$(kubectl get secret secure-tls -n tls-lab -o jsonpath='{.type}')
if [ "$SECRET_TYPE" != "kubernetes.io/tls" ]; then
  echo "Secret 'secure-tls' is not of type kubernetes.io/tls"
  exit 1
fi

# Check if Secret has tls.crt and tls.key
if ! kubectl get secret secure-tls -n tls-lab -o jsonpath='{.data.tls\.crt}' | grep -q .; then
  echo "Secret 'secure-tls' does not contain tls.crt"
  exit 1
fi

if ! kubectl get secret secure-tls -n tls-lab -o jsonpath='{.data.tls\.key}' | grep -q .; then
  echo "Secret 'secure-tls' does not contain tls.key"
  exit 1
fi

echo "TLS Secret exists with type kubernetes.io/tls"
