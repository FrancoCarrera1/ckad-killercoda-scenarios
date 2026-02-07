# Perform Rolling Update

Update the payment service to a new image version and observe the rolling update in action.

## Task

1. Update the `payment-service` deployment to use image `nginx:1.25`
2. Use `kubectl rollout status` to watch the update progress
3. Observe that with `maxUnavailable=1` and `maxSurge=1`, you'll have between 3-5 pods during the rollout
4. Annotate the deployment with the change-cause

During the rollout:
- Minimum pods: 4 - 1 = 3 (due to maxUnavailable=1)
- Maximum pods: 4 + 1 = 5 (due to maxSurge=1)

<details><summary>Hint</summary>

Use `kubectl set image` to update the deployment image:
```bash
kubectl set image deployment/payment-service nginx=nginx:1.25 -n payments
```

Watch the rollout with:
```bash
kubectl rollout status deployment/payment-service -n payments
```

You can also watch pods in real-time:
```bash
kubectl get pods -n payments -w
```

</details>

<details><summary>Solution</summary>

```bash
# Update the image
kubectl set image deployment/payment-service nginx=nginx:1.25 -n payments

# Annotate with change-cause
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Updated to nginx 1.25" --overwrite

# Watch the rollout
kubectl rollout status deployment/payment-service -n payments

# Verify all pods are running
kubectl get pods -n payments

# Check the image version
kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}'
echo
```

</details>
