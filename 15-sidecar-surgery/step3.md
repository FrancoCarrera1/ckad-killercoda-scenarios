## Add Health Probes and Verify

Complete the production hardening by adding liveness and readiness probes to the `app` container.

### Task

Edit the `legacy-app` Deployment to add health probes to the `app` container:

**Readiness Probe:**
- Type: `httpGet`
- Path: `/`
- Port: `80`
- initialDelaySeconds: `5`
- periodSeconds: `10`

**Liveness Probe:**
- Type: `httpGet`
- Path: `/`
- Port: `80`
- initialDelaySeconds: `15`
- periodSeconds: `20`

After adding probes, verify the deployment:
1. Wait for rollout to complete
2. Generate traffic to test the app
3. Verify the log-collector sidecar captures the access logs

### Why These Probes?

**Readiness Probe:**
- Tells Kubernetes when Pod is ready to receive traffic
- Pod removed from Service endpoints if readiness fails
- Prevents sending traffic to unready Pods (zero-downtime deployments)

**Liveness Probe:**
- Detects if container is frozen or deadlocked
- Kubernetes restarts container if liveness fails
- Recovers from situations where app is running but not responding

**Initial Delays:**
- Readiness: 5s (nginx starts quickly)
- Liveness: 15s (give more time, avoid restart loops)

<details><summary>Hint</summary>

Edit deployment:
```bash
kubectl edit deployment legacy-app -n legacy
```

Add probes to the `app` container:
```yaml
containers:
- name: app
  image: nginx:1.24
  ports:
  - containerPort: 80
  livenessProbe:
    httpGet:
      path: /
      port: 80
    initialDelaySeconds: 15
    periodSeconds: 20
  readinessProbe:
    httpGet:
      path: /
      port: 80
    initialDelaySeconds: 5
    periodSeconds: 10
  volumeMounts:
  - name: shared-logs
    mountPath: /var/log/nginx
  - name: nginx-cache
    mountPath: /var/cache/nginx
```
</details>

<details><summary>Solution</summary>

```bash
# Edit the deployment
kubectl edit deployment legacy-app -n legacy
```

Add probes to the `app` container:

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
        livenessProbe:                    # ADD THIS
          httpGet:                        # ADD THIS
            path: /                       # ADD THIS
            port: 80                      # ADD THIS
          initialDelaySeconds: 15         # ADD THIS
          periodSeconds: 20               # ADD THIS
        readinessProbe:                   # ADD THIS
          httpGet:                        # ADD THIS
            path: /                       # ADD THIS
            port: 80                      # ADD THIS
          initialDelaySeconds: 5          # ADD THIS
          periodSeconds: 10               # ADD THIS
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

After saving, verify the changes:

```bash
# Wait for rollout to complete
kubectl rollout status deployment/legacy-app -n legacy

# Check Pods are healthy (2/2 Ready)
kubectl get pods -n legacy

# Verify probes are configured
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}'
echo
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}'

# Generate traffic
POD_NAME=$(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD_NAME -n legacy -c app -- curl -s localhost > /dev/null
echo "Generated traffic to $POD_NAME"

# Wait a moment for logs to be written
sleep 2

# Check log-collector sees the access log
echo "Checking log-collector output:"
kubectl logs $POD_NAME -n legacy -c log-collector --tail=5

# Describe Pod to see probe status
kubectl describe pod $POD_NAME -n legacy | grep -A 10 "Conditions:"
```

**Success indicators:**
- Pods show 2/2 Ready
- Readiness probe succeeds (Pod receives traffic)
- Log-collector shows nginx access logs
- Liveness probe succeeds (no restarts)
</details>
