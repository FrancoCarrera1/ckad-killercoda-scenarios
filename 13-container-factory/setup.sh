#!/bin/bash
set -euo pipefail

# Create working directory
mkdir -p /root/container-factory

# Create a simple Go application
cat > /root/container-factory/main.go << 'GOEOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello from the Container Factory! Build v1")
}
GOEOF

cat > /root/container-factory/go.mod << 'GOEOF'
module container-factory

go 1.21
GOEOF

echo "Container Factory environment ready!"
