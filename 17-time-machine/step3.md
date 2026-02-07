# Roll Back to Specific Revision

The team has decided they want to go all the way back to the original nginx:1.24 version. You can roll back to any previous revision using `--to-revision`.

## Task

1. View the rollout history to see all available revisions
2. Roll back to revision 1 (nginx:1.24) using `kubectl rollout undo --to-revision=1`
3. Verify the image is now `nginx:1.24`
4. Add a change-cause annotation explaining why you rolled back

Rolling back to specific revisions is useful when you need to skip multiple versions or return to a known-good baseline.

<details><summary>Hint</summary>

View available revisions:
```bash
kubectl rollout history deployment/payment-service -n payments
```

Roll back to specific revision:
```bash
kubectl rollout undo deployment/payment-service --to-revision=1 -n payments
```

Add change-cause annotation:
```bash
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Rolled back to nginx 1.24 after failed 1.99 deployment" --overwrite
```

</details>

<details><summary>Solution</summary>

```bash
# View rollout history
kubectl rollout history deployment/payment-service -n payments

# Roll back to revision 1 (nginx:1.24)
kubectl rollout undo deployment/payment-service --to-revision=1 -n payments

# Watch the rollout
kubectl rollout status deployment/payment-service -n payments

# Verify image is nginx:1.24
kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}'
echo

# Add change-cause annotation
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Rolled back to nginx 1.24 after failed 1.99 deployment" --overwrite

# Verify all pods are running
kubectl get pods -n payments

# View updated history
kubectl rollout history deployment/payment-service -n payments
```

</details>
