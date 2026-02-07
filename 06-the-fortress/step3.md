# Step 3: Test Baseline vs Restricted Enforcement

Now let's see what happens when you try to deploy non-compliant pods in namespaces with different security levels.

## Your Task

1. **Try to deploy a root-running pod in `secure-apps`** (restricted):
   - Create a pod named `root-pod` using `nginx:1.24`
   - Don't set any security context (it will run as root by default)
   - This should be **REJECTED** by the restricted policy

2. **Deploy the same root-running pod in `legacy-apps`** (baseline):
   - Create a pod named `root-pod` using `nginx:1.24`
   - Don't set any security context
   - This should **SUCCEED** because baseline allows root (as long as it's not privileged)

3. **Observe the difference**:
   - Note why one namespace accepts the pod and the other rejects it

<details><summary>Hint</summary>

A simple pod without security context:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: root-pod
  namespace: <namespace>
spec:
  containers:
  - name: nginx
    image: nginx:1.24
```

Try creating this in both namespaces and observe the results.

The key differences:
- **Restricted**: Requires `runAsNonRoot: true`, drops capabilities, seccomp, etc.
- **Baseline**: Allows running as root, but blocks privileged containers and other dangerous features

</details>

<details><summary>Solution</summary>

```bash
# Try to create root-pod in secure-apps (should FAIL)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: root-pod
  namespace: secure-apps
spec:
  containers:
  - name: nginx
    image: nginx:1.24
EOF

# You should see an error like:
# Error from server (Forbidden): pods "root-pod" is forbidden:
# violates PodSecurity "restricted:latest": ...

# Now create the same pod in legacy-apps (should SUCCEED)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: root-pod
  namespace: legacy-apps
spec:
  containers:
  - name: nginx
    image: nginx:1.24
EOF

# Verify the pod is running in legacy-apps
kubectl get pod root-pod -n legacy-apps

# Try to see if secure-apps rejected it (pod won't exist)
kubectl get pod root-pod -n secure-apps
# Should return: Error from server (NotFound)

# Compare the namespaces
kubectl get pods -n secure-apps
kubectl get pods -n legacy-apps
```

</details>

## Understanding the Difference

### Baseline Standard
- Prevents known privilege escalations
- Allows running as root
- Blocks privileged containers
- Blocks host namespaces (hostNetwork, hostPID, hostIPC)

### Restricted Standard
- Enforces all baseline requirements PLUS:
- Requires running as non-root
- Requires dropping all capabilities
- Requires read-only root filesystem
- Requires seccomp profile
- Prevents privilege escalation

This is why the `root-pod` succeeds in `legacy-apps` (baseline) but fails in `secure-apps` (restricted).
