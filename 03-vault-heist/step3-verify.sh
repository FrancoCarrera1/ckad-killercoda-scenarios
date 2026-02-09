#!/bin/bash
set -euo pipefail

# Wait a bit for pod to be fully ready
sleep 2

# Check if DB_USER env var is set correctly
DB_USER=$(kubectl exec secure-app -n vault -- sh -c 'echo $DB_USER' 2>/dev/null || echo "")
if [[ "$DB_USER" != "admin" ]]; then
  echo "❌ Environment variable DB_USER is not set correctly (expected: admin, found: $DB_USER)"
  exit 1
fi

# Check if DB_PASS env var is set correctly
DB_PASS=$(kubectl exec secure-app -n vault -- sh -c 'echo $DB_PASS' 2>/dev/null || echo "")
if [[ "$DB_PASS" != "S3cur3P@ss!" ]]; then
  echo "❌ Environment variable DB_PASS is not set correctly"
  exit 1
fi

# Check file exists
if ! kubectl exec secure-app -n vault -- test -f /etc/secrets/app/username 2>/dev/null; then
  echo "❌ File /etc/secrets/app/username does not exist"
  exit 1
fi

# Verify file content
USERNAME_CONTENT=$(kubectl exec secure-app -n vault -- cat /etc/secrets/app/username 2>/dev/null || echo "")
if [[ "$USERNAME_CONTENT" != "admin" ]]; then
  echo "❌ File /etc/secrets/app/username has incorrect content (expected: admin, found: $USERNAME_CONTENT)"
  exit 1
fi

echo "✅ Step 3 complete! All secret configurations verified successfully."
echo ""
echo "Summary:"
echo "  ✓ Environment variables: DB_USER and DB_PASS set correctly"
echo "  ✓ Secret files mounted and accessible at /etc/secrets/app/"
exit 0
