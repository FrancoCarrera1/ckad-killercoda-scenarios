# Step 2: Inject ConfigMap as Environment Variables

## Task

Deploy a pod in the staging environment that loads the entire ConfigMap as environment variables using `envFrom`.

### Requirements

1. Create a pod named `webapp-staging` in the `staging` namespace:
   - Image: `nginx:1.24`
   - Inject the entire `app-config` ConfigMap as environment variables using `envFrom` with `configMapRef`

2. Verify that the environment variables are present in the running container

## Why This Matters

`envFrom` with `configMapRef` is the fastest way to inject all ConfigMap keys as environment variables. Each key becomes an env var with the same name. This is perfect for 12-factor apps that read config from the environment.

**Key difference:**
- `env.valueFrom.configMapKeyRef`: Inject individual keys (more control, more verbose)
- `envFrom.configMapRef`: Inject entire ConfigMap (faster, less control)

<details><summary>Hint 1: Using envFrom requires YAML</summary>

The `kubectl run` command doesn't support `envFrom`, so you'll need to:
1. Generate a base YAML with `kubectl run --dry-run=client -o yaml`
2. Add the `envFrom` section
3. Apply it

</details>

<details><summary>Hint 2: envFrom syntax</summary>

The YAML structure for envFrom is:
```yaml
spec:
  containers:
  - name: container-name
    image: nginx:1.24
    envFrom:
    - configMapRef:
        name: app-config
```

</details>

<details><summary>Hint 3: Verifying environment variables</summary>

Once the pod is running, exec into it:
```bash
kubectl exec webapp-staging -n staging -- env | grep -E 'DB_HOST|LOG_LEVEL|FEATURE'
```

</details>

<details><summary>Solution</summary>

```bash
# Generate base YAML and add envFrom
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: webapp-staging
  namespace: staging
spec:
  containers:
  - name: webapp
    image: nginx:1.24
    envFrom:
    - configMapRef:
        name: app-config
EOF

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod/webapp-staging -n staging --timeout=60s

# Verify environment variables are set
kubectl exec webapp-staging -n staging -- env | sort

# Check specific variables
kubectl exec webapp-staging -n staging -- sh -c 'echo "DB_HOST=$DB_HOST"'
kubectl exec webapp-staging -n staging -- sh -c 'echo "LOG_LEVEL=$LOG_LEVEL"'
kubectl exec webapp-staging -n staging -- sh -c 'echo "FEATURE_DARK_MODE=$FEATURE_DARK_MODE"'
```

Expected output:
```
DB_HOST=staging-db.internal
LOG_LEVEL=debug
FEATURE_DARK_MODE=true
```

</details>
