# Step 2: Deploy a Restricted-Compliant Pod

Now that the `secure-apps` namespace enforces the `restricted` standard, you need to create a pod that meets all the requirements. This is challenging because the `restricted` standard has strict requirements!

## Your Task

Create a pod named `compliant-nginx` in the `secure-apps` namespace that:

1. **Uses the image**: `nginx:1.24`
2. **Security Context Requirements**:
   - `runAsNonRoot: true`
   - `runAsUser: 1000`
   - Drop ALL capabilities: `capabilities: { drop: ["ALL"] }`
   - Set seccomp profile: `seccompProfile: { type: RuntimeDefault }`
   - Use read-only root filesystem: `readOnlyRootFilesystem: true`

3. **Handle Nginx's writable directories**:
   - Nginx needs to write to certain directories
   - Add `emptyDir` volumes for:
     - `/var/cache/nginx`
     - `/var/run`
     - `/tmp`

## Why These Requirements?

The `restricted` Pod Security Standard requires:
- Running as non-root (prevents many privilege escalation attacks)
- Dropping all capabilities (reduces attack surface)
- Seccomp profile (restricts system calls)
- Read-only root filesystem (prevents tampering)

<details><summary>Hint</summary>

Here's the structure you need:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: compliant-nginx
  namespace: secure-apps
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx:1.24
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
    volumeMounts:
    - name: cache
      mountPath: /var/cache/nginx
    - name: run
      mountPath: /var/run
    - name: tmp
      mountPath: /tmp
  volumes:
  - name: cache
    emptyDir: {}
  - name: run
    emptyDir: {}
  - name: tmp
    emptyDir: {}
```

You can create this pod using `kubectl apply -f <filename>` or by using a heredoc.

</details>

<details><summary>Solution</summary>

```bash
# Create the compliant pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: compliant-nginx
  namespace: secure-apps
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx:1.24
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
    volumeMounts:
    - name: cache
      mountPath: /var/cache/nginx
    - name: run
      mountPath: /var/run
    - name: tmp
      mountPath: /tmp
  volumes:
  - name: cache
    emptyDir: {}
  - name: run
    emptyDir: {}
  - name: tmp
    emptyDir: {}
EOF

# Wait for the pod to be ready
kubectl wait --for=condition=Ready pod/compliant-nginx -n secure-apps --timeout=60s

# Verify the pod is running
kubectl get pod compliant-nginx -n secure-apps

# Check the security context
kubectl get pod compliant-nginx -n secure-apps -o yaml | grep -A 20 securityContext
```

</details>

## Common Restricted Standard Requirements

- `runAsNonRoot: true` - Must not run as root
- `allowPrivilegeEscalation: false` - Prevents privilege escalation
- `capabilities: drop: ["ALL"]` - Drops all Linux capabilities
- `seccompProfile: RuntimeDefault` - Applies default seccomp profile
- `readOnlyRootFilesystem: true` - Makes root filesystem read-only

If your pod is rejected, check the error message carefully - it will tell you exactly which requirement is not met!
