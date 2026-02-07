#!/bin/bash
set -euo pipefail

# Verify cluster-warnings.txt exists
if [ ! -f /root/cluster-warnings.txt ]; then
  echo "File /root/cluster-warnings.txt not found"
  exit 1
fi

# Verify system-health.txt exists
if [ ! -f /root/system-health.txt ]; then
  echo "File /root/system-health.txt not found"
  exit 1
fi

# Check if system-health.txt has content
if [ ! -s /root/system-health.txt ]; then
  echo "File /root/system-health.txt is empty"
  exit 1
fi

# Verify system-health.txt contains pod information
if ! grep -qE "(kube-system|NAME|Running|Pending)" /root/system-health.txt; then
  echo "File /root/system-health.txt does not contain expected system pod information"
  exit 1
fi

echo "Cluster health assessment completed successfully"
