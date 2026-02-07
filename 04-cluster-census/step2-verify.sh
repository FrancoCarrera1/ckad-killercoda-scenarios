#!/bin/bash
set -euo pipefail

# Check if all-pods.txt exists
if [[ ! -f /root/all-pods.txt ]]; then
  echo "❌ File /root/all-pods.txt does not exist"
  exit 1
fi

# Check if file contains pods from multiple namespaces
NAMESPACE_COUNT=$(grep -E "app-team|monitoring|kube-system" /root/all-pods.txt | wc -l)
if [[ "$NAMESPACE_COUNT" -lt 2 ]]; then
  echo "❌ File /root/all-pods.txt does not contain pods from multiple namespaces"
  exit 1
fi

# Check if system-pods.txt exists
if [[ ! -f /root/system-pods.txt ]]; then
  echo "❌ File /root/system-pods.txt does not exist"
  exit 1
fi

# Check if system-pods.txt contains kube-system pods
if ! grep -q "kube-system" /root/system-pods.txt; then
  echo "❌ File /root/system-pods.txt does not contain kube-system namespace"
  exit 1
fi

# Check that system-pods.txt doesn't contain other namespaces
if grep -qE "app-team|monitoring" /root/system-pods.txt 2>/dev/null; then
  echo "❌ File /root/system-pods.txt should only contain kube-system pods (found other namespaces)"
  exit 1
fi

# Check that files are not empty
if [[ ! -s /root/all-pods.txt ]]; then
  echo "❌ File /root/all-pods.txt is empty"
  exit 1
fi

if [[ ! -s /root/system-pods.txt ]]; then
  echo "❌ File /root/system-pods.txt is empty"
  exit 1
fi

echo "✅ Step 2 complete! Pod inventories created with correct filtering."
exit 0
