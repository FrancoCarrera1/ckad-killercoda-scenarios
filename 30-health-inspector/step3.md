## Task description

Break the probes by corrupting the application and observe the automatic recovery cascade.

Execute the following command to break nginx by renaming its index file:

```bash
kubectl exec healthy-app -n health-lab -- mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak
```

Now observe the failure cascade:
1. **Readiness probe fails** (HTTP 403/404) - pod is removed from Service endpoints
2. **Liveness probe fails** after multiple attempts - Kubernetes restarts the container
3. **Auto-recovery** - the restart brings back the original index.html, probes succeed again

Watch the pod with `kubectl get pod healthy-app -n health-lab -w` and check events with `kubectl describe pod`.

<details><summary>Hint</summary>
After breaking the app, use `kubectl get pod -n health-lab -w` to watch the pod status change. Use `kubectl describe pod` to see the probe failure events. The RESTARTS column will increment when the liveness probe triggers a restart.
</details>

<details><summary>Solution</summary>
```bash
# Break the application
kubectl exec healthy-app -n health-lab -- mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak

# Watch the pod status (press Ctrl+C to exit)
kubectl get pod healthy-app -n health-lab -w

# Check events to see probe failures
kubectl describe pod healthy-app -n health-lab

# Verify the pod has restarted and recovered
kubectl get pod healthy-app -n health-lab

# The RESTARTS column should be > 0, and STATUS should be Running
```
</details>
