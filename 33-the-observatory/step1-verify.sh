#!/bin/bash
set -euo pipefail

# Verify resource-usage.txt exists
if [ ! -f /root/resource-usage.txt ]; then
  echo "File /root/resource-usage.txt not found"
  exit 1
fi

# Check if file has content
if [ ! -s /root/resource-usage.txt ]; then
  echo "File /root/resource-usage.txt is empty"
  exit 1
fi

# Verify file contains node or pod information
if ! grep -qE "(NODE|NAME|cpu-hog|web-|api-)" /root/resource-usage.txt; then
  echo "File does not contain expected resource metrics"
  exit 1
fi

echo "Resource usage data collected successfully"
