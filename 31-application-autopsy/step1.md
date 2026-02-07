## Task description

The database pod is Pending because it references a PersistentVolumeClaim that doesn't exist.

Diagnose the issue:
```bash
kubectl get pod database -n autopsy
kubectl describe pod database -n autopsy
```

Fix the database layer by creating:
1. A PersistentVolume named `db-pv` with:
   - Capacity: `1Gi`
   - Access mode: `ReadWriteOnce`
   - hostPath: `/opt/db-data`

2. A PersistentVolumeClaim named `db-pvc` in the `autopsy` namespace with:
   - Request: `500Mi`
   - Access mode: `ReadWriteOnce`

Wait for the database pod to become Running.

<details><summary>Hint</summary>
Check the pod events with `kubectl describe pod` to see why it's Pending. Create the PV first (cluster-scoped), then the PVC (namespaced). The pod should automatically bind once the PVC is available.
</details>

<details><summary>Solution</summary>
```bash
# Check the issue
kubectl describe pod database -n autopsy

# Create PersistentVolume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /opt/db-data
EOF

# Create PersistentVolumeClaim
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: db-pvc
  namespace: autopsy
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
EOF

# Wait for pod to become Running
kubectl wait --for=condition=Ready pod/database -n autopsy --timeout=60s
```
</details>
