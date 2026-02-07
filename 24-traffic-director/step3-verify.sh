#!/bin/bash
set -euo pipefail

# Verify Ingress still has correct configuration (same as step 2)
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

# Verify all backend services are still running
SERVICES=("storefront-svc" "api-svc" "docs-svc")
for svc in "${SERVICES[@]}"; do
    if ! kubectl get service "$svc" -n traffic-lab &>/dev/null; then
        echo "Service $svc not found in namespace traffic-lab"
        exit 1
    fi
done

# Check if all deployments have at least 1 ready replica
DEPLOYMENTS=("storefront" "api-server" "docs-site")
for deploy in "${DEPLOYMENTS[@]}"; do
    READY=$(kubectl get deployment "$deploy" -n traffic-lab -o jsonpath='{.status.readyReplicas}')
    if [ "$READY" != "1" ]; then
        echo "Deployment $deploy does not have 1 ready replica (found: $READY)"
        exit 1
    fi
done

echo "Step 3 verification passed!"
exit 0
