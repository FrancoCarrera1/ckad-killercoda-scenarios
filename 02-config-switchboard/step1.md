# Step 1: Create Environment-Specific ConfigMaps

## Task

Create identical ConfigMaps in both the staging and production namespaces, but with different values appropriate for each environment.

### Requirements

1. In the `staging` namespace, create a ConfigMap named `app-config` with:
   - `DB_HOST=staging-db.internal`
   - `LOG_LEVEL=debug`
   - `FEATURE_DARK_MODE=true`

2. In the `production` namespace, create a ConfigMap named `app-config` with:
   - `DB_HOST=prod-db.internal`
   - `LOG_LEVEL=warn`
   - `FEATURE_DARK_MODE=false`

## Why This Matters

The same application can use the same ConfigMap **name** but get different values based on which namespace it's deployed in. This is a common pattern for multi-environment deployments.

<details><summary>Hint 1: Creating ConfigMaps with literal values</summary>

Use `kubectl create configmap` with `--from-literal` flags:
```bash
kubectl create configmap <name> \
  --from-literal=KEY1=value1 \
  --from-literal=KEY2=value2 \
  -n <namespace>
```

</details>

<details><summary>Hint 2: Multiple literal values</summary>

You can chain multiple `--from-literal` flags:
```bash
kubectl create configmap app-config \
  --from-literal=DB_HOST=staging-db.internal \
  --from-literal=LOG_LEVEL=debug \
  --from-literal=FEATURE_DARK_MODE=true \
  -n staging
```

</details>

<details><summary>Solution</summary>

```bash
# Create staging ConfigMap
kubectl create configmap app-config \
  --from-literal=DB_HOST=staging-db.internal \
  --from-literal=LOG_LEVEL=debug \
  --from-literal=FEATURE_DARK_MODE=true \
  -n staging

# Create production ConfigMap
kubectl create configmap app-config \
  --from-literal=DB_HOST=prod-db.internal \
  --from-literal=LOG_LEVEL=warn \
  --from-literal=FEATURE_DARK_MODE=false \
  -n production

# Verify both ConfigMaps
kubectl get configmap app-config -n staging -o yaml
kubectl get configmap app-config -n production -o yaml

# Compare the data sections
kubectl get configmap app-config -n staging -o jsonpath='{.data}'
kubectl get configmap app-config -n production -o jsonpath='{.data}'
```

</details>

## Verification

Run the verification script to check your work:
```bash
/usr/local/bin/step1-verify.sh
```
