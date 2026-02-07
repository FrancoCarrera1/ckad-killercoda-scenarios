# Inspect Rollout History

Learn to track deployment history and compare revisions for audit and rollback purposes.

## Task

1. View the rollout history with `kubectl rollout history`
2. Examine specific revisions using `--revision` flag
3. Compare revision 1 and revision 2 to see what changed
4. Verify the change-cause annotations are present

The rollout history helps you track what changed, when, and why — essential for compliance and debugging.

<details><summary>Hint</summary>

View rollout history:
```bash
kubectl rollout history deployment/payment-service -n payments
```

View details of a specific revision:
```bash
kubectl rollout history deployment/payment-service -n payments --revision=1
kubectl rollout history deployment/payment-service -n payments --revision=2
```

The change-cause annotations you added in previous steps will appear in the history.

</details>

<details><summary>Solution</summary>

```bash
# View rollout history
kubectl rollout history deployment/payment-service -n payments

# View revision 1 details
echo "=== Revision 1 ==="
kubectl rollout history deployment/payment-service -n payments --revision=1

# View revision 2 details
echo "=== Revision 2 ==="
kubectl rollout history deployment/payment-service -n payments --revision=2

# The output shows:
# - Revision 1: nginx:1.24 with "Initial deployment with nginx 1.24"
# - Revision 2: nginx:1.25 with "Updated to nginx 1.25"

# You can see the image differences and change-cause annotations
```

</details>
