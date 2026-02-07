# Congratulations!

You've successfully navigated The Admission Gatekeeper and mastered resource constraints!

## What You Learned

### Admission Controllers
- **Built-in gatekeepers** that validate and mutate API requests
- **Enabled at API server level** via `--enable-admission-plugins`
- **Work in sequence**: mutating controllers first, then validating controllers
- **Key controllers**: LimitRanger, ResourceQuota, PodSecurity, NodeRestriction

### LimitRange
- **Per-pod/container constraints**
- Enforces max/min resource requests and limits
- Applies default requests/limits if not specified
- Runs BEFORE ResourceQuota

### ResourceQuota
- **Namespace-level aggregate constraints**
- Limits total resources across all pods
- Tracks CPU, memory, pod count, storage, and more
- Runs AFTER LimitRanger

### Resource Calculation
- Always calculate total usage vs quota
- Account for default requests from LimitRange
- Leave headroom for system overhead

## CKAD Exam Tips

### Quick Quota/LimitRange Checks
```bash
# View all resource constraints in a namespace
kubectl describe namespace <namespace>

# Or check individually
kubectl describe limitrange -n <namespace>
kubectl describe resourcequota -n <namespace>
```

### Common Rejection Scenarios

| Rejection | Cause | Fix |
|-----------|-------|-----|
| "maximum memory usage per Container is 256Mi" | Exceeds LimitRange max | Reduce container request |
| "exceeded quota: compute-quota" | Exceeds ResourceQuota | Delete pods or reduce replicas |
| "minimum memory usage per Container is 64Mi" | Below LimitRange min | Increase container request |

### Working Within Constraints

1. **Check the limits first**:
   ```bash
   kubectl describe limitrange -n <ns>
   kubectl describe resourcequota -n <ns>
   ```

2. **Calculate headroom**:
   - Quota hard limit - current usage = available headroom

3. **Size your deployment**:
   - Replicas × per-pod requests must fit in headroom
   - Total pods must be under quota

4. **Delete pods if needed**:
   - Sometimes you need to remove existing pods to make room

### Default Requests and Limits

If a container doesn't specify requests/limits, LimitRange applies defaults:

```yaml
# LimitRange applies these if not specified
defaultRequest:
  cpu: 100m
  memory: 128Mi
default:  # This becomes the limit
  cpu: 100m
  memory: 128Mi
```

**Exam tip**: Always check for LimitRange defaults when calculating quota usage!

### Creating Quotas and LimitRanges

**ResourceQuota example**:
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: my-namespace
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 4Gi
    limits.cpu: "8"
    limits.memory: 8Gi
    pods: "10"
```

**LimitRange example**:
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
  namespace: my-namespace
spec:
  limits:
  - max:
      cpu: "1"
      memory: 1Gi
    min:
      cpu: 10m
      memory: 10Mi
    default:
      cpu: 100m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 128Mi
    type: Container
```

### Debugging Resource Issues

1. **Pod won't create** → Check LimitRange first
2. **Still won't create** → Check ResourceQuota
3. **Need exact error** → Try to create the pod and read the message
4. **Check current usage**:
   ```bash
   kubectl describe resourcequota -n <namespace>
   ```

### Time-Saving Shortcuts

```bash
# Quick quota status
kubectl get resourcequota -n <ns>

# Quick limits check
kubectl get limitrange -n <ns>

# Create deployment with resources in one go
kubectl create deployment app --image=nginx --replicas=3 -n <ns> --dry-run=client -o yaml | \
  kubectl set resources -f - --requests=cpu=100m,memory=64Mi --limits=cpu=200m,memory=128Mi --local -o yaml | \
  kubectl apply -f -
```

### Common Exam Scenarios

- "Create a deployment that fits within the namespace quota"
- "Why is this pod being rejected?" → Check LimitRange and ResourceQuota
- "Set default resource requests for all pods in namespace X" → Create LimitRange
- "Limit total CPU in namespace to 2 cores" → Create ResourceQuota

### Remember the Order

1. **LimitRanger** validates/mutates individual pods
2. **ResourceQuota** validates aggregate namespace usage
3. If either rejects, the pod is not created

## Best Practices

### In Production

- **Always set quotas** on non-system namespaces to prevent resource exhaustion
- **Use LimitRanges** to enforce sane defaults and prevent huge requests
- **Set both requests and limits** explicitly on workloads
- **Monitor quota usage** to prevent hitting limits unexpectedly

### Quota Planning

- **CPU**: Set quota based on cluster capacity and tenant allocation
- **Memory**: Account for pod overhead (typically 100-200Mi per pod)
- **Pods**: Limit pod count to prevent API server overload
- **Storage**: Set PVC count and size limits

### LimitRange Best Practices

- **Set reasonable defaults** that work for most containers
- **Set max limits** to prevent single pods from consuming excessive resources
- **Set min limits** to ensure QoS (optional)
- **Different limits for different namespaces** based on workload types

## Next Steps

- Explore PriorityClasses and preemption
- Learn about ResourceQuota scopes (BestEffort, NotBestEffort, etc.)
- Study other admission controllers (PodSecurity, ImagePolicyWebhook)
- Practice calculating multi-deployment quota scenarios

Excellent work! Resource management is crucial for multi-tenant Kubernetes clusters and a key skill for the CKAD exam.
