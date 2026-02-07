# Switch Traffic to Green

Time for the big moment! Switch all traffic from blue to green instantly by patching the Service selector. Then scale down blue.

## Task

1. Patch the Service to change selector from `version=blue` to `version=green`
2. Verify traffic now goes to green pods
3. Scale the blue deployment to 0 replicas (keep it ready for quick rollback if needed)

This is the essence of blue-green: instant atomic cutover by changing the Service selector.

<details><summary>Hint</summary>

Patch the Service selector:
```bash
kubectl patch service webapp-svc -n web-app -p '{"spec":{"selector":{"app":"webapp","version":"green"}}}'
```

Verify the change:
```bash
kubectl describe service webapp-svc -n web-app | grep Selector
kubectl get endpoints webapp-svc -n web-app
```

Scale blue to 0:
```bash
kubectl scale deployment webapp-blue --replicas=0 -n web-app
```

</details>

<details><summary>Solution</summary>

```bash
# Switch traffic to green
kubectl patch service webapp-svc -n web-app -p '{"spec":{"selector":{"app":"webapp","version":"green"}}}'

# Verify the selector changed
kubectl get service webapp-svc -n web-app -o jsonpath='{.spec.selector}'
echo

# Check endpoints - should now point to green pods
kubectl get endpoints webapp-svc -n web-app

# Test the service - should now get Green Version v2
kubectl run curl-test --image=curlimages/curl -n web-app --rm -it --restart=Never -- curl -s webapp-svc

# Scale blue to 0 (keep deployment for quick rollback)
kubectl scale deployment webapp-blue --replicas=0 -n web-app

# Verify final state
kubectl get deployments -n web-app
kubectl get pods -n web-app

# If you needed to rollback, you could quickly:
# kubectl patch service webapp-svc -n web-app -p '{"spec":{"selector":{"version":"blue"}}}'
# kubectl scale deployment webapp-blue --replicas=3 -n web-app
```

</details>
