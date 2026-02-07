# Handle Failed Update and Rollback

Simulate a bad deployment and practice recovering with a rollback.

## Task Description

1. **Simulate a failed update**:
   - Edit `/root/webapp-kustomize/base/deployment.yaml`
   - Change the image to `nginx:1.99-broken` (this image doesn't exist)
   - Apply the change: `kubectl apply -k /root/webapp-kustomize/base/ -n fullstack`

2. **Observe the failure**:
   - Watch the deployment status—new pods will fail to pull the image
   - Some old pods will remain running (rollout won't complete)
   - Use `kubectl get pods -n fullstack` to see ImagePullBackOff errors

3. **Rollback the deployment**:
   - Use `kubectl rollout undo` to revert to the previous version
   - Wait for the rollback to complete
   - Verify all pods are healthy again

4. **Verify recovery**:
   - Check that pods are running nginx:1.25 (the previous good version)
   - Ensure all replicas are ready
   - The deployment should be fully functional again

Understanding rollback is critical—it's your emergency recovery mechanism!

<details><summary>Hint</summary>

After applying the broken image, check status:
```bash
kubectl rollout status deployment/webapp -n fullstack --timeout=30s
kubectl get pods -n fullstack
```

Rollback to the previous revision:
```bash
kubectl rollout undo deployment/webapp -n fullstack
```

Check rollout history:
```bash
kubectl rollout history deployment/webapp -n fullstack
```

</details>

<details><summary>Solution</summary>

```bash
# Update deployment.yaml with a broken image
sed -i 's|nginx:1.25|nginx:1.99-broken|g' /root/webapp-kustomize/base/deployment.yaml

# Apply the broken configuration
kubectl apply -k /root/webapp-kustomize/base/ -n fullstack

# Watch it fail (wait a bit to see the ImagePullBackOff)
sleep 10
kubectl get pods -n fullstack

# Try to check rollout status (it will timeout or show failure)
kubectl rollout status deployment/webapp -n fullstack --timeout=20s || echo "Rollout failed as expected"

# Rollback to the previous revision
kubectl rollout undo deployment/webapp -n fullstack

# Wait for rollback to complete
kubectl rollout status deployment/webapp -n fullstack --timeout=120s

# Verify recovery
kubectl get deployment webapp -n fullstack
kubectl get pods -n fullstack

# Check the current image (should be back to nginx:1.25)
kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.template.spec.containers[0].image}'
echo

# View rollout history
kubectl rollout history deployment/webapp -n fullstack

# Verify all replicas are ready
kubectl get deployment webapp -n fullstack -o jsonpath='{.status.readyReplicas}'
echo
```

</details>
