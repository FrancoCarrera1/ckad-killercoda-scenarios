#!/bin/bash
set -euo pipefail

# Write test data from app container
kubectl exec webapp -n microservices -c app -- sh -c "echo 'test-log-entry' >> /var/log/app/access.log" 2>/dev/null || {
  echo "Failed to write to shared volume from app container"
  exit 1
}

# Verify log-streamer can read the file
LOG_CONTENT=$(kubectl exec webapp -n microservices -c log-streamer -- cat /var/log/app/access.log 2>/dev/null)

if [[ ! "$LOG_CONTENT" =~ "test-log-entry" ]]; then
  echo "Shared volume not working. Log-streamer cannot see the test entry."
  echo "Got: $LOG_CONTENT"
  exit 1
fi

# Verify both containers can access the volume
APP_FILE_CHECK=$(kubectl exec webapp -n microservices -c app -- ls /var/log/app/access.log 2>/dev/null || echo "not found")
SIDECAR_FILE_CHECK=$(kubectl exec webapp -n microservices -c log-streamer -- ls /var/log/app/access.log 2>/dev/null || echo "not found")

if [ "$APP_FILE_CHECK" == "not found" ] || [ "$SIDECAR_FILE_CHECK" == "not found" ]; then
  echo "Volume not properly mounted in both containers"
  exit 1
fi

echo "Shared volume working correctly between containers!"
exit 0
