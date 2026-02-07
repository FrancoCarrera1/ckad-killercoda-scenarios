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

# Check file permissions (should be 0400 = -r--------)
FILE_PERMS=$(kubectl exec secure-app -n vault -- stat -c '%a' /etc/secrets/app/username 2>/dev/null || echo "")
if [[ "$FILE_PERMS" != "400" ]]; then
  echo "❌ File /etc/secrets/app/username has incorrect permissions (expected: 400, found: $FILE_PERMS)"
  exit 1
fi

# Check process is running as UID 1000
PROCESS_UID=$(kubectl exec secure-app -n vault -- id -u 2>/dev/null || echo "")
if [[ "$PROCESS_UID" != "1000" ]]; then
  echo "❌ Process is not running as UID 1000 (found: $PROCESS_UID)"
  exit 1
fi

echo "✅ Step 3 complete! All security configurations verified successfully."
echo ""
echo "Summary:"
echo "  ✓ File permissions: 0400 (read-only for owner)"
echo "  ✓ Environment variables: DB_USER and DB_PASS set correctly"
echo "  ✓ Process UID: 1000 (non-root)"
exit 0
