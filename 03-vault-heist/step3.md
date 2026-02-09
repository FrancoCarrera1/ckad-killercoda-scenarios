# Step 3: Verify Secret Configuration

## Task

Exec into the running pod and verify that all secrets are correctly configured.

### Verification Tasks

1. Verify environment variables `DB_USER` and `DB_PASS` are set correctly
2. Verify secret files exist at `/etc/secrets/app/` and contain the correct values
3. Verify imagePullSecrets is configured on the pod

## Why This Matters

The CKAD exam often requires you to:
- Exec into pods to troubleshoot
- Verify environment variables are set correctly
- Check that volume-mounted secrets are accessible
- Inspect pod configuration to validate imagePullSecrets

This step teaches you how to verify your secret configuration is actually working!

<details><summary>Hint 1: Checking environment variables</summary>

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

<details><summary>Hint 2: Checking mounted secret files</summary>

List files in the mounted secret directory:
```bash
kubectl exec secure-app -n vault -- ls /etc/secrets/app/
```

Read the secret files:
```bash
kubectl exec secure-app -n vault -- cat /etc/secrets/app/username
kubectl exec secure-app -n vault -- cat /etc/secrets/app/password
```

</details>

<details><summary>Hint 3: Checking imagePullSecrets</summary>

Describe the pod to see imagePullSecrets:
```bash
kubectl describe pod secure-app -n vault | grep -A2 "Image Pull Secrets"
```

Or use jsonpath:
```bash
kubectl get pod secure-app -n vault -o jsonpath='{.spec.imagePullSecrets[0].name}'
```

</details>

<details><summary>Solution</summary>

```bash
# Check environment variables
echo "=== Environment Variables ==="
kubectl exec secure-app -n vault -- env | grep DB_

# Or with echo
kubectl exec secure-app -n vault -- sh -c 'echo "DB_USER=$DB_USER"'
kubectl exec secure-app -n vault -- sh -c 'echo "DB_PASS=$DB_PASS"'

# List secret files in mounted volume
echo -e "\n=== Secret Files ==="
kubectl exec secure-app -n vault -- ls /etc/secrets/app/

# Read the secret files
echo -e "\n=== Secret File Contents ==="
kubectl exec secure-app -n vault -- cat /etc/secrets/app/username
kubectl exec secure-app -n vault -- cat /etc/secrets/app/password

# Verify imagePullSecrets
echo -e "\n=== ImagePullSecrets ==="
kubectl describe pod secure-app -n vault | grep -A2 "Image Pull Secrets"

# Or use jsonpath
kubectl get pod secure-app -n vault -o jsonpath='{.spec.imagePullSecrets[0].name}'
echo ""
```

All checks should pass:
- `DB_USER=admin` and `DB_PASS=S3cur3P@ss!`
- Files `/etc/secrets/app/username` and `/etc/secrets/app/password` exist and contain correct values
- imagePullSecret `registry-creds` is configured

</details>

After passing, congratulations! You've mastered Kubernetes secret management!