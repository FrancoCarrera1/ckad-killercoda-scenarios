#!/bin/bash
set -euo pipefail

# Check if Ingress exists
if ! kubectl get ingress secure-ingress -n tls-lab &>/dev/null; then
  echo "Ingress 'secure-ingress' not found in tls-lab namespace"
  exit 1
fi

# Check if Ingress has TLS configuration
TLS_HOSTS=$(kubectl get ingress secure-ingress -n tls-lab -o jsonpath='{.spec.tls[0].hosts[0]}')
if [ "$TLS_HOSTS" != "secure.example.com" ]; then
  echo "Ingress TLS configuration does not include secure.example.com"
  exit 1
fi

TLS_SECRET=$(kubectl get ingress secure-ingress -n tls-lab -o jsonpath='{.spec.tls[0].secretName}')
if [ "$TLS_SECRET" != "secure-tls" ]; then
  echo "Ingress TLS configuration does not reference secure-tls secret"
  exit 1
fi

echo "Ingress exists with TLS configuration"
