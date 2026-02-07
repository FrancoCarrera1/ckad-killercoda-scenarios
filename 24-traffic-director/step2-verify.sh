#!/bin/bash
set -euo pipefail

# Check if Ingress exists
if ! kubectl get ingress traffic-director -n traffic-lab &>/dev/null; then
    echo "Ingress traffic-director not found in namespace traffic-lab"
    exit 1
fi

# Check if Ingress has correct host
HOST=$(kubectl get ingress traffic-director -n traffic-lab -o jsonpath='{.spec.rules[0].host}')
if [ "$HOST" != "myapp.local" ]; then
    echo "Ingress does not have host myapp.local (found: $HOST)"
    exit 1
fi

# Check if Ingress has 3 path rules
PATH_COUNT=$(kubectl get ingress traffic-director -n traffic-lab -o jsonpath='{.spec.rules[0].http.paths}' | jq '. | length')
if [ "$PATH_COUNT" != "3" ]; then
    echo "Ingress does not have 3 path rules (found: $PATH_COUNT)"
    exit 1
fi

# Check if paths exist (shop, api, docs)
PATHS=$(kubectl get ingress traffic-director -n traffic-lab -o jsonpath='{.spec.rules[0].http.paths[*].path}')
if [[ ! "$PATHS" =~ "/shop" ]] || [[ ! "$PATHS" =~ "/api" ]] || [[ ! "$PATHS" =~ "/docs" ]]; then
    echo "Ingress does not have all required paths (/shop, /api, /docs). Found: $PATHS"
    exit 1
fi

# Check if default backend is set
DEFAULT_BACKEND=$(kubectl get ingress traffic-director -n traffic-lab -o jsonpath='{.spec.defaultBackend.service.name}')
if [ "$DEFAULT_BACKEND" != "storefront-svc" ]; then
    echo "Ingress does not have correct default backend (expected: storefront-svc, found: $DEFAULT_BACKEND)"
    exit 1
fi

# Check if rewrite annotation exists
ANNOTATION=$(kubectl get ingress traffic-director -n traffic-lab -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/rewrite-target}')
if [ "$ANNOTATION" != "/" ]; then
    echo "Ingress does not have rewrite-target annotation set to /"
    exit 1
fi

echo "Step 2 verification passed!"
exit 0
