#!/bin/bash
set -euo pipefail

# Check if Bitnami repo is added
if ! helm repo list | grep -q bitnami; then
  echo "Bitnami repository not found. Please add it with 'helm repo add'."
  exit 1
fi

# Check if apache-values.yaml exists
if [ ! -f /root/apache-values.yaml ]; then
  echo "File /root/apache-values.yaml not found. Please save the default values."
  exit 1
fi

# Check if the file has content (at least 100 bytes)
file_size=$(stat -f%z /root/apache-values.yaml 2>/dev/null || stat -c%s /root/apache-values.yaml 2>/dev/null)
if [ "$file_size" -lt 100 ]; then
  echo "File /root/apache-values.yaml appears to be empty or incomplete."
  exit 1
fi

echo "Success! Bitnami repository added and apache values saved."
exit 0
