# Step 3: Fix Ingress Bug

The Service is now working correctly, but traffic still won't flow through the Ingress. Let's fix the final bug.

## Your Task

**Bug 3**: Fix the Ingress backend port from `8080` to `80`

The Ingress is trying to send traffic to port 8080 on the Service, but the Service is listening on port 80.

## Fix the Ingress

You can fix this by patching or editing:

**Method 1: Patch the Ingress**
```bash
kubectl patch ingress webapp-ingress -n broken-bridge --type='json' \
  -p='[{"op": "replace", "path": "/spec/rules/0/http/paths/0/backend/service/port/number", "value":80}]'
```

**Method 2: Edit directly**
```bash
kubectl edit ingress webapp-ingress -n broken-bridge
# Change port number: 8080 → 80
```

## Verify End-to-End Connectivity

After fixing, test the full chain:

```bash
# Get the ingress controller NodePort
NODEPORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

# Test with curl (using Host header)
curl -H "Host: webapp.local" http://localhost:$NODEPORT/
```

You should see the nginx welcome page!

<details><summary>Hint</summary>

The Ingress backend port must match the Service port (not the pod's containerPort or targetPort).

Check the Service port:
```bash
kubectl get svc webapp-svc -n broken-bridge -o jsonpath='{.spec.ports[0].port}'
```

Check the current Ingress backend port:
```bash
kubectl get ingress webapp-ingress -n broken-bridge -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}'
```

</details>

<details><summary>Solution</summary>

```bash
# Fix Bug 3: Ingress backend port
kubectl patch ingress webapp-ingress -n broken-bridge --type='json' \
  -p='[{"op": "replace", "path": "/spec/rules/0/http/paths/0/backend/service/port/number", "value":80}]'

# Verify the fix
kubectl get ingress webapp-ingress -n broken-bridge -o yaml | grep -A3 backend

# Test end-to-end connectivity
NODEPORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl -H "Host: webapp.local" http://localhost:$NODEPORT/

# You should see the nginx welcome page HTML
```

</details>

## Understanding the Full Chain

Now that everything works, let's review the complete path:

1. **Ingress** receives request for `webapp.local`
2. **Ingress** forwards to Service `webapp-svc` on port **80**
3. **Service** has selector `app: webapp` that matches pods
4. **Service** forwards to targetPort **80** on matching pods
5. **Pods** receive traffic on containerPort **80**

All three layers must align perfectly for traffic to flow!
