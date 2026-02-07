## Step 1: Create Storage Resources

Create the storage foundation: StorageClass, PersistentVolume, and PersistentVolumeClaim.

### Requirements

**StorageClass** named `local-fast`:
- **Provisioner**: `kubernetes.io/no-provisioner` (manual provisioning)
- **VolumeBindingMode**: `WaitForFirstConsumer`

**PersistentVolume** named `bookshelf-pv`:
- **Capacity**: 1Gi
- **AccessModes**: ReadWriteOnce
- **StorageClassName**: `local-fast`
- **HostPath**: `/opt/bookshelf-data`
- **NodeAffinity**: Require node with hostname `controlplane`

**PersistentVolumeClaim** named `bookshelf-pvc` in `bookshelf` namespace:
- **Storage Request**: 500Mi
- **AccessModes**: ReadWriteOnce
- **StorageClassName**: `local-fast`

### Key Concepts

- **StorageClass**: Defines the "class" of storage (performance tier, provisioner, policies)
- **VolumeBindingMode**:
  - `Immediate`: Bind PVC to PV immediately
  - `WaitForFirstConsumer`: Delay binding until a pod uses the PVC (better for topology constraints)
- **PersistentVolume**: The actual storage resource (admin creates this)
- **PersistentVolumeClaim**: Request for storage (developer creates this)
- **AccessModes**:
  - `ReadWriteOnce` (RWO): Mounted read-write by a single node
  - `ReadOnlyMany` (ROX): Mounted read-only by many nodes
  - `ReadWriteMany` (RWX): Mounted read-write by many nodes

<details><summary>Hint</summary>

Create each resource with YAML. The StorageClass is cluster-scoped, PV is cluster-scoped, and PVC is namespaced.

StorageClass template:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-fast
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

PersistentVolume template:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: bookshelf-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: local-fast
  hostPath:
    path: /opt/bookshelf-data
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - controlplane
```

PersistentVolumeClaim template:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bookshelf-pvc
  namespace: bookshelf
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: local-fast
  resources:
    requests:
      storage: 500Mi
```

</details>

<details><summary>Solution</summary>

```bash
# Create StorageClass
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-fast
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF

# Create PersistentVolume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: bookshelf-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: local-fast
  hostPath:
    path: /opt/bookshelf-data
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - controlplane
EOF

# Create PersistentVolumeClaim
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bookshelf-pvc
  namespace: bookshelf
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: local-fast
  resources:
    requests:
      storage: 500Mi
EOF

# Check resources
kubectl get storageclass
kubectl get pv
kubectl get pvc -n bookshelf
```

Note: The PVC will remain in `Pending` state until a pod uses it (WaitForFirstConsumer mode).

</details>

### Understanding the Storage Chain

```
StorageClass (defines policy)
    ↓
PersistentVolume (actual storage)
    ↓
PersistentVolumeClaim (request for storage)
    ↓
Pod (uses the claim)
```

### Verification

All three storage resources should be created. The PVC may be Pending (this is expected with WaitForFirstConsumer).
