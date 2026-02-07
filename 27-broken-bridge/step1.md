# Step 1: Trace the Networking Chain

In Kubernetes, traffic flows through multiple layers:
**Ingress → Service → Endpoints → Pods**

Let's trace this chain systematically to identify all bugs.

## Your Task

Investigate the entire networking chain and identify all three bugs:

1. Check the Ingress configuration:
   ```bash
   kubectl describe ingress webapp-ingress -n broken-bridge
   ```

2. Check the Service configuration and endpoints:
   ```bash
   kubectl describe svc webapp-svc -n broken-bridge
   kubectl get endpoints webapp-svc -n broken-bridge
   ```

3. Check the Pod labels:
   ```bash
   kubectl get pods -n broken-bridge --show-labels
   ```

4. Check the actual container port:
   ```bash
   kubectl get pods -n broken-bridge -o jsonpath='{.items[0].spec.containers[0].ports}'
   ```

## What to Look For

- Does the Service selector match the Pod labels?
- Are the Service endpoints populated (do you see pod IPs)?
- Does the Service targetPort match the container port?
- Does the Ingress backend port match the Service port?

<details><summary>Hint</summary>

Compare these three things carefully:
1. Service selector vs Pod labels (should match exactly)
2. Service targetPort vs container port (should be 80)
3. Ingress backend port vs Service port (should be 80)

Use `kubectl get` with `-o yaml` to see exact values if needed.

</details>

<details><summary>Solution</summary>

```bash
# Identify Bug 1: Service selector mismatch
kubectl get pods -n broken-bridge --show-labels
# Pods have label: app=webapp

kubectl get svc webapp-svc -n broken-bridge -o yaml | grep -A2 selector
# Service selector: app=web-app (WRONG! Should be app=webapp)

# Identify Bug 2: Service targetPort wrong
kubectl get svc webapp-svc -n broken-bridge -o yaml | grep -A5 ports
# targetPort: 8081 (WRONG! Should be 80)

kubectl get pods -n broken-bridge -o jsonpath='{.items[0].spec.containers[0].ports}'
# containerPort: 80 (correct)

# Identify Bug 3: Ingress backend port wrong
kubectl get ingress webapp-ingress -n broken-bridge -o yaml | grep -A5 backend
# port number: 8080 (WRONG! Should be 80)

kubectl get svc webapp-svc -n broken-bridge -o yaml | grep -A5 ports
# Service port: 80 (correct)

# Summary of bugs found:
# 1. Service selector "web-app" doesn't match pod label "webapp"
# 2. Service targetPort 8081 doesn't match container port 80
# 3. Ingress backend port 8080 doesn't match Service port 80
```

</details>
