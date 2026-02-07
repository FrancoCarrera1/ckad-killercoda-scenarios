#!/bin/bash
set -euo pipefail

# Check if ExternalName service exists
if ! kubectl get service external-api -n service-menu &>/dev/null; then
    echo "Service external-api not found in namespace service-menu"
    exit 1
fi

# Check if ExternalName service type is correct
SERVICE_TYPE=$(kubectl get service external-api -n service-menu -o jsonpath='{.spec.type}')
if [ "$SERVICE_TYPE" != "ExternalName" ]; then
    echo "Service external-api is not of type ExternalName (found: $SERVICE_TYPE)"
    exit 1
fi

# Check if ExternalName points to correct domain
EXTERNAL_NAME=$(kubectl get service external-api -n service-menu -o jsonpath='{.spec.externalName}')
if [ "$EXTERNAL_NAME" != "api.example.com" ]; then
    echo "Service external-api does not point to api.example.com (found: $EXTERNAL_NAME)"
    exit 1
fi

# Check if Headless service exists
if ! kubectl get service web-headless -n service-menu &>/dev/null; then
    echo "Service web-headless not found in namespace service-menu"
    exit 1
fi

# Check if Headless service has clusterIP: None
CLUSTER_IP=$(kubectl get service web-headless -n service-menu -o jsonpath='{.spec.clusterIP}')
if [ "$CLUSTER_IP" != "None" ]; then
    echo "Service web-headless does not have clusterIP: None (found: $CLUSTER_IP)"
    exit 1
fi

# Check if Headless service has correct selector
SELECTOR=$(kubectl get service web-headless -n service-menu -o jsonpath='{.spec.selector.app}')
if [ "$SELECTOR" != "web" ]; then
    echo "Service web-headless does not select app=web (found: $SELECTOR)"
    exit 1
fi

# Check if Headless service has correct port
SERVICE_PORT=$(kubectl get service web-headless -n service-menu -o jsonpath='{.spec.ports[0].port}')
if [ "$SERVICE_PORT" != "80" ]; then
    echo "Service web-headless does not expose port 80 (found: $SERVICE_PORT)"
    exit 1
fi

echo "Step 3 verification passed!"
exit 0
