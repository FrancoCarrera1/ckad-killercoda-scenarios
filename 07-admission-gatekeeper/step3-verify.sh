#!/bin/bash
set -euo pipefail

# Check that the output files exist
if [ ! -f /root/limitrange-output.txt ]; then
  echo "File /root/limitrange-output.txt not found"
  echo "Run: kubectl describe limitrange compute-limits -n limitrange-lab > /root/limitrange-output.txt"
  exit 1
fi

if [ ! -s /root/limitrange-output.txt ]; then
  echo "File /root/limitrange-output.txt is empty"
  exit 1
fi

if [ ! -f /root/quota-output.txt ]; then
  echo "File /root/quota-output.txt not found"
  echo "Run: kubectl describe resourcequota compute-quota -n quota-lab > /root/quota-output.txt"
  exit 1
fi

if [ ! -s /root/quota-output.txt ]; then
  echo "File /root/quota-output.txt is empty"
  exit 1
fi

echo "Success: Enforcement tests completed and output files saved"
exit 0
