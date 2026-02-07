#!/bin/bash
set -euo pipefail

# Check if both tags exist
v1_exists=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -c "^myapp:v1$" || true)
latest_exists=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -c "^myapp:latest$" || true)

if [[ "$v1_exists" -eq 1 && "$latest_exists" -eq 1 ]]; then
    echo "Success: Both myapp:v1 and myapp:latest exist"
    exit 0
else
    echo "Error: Missing image tags"
    [[ "$v1_exists" -eq 0 ]] && echo "  - myapp:v1 not found"
    [[ "$latest_exists" -eq 0 ]] && echo "  - myapp:latest not found"
    exit 1
fi
