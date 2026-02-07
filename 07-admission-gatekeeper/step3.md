# Step 3: Test Enforcement

Now that both namespaces are configured, let's test that the constraints are actually enforced.

## Your Task

### Test 1: LimitRange Max Rejection

In the `limitrange-lab` namespace, try to create a pod that **exceeds the LimitRange max**:

- Pod name: `too-big`
- Image: `nginx:1.24`
- Memory request: `512Mi` (exceeds the 256Mi max)

This should be **rejected** by the LimitRanger admission controller.

### Test 2: ResourceQuota Pod Limit

In the `quota-lab` namespace, create additional pods until you hit the pod count limit:

1. First, check how many pods are currently running and what the pod limit is
2. Create pods (named `extra-1`, `extra-2`, `extra-3`) until the quota is reached
3. Try to create one more pod — it should be **rejected** by the ResourceQuota

### Test 3: ResourceQuota CPU Limit

In the `quota-lab` namespace, try to create a pod with a **large CPU request** that would exceed the quota:

- Pod name: `cpu-hungry`
- Image: `nginx:1.24`
- CPU request: `800m`

Check whether this is accepted or rejected based on the remaining CPU headroom.

### Verification

After testing, save the LimitRange description to `/root/limitrange-output.txt` and the ResourceQuota description to `/root/quota-output.txt`:

```bash
kubectl describe limitrange compute-limits -n limitrange-lab > /root/limitrange-output.txt
kubectl describe resourcequota compute-quota -n quota-lab > /root/quota-output.txt
```

<details><summary>Hint</summary>

Test LimitRange max:
```bash
kubectl run too-big --image=nginx:1.24 -n limitrange-lab --requests='memory=512Mi'
# Should fail with: maximum memory usage per Container is 256Mi
```

Check quota usage:
```bash
kubectl describe resourcequota compute-quota -n quota-lab
```

Create extra pods:
```bash
kubectl run extra-1 --image=nginx:1.24 -n quota-lab
kubectl run extra-2 --image=nginx:1.24 -n quota-lab
kubectl run extra-3 --image=nginx:1.24 -n quota-lab
```

Test CPU limit:
```bash
kubectl run cpu-hungry --image=nginx:1.24 -n quota-lab --requests='cpu=800m' --limits='cpu=800m'
```

</details>

<details><summary>Solution</summary>

```bash
# Test 1: LimitRange max rejection
kubectl run too-big --image=nginx:1.24 -n limitrange-lab --requests='memory=512Mi' 2>&1 || true
# Error: maximum memory usage per Container is 256Mi, but request is 512Mi

# Test 2: ResourceQuota pod limit
# Check current usage
kubectl describe resourcequota compute-quota -n quota-lab

# Create pods until we hit the limit (quota is 6 pods, we have 3)
kubectl run extra-1 --image=nginx:1.24 -n quota-lab
kubectl run extra-2 --image=nginx:1.24 -n quota-lab
kubectl run extra-3 --image=nginx:1.24 -n quota-lab

# Now we have 6 pods — try to create a 7th
kubectl run extra-4 --image=nginx:1.24 -n quota-lab 2>&1 || true
# Error: exceeded quota: compute-quota, requested: pods=1, used: pods=6, limited: pods=6

# Test 3: ResourceQuota CPU limit
# Current usage: 6 pods × 100m = 600m requests, quota is 1000m
# 800m would bring total to 1400m, but we're already at pod limit
# If we delete a pod first to make room:
kubectl delete pod extra-3 -n quota-lab
kubectl run cpu-hungry --image=nginx:1.24 -n quota-lab --requests='cpu=800m' --limits='cpu=800m' 2>&1 || true
# Error: exceeded quota: compute-quota, requested: requests.cpu=800m,
# used: requests.cpu=500m, limited: requests.cpu=1

# Save outputs
kubectl describe limitrange compute-limits -n limitrange-lab > /root/limitrange-output.txt
kubectl describe resourcequota compute-quota -n quota-lab > /root/quota-output.txt

# View them
cat /root/limitrange-output.txt
echo "---"
cat /root/quota-output.txt
```

</details>

## Rejection Messages Explained

| Error Message | Controller | Meaning |
|--------------|------------|---------|
| "maximum memory usage per Container is 256Mi" | LimitRanger | Pod exceeds LimitRange max |
| "exceeded quota: compute-quota, requested: pods=1" | ResourceQuota | Pod count would exceed quota |
| "exceeded quota: compute-quota, requested: requests.cpu=800m" | ResourceQuota | Total CPU would exceed quota |
| "must specify limits.cpu, limits.memory" | ResourceQuota | No resources set and no LimitRange defaults |

## Admission Controller Order

1. **LimitRanger** runs first — applies defaults and validates min/max
2. **ResourceQuota** runs second — checks aggregate namespace usage
3. If either rejects, the pod is **not created**
