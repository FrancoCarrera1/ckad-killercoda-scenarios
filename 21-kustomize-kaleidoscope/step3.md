# Deploy Both Environments

Now it's time to apply your Kustomize configurations to the cluster and see the overlays in action.

## Task Description

1. **Apply the dev overlay**:
   ```bash
   kubectl apply -k /root/kustomize-app/overlays/dev/
   ```

2. **Apply the prod overlay**:
   ```bash
   kubectl apply -k /root/kustomize-app/overlays/prod/
   ```

3. **Verify the deployments**:
   - Check that `dev-webapp` exists in the `dev` namespace with 1 replica
   - Check that `prod-webapp` exists in the `prod` namespace with 5 replicas
   - Verify that the prod deployment has resource limits set

4. **Inspect the differences**:
   - Compare the deployments in both namespaces
   - Notice how the same base was customized differently

The `-k` flag tells kubectl to use Kustomize to build the configuration before applying it.

<details><summary>Hint</summary>

After applying, check resources with:
```bash
kubectl get all -n dev
kubectl get all -n prod
```

To see resource limits:
```bash
kubectl describe deployment prod-webapp -n prod
```

Or get the YAML:
```bash
kubectl get deployment prod-webapp -n prod -o yaml
```

</details>

<details><summary>Solution</summary>

```bash
# Apply the dev overlay
kubectl apply -k /root/kustomize-app/overlays/dev/

# Apply the prod overlay
kubectl apply -k /root/kustomize-app/overlays/prod/

# Wait for deployments to be ready
kubectl wait --for=condition=available deployment/dev-webapp -n dev --timeout=120s
kubectl wait --for=condition=available deployment/prod-webapp -n prod --timeout=120s

# Verify dev deployment (1 replica)
kubectl get deployment dev-webapp -n dev
kubectl get pods -n dev

# Verify prod deployment (5 replicas with resource limits)
kubectl get deployment prod-webapp -n prod
kubectl get pods -n prod

# Check resource limits in prod
kubectl describe deployment prod-webapp -n prod | grep -A 4 "Limits:"

# Compare the two deployments
echo "Dev deployment:"
kubectl get deployment dev-webapp -n dev -o yaml | grep -A 2 "replicas:"

echo "Prod deployment:"
kubectl get deployment prod-webapp -n prod -o yaml | grep -A 2 "replicas:"
```

</details>
