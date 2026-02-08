# Step 2: Set Resource Limits and Quotas

## Task

Configure resource controls to prevent Angelica's namespace from consuming excessive cluster resources.

### Requirements

1. Create a ResourceQuota named `dev-quota` in the `dev-priya` namespace with:
   - `requests.cpu: 2`
   - `requests.memory: 2Gi`
   - `pods: 10`

2. Create a LimitRange named `dev-limits` in the `dev-priya` namespace with:
   - **Default limits**: `cpu: 250m`, `memory: 256Mi`
   - **Default requests**: `cpu: 100m`, `memory: 128Mi`

## Why This Matters

- **ResourceQuota** limits the total resources a namespace can consume (prevents one team from starving others)
- **LimitRange** sets default and maximum resource values for pods/containers (ensures developers don't forget to set requests/limits)
- In the CKAD exam, you need to know how these work together!

<details><summary>Hint 1: Creating a ResourceQuota</summary>

You can use `kubectl create quota` or write a YAML manifest.

Imperative approach:

```bash
kubectl create quota <name> \
  --hard=requests.cpu=2,requests.memory=2Gi,pods=10 \
  -n <namespace>
```

</details>

<details><summary>Hint 2: Creating a LimitRange</summary>

LimitRange requires a YAML manifest. The structure is:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limits
  namespace: dev-priya
spec:
  limits:
    - default: # default limits
        cpu: 250m
        memory: 256Mi
      defaultRequest: # default requests
        cpu: 100m
        memory: 128Mi
      type: Container
```

</details>

<details><summary>Solution</summary>

```bash
# Create ResourceQuota
kubectl create quota dev-quota \
  --hard=requests.cpu=2,requests.memory=2Gi,pods=10 \
  -n dev-priya

# Create LimitRange (requires YAML)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limits
  namespace: dev-priya
spec:
  limits:
  - default:
      cpu: 250m
      memory: 256Mi
    defaultRequest:
      cpu: 100m
      memory: 128Mi
    type: Container
EOF

# Verify your work
kubectl get resourcequota dev-quota -n dev-priya
kubectl describe resourcequota dev-quota -n dev-priya
kubectl get limitrange dev-limits -n dev-priya
kubectl describe limitrange dev-limits -n dev-priya
```

</details>

## Verification

Run the verification script to check your work:

```bash
/usr/local/bin/step2-verify.sh
```
