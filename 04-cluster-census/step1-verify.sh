#!/bin/bash
set -euo pipefail

# Check if file exists
if [[ ! -f /root/namespaces.txt ]]; then
  echo "❌ File /root/namespaces.txt does not exist"
  exit 1
fi

# Check if file contains expected namespaces
if ! grep -q "app-team" /root/namespaces.txt; then
  echo "❌ File /root/namespaces.txt does not contain 'app-team' namespace"
  exit 1
fi

if ! grep -q "monitoring" /root/namespaces.txt; then
  echo "❌ File /root/namespaces.txt does not contain 'monitoring' namespace"
  exit 1
fi

# Check if file is not empty
if [[ ! -s /root/namespaces.txt ]]; then
  echo "❌ File /root/namespaces.txt is empty"
  exit 1
fi

echo "✅ Step 1 complete! Namespaces listed and saved to file."
exit 0
