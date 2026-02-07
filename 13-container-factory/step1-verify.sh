#!/bin/bash
set -euo pipefail

# Check if the image myapp:v1 exists
if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^myapp:v1$"; then
    echo "Success: Image myapp:v1 exists"
    exit 0
else
    echo "Error: Image myapp:v1 not found"
    echo "Run: docker build -t myapp:v1 /root/container-factory"
    exit 1
fi
