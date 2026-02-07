# Upgrade, Rollback, and Uninstall

Managing the lifecycle of a Helm release is crucial. You'll practice upgrading, rolling back, and cleaning up.

## Task Description

1. **Upgrade the release** to 3 replicas:
   - Use `helm upgrade` to modify the `my-web` release
   - Set `replicaCount=3` and keep `service.type=ClusterIP`
   - Verify the revision number is now 2

2. **Check the upgrade** by viewing the deployment and pods

3. **Rollback to revision 1**:
   - Use `helm rollback` to revert to the previous configuration
   - Verify the replica count returns to 2

4. **Uninstall the release**:
   - Clean up by uninstalling the `my-web` release
   - Verify it's been removed

Understanding rollbacks is critical for the CKAD exam—you need to quickly recover from failed updates.

<details><summary>Hint</summary>

Use `helm upgrade <release> <chart> -n <namespace> --set key=value` to upgrade.

Use `helm history <release> -n <namespace>` to see revision history.

Use `helm rollback <release> <revision> -n <namespace>` to rollback.

Use `helm uninstall <release> -n <namespace>` to remove a release.

</details>

<details><summary>Solution</summary>

```bash
# Upgrade the release to 3 replicas
helm upgrade my-web bitnami/apache -n helm-lab \
  --set replicaCount=3 \
  --set service.type=ClusterIP

# Wait for the upgrade to complete
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=apache -n helm-lab --timeout=120s

# Check the revision history
helm history my-web -n helm-lab

# Verify 3 replicas are running
kubectl get deployment -n helm-lab

# Rollback to revision 1
helm rollback my-web 1 -n helm-lab

# Wait for rollback to complete
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=apache -n helm-lab --timeout=120s

# Verify back to 2 replicas
kubectl get deployment -n helm-lab

# Uninstall the release
helm uninstall my-web -n helm-lab

# Verify it's gone
helm list -n helm-lab
kubectl get pods -n helm-lab
```

</details>
