## Step 3: Verify Data Persistence

The true test of persistent storage: delete the pod and verify data survives!

### Requirements

1. Delete the current pod (not the deployment)
2. Wait for the Deployment to create a new pod
3. Verify the new pod can still read the `book1.txt` file with the same content

### Key Concepts

- **Persistent vs Ephemeral**: Unlike emptyDir, PersistentVolumes survive pod deletion
- **Data Lifecycle**: Data in PV persists until the PV is deleted
- **Pod Rescheduling**: New pods can mount the same PV and access existing data

<details><summary>Hint</summary>

Get the current pod name:
```bash
kubectl get pods -n bookshelf -l app=bookshelf
```

Delete it:
```bash
kubectl delete pod <pod-name> -n bookshelf
```

Wait for the new pod:
```bash
kubectl wait --for=condition=ready pod -l app=bookshelf -n bookshelf --timeout=60s
```

Check the file in the new pod:
```bash
NEW_POD=$(kubectl get pods -n bookshelf -l app=bookshelf -o jsonpath='{.items[0].metadata.name}')
kubectl exec $NEW_POD -n bookshelf -- cat /usr/share/nginx/html/books/book1.txt
```

</details>

<details><summary>Solution</summary>

```bash
# Get current pod name
OLD_POD=$(kubectl get pods -n bookshelf -l app=bookshelf -o jsonpath='{.items[0].metadata.name}')
echo "Current pod: $OLD_POD"

# Delete the pod (Deployment will recreate it)
kubectl delete pod $OLD_POD -n bookshelf

# Wait a moment for deletion
sleep 2

# Wait for new pod to be ready
kubectl wait --for=condition=ready pod -l app=bookshelf -n bookshelf --timeout=60s

# Get new pod name
NEW_POD=$(kubectl get pods -n bookshelf -l app=bookshelf -o jsonpath='{.items[0].metadata.name}')
echo "New pod: $NEW_POD"

# Verify data persisted
kubectl exec $NEW_POD -n bookshelf -- cat /usr/share/nginx/html/books/book1.txt

# Should output: Kubernetes In Action
```

Success! The data survived pod deletion because it's stored in the PersistentVolume, not in the pod's ephemeral storage.

</details>

### Understanding Persistence

**What persists:**
- Data in PersistentVolumes
- Data in ConfigMaps and Secrets (always persistent)
- Node's local storage (hostPath, local volumes)

**What doesn't persist:**
- Data in emptyDir volumes
- Container filesystem (unless using volumes)
- Pod state and metadata

### Real-World Scenario

This is exactly how databases run in Kubernetes:
1. StatefulSet creates pods with PVCs
2. Database writes data to the mounted PV
3. If a pod crashes or is rescheduled, the new pod mounts the same PV
4. Data is preserved across pod lifecycle

### Verification

The new pod should be running and still have access to the book1.txt file with the original content.
