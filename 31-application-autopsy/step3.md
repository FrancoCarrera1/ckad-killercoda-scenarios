## Task description

The frontend pod is in CrashLoopBackOff because it's trying to reach a Service that doesn't exist.

Diagnose the issue:
```bash
kubectl get pod frontend -n autopsy
kubectl logs frontend -n autopsy
```

Fix the frontend layer:
1. Create a Service named `backend-svc` in the `autopsy` namespace that:
   - Selects pods with label `tier=backend`
   - Exposes port `80`

2. Delete and recreate the frontend pod as a stable nginx pod:
   - Name: `frontend`
   - Namespace: `autopsy`
   - Image: `nginx:1.24`
   - Label: `tier=frontend`
   - Port: `80`

<details><summary>Hint</summary>
Check the logs to see the connection failure to backend-svc. Create the Service first to expose the backend pod, then recreate the frontend as a simple nginx pod instead of the failing busybox wget command.
</details>

<details><summary>Solution</summary>
```bash
# Check the logs
kubectl logs frontend -n autopsy

# Create backend Service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: autopsy
spec:
  selector:
    tier: backend
  ports:
  - port: 80
    targetPort: 80
EOF

# Delete the broken frontend pod
kubectl delete pod frontend -n autopsy

# Recreate frontend as nginx
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: autopsy
  labels:
    tier: frontend
spec:
  containers:
  - name: frontend
    image: nginx:1.24
    ports:
    - containerPort: 80
EOF

# Wait for pod to become Running
kubectl wait --for=condition=Ready pod/frontend -n autopsy --timeout=60s
```
</details>
