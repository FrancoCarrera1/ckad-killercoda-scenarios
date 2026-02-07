# Add ConfigMap and Secret Generators

Kustomize can generate ConfigMaps and Secrets with automatic hash suffixes. This ensures pods are restarted when configuration changes.

## Task Description

Enhance the **prod overlay** by adding configuration generators:

1. **Add a ConfigMap generator** to `/root/kustomize-app/overlays/prod/kustomization.yaml`:
   - Name: `app-config`
   - Literals:
     - `APP_ENV=production`
     - `LOG_LEVEL=warn`

2. **Add a Secret generator** to the same file:
   - Name: `app-secret`
   - Literals:
     - `DB_PASSWORD=prodpass123`

3. **Re-apply the prod overlay**:
   ```bash
   kubectl apply -k /root/kustomize-app/overlays/prod/
   ```

4. **Verify the generated resources**:
   - Check that ConfigMap with name starting with `prod-app-config-` exists
   - Check that Secret with name starting with `prod-app-secret-` exists
   - Notice the hash suffix (e.g., `prod-app-config-6f4m2t9h8k`)

The hash suffix changes whenever the content changes, triggering pod restarts automatically.

<details><summary>Hint</summary>

Add these sections to the prod `kustomization.yaml`:

```yaml
configMapGenerator:
  - name: app-config
    literals:
      - APP_ENV=production
      - LOG_LEVEL=warn

secretGenerator:
  - name: app-secret
    literals:
      - DB_PASSWORD=prodpass123
```

List ConfigMaps with:
```bash
kubectl get configmap -n prod
```

List Secrets with:
```bash
kubectl get secret -n prod
```

</details>

<details><summary>Solution</summary>

```bash
# Update the prod kustomization.yaml to add generators
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
configMapGenerator:
  - name: app-config
    literals:
      - APP_ENV=production
      - LOG_LEVEL=warn
secretGenerator:
  - name: app-secret
    literals:
      - DB_PASSWORD=prodpass123
EOF

# Re-apply the prod overlay
kubectl apply -k /root/kustomize-app/overlays/prod/

# List ConfigMaps in prod namespace
kubectl get configmap -n prod

# List Secrets in prod namespace
kubectl get secret -n prod

# View the generated ConfigMap
kubectl get configmap -n prod -l kustomize.config.k8s.io/generated=true

# View the ConfigMap content
kubectl describe configmap -n prod | grep -A 5 "app-config"
```

</details>
