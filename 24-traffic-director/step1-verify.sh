#!/bin/bash
set -euo pipefail

# Check if all three services exist
SERVICES=("storefront-svc" "api-svc" "docs-svc")
for svc in "${SERVICES[@]}"; do
    if ! kubectl get service "$svc" -n traffic-lab &>/dev/null; then
        echo "Service $svc not found in namespace traffic-lab"
        exit 1
    fi

    # Check if service exposes port 80
    PORT=$(kubectl get service "$svc" -n traffic-lab -o jsonpath='{.spec.ports[0].port}')
    if [ "$PORT" != "80" ]; then
        echo "Service $svc does not expose port 80 (found: $PORT)"
        exit 1
    fi
done

# Check if all three deployments exist
DEPLOYMENTS=("storefront" "api-server" "docs-site")
for deploy in "${DEPLOYMENTS[@]}"; do
    if ! kubectl get deployment "$deploy" -n traffic-lab &>/dev/null; then
        echo "Deployment $deploy not found in namespace traffic-lab"
        exit 1
    fi
done

# Check if all three configmaps exist
CONFIGMAPS=("storefront-page" "api-page" "docs-page")
for cm in "${CONFIGMAPS[@]}"; do
    if ! kubectl get configmap "$cm" -n traffic-lab &>/dev/null; then
        echo "ConfigMap $cm not found in namespace traffic-lab"
        exit 1
    fi
done

echo "Step 1 verification passed!"
exit 0
