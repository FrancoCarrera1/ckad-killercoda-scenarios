# Step 3: Verify Security Configuration

## Task

Exec into the running pod and verify that all security configurations are correctly applied.

### Verification Tasks

1. Verify the file permissions of `/etc/secrets/app/username` are `0400` (read-only for owner)
2. Verify environment variables `DB_USER` and `DB_PASS` are set correctly
3. Verify the process is running as UID 1000 (non-root)

## Why This Matters

The CKAD exam often requires you to:
- Exec into pods to troubleshoot
- Verify file permissions on mounted volumes
- Check which user is running the container process
- Validate environment variables

This step teaches you how to verify your security configuration is actually applied!

<details><summary>Hint 1: Checking file permissions</summary>

Use `ls -la` to see file permissions:
```bash
kubectl exec secure-app -n vault -- ls -la /etc/secrets/app/
```

File permission `0400` appears as `-r--------` (read-only for owner, no access for group/others).

</details>

<details><summary>Hint 2: Checking environment variables</summary>

Print environment variables:
```bash
kubectl exec secure-app -n vault -- env | grep DB_
```

Or individually:
```bash
kubectl exec secure-app -n vault -- sh -c 'echo $DB_USER'
kubectl exec secure-app -n vault -- sh -c 'echo $DB_PASS'
```

</details>

<details><summary>Hint 3: Checking process UID</summary>

Check what user the nginx process is running as:
```bash
kubectl exec secure-app -n vault -- ps aux
kubectl exec secure-app -n vault -- id
```

</details>

<details><summary>Solution</summary>

```bash
# Check file permissions of mounted secret
echo "=== File Permissions ==="
kubectl exec secure-app -n vault -- ls -la /etc/secrets/app/

# You should see:
# -r-------- 1 1000 1000  5 ... username
# -r-------- 1 1000 1000 12 ... password

# Check specific file
kubectl exec secure-app -n vault -- ls -l /etc/secrets/app/username

# Read the secret files
echo -e "\n=== Secret File Contents ==="
kubectl exec secure-app -n vault -- cat /etc/secrets/app/username
kubectl exec secure-app -n vault -- cat /etc/secrets/app/password

# Check environment variables
echo -e "\n=== Environment Variables ==="
kubectl exec secure-app -n vault -- env | grep DB_

# Or with echo
kubectl exec secure-app -n vault -- sh -c 'echo "DB_USER=$DB_USER"'
kubectl exec secure-app -n vault -- sh -c 'echo "DB_PASS=$DB_PASS"'

# Check process user ID
echo -e "\n=== Process User ID ==="
kubectl exec secure-app -n vault -- id

# Expected output:
# uid=1000 gid=1000 groups=1000

# Check nginx process
kubectl exec secure-app -n vault -- ps aux

# Verify nginx is running as UID 1000 (not root)
```

All checks should pass:
- Files have `-r--------` permissions (0400)
- `DB_USER=admin` and `DB_PASS=S3cur3P@ss!`
- Process runs as `uid=1000`

</details>

After passing, congratulations! You've mastered Kubernetes secrets and security contexts!