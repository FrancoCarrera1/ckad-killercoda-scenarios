#!/bin/bash
set -euo pipefail

# Check if Ingress has TLS configured
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

echo "Ingress has TLS with correct secret name and host"
