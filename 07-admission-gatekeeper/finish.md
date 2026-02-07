# Congratulations!

You've successfully configured LimitRange and ResourceQuota to control resource usage in your cluster!

## What You Learned

### LimitRange
- Sets **per-container** defaults, min, and max resource constraints
- Defaults are only applied at **pod creation time** — not retroactively
- Existing pods must be **deleted and recreated** to pick up new defaults
- Pods exceeding `max` or below `min` are rejected immediately

### ResourceQuota
- Sets **namespace-level** aggregate resource caps
- Tracks total CPU, memory, and pod count across all pods
- When CPU/memory quotas exist, **every new pod must specify resources**
- A LimitRange providing defaults solves the "must specify resources" problem
- Does **not evict** running pods — only prevents new ones

### Admission Controller Order
1. **LimitRanger** runs first (applies defaults, validates min/max)
2. **ResourceQuota** runs second (checks namespace totals)
3. If either rejects, the pod is not created

## CKAD Exam Tips

### Quick Reference Commands
```bash
# View all resource constraints in a namespace
kubectl describe namespace <namespace>

# Check LimitRange
kubectl describe limitrange -n <namespace>

# Check ResourceQuota and current usage
kubectl describe resourcequota -n <namespace>
```

### Common Exam Scenarios

| Task | What to Create |
|------|---------------|
| "Set default resource requests for all pods" | LimitRange with `default` and `defaultRequest` |
| "Limit total CPU in namespace to 2 cores" | ResourceQuota with `requests.cpu: "2"` |
| "Prevent pods from requesting more than 512Mi" | LimitRange with `max.memory: 512Mi` |
| "Limit namespace to 10 pods" | ResourceQuota with `pods: "10"` |

### Calculating Quota Headroom
```bash
# Check current usage vs limits
kubectl describe resourcequota compute-quota -n <namespace>
# Headroom = Hard limit - Used
```

### Key Gotcha
When a ResourceQuota for CPU/memory exists but there's no LimitRange, new pods **must** explicitly set resource requests and limits or they'll be rejected with a 403 error. Always pair ResourceQuota with a LimitRange that provides defaults.

## Example YAML Templates

**LimitRange**:
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
spec:
  limits:
  - default:
      cpu: 200m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    max:
      cpu: "1"
      memory: 512Mi
    min:
      cpu: 50m
      memory: 32Mi
    type: Container
```

**ResourceQuota**:
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 2Gi
    limits.cpu: "4"
    limits.memory: 4Gi
    pods: "10"
```

Great work mastering resource constraints!
