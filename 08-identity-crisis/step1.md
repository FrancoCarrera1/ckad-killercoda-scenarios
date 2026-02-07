# Step 1: Compare Auto-Mount vs No-Mount Tokens

By default, Kubernetes automatically mounts the ServiceAccount token into every pod. Let's explore this behavior and learn how to disable it.

## Your Task

1. **Create pod with auto-mounted token**:
   - Create a pod named `auto-mount-pod` in `identity-lab` namespace
   - Use image `nginx:1.24`
   - Don't specify any ServiceAccount settings (uses default behavior)

2. **Create pod without auto-mounted token**:
   - Create a pod named `no-mount-pod` in `identity-lab` namespace
   - Use image `nginx:1.24`
   - Set `automountServiceAccountToken: false`

3. **Verify the difference**:
   - Exec into `auto-mount-pod` and check for token at `/var/run/secrets/kubernetes.io/serviceaccount/token`
   - Exec into `no-mount-pod` and verify the token is NOT present

<details><summary>Hint</summary>

To create a pod with auto-mount disabled:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: no-mount-pod
  namespace: identity-lab
spec:
  automountServiceAccountToken: false
  containers:
  - name: nginx
    image: nginx:1.24
```

To check for the token:
```bash
kubectl exec auto-mount-pod -n identity-lab -- ls -la /var/run/secrets/kubernetes.io/serviceaccount/
kubectl exec no-mount-pod -n identity-lab -- ls -la /var/run/secrets/kubernetes.io/serviceaccount/
```

The first should show `token`, `ca.crt`, and `namespace` files.
The second should show "No such file or directory".

</details>

<details><summary>Solution</summary>

```bash
# Create pod with auto-mounted token (default behavior)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: auto-mount-pod
  namespace: identity-lab
spec:
  containers:
  - name: nginx
    image: nginx:1.24
EOF

# Create pod without auto-mounted token
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-mount-pod
  namespace: identity-lab
spec:
  automountServiceAccountToken: false
  containers:
  - name: nginx
    image: nginx:1.24
EOF

# Wait for pods to be ready
kubectl wait --for=condition=Ready pod/auto-mount-pod -n identity-lab --timeout=60s
kubectl wait --for=condition=Ready pod/no-mount-pod -n identity-lab --timeout=60s

# Check auto-mount-pod (should have token)
kubectl exec auto-mount-pod -n identity-lab -- ls -la /var/run/secrets/kubernetes.io/serviceaccount/

# Output should show:
# token
# ca.crt
# namespace

# View the token (it's a JWT)
kubectl exec auto-mount-pod -n identity-lab -- cat /var/run/secrets/kubernetes.io/serviceaccount/token

# Check no-mount-pod (should NOT have token)
kubectl exec no-mount-pod -n identity-lab -- ls -la /var/run/secrets/kubernetes.io/serviceaccount/ 2>&1

# Output should show:
# ls: /var/run/secrets/kubernetes.io/serviceaccount/: No such file or directory
```

</details>

## Understanding Auto-Mount Behavior

### When Token IS Auto-Mounted (default)
- Volume mount is created at `/var/run/secrets/kubernetes.io/serviceaccount/`
- Contains: `token`, `ca.crt`, `namespace`
- Pod can authenticate to API server using this token
- Permissions determined by ServiceAccount's RBAC bindings

### When Token is NOT Auto-Mounted
- No volume mount created
- Pod cannot authenticate to API server (without providing token another way)
- Reduces attack surface for pods that don't need API access

### When to Disable Auto-Mount
- Pods that don't need to access the Kubernetes API
- Improved security posture (principle of least privilege)
- Reduces exposure if pod is compromised

### Best Practice
Disable auto-mount by default and only enable it for pods that specifically need API access.
