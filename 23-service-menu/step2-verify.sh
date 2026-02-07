#!/bin/bash
set -euo pipefail

# Check if service exists
if ! kubectl get service web-nodeport -n service-menu &>/dev/null; then
    echo "Service web-nodeport not found in namespace service-menu"
    exit 1
fi

# Check if service type is NodePort
SERVICE_TYPE=$(kubectl get service web-nodeport -n service-menu -o jsonpath='{.spec.type}')
if [ "$SERVICE_TYPE" != "NodePort" ]; then
    echo "Service web-nodeport is not of type NodePort (found: $SERVICE_TYPE)"
    exit 1
fi

# Check if service has correct port
SERVICE_PORT=$(kubectl get service web-nodeport -n service-menu -o jsonpath='{.spec.ports[0].port}')
if [ "$SERVICE_PORT" != "80" ]; then
    echo "Service web-nodeport does not expose port 80 (found: $SERVICE_PORT)"
    exit 1
fi

# Check if service has correct nodePort
NODE_PORT=$(kubectl get service web-nodeport -n service-menu -o jsonpath='{.spec.ports[0].nodePort}')
if [ "$NODE_PORT" != "30080" ]; then
    echo "Service web-nodeport does not use nodePort 30080 (found: $NODE_PORT)"
    exit 1
fi

# Check if service has correct selector
SELECTOR=$(kubectl get service web-nodeport -n service-menu -o jsonpath='{.spec.selector.app}')
if [ "$SELECTOR" != "web" ]; then
    echo "Service web-nodeport does not select app=web (found: $SELECTOR)"
    exit 1
fi

echo "Step 2 verification passed!"
exit 0
