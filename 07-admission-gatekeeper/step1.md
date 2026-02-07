# Step 1: Configure a LimitRange

The `limitrange-lab` namespace has 3 pods running with **no resource requests or limits**. Your task is to create a LimitRange and update the pods to comply.

## Examine the Current State

First, check the existing pods:

```bash
kubectl get pods -n limitrange-lab
kubectl get pod app-1 -n limitrange-lab -o jsonpath='{.spec.containers[0].resources}'
```

Notice that the `resources` field is empty — no requests or limits are set.

## Your Task

### Part 1: Create a LimitRange

Create a LimitRange named `compute-limits` in the `limitrange-lab` namespace with these settings:

| Setting | CPU | Memory |
|---------|-----|--------|
| **default** (limit) | 200m | 128Mi |
| **defaultRequest** | 100m | 64Mi |
| **max** | 500m | 256Mi |
| **min** | 50m | 32Mi |

The type should be `Container`.

### Part 2: Understand Retroactive Behavior

After creating the LimitRange, check the existing pods again:

```bash
kubectl get pod app-1 -n limitrange-lab -o jsonpath='{.spec.containers[0].resources}'
```

**Key insight**: The existing pods still have no resources! LimitRange defaults are only applied when a pod is **created** (at admission time). Already-running pods are not modified.

### Part 3: Recreate the Pods

Since the existing pods don't have the LimitRange defaults, you need to delete and recreate them so the defaults get applied:

1. Delete all 3 pods
2. Recreate them with the same names and image (`nginx:1.24`)
3. Verify the LimitRange defaults were automatically injected

<details><summary>Hint</summary>

To create the LimitRange:
```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
  namespace: limitrange-lab
spec:
  limits:
  - default:
      cpu: 200m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    max:
      cpu: 500m
      memory: 256Mi
    min:
      cpu: 50m
      memory: 32Mi
    type: Container
EOF
```

To recreate pods:
```bash
kubectl delete pod app-1 app-2 app-3 -n limitrange-lab
for i in 1 2 3; do
  kubectl run app-$i --image=nginx:1.24 -n limitrange-lab
done
```

</details>

<details><summary>Solution</summary>

```bash
# Create the LimitRange
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: compute-limits
  namespace: limitrange-lab
spec:
  limits:
  - default:
      cpu: 200m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    max:
      cpu: 500m
      memory: 256Mi
    min:
      cpu: 50m
      memory: 32Mi
    type: Container
EOF

# Verify the LimitRange
kubectl describe limitrange compute-limits -n limitrange-lab

# Check existing pods — still no resources!
kubectl get pod app-1 -n limitrange-lab -o jsonpath='{.spec.containers[0].resources}'
echo ""
# Output: {} (empty)

# Delete and recreate the pods
kubectl delete pod app-1 app-2 app-3 -n limitrange-lab

for i in 1 2 3; do
  kubectl run app-$i --image=nginx:1.24 -n limitrange-lab
done

# Wait for pods to be ready
kubectl wait --for=condition=Ready pods --all -n limitrange-lab --timeout=60s

# Verify defaults were injected
kubectl get pod app-1 -n limitrange-lab -o jsonpath='{.spec.containers[0].resources}' | python3 -m json.tool
# Should show:
# {
#   "limits": { "cpu": "200m", "memory": "128Mi" },
#   "requests": { "cpu": "100m", "memory": "64Mi" }
# }
```

</details>

## How LimitRange Works

- **`default`**: The limit applied to containers that don't specify their own limits
- **`defaultRequest`**: The request applied to containers that don't specify their own requests
- **`max`**: The maximum limit a container can request (pods exceeding this are rejected)
- **`min`**: The minimum request a container must have (pods below this are rejected)
- **`type: Container`**: These rules apply per-container (can also be `Pod` or `PersistentVolumeClaim`)
