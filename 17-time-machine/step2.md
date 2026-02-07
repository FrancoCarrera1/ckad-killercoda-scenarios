# Roll Back to Previous Version

Now that you've identified the problem, it's time to fix it! Use `kubectl rollout undo` to quickly revert to the last working version.

## Task

1. Roll back the deployment to the previous revision using `kubectl rollout undo`
2. Watch the rollout to ensure it completes successfully
3. Verify all 3 pods are running and healthy
4. Confirm the image is back to `nginx:1.25` (the last working version)

The `rollout undo` command without `--to-revision` rolls back to the immediately previous revision.

<details><summary>Hint</summary>

Roll back to previous revision:
```bash
kubectl rollout undo deployment/payment-service -n payments
```

Watch the rollout:
```bash
kubectl rollout status deployment/payment-service -n payments
```

Verify pods are running:
```bash
kubectl get pods -n payments
```

</details>

<details><summary>Solution</summary>

```bash
# Roll back to previous revision (revision 2: nginx:1.25)
kubectl rollout undo deployment/payment-service -n payments

# Watch the rollout complete
kubectl rollout status deployment/payment-service -n payments

# Verify all pods are running
kubectl get pods -n payments

# Confirm the image is nginx:1.25
kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}'
echo

# Check rollout history - you'll see revision 4 is now the rollback
kubectl rollout history deployment/payment-service -n payments
```

</details>
