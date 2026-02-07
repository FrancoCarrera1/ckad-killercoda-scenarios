## Task description

Debug the `mystery-crash` pod, which keeps crashing. Identify why it's failing and fix it.

Tasks:
1. Check the status of the `mystery-crash` pod
2. Describe the pod to see detailed information
3. Look at events to understand what's happening
4. Identify the cause of the crash (hint: it's OOMKilled - Out Of Memory)
5. Delete the pod and recreate it with a sufficient memory limit (at least 64Mi)

The crash is caused by the container trying to use more memory than its limit allows. You need to increase the memory limit.

<details><summary>Hint</summary>

Commands to investigate:
```bash
kubectl get pod mystery-crash -n observatory
kubectl describe pod mystery-crash -n observatory
kubectl get events -n observatory --sort-by='.lastTimestamp'
```

Look for:
- Pod status: `OOMKilled` or `CrashLoopBackOff`
- Events showing "OOM Killed" or memory limits exceeded
- Current memory limit in the pod spec

To fix, you'll need to:
1. Delete the existing pod
2. Create a new manifest with higher memory limits
3. Apply it

</details>

<details><summary>Solution</summary>

```bash
# Check pod status
kubectl get pod mystery-crash -n observatory

# Describe to see details
kubectl describe pod mystery-crash -n observatory

# Check events
kubectl get events -n observatory --sort-by='.lastTimestamp'

# You'll see the pod is OOMKilled because it tries to use more than 32Mi

# Delete the broken pod
kubectl delete pod mystery-crash -n observatory

# Create a fixed version with higher memory limit
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: mystery-crash
  namespace: observatory
  labels:
    app: crash-test
spec:
  containers:
  - name: memory-eater
    image: busybox:1.36
    command: ["sh", "-c", "dd if=/dev/zero of=/dev/null bs=1M"]
    resources:
      limits:
        memory: "128Mi"
      requests:
        memory: "64Mi"
EOF

# Verify the pod is now running
kubectl get pod mystery-crash -n observatory

# Check that it stays running (wait a few seconds)
sleep 5
kubectl get pod mystery-crash -n observatory
```

The pod should now be Running with the increased memory limit.

</details>
