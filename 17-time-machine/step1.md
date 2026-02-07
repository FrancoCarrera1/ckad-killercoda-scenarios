# Diagnose the Broken Deployment

Before you can fix the problem, you need to understand what went wrong. Time to put on your detective hat!

## Task

Investigate the broken deployment and identify the root cause:

1. Check the status of the `payment-service` deployment in the `payments` namespace
2. List the pods and observe their status
3. Describe a failing pod to find the error message
4. Identify which image is causing the problem

Look for:
- Pod status (should show `ImagePullBackOff` or `ErrImagePull`)
- Error messages in pod events
- The problematic image name and tag

<details><summary>Hint</summary>

Check deployment and pod status:
```bash
kubectl get deployment payment-service -n payments
kubectl get pods -n payments
```

Describe a pod to see detailed error messages:
```bash
kubectl describe pod <pod-name> -n payments
```

Check the current image in the deployment:
```bash
kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}'
```

</details>

<details><summary>Solution</summary>

```bash
# Check deployment status
kubectl get deployment payment-service -n payments

# List pods - you'll see ImagePullBackOff or ErrImagePull
kubectl get pods -n payments

# Describe a pod to see the error
POD=$(kubectl get pods -n payments -l app=payment-service -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD -n payments

# Check the problematic image
kubectl get deployment payment-service -n payments -o jsonpath='{.spec.template.spec.containers[0].image}'
echo

# The issue: nginx:1.99-nonexistent doesn't exist!
# You'll see events like:
#   Failed to pull image "nginx:1.99-nonexistent": rpc error: code = Unknown desc = Error response from daemon: manifest for nginx:1.99-nonexistent not found

# Check rollout history to see what happened
kubectl rollout history deployment/payment-service -n payments
```

</details>
