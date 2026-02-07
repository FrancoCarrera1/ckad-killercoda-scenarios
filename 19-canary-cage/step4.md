# Step 4: Promote Canary

The canary has been tested and is working well! Now you'll promote it to be the new stable version by scaling down the old stable deployment and scaling up the canary.

## Task Description

Perform a full promotion of the canary version:

1. Scale `frontend-stable` deployment to 0 replicas
2. Scale `frontend-canary` deployment to 5 replicas

After this change, 100% of traffic will go to the canary version (which becomes the new production version). In a real scenario, you might rename or relabel deployments, but for this exercise, scaling demonstrates the promotion concept.

<details><summary>Hint</summary>

Use the `kubectl scale` command:

```bash
kubectl scale deployment <name> --replicas=<count> -n <namespace>
```

</details>

<details><summary>Solution</summary>

```bash
# Scale down the stable deployment to 0
kubectl scale deployment frontend-stable --replicas=0 -n canary-test

# Scale up the canary deployment to 5
kubectl scale deployment frontend-canary --replicas=5 -n canary-test

# Wait for the canary deployment to scale up
kubectl wait --for=condition=Available deployment/frontend-canary -n canary-test --timeout=60s

# Verify the new state
kubectl get deployments -n canary-test
kubectl get pods -n canary-test -l app=frontend

# Test that all traffic now goes to canary
kubectl run test-final --image=curlimages/curl -n canary-test --rm -i --tty -- sh -c '
for i in $(seq 1 10); do
  curl -s http://frontend-svc
  echo ""
done
'
# All responses should show "Canary v2"

# Check the Service endpoints (should now be 5 canary pods)
kubectl get endpoints frontend-svc -n canary-test
```

</details>

## Rollback Strategy

If you discovered issues with the canary during testing, you would do the opposite:

```bash
# Rollback: scale canary to 0, keep stable at 4
kubectl scale deployment frontend-canary --replicas=0 -n canary-test
kubectl scale deployment frontend-stable --replicas=4 -n canary-test
```

This is why canary deployments are considered safer than "big bang" rollouts - you can quickly revert if problems arise.

## Production Considerations

In a real production scenario, you would also:
- Monitor metrics (error rates, latency, etc.) for the canary
- Use automated canary analysis tools (Flagger, Argo Rollouts)
- Gradually increase canary traffic (10% → 25% → 50% → 100%)
- Keep old versions around temporarily for quick rollback
- Use proper versioning and labels for tracking
