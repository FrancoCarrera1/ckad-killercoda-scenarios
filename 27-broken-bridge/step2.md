# Step 2: Fix Service Bugs

Now that you've identified the bugs, let's fix the Service configuration issues.

## Your Task

Fix both Service bugs:

1. **Bug 1**: Change the Service selector from `app: web-app` to `app: webapp`
2. **Bug 2**: Change the Service targetPort from `8081` to `80`

After fixing, verify that:
- The Service endpoints now show pod IPs
- The endpoint count matches the number of pods

## Methods to Fix

You can fix this in several ways:

**Method 1: Patch the Service**
```bash
kubectl patch svc webapp-svc -n broken-bridge --type='json' -p='[{"op": "replace", "path": "/spec/selector/app", "value":"webapp"}]'
kubectl patch svc webapp-svc -n broken-bridge --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/targetPort", "value":80}]'
```

**Method 2: Edit directly**
```bash
kubectl edit svc webapp-svc -n broken-bridge
# Change selector app: web-app → app: webapp
# Change targetPort: 8081 → targetPort: 80
```

**Method 3: Delete and recreate**
```bash
kubectl delete svc webapp-svc -n broken-bridge
kubectl expose deployment webapp -n broken-bridge --name=webapp-svc --port=80 --target-port=80
```

## Verify the Fix

After fixing, check the endpoints:
```bash
kubectl get endpoints webapp-svc -n broken-bridge
```

You should now see pod IPs listed!

<details><summary>Hint</summary>

The selector must match the pod labels exactly. Check:
```bash
kubectl get pods -n broken-bridge --show-labels
```

The targetPort must match the container port (80). Check:
```bash
kubectl get pods -n broken-bridge -o jsonpath='{.items[0].spec.containers[0].ports[0].containerPort}'
```

</details>

<details><summary>Solution</summary>

```bash
# Fix Bug 1: Service selector
kubectl patch svc webapp-svc -n broken-bridge --type='json' \
  -p='[{"op": "replace", "path": "/spec/selector/app", "value":"webapp"}]'

# Fix Bug 2: Service targetPort
kubectl patch svc webapp-svc -n broken-bridge --type='json' \
  -p='[{"op": "replace", "path": "/spec/ports/0/targetPort", "value":80}]'

# Verify endpoints are now populated
kubectl get endpoints webapp-svc -n broken-bridge

# You should see output like:
# NAME          ENDPOINTS                         AGE
# webapp-svc    10.244.0.5:80,10.244.0.6:80      5m

# Test connectivity to the service
kubectl run test-pod --image=nginx:1.24 -n broken-bridge --rm -it --restart=Never -- curl webapp-svc.broken-bridge.svc.cluster.local
```

</details>
