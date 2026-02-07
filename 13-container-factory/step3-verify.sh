#!/bin/bash
set -euo pipefail

# Run the container and check it completed successfully
container_name="verify-factory-test-$$"

# Run container
if docker run --name "$container_name" myapp:v1 > /tmp/factory-output.txt 2>&1; then
    # Check exit code
    exit_code=$(docker inspect "$container_name" --format='{{.State.ExitCode}}')

    if [[ "$exit_code" -eq 0 ]]; then
        # Verify output contains expected message
        if grep -q "Hello from the Container Factory" /tmp/factory-output.txt; then
            echo "Success: Container ran successfully with correct output"
            docker rm "$container_name" > /dev/null 2>&1
            rm -f /tmp/factory-output.txt
            exit 0
        else
            echo "Error: Container output doesn't contain expected message"
            docker rm "$container_name" > /dev/null 2>&1
            exit 1
        fi
    else
        echo "Error: Container exited with code $exit_code"
        docker rm "$container_name" > /dev/null 2>&1
        exit 1
    fi
else
    echo "Error: Failed to run container"
    docker rm "$container_name" > /dev/null 2>&1 || true
    exit 1
fi
