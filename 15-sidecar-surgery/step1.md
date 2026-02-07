## Examine the Legacy Deployment

Before making changes, you need to understand the current state of the deployment.

### Task

Examine the existing `legacy-app` Deployment in the `legacy` namespace and identify what's missing:

1. **Describe the deployment**: Use `kubectl describe` to view full details
2. **Check the Pod spec**: Look for health probes, volumes, and sidecar containers
3. **View a Pod**: Examine one of the running Pods

### What to Look For

Note the following gaps:
- **No liveness probe**: Kubernetes can't detect if the app is frozen
- **No readiness probe**: Traffic may be sent before app is ready
- **No sidecar containers**: Only one container per Pod
- **No volumes**: No shared storage between containers
- **No logging infrastructure**: Logs only available via kubectl

### Requirements

- Deployment exists in `legacy` namespace
- Deployment has 2 replicas
- Pods are running but lack health probes and sidecars

<details><summary>Hint</summary>

Useful commands:
```bash
# Get deployment details
kubectl get deployment legacy-app -n legacy -o yaml

# Describe deployment
kubectl describe deployment legacy-app -n legacy

# Get Pods
kubectl get pods -n legacy

# Describe a Pod
kubectl describe pod <pod-name> -n legacy

# Check what's in the Pod spec
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec}' | jq
```
</details>

<details><summary>Solution</summary>

```bash
# View the deployment
kubectl get deployment legacy-app -n legacy

# Get detailed deployment info
kubectl describe deployment legacy-app -n legacy

# View the Pod template
kubectl get deployment legacy-app -n legacy -o yaml

# Check running Pods
kubectl get pods -n legacy

# Examine a Pod in detail
POD_NAME=$(kubectl get pods -n legacy -l app=legacy-app -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD_NAME -n legacy

# Check for health probes (should be empty)
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}'
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}'

# Check number of containers (should be 1)
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.containers[*].name}'

# Check volumes (should be empty or minimal)
kubectl get deployment legacy-app -n legacy -o jsonpath='{.spec.template.spec.volumes}'
```

**Key Observations:**
- Deployment has 1 container named "app"
- No livenessProbe or readinessProbe configured
- No additional sidecar containers
- No shared volumes for logging
- Basic nginx setup without observability
</details>
