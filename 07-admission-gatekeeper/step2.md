# Step 2: Test LimitRange and ResourceQuota Enforcement

Now let's see these admission controllers in action! You'll test both LimitRange (per-pod limits) and ResourceQuota (namespace-level limits).

## Your Task

### Part 1: Test LimitRange Rejection

1. **Check the LimitRange**:
   - View the LimitRange in the `controlled` namespace
   - Note the max limits: 256Mi memory, 256m CPU

2. **Try to create a pod that exceeds limits**:
   - Create a pod named `too-big` in the `controlled` namespace
   - Use image `nginx:1.24`
   - Request 512Mi memory (exceeds the 256Mi max)
   - The LimitRanger admission controller should **REJECT** this

### Part 2: Test ResourceQuota Enforcement

1. **Check the ResourceQuota**:
   - View the quota in the `controlled` namespace
   - Note the pod limit: 5 pods max

2. **Create 5 minimal pods**:
   - Create pods named `pod-1`, `pod-2`, `pod-3`, `pod-4`, `pod-5`
   - Use image `nginx:1.24`
   - Don't specify resources (they'll get defaults from LimitRange)

3. **Try to create a 6th pod**:
   - Try to create `pod-6`
   - The ResourceQuota admission controller should **REJECT** this

<details><summary>Hint</summary>

To view the LimitRange:
```bash
kubectl get limitrange -n controlled
kubectl describe limitrange compute-limits -n controlled
```

To view the ResourceQuota:
```bash
kubectl get resourcequota -n controlled
kubectl describe resourcequota compute-quota -n controlled
```

To create a pod with resource requests:
```bash
kubectl run too-big --image=nginx:1.24 -n controlled \
  --requests='memory=512Mi'
```

To create simple pods in a loop:
```bash
for i in {1..5}; do
  kubectl run pod-$i --image=nginx:1.24 -n controlled
done
```

</details>

<details><summary>Solution</summary>

```bash
# Part 1: Test LimitRange

# View the LimitRange
kubectl get limitrange -n controlled
kubectl describe limitrange compute-limits -n controlled

# Try to create a pod exceeding the limit
kubectl run too-big --image=nginx:1.24 -n controlled --requests='memory=512Mi'

# Expected error:
# Error from server (Forbidden): pods "too-big" is forbidden:
# maximum memory usage per Container is 256Mi, but request is 512Mi

# Part 2: Test ResourceQuota

# View the ResourceQuota
kubectl get resourcequota -n controlled
kubectl describe resourcequota compute-quota -n controlled

# Create 5 pods (this will succeed)
for i in {1..5}; do
  kubectl run pod-$i --image=nginx:1.24 -n controlled
  sleep 1
done

# Check the quota usage
kubectl describe resourcequota compute-quota -n controlled

# Try to create a 6th pod (this will fail)
kubectl run pod-6 --image=nginx:1.24 -n controlled

# Expected error:
# Error from server (Forbidden): pods "pod-6" is forbidden:
# exceeded quota: compute-quota, requested: pods=1, used: pods=5, limited: pods=5

# Verify exactly 5 pods exist
kubectl get pods -n controlled
```

</details>

## Understanding the Admission Flow

### LimitRanger Admission Controller
- **Runs BEFORE ResourceQuota**
- Validates that container/pod requests don't exceed LimitRange max
- Applies default requests/limits if not specified
- Rejects pods that violate constraints

### ResourceQuota Admission Controller
- **Runs AFTER LimitRanger**
- Validates that the sum of all pods' requests doesn't exceed quota
- Tracks usage across the namespace
- Rejects pods that would exceed quota

### Rejection Messages
- LimitRange: "maximum memory usage per Container is 256Mi"
- ResourceQuota: "exceeded quota: compute-quota, requested: pods=1"

When a pod is rejected, it's never created - the API server returns an error immediately.
