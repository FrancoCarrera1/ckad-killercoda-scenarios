#!/bin/bash
set -euo pipefail

# Check if pod exists
if ! kubectl get pod shared-workspace -n workshop &>/dev/null; then
  echo "Pod 'shared-workspace' does not exist in namespace 'workshop'"
  exit 1
fi

# Check if pod is running with 2/2 containers ready
READY_CONTAINERS=$(kubectl get pod shared-workspace -n workshop -o jsonpath='{.status.containerStatuses[?(@.ready==true)]}' | jq '. | length')
TOTAL_CONTAINERS=$(kubectl get pod shared-workspace -n workshop -o jsonpath='{.spec.containers}' | jq '. | length')

if [ "$TOTAL_CONTAINERS" != "2" ]; then
  echo "Pod 'shared-workspace' does not have 2 containers (found: $TOTAL_CONTAINERS)"
  exit 1
fi

if [ "$READY_CONTAINERS" != "2" ]; then
  echo "Pod 'shared-workspace' does not have 2/2 containers ready (ready: $READY_CONTAINERS)"
  exit 1
fi

# Check if the log.txt file exists in the shared volume
sleep 3  # Give it a moment to write
if ! kubectl exec shared-workspace -n workshop -c writer -- test -f /data/log.txt 2>/dev/null; then
  echo "File /data/log.txt does not exist in the shared workspace"
  exit 1
fi

# Verify the file has content (writer is working)
LOG_LINES=$(kubectl exec shared-workspace -n workshop -c writer -- wc -l /data/log.txt 2>/dev/null | awk '{print $1}')
if [ "$LOG_LINES" -lt 1 ]; then
  echo "File /data/log.txt exists but has no content"
  exit 1
fi

# Verify both containers can access the same file
WRITER_FILE=$(kubectl exec shared-workspace -n workshop -c writer -- cat /data/log.txt 2>/dev/null)
READER_FILE=$(kubectl exec shared-workspace -n workshop -c reader -- cat /data/log.txt 2>/dev/null)

if [ "$WRITER_FILE" != "$READER_FILE" ]; then
  echo "Containers are not sharing the same workspace correctly"
  exit 1
fi

echo "Verification passed: Pod is running with 2/2 containers sharing workspace"
exit 0
