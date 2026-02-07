# Step 2: Shared Workspace

Now you'll create a pod with two containers that share data through an emptyDir volume. This is a common pattern for sidecar containers that process or monitor files created by the main container.

## Task Description

Create a pod named `shared-workspace` in the `workshop` namespace with two containers sharing an emptyDir volume:

**Shared Volume**:
- Name: `workspace`
- Mount path: `/data` (in both containers)

**Container 1 - writer**:
- Image: `busybox:1.36`
- Command: `["sh", "-c", "while true; do date >> /data/log.txt; sleep 5; done"]`
- Continuously writes timestamps to `/data/log.txt`

**Container 2 - reader**:
- Image: `busybox:1.36`
- Command: `["sh", "-c", "tail -f /data/log.txt"]`
- Continuously reads and displays the log file

This demonstrates how containers in the same pod can communicate through shared storage, a pattern useful for log processing, data transformation pipelines, and monitoring sidecars.

<details><summary>Hint</summary>

Both containers need to mount the same volume. The structure looks like this:

```yaml
spec:
  containers:
  - name: writer
    volumeMounts:
    - name: workspace
      mountPath: /data
  - name: reader
    volumeMounts:
    - name: workspace
      mountPath: /data
  volumes:
  - name: workspace
    emptyDir: {}
```

</details>

<details><summary>Solution</summary>

```bash
# Create the pod with two containers sharing a volume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: shared-workspace
  namespace: workshop
spec:
  containers:
  - name: writer
    image: busybox:1.36
    command: ["sh", "-c", "while true; do date >> /data/log.txt; sleep 5; done"]
    volumeMounts:
    - name: workspace
      mountPath: /data
  - name: reader
    image: busybox:1.36
    command: ["sh", "-c", "tail -f /data/log.txt"]
    volumeMounts:
    - name: workspace
      mountPath: /data
  volumes:
  - name: workspace
    emptyDir: {}
EOF

# Wait for the pod to be ready
kubectl wait --for=condition=Ready pod/shared-workspace -n workshop --timeout=60s

# View logs from the reader container to see the shared data
kubectl logs shared-workspace -n workshop -c reader

# You can also exec into the writer container and verify the file
kubectl exec shared-workspace -n workshop -c writer -- cat /data/log.txt
```

</details>
