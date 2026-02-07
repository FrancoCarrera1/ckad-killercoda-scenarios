## Add Sidecar Container with Shared Volumes

Now you'll retrofit a log-collector sidecar and shared volumes to enable centralized logging.

### Task

Edit the `legacy-app` Deployment to add:

**1. Volumes:**
- Add an `emptyDir` volume named `shared-logs`
- Add an `emptyDir` volume named `nginx-cache` (nginx needs writable /var/cache/nginx)

**2. Update the `app` container:**
- Mount `shared-logs` at `/var/log/nginx`
- Mount `nginx-cache` at `/var/cache/nginx`

**3. Add a sidecar container:**
- **Name**: `log-collector`
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "tail -f /var/log/nginx/access.log 2>/dev/null || tail -f /dev/null"]`
- **Volume mount**: Mount `shared-logs` at `/var/log/nginx`

After editing, wait for the rollout to complete.

### Why This Design?

**emptyDir volumes** are perfect for:
- **Inter-container communication**: Share files between containers
- **Temporary storage**: Lives with the Pod, deleted when Pod terminates
- **Performance**: Stored in memory (if `medium: Memory`) or disk

**Sidecar pattern** enables:
- **Separation of concerns**: App writes logs, sidecar ships them
- **Reusability**: Same log-collector for many apps
- **Independent scaling**: Different resource limits per container

### Important Notes

- Nginx writes access logs to `/var/log/nginx/access.log`
- Nginx needs `/var/cache/nginx` to be writable (default is read-only)
- The sidecar's fallback (`|| tail -f /dev/null`) prevents crashes if log file doesn't exist yet

<details><summary>Hint</summary>

Edit the deployment:
```bash
kubectl edit deployment legacy-app -n legacy
```

Add volumes section:
```yaml
spec:
  template:
    spec:
      volumes:
      - name: shared-logs
        emptyDir: {}
      - name: nginx-cache
        emptyDir: {}
      containers:
      - name: app
        image: nginx:1.24
        ports:
        - containerPort: 80
        volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
        - name: nginx-cache
          mountPath: /var/cache/nginx
      - name: log-collector
        image: busybox:1.36
        command:
        - sh
        - -c
        - tail -f /var/log/nginx/access.log 2>/dev/null || tail -f /dev/null
        volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

Wait for rollout:
```bash
kubectl rollout status deployment/legacy-app -n legacy
```
</details>

<details><summary>Solution</summary>

```bash
# Edit the deployment
kubectl edit deployment legacy-app -n legacy
```

Update the spec to add volumes and sidecar (add the highlighted sections):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-app
  namespace: legacy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy-app
  template:
    metadata:
      labels:
        app: legacy-app
    spec:
      volumes:                          # ADD THIS
      - name: shared-logs               # ADD THIS
        emptyDir: {}                    # ADD THIS
      - name: nginx-cache               # ADD THIS
        emptyDir: {}                    # ADD THIS
      containers:
      - name: app
        image: nginx:1.24
        ports:
        - containerPort: 80
        volumeMounts:                   # ADD THIS
        - name: shared-logs             # ADD THIS
          mountPath: /var/log/nginx     # ADD THIS
        - name: nginx-cache             # ADD THIS
          mountPath: /var/cache/nginx   # ADD THIS
      - name: log-collector             # ADD THIS ENTIRE CONTAINER
        image: busybox:1.36
        command:
        - sh
        - -c
        - tail -f /var/log/nginx/access.log 2>/dev/null || tail -f /dev/null
        volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

After saving, watch the rollout:
```bash
# Watch rollout progress
kubectl rollout status deployment/legacy-app -n legacy

# Check Pods (should show 2/2 containers)
kubectl get pods -n legacy

# Verify both containers are running
kubectl get pods -n legacy -o jsonpath='{.items[0].status.containerStatuses[*].name}'

# Generate some traffic to create logs
POD_NAME=$(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD_NAME -n legacy -c app -- curl -s localhost

# Check log-collector sees the logs
kubectl logs $POD_NAME -n legacy -c log-collector
```
</details>
