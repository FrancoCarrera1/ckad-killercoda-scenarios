# Congratulations!

You've successfully orchestrated a multi-container pod with init containers, sidecars, and shared volumes!

## What You Learned

### Init Containers
- Run sequentially before main containers
- Must complete successfully before the pod can start
- Perfect for setup tasks and dependency checks
- Don't count in the pod's Ready status

### Sidecar Pattern
- Auxiliary containers running alongside the main application
- Common for logging, monitoring, proxying, and configuration management
- Share the pod's network namespace and can share volumes

### Shared Volumes
- emptyDir volumes provide temporary shared storage
- All containers in a pod can mount the same volume
- Data persists through container restarts but not pod deletion
- No size limit unless specified (uses node's available space)

## CKAD Exam Tips

### Multi-Container Pod Commands

```bash
# Exec into specific container
kubectl exec <pod> -c <container> -- <command>

# View logs from specific container
kubectl logs <pod> -c <container>

# Follow logs from specific container
kubectl logs <pod> -c <container> -f

# Get previous container logs (after restart)
kubectl logs <pod> -c <container> --previous

# View all container names in a pod
kubectl get pod <pod> -o jsonpath='{.spec.containers[*].name}'
```

### Common Patterns

**Init Container for Git Clone**:
```yaml
initContainers:
- name: git-clone
  image: alpine/git
  command: ['git', 'clone', 'https://github.com/user/repo.git', '/data']
  volumeMounts:
  - name: code
    mountPath: /data
```

**Sidecar for Log Forwarding**:
```yaml
containers:
- name: app
  # main app
- name: log-forwarder
  image: fluentd
  volumeMounts:
  - name: logs
    mountPath: /var/log
```

### Debugging Multi-Container Pods

1. **Check which container is failing**: `kubectl describe pod <name>`
2. **View container-specific logs**: `kubectl logs <pod> -c <container>`
3. **Check init container logs**: `kubectl logs <pod> -c <init-container-name>`
4. **Verify volume mounts**: `kubectl describe pod <name>` and check the Mounts section
5. **Exec into specific container**: `kubectl exec <pod> -c <container> -it -- sh`

### Common Pitfalls

1. **Forgetting `-c` flag**: Multi-container pods require specifying which container
2. **Init container failures**: The pod won't start if init containers fail
3. **Ready status confusion**: Init containers don't count in `READY` (e.g., 2/2, not 3/3)
4. **RestartPolicy**: Init containers respect the pod's restart policy
5. **emptyDir size**: Without sizeLimit, can fill up node storage

### Exam Strategy

- Multi-container pods appear in 2-3 exam questions typically
- Practice creating pods with init containers quickly
- Know how to debug specific containers in multi-container pods
- Understand volume sharing between containers
- Be comfortable with `kubectl exec` and `kubectl logs` with `-c` flag

## Real-World Applications

### Service Mesh
- Sidecar proxy (Envoy) handles all network traffic
- Main container doesn't need to know about service mesh
- Automatic metrics, tracing, and traffic management

### Monitoring
- Sidecar collects metrics from main application
- Exports to Prometheus or other monitoring systems
- Main app focuses on business logic

### Secret Management
- Init container fetches secrets from Vault
- Writes to shared volume
- Main app reads secrets from volume

## What's Next?

Now that you've mastered multi-container pods, you're ready to explore:
- Persistent storage with PersistentVolumes
- Advanced volume types (ConfigMaps, Secrets, hostPath)
- StatefulSets for stateful applications

## Resource Cleanup

```bash
kubectl delete namespace microservices
```

Excellent work on orchestrating your microservices quartet!
