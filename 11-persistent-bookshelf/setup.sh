#!/bin/bash
set -euo pipefail

# Create namespace for bookshelf application
kubectl create namespace bookshelf

# Create hostPath directory on the node (for hostPath PV)
# In a multi-node cluster, this would be on specific nodes
mkdir -p /opt/bookshelf-data

echo "Bookshelf namespace and storage directory ready!"
