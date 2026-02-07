# Install Apache with Custom Values

Now that you've explored the chart, it's time to install it with custom configuration.

## Task Description

1. **Install the `bitnami/apache` chart** as a release named `my-web` in the `helm-lab` namespace
2. **Customize the installation** with these values:
   - `replicaCount=2` (deploy 2 replicas)
   - `service.type=ClusterIP` (use ClusterIP service type)
3. **Verify the installation** by listing Helm releases
4. **Check that pods are running** and ready

Use the `--set` flag to override default values during installation. This is faster than creating a custom values file and is commonly used in the CKAD exam.

<details><summary>Hint</summary>

Use `helm install <release-name> <chart> -n <namespace> --set key1=value1 --set key2=value2`

After installation, use `helm list -n <namespace>` to see releases.

Use `kubectl get pods -n helm-lab` to verify pods are running.

</details>

<details><summary>Solution</summary>

```bash
# Install the Apache chart with custom values
helm install my-web bitnami/apache -n helm-lab \
  --set replicaCount=2 \
  --set service.type=ClusterIP

# List Helm releases in the helm-lab namespace
helm list -n helm-lab

# Wait for pods to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=apache -n helm-lab --timeout=120s

# Verify pods are running
kubectl get pods -n helm-lab

# Check the deployment
kubectl get deployment -n helm-lab
```

</details>
