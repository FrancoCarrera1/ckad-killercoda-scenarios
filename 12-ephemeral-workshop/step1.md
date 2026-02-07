# Step 1: Memory-Backed Cache

In this step, you'll create a pod with a memory-backed emptyDir volume. This is perfect for caching scenarios where speed is critical and data doesn't need to persist.

## Task Description

Create a pod named `memory-cache` in the `workshop` namespace with the following specifications:

- **Image**: `busybox:1.36`
- **Command**: `sleep 3600`
- **Volume**: emptyDir with these properties:
  - Name: `cache`
  - Medium: `Memory` (stores data in RAM instead of disk)
  - Size limit: `64Mi` (prevents excessive memory usage)
- **Mount**: Mount the volume at `/cache`

Memory-backed emptyDir volumes use tmpfs, which is very fast but counts against the container's memory limit. Always set a sizeLimit to prevent out-of-memory issues.

<details><summary>Hint</summary>

You can create a pod imperatively and then edit it, or write a YAML manifest directly. The key fields are:

```yaml
volumes:
- name: cache
  emptyDir:
    medium: Memory
    sizeLimit: 64Mi
volumeMounts:
- name: cache
  mountPath: /cache
```

</details>

<details><summary>Solution</summary>

```bash
# Create the pod with a YAML manifest
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-cache
  namespace: workshop
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: cache
      mountPath: /cache
  volumes:
  - name: cache
    emptyDir:
      medium: Memory
      sizeLimit: 64Mi
EOF

# Verify the pod is running
kubectl get pod memory-cache -n workshop

# Verify the volume is memory-backed
kubectl describe pod memory-cache -n workshop | grep -A 5 "Volumes:"
```

</details>
