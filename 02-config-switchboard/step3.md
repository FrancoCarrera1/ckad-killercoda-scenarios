# Step 3: Mount ConfigMap as Volume

## Task

Deploy a pod in the production environment that mounts the ConfigMap as files in a directory using volumes.

### Requirements

1. Create a pod named `webapp-prod` in the `production` namespace:
   - Image: `nginx:1.24`
   - Mount the `app-config` ConfigMap as a volume at `/etc/app-config/`
   - Each key in the ConfigMap should become a file in that directory

2. Verify that the files exist and contain the correct values

## Why This Matters

Mounting ConfigMaps as volumes is better when:
- Your app reads config files (not env vars)
- You need hot-reload capability (ConfigMap updates reflect without pod restart)
- You have large configs or binary data

Each key in the ConfigMap becomes a filename, and the value becomes the file content.

<details><summary>Hint 1: Volume mount syntax</summary>

You need two parts in the pod spec:
1. **volumes** section (defines the source)
2. **volumeMounts** section in the container (defines the mount path)

</details>

<details><summary>Hint 2: YAML structure</summary>

```yaml
spec:
  containers:
  - name: webapp
    image: nginx:1.24
    volumeMounts:
    - name: config-volume
      mountPath: /etc/app-config/
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

</details>

<details><summary>Hint 3: Verifying mounted files</summary>

After the pod is running:
```bash
# List files in the mount directory
kubectl exec webapp-prod -n production -- ls -la /etc/app-config/

# Check file contents
kubectl exec webapp-prod -n production -- cat /etc/app-config/DB_HOST
kubectl exec webapp-prod -n production -- cat /etc/app-config/LOG_LEVEL
```

</details>

<details><summary>Solution</summary>

```bash
# Create pod with ConfigMap mounted as volume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: webapp-prod
  namespace: production
spec:
  containers:
  - name: webapp
    image: nginx:1.24
    volumeMounts:
    - name: config-volume
      mountPath: /etc/app-config/
  volumes:
  - name: config-volume
    configMap:
      name: app-config
EOF

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod/webapp-prod -n production --timeout=60s

# List all config files
kubectl exec webapp-prod -n production -- ls -la /etc/app-config/

# Check each file content
echo "DB_HOST:"
kubectl exec webapp-prod -n production -- cat /etc/app-config/DB_HOST

echo "LOG_LEVEL:"
kubectl exec webapp-prod -n production -- cat /etc/app-config/LOG_LEVEL

echo "FEATURE_DARK_MODE:"
kubectl exec webapp-prod -n production -- cat /etc/app-config/FEATURE_DARK_MODE
```

Expected output:
```
DB_HOST:
prod-db.internal
LOG_LEVEL:
warn
FEATURE_DARK_MODE:
false
```

</details>

## Verification

Run the verification script to check your work:
```bash
/usr/local/bin/step3-verify.sh
```
