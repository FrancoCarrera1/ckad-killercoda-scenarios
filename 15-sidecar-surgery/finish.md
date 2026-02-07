# Congratulations!

You've successfully completed the Sidecar Surgery scenario and transformed a legacy deployment into a production-ready application!

## What You Learned

### Sidecar Pattern
- **Multi-container Pods**: Augment primary container with supporting functionality
- **Shared volumes**: Use `emptyDir` for inter-container communication
- **Separation of concerns**: App writes logs, sidecar ships them
- **Independent lifecycle**: Containers share Pod lifecycle but run independently

### Volume Types
- **emptyDir**: Temporary storage that lives with the Pod
  - Deleted when Pod terminates
  - Can be memory-backed (`medium: Memory`) for performance
  - Perfect for scratch space and inter-container sharing
- **Volume mounts**: Each container mounts what it needs

### Health Probes
- **Readiness probe**: Traffic control (is app ready for requests?)
- **Liveness probe**: Failure detection (is app alive or frozen?)
- **Probe types**: httpGet, tcpSocket, exec
- **Timing**: initialDelaySeconds, periodSeconds, timeoutSeconds, failureThreshold

### Rolling Updates
- **Automatic rollout**: Kubernetes replaces Pods gradually
- **Zero downtime**: New Pods become ready before old Pods terminate
- **Rollback capability**: `kubectl rollout undo` if issues occur
- **Status tracking**: `kubectl rollout status` monitors progress

## Key Commands Mastered

```bash
# Edit deployment in-place
kubectl edit deployment <name> -n <namespace>

# Check rollout status
kubectl rollout status deployment/<name> -n <namespace>

# View rollout history
kubectl rollout history deployment/<name> -n <namespace>

# Rollback if needed
kubectl rollout undo deployment/<name> -n <namespace>

# Check Pod container status
kubectl get pods -o wide
kubectl describe pod <name>

# View logs from specific container
kubectl logs <pod> -c <container-name>

# Execute commands in specific container
kubectl exec <pod> -c <container-name> -- <command>
```

## CKAD Exam Tips

### Multi-Container Pods (Core CKAD Topic)
Multi-container Pods are **heavily tested** on CKAD. You must master:

**Sidecar Pattern:**
- Supporting container that enhances primary container
- Examples: Log shipping, metrics collection, proxy

**Init Container Pattern:**
- Runs before main containers start
- Used for setup, configuration, waiting for dependencies

**Ambassador Pattern:**
- Proxy for external services
- Simplifies connection management

**Adapter Pattern:**
- Standardizes output from diverse sources
- Normalizes logs, metrics formats

### Health Probes (Critical CKAD Topic)
Probes are **always tested** on CKAD:

**Probe Types:**
```yaml
# HTTP probe (most common)
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

# TCP probe
readinessProbe:
  tcpSocket:
    port: 3306
  initialDelaySeconds: 5
  periodSeconds: 10

# Exec probe
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5
```

**Key Parameters:**
- `initialDelaySeconds`: Wait before first probe (avoid false failures during startup)
- `periodSeconds`: How often to probe
- `timeoutSeconds`: Probe timeout (default 1s)
- `successThreshold`: Consecutive successes needed (default 1)
- `failureThreshold`: Consecutive failures before action (default 3)

### Exam-Specific Skills

**Quick Pod Creation with Multiple Containers:**
```bash
# Start with single container
kubectl run myapp --image=nginx --dry-run=client -o yaml > pod.yaml

# Edit to add sidecar
vi pod.yaml
```

**Common Patterns to Memorize:**

**1. Shared Log Volume:**
```yaml
volumes:
- name: logs
  emptyDir: {}
containers:
- name: app
  volumeMounts:
  - name: logs
    mountPath: /var/log/app
- name: log-shipper
  volumeMounts:
  - name: logs
    mountPath: /var/log/app
```

**2. Init Container for Setup:**
```yaml
initContainers:
- name: setup
  image: busybox
  command: ['sh', '-c', 'echo Setup complete > /work-dir/ready']
  volumeMounts:
  - name: workdir
    mountPath: /work-dir
containers:
- name: app
  volumeMounts:
  - name: workdir
    mountPath: /work-dir
```

**3. Readiness + Liveness Combo:**
```yaml
containers:
- name: app
  readinessProbe:
    httpGet:
      path: /ready
      port: 8080
    initialDelaySeconds: 5
  livenessProbe:
    httpGet:
      path: /health
      port: 8080
    initialDelaySeconds: 15
```

### Time-Saving Tips

**1. Use `kubectl edit` for quick changes:**
```bash
kubectl edit deployment <name>
# Opens in editor, saves automatically apply
```

**2. Extract existing resource to modify:**
```bash
kubectl get deployment <name> -o yaml > deploy.yaml
# Edit deploy.yaml
kubectl apply -f deploy.yaml
```

**3. Check specific fields quickly:**
```bash
kubectl get pod <name> -o jsonpath='{.spec.containers[*].name}'
kubectl get pod <name> -o jsonpath='{.status.containerStatuses[*].ready}'
```

## Real-World Applications

### Logging Sidecar (Your Scenario)
```yaml
# App writes to shared volume
# Sidecar ships logs to central system
volumes:
- name: logs
  emptyDir: {}
containers:
- name: app
  volumeMounts:
  - name: logs
    mountPath: /var/log
- name: fluentd
  image: fluent/fluentd
  volumeMounts:
  - name: logs
    mountPath: /var/log
```

### Service Mesh Sidecar (Istio/Linkerd)
```yaml
# Sidecar proxy intercepts all traffic
containers:
- name: app
  image: myapp:v1
- name: istio-proxy
  image: istio/proxyv2
  # Handles traffic routing, retries, circuit breaking
```

### Database Initialization
```yaml
# Init container waits for DB to be ready
initContainers:
- name: wait-for-db
  image: busybox
  command:
  - sh
  - -c
  - until nc -z postgres 5432; do sleep 1; done
containers:
- name: app
  image: myapp:v1
```

### Configuration Reload
```yaml
# Sidecar watches ConfigMap changes
# Signals app to reload config
volumes:
- name: config
  configMap:
    name: app-config
containers:
- name: app
  volumeMounts:
  - name: config
    mountPath: /config
- name: config-reloader
  image: config-reloader:v1
  volumeMounts:
  - name: config
    mountPath: /config
```

## Best Practices

### Sidecar Design
1. **Single responsibility**: Each container does one thing well
2. **Shared volumes**: Use emptyDir for inter-container communication
3. **Resource limits**: Set limits on both containers
4. **Graceful shutdown**: Handle SIGTERM properly in both containers

### Health Probe Configuration
1. **Readiness for traffic**: Check if app can handle requests
2. **Liveness for recovery**: Check if app needs restart
3. **Appropriate delays**: Avoid restart loops during startup
4. **Lightweight checks**: Probes shouldn't stress the app
5. **Different endpoints**: Use `/ready` for readiness, `/health` for liveness

### Rolling Update Safety
1. **Readiness gates traffic**: New Pods must pass readiness before receiving traffic
2. **Liveness prevents stuck deployments**: Failed Pods get restarted
3. **Monitor rollout**: Use `kubectl rollout status` to track progress
4. **Quick rollback**: `kubectl rollout undo` if issues detected

### Volume Best Practices
1. **emptyDir for temporary**: Scratch space, inter-container sharing
2. **ConfigMap for config**: Application configuration
3. **Secret for credentials**: Sensitive data
4. **PersistentVolume for data**: Persistent application data

## Common Pitfalls to Avoid

### 1. Forgetting restartPolicy
```yaml
# Jobs and CronJobs need this
restartPolicy: Never  # or OnFailure
# Deployments default to Always
```

### 2. Probe Timing Issues
```yaml
# Too aggressive - causes restart loops
livenessProbe:
  initialDelaySeconds: 1  # BAD: App not started yet
  failureThreshold: 1     # BAD: No tolerance

# Better
livenessProbe:
  initialDelaySeconds: 30  # Give app time to start
  failureThreshold: 3      # Allow transient failures
```

### 3. Not Waiting for Rollout
```yaml
# Always wait for rollout to complete
kubectl rollout status deployment/myapp
# Don't assume it's done immediately!
```

### 4. Resource Limits on Sidecars
```yaml
# Don't forget sidecar resource limits
containers:
- name: app
  resources:
    limits:
      memory: "512Mi"
- name: sidecar
  resources:
    limits:
      memory: "128Mi"  # Sidecar needs limits too!
```

## Next Steps

Continue building CKAD mastery:
- **StatefulSets**: Persistent identity and storage
- **DaemonSets**: One Pod per node
- **Network Policies**: Pod-to-Pod communication control
- **Resource Quotas**: Namespace-level resource management

Excellent work on production-hardening your deployment!
