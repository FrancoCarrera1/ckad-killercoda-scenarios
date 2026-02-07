## Task description

Observe how the probes transition during pod startup and verify the pod is receiving traffic.

Use `kubectl describe pod healthy-app -n health-lab` to observe the probe events. You should see:
- Startup probe succeeding first
- Readiness probe succeeding, making the pod Ready
- Liveness probe running in the background

Verify that:
1. The pod has transitioned to Ready state
2. The Service `healthy-svc` has endpoints (meaning the pod is ready to receive traffic)

<details><summary>Hint</summary>
Use `kubectl describe pod` to see events and probe results. Use `kubectl get endpoints` to check if the Service has registered the pod's IP.
</details>

<details><summary>Solution</summary>
```bash
# Observe probe events
kubectl describe pod healthy-app -n health-lab

# Check pod status
kubectl get pod healthy-app -n health-lab

# Verify Service endpoints
kubectl get endpoints healthy-svc -n health-lab

# The endpoints should show the pod's IP address
```
</details>
