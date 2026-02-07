#!/bin/bash
set -euo pipefail

# Check if node-info.txt exists
if [[ ! -f /root/node-info.txt ]]; then
  echo "❌ File /root/node-info.txt does not exist"
  exit 1
fi

# Check if file is not empty
if [[ ! -s /root/node-info.txt ]]; then
  echo "❌ File /root/node-info.txt is empty"
  exit 1
fi

# Check if file contains at least one node name (should contain "node" or "controlplane" or similar)
if ! grep -qiE "node|controlplane|master" /root/node-info.txt; then
  echo "❌ File /root/node-info.txt does not appear to contain node names"
  exit 1
fi

# Check if file contains an IP address pattern
if ! grep -qE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" /root/node-info.txt; then
  echo "❌ File /root/node-info.txt does not appear to contain IP addresses"
  exit 1
fi

# Check if services.txt exists
if [[ ! -f /root/services.txt ]]; then
  echo "❌ File /root/services.txt does not exist"
  exit 1
fi

# Check if file is not empty
if [[ ! -s /root/services.txt ]]; then
  echo "❌ File /root/services.txt is empty"
  exit 1
fi

# Check if file contains column headers
if ! grep -q "NAME" /root/services.txt; then
  echo "❌ File /root/services.txt does not contain NAME column"
  exit 1
fi

if ! grep -q "CLUSTER-IP" /root/services.txt; then
  echo "❌ File /root/services.txt does not contain CLUSTER-IP column"
  exit 1
fi

# Check if file contains at least the kubernetes service
if ! grep -q "kubernetes" /root/services.txt; then
  echo "❌ File /root/services.txt does not contain the 'kubernetes' service"
  exit 1
fi

echo "✅ Step 3 complete! Advanced output formatting mastered."
echo ""
echo "Summary:"
echo "  ✓ Node information extracted with JSONPath"
echo "  ✓ Services listed with custom columns"
exit 0
