# Build Environment Overlays

Overlays allow you to customize the base configuration for different environments without modifying the original files.

## Task Description

Create two overlays: one for dev and one for prod.

### Dev Overlay (`/root/kustomize-app/overlays/dev/`)

Create `kustomization.yaml` with:
- `namespace: dev`
- `namePrefix: dev-`
- Reference to the base: `../../base`

### Prod Overlay (`/root/kustomize-app/overlays/prod/`)

Create two files:

1. **kustomization.yaml** with:
   - `namespace: prod`
   - `namePrefix: prod-`
   - Reference to the base: `../../base`
   - Replicas patch: Set `webapp` deployment to 5 replicas
   - Patch file: Reference `resource-limits-patch.yaml`

2. **resource-limits-patch.yaml**: A strategic merge patch that adds resource requests and limits to the webapp deployment:
   - Requests: CPU `100m`, Memory `128Mi`
   - Limits: CPU `250m`, Memory `256Mi`

After creating the overlays, verify them with:
```bash
kubectl kustomize /root/kustomize-app/overlays/dev/
kubectl kustomize /root/kustomize-app/overlays/prod/
```

<details><summary>Hint</summary>

Create the directory structure:
```bash
mkdir -p /root/kustomize-app/overlays/dev
mkdir -p /root/kustomize-app/overlays/prod
```

For replicas, use the `replicas` field in kustomization.yaml:
```yaml
replicas:
  - name: webapp
    count: 5
```

For patches, use the `patches` or `patchesStrategicMerge` field.

</details>

<details><summary>Solution</summary>

```bash
# Create overlay directories
mkdir -p /root/kustomize-app/overlays/dev
mkdir -p /root/kustomize-app/overlays/prod

# Create dev overlay kustomization.yaml
cat <<EOF > /root/kustomize-app/overlays/dev/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: dev
namePrefix: dev-
resources:
  - ../../base
EOF

# Create prod overlay kustomization.yaml
cat <<EOF > /root/kustomize-app/overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: prod
namePrefix: prod-
resources:
  - ../../base
replicas:
  - name: webapp
    count: 5
patchesStrategicMerge:
  - resource-limits-patch.yaml
EOF

# Create resource limits patch
cat <<EOF > /root/kustomize-app/overlays/prod/resource-limits-patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  template:
    spec:
      containers:
      - name: nginx
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
EOF

# Verify both overlays
echo "Dev overlay:"
kubectl kustomize /root/kustomize-app/overlays/dev/

echo -e "\nProd overlay:"
kubectl kustomize /root/kustomize-app/overlays/prod/
```

</details>
