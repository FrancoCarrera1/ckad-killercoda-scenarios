# Step 2: Configure a ResourceQuota

The `quota-lab` namespace also has 3 pods running with **no resource requests or limits**. Your task is to create a ResourceQuota and ensure all pods comply.

## Examine the Current State

```bash
kubectl get pods -n quota-lab
kubectl get pod app-1 -n quota-lab -o jsonpath='{.spec.containers[0].resources}'
```

Again, no resources are set on any pod.

## Your Task

### Part 1: Create a ResourceQuota

Create a ResourceQuota named `compute-quota` in the `quota-lab` namespace:

| Resource | Hard Limit |
|----------|-----------|
| requests.cpu | 1 |
| requests.memory | 512Mi |
| limits.cpu | 2 |
| limits.memory | 1Gi |
| pods | 6 |

### Part 2: Understand the Enforcement Problem

After creating the quota, the existing 3 pods continue running — ResourceQuota doesn't evict running pods. But try creating a new pod:

```bash
kubectl run test-pod --image=nginx:1.24 -n quota-lab
```

**This will fail!** When a ResourceQuota for CPU/memory exists, **every new pod must specify resource requests and limits**. Without a LimitRange to inject defaults, the pod is rejected.

### Part 3: Create a LimitRange for Defaults

To allow new pods to be created without explicitly setting resources, create a LimitRange named `compute-limits` in the `quota-lab` namespace:

| Setting | CPU | Memory |
|---------|-----|--------|
| **default** (limit) | 200m | 128Mi |
| **defaultRequest** | 100m | 64Mi |

This LimitRange provides defaults so that new pods automatically get resource requests/limits and satisfy the ResourceQuota requirement.

### Part 4: Recreate the Pods

The existing pods still have no resources and don't count toward the quota's resource tracking properly. Delete and recreate them:

1. Delete all 3 pods in `quota-lab`
2. Recreate them with the same names and image (`nginx:1.24`)
3. Verify the quota usage is being tracked

<details><summary>Hint</summary>

ResourceQuota:
```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: quota-lab
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 512Mi
    limits.cpu: "2"
    limits.memory: 1Gi
    pods: "6"
EOF
```

LimitRange:
```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
  namespace: quota-lab
spec:
  limits:
  - default:
      cpu: 200m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    type: Container
EOF
```

Recreate pods:
```bash
kubectl delete pod app-1 app-2 app-3 -n quota-lab
for i in 1 2 3; do
  kubectl run app-$i --image=nginx:1.24 -n quota-lab
done
```

</details>

<details><summary>Solution</summary>

```bash
# Create the ResourceQuota
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: quota-lab
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 512Mi
    limits.cpu: "2"
    limits.memory: 1Gi
    pods: "6"
EOF

# Verify the quota
kubectl describe resourcequota compute-quota -n quota-lab

# Try creating a pod without resources — this will FAIL
kubectl run test-pod --image=nginx:1.24 -n quota-lab 2>&1 || true
# Error: pods "test-pod" is forbidden: failed quota: compute-quota:
# must specify limits.cpu, limits.memory, requests.cpu, requests.memory

# Create a LimitRange to provide defaults
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
  namespace: quota-lab
spec:
  limits:
  - default:
      cpu: 200m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    type: Container
EOF

# Delete and recreate the pods
kubectl delete pod app-1 app-2 app-3 -n quota-lab

for i in 1 2 3; do
  kubectl run app-$i --image=nginx:1.24 -n quota-lab
done

# Wait for pods to be ready
kubectl wait --for=condition=Ready pods --all -n quota-lab --timeout=60s

# Check quota usage — now resources are tracked
kubectl describe resourcequota compute-quota -n quota-lab
# Should show:
# Used: requests.cpu=300m, requests.memory=192Mi, pods=3
# Hard: requests.cpu=1, requests.memory=512Mi, pods=6

# Clean up the failed test pod if it somehow exists
kubectl delete pod test-pod -n quota-lab --ignore-not-found
```

</details>

## How ResourceQuota Works

- **Tracks aggregate usage** across all pods in the namespace
- **Rejects new pods** that would exceed any hard limit
- **Does not evict** existing pods — only prevents new ones from being created
- When CPU/memory quotas are set, **all new pods must have resource requests/limits** specified (either manually or via LimitRange defaults)
- The **LimitRanger** admission controller runs before **ResourceQuota**, so LimitRange defaults are applied first, then quota is checked
