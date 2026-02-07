# Rolling Update the Webapp

Practice performing a rolling update to upgrade the webapp to a newer version.

## Task Description

1. **Update the image** in `/root/webapp-kustomize/base/deployment.yaml`:
   - Change from `nginx:1.24` to `nginx:1.25`

2. **Re-apply the Kustomize configuration**:
   ```bash
   kubectl apply -k /root/webapp-kustomize/base/ -n fullstack
   ```

3. **Watch the rolling update**:
   - Observe pods being replaced one by one
   - Use `kubectl rollout status` to monitor progress

4. **Verify the new image**:
   - Check that all pods are now running `nginx:1.25`
   - Ensure the REDIS_HOST environment variable is still set

5. **Test connectivity** (optional):
   - Exec into a webapp pod and verify Redis is still reachable

Rolling updates ensure zero downtime by gradually replacing old pods with new ones.

<details><summary>Hint</summary>

Edit the deployment.yaml file and change the image line.

Watch the rollout:
```bash
kubectl rollout status deployment/webapp -n fullstack
```

Check the current image:
```bash
kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.template.spec.containers[0].image}'
```

To watch pods being replaced:
```bash
kubectl get pods -n fullstack -w
```

</details>

<details><summary>Solution</summary>

```bash
# Update the deployment.yaml with new image
sed -i 's|nginx:1.24|nginx:1.25|g' /root/webapp-kustomize/base/deployment.yaml

# Or manually edit:
# vi /root/webapp-kustomize/base/deployment.yaml
# Change: image: nginx:1.24 -> image: nginx:1.25

# Re-apply the Kustomize configuration
kubectl apply -k /root/webapp-kustomize/base/ -n fullstack

# Watch the rolling update
kubectl rollout status deployment/webapp -n fullstack

# Verify the new image
kubectl get deployment webapp -n fullstack -o jsonpath='{.spec.template.spec.containers[0].image}'
echo

# Check all pods are running the new image
kubectl get pods -n fullstack -l app=webapp -o jsonpath='{.items[*].spec.containers[0].image}'
echo

# Verify REDIS_HOST is still set
POD=$(kubectl get pod -n fullstack -l app=webapp -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -n fullstack -- env | grep REDIS_HOST

# Optional: Test Redis connectivity
kubectl exec $POD -n fullstack -- sh -c 'command -v curl && curl -f http://localhost || echo "Nginx running"'
```

</details>
