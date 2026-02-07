#!/bin/bash
set -euo pipefail

# Verify app-logs.txt exists
if [ ! -f /root/app-logs.txt ]; then
  echo "File /root/app-logs.txt not found"
  exit 1
fi

# Check if file has content
if [ ! -s /root/app-logs.txt ]; then
  echo "File /root/app-logs.txt is empty"
  exit 1
fi

# Verify file contains [APP] log lines
if ! grep -q "\[APP\]" /root/app-logs.txt; then
  echo "File does not contain [APP] log entries from the app container"
  exit 1
fi

# Should NOT contain [SIDECAR] logs (we only saved app container logs)
if grep -q "\[SIDECAR\]" /root/app-logs.txt; then
  echo "File contains [SIDECAR] logs but should only have app container logs"
  exit 1
fi

echo "App container logs collected successfully"
