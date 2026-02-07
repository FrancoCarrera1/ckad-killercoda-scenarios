#!/bin/bash
set -euo pipefail

# Check if the admission-plugins.txt file exists
if [ ! -f /root/admission-plugins.txt ]; then
  echo "File /root/admission-plugins.txt not found. Save the admission controller list to this file."
  exit 1
fi

# Check if the file has content
if [ ! -s /root/admission-plugins.txt ]; then
  echo "File /root/admission-plugins.txt is empty. Save the admission controller list to this file."
  exit 1
fi

echo "Success: Admission controller list has been saved"
exit 0
