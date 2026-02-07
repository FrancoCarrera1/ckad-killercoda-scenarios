## Task description

The backend pod is in Error state because of a bad command flag.

Diagnose the issue:
```bash
kubectl get pod backend -n autopsy
kubectl logs backend -n autopsy
```

Fix the backend layer:
1. Delete the broken backend pod
2. Recreate it with the correct nginx command (remove the invalid `--bad-flag`)

The new backend pod should use:
- Image: `nginx:1.24`
- Label: `tier=backend`
- Correct command: `["nginx", "-g", "daemon off;"]`
- Port: `80`
- Environment variable: `DB_HOST=database-svc`

<details><summary>Hint</summary>
Check the logs with `kubectl logs` to see the nginx error. The `--bad-flag` is not a valid nginx option. Delete the pod and recreate it without that flag.
</details>

<details><summary>Solution</summary>
```bash
# Check the logs
kubectl logs backend -n autopsy

# Delete the broken pod
kubectl delete pod backend -n autopsy

# Recreate with correct command
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: autopsy
  labels:
    tier: backend
spec:
  containers:
  - name: backend
    image: nginx:1.24
    command: ["nginx", "-g", "daemon off;"]
    ports:
    - containerPort: 80
    env:
    - name: DB_HOST
      value: database-svc
EOF

# Wait for pod to become Running
kubectl wait --for=condition=Ready pod/backend -n autopsy --timeout=60s
```
</details>
