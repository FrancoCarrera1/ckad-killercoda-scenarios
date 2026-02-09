#!/bin/bash
set -euo pipefail

# Check if all-pods.txt exists and is non-empty
if [[ ! -f /root/all-pods.txt ]]; then
  echo "File /root/all-pods.txt does not exist"
  exit 1
fi

if [[ ! -s /root/all-pods.txt ]]; then
  echo "File /root/all-pods.txt is empty"
  exit 1
fi

# Check if system-pods.txt exists and is non-empty
if [[ ! -f /root/system-pods.txt ]]; then
  echo "File /root/system-pods.txt does not exist"
  exit 1
fi

if [[ ! -s /root/system-pods.txt ]]; then
  echo "File /root/system-pods.txt is empty"
  exit 1
fi

echo "Success: Pod inventory files created"
exit 0
