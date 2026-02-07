#!/bin/bash
set -euo pipefail

# Check if service exists
if ! kubectl get service web-clusterip -n service-menu &>/dev/null; then
    echo "Service web-clusterip not found in namespace service-menu"
    exit 1
fi

# Check if service type is ClusterIP
SERVICE_TYPE=$(kubectl get service web-clusterip -n service-menu -o jsonpath='{.spec.type}')
if [ "$SERVICE_TYPE" != "ClusterIP" ]; then
    echo "Service web-clusterip is not of type ClusterIP (found: $SERVICE_TYPE)"
    exit 1
fi

# Check if service has correct port
SERVICE_PORT=$(kubectl get service web-clusterip -n service-menu -o jsonpath='{.spec.ports[0].port}')
if [ "$SERVICE_PORT" != "80" ]; then
    echo "Service web-clusterip does not expose port 80 (found: $SERVICE_PORT)"
    exit 1
fi

# Check if service has correct selector
SELECTOR=$(kubectl get service web-clusterip -n service-menu -o jsonpath='{.spec.selector.app}')
if [ "$SELECTOR" != "web" ]; then
    echo "Service web-clusterip does not select app=web (found: $SELECTOR)"
    exit 1
fi

echo "Step 1 verification passed!"
exit 0
