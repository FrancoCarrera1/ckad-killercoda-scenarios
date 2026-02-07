## Task description

Verify that the entire three-tier application stack is now healthy.

Check all pods:
```bash
kubectl get pods -n autopsy
```

All three pods (database, backend, frontend) should be Running.

Review the event timeline to see the complete story:
```bash
kubectl get events -n autopsy --sort-by=.lastTimestamp
```

This shows the entire debugging journey: the initial failures, your interventions, and the successful recovery.

<details><summary>Hint</summary>
Use `kubectl get pods` to see all pods at once. Use `kubectl get events` to review the chronological timeline of what happened during the debugging process.
</details>

<details><summary>Solution</summary>
```bash
# Verify all pods are Running
kubectl get pods -n autopsy

# Should show:
# NAME       READY   STATUS    RESTARTS   AGE
# backend    1/1     Running   0          ...
# database   1/1     Running   0          ...
# frontend   1/1     Running   0          ...

# Review the complete event timeline
kubectl get events -n autopsy --sort-by=.lastTimestamp

# Optionally test the full stack
kubectl exec -n autopsy frontend -- curl -s backend-svc
```
</details>
