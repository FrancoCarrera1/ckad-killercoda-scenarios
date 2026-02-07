## Step 1: Create Multi-Container Pod

Create a pod with an init container, a main application container, and a sidecar container.

### Requirements

Create a pod named `webapp` in the `microservices` namespace with:

**Init Container** (runs first, must complete before main containers start):
- **Name**: `wait-for-db`
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "until nslookup database-service.microservices.svc.cluster.local; do echo waiting for db; sleep 2; done"]`

**Main Container**:
- **Name**: `app`
- **Image**: `nginx:1.24`
- **VolumeMount**: `shared-logs` mounted at `/var/log/app`

**Sidecar Container**:
- **Name**: `log-streamer`
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "tail -f /var/log/app/access.log 2>/dev/null || sleep 3600"]`
- **VolumeMount**: `shared-logs` mounted at `/var/log/app`

**Volume**:
- **Name**: `shared-logs`
- **Type**: `emptyDir` (ephemeral volume)

### Key Concepts

- **Init Containers**: Run sequentially before any main containers start. Perfect for setup tasks, waiting for dependencies, or pre-populating data.
- **Sidecar Pattern**: A helper container that runs alongside the main application, often for logging, monitoring, or proxying.
- **emptyDir Volume**: A temporary directory that exists as long as the pod exists. Shared between all containers in the pod.

<details><summary>Hint</summary>

You cannot easily generate this with kubectl, so create a YAML file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp
  namespace: microservices
spec:
  initContainers:
  - name: wait-for-db
    image: busybox:1.36
    command: ["sh", "-c", "until nslookup database-service.microservices.svc.cluster.local; do echo waiting for db; sleep 2; done"]

  containers:
  - name: app
    image: nginx:1.24
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app

  - name: log-streamer
    image: busybox:1.36
    command: ["sh", "-c", "tail -f /var/log/app/access.log 2>/dev/null || sleep 3600"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app

  volumes:
  - name: shared-logs
    emptyDir: {}
```

</details>

<details><summary>Solution</summary>

```bash
# Create the multi-container pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: webapp
  namespace: microservices
spec:
  initContainers:
  - name: wait-for-db
    image: busybox:1.36
    command: ["sh", "-c", "until nslookup database-service.microservices.svc.cluster.local; do echo waiting for db; sleep 2; done"]

  containers:
  - name: app
    image: nginx:1.24
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app

  - name: log-streamer
    image: busybox:1.36
    command: ["sh", "-c", "tail -f /var/log/app/access.log 2>/dev/null || sleep 3600"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app

  volumes:
  - name: shared-logs
    emptyDir: {}
EOF

# Watch the pod start
kubectl get pods -n microservices -w
```

You should see the pod go through these phases:
1. Init:0/1 - Init container running
2. PodInitializing - Init container completed
3. 2/2 Running - Both main containers running

</details>

### Verification

Your pod should exist with 3 containers total: 1 init container (completed) and 2 main containers (running).
