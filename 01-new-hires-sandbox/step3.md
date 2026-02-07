# Step 3: Test Resource Controls

## Task

Deploy a test pod to verify that the LimitRange is automatically injecting defaults, and test that the ResourceQuota prevents resource abuse.

### Requirements

1. Create a pod named `nginx-test` in the `dev-priya` namespace:
   - Image: `nginx:1.24`
   - ServiceAccount: `priya-sa`
   - Do NOT specify resource requests/limits (let LimitRange inject them)

2. Verify that the pod is running and has the default limits/requests from the LimitRange

3. Attempt to create a pod named `greedy-pod` that requests 4 CPU (this should fail due to the ResourceQuota limit of 2 CPU)

## Why This Matters

This demonstrates the **defense in depth** approach:
- LimitRange ensures pods always have resource requests/limits (prevents "unbounded" pods)
- ResourceQuota prevents the total consumption from exceeding limits
- In the CKAD exam, you need to understand how these mechanisms interact

<details><summary>Hint 1: Creating the nginx-test pod</summary>

Use `kubectl run` with the `--serviceaccount` flag:
```bash
kubectl run nginx-test --image=nginx:1.24 \
  --serviceaccount=priya-sa \
  -n dev-priya
```

Wait for it to be running, then inspect its resource settings with `kubectl describe` or `kubectl get pod -o yaml`.

</details>

<details><summary>Hint 2: Verifying default injection</summary>

Use `kubectl describe pod nginx-test -n dev-priya` and look at the "Limits" and "Requests" sections. They should match the LimitRange defaults (250m CPU / 256Mi memory for limits, 100m CPU / 128Mi memory for requests).

</details>

<details><summary>Hint 3: Testing the quota limit</summary>

Try to create a pod that requests more CPU than the quota allows:
```bash
kubectl run greedy-pod --image=nginx:1.24 -n dev-priya \
  --requests=cpu=4
```

This should fail with a quota exceeded error.

</details>

<details><summary>Solution</summary>

```bash
# Create nginx-test pod with the ServiceAccount
kubectl run nginx-test --image=nginx:1.24 \
  --serviceaccount=priya-sa \
  -n dev-priya

# Wait for pod to be running
kubectl wait --for=condition=Ready pod/nginx-test -n dev-priya --timeout=60s

# Verify LimitRange defaults were injected
kubectl describe pod nginx-test -n dev-priya | grep -A 4 "Limits:"
kubectl get pod nginx-test -n dev-priya -o jsonpath='{.spec.containers[0].resources}'

# You should see:
# Limits: cpu=250m, memory=256Mi
# Requests: cpu=100m, memory=128Mi

# Try to create a greedy pod (this should fail)
kubectl run greedy-pod --image=nginx:1.24 -n dev-priya \
  --requests=cpu=4 || echo "✅ Quota correctly prevented greedy pod!"

# Check the quota usage
kubectl describe resourcequota dev-quota -n dev-priya
```

</details>

## Verification

Run the verification script to check your work:
```bash
/usr/local/bin/step3-verify.sh
```
