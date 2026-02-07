# Step 3: Test Ingress Routing

Now verify that your Ingress is correctly routing traffic to the different backend services based on the URL path.

## Task

Test each route using curl with a custom Host header. The Ingress controller is exposed via a NodePort service, so you'll need to find that port first.

### Testing Commands

```bash
# Get the Ingress controller's NodePort
NODEPORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

# Test the /shop path
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/shop

# Test the /api path
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/api

# Test the /docs path
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/docs

# Test the default backend (any other path)
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/
```

Each request should return the appropriate HTML:
- `/shop` → `<h1>Storefront</h1>`
- `/api` → `<h1>API Server</h1>`
- `/docs` → `<h1>Documentation</h1>`
- `/` (or any unmatched path) → `<h1>Storefront</h1>`

## Understanding the Test

The `-H "Host: myapp.local"` flag sets the HTTP Host header, which the Ingress uses to match the routing rule. Without this header, the Ingress wouldn't know which rule to apply.

<details><summary>Hint</summary>

If your curls aren't working:
1. Wait a few moments for the Ingress to be fully configured
2. Check that the Ingress controller is running: `kubectl get pods -n ingress-nginx`
3. Verify the Ingress has been assigned an address: `kubectl get ingress -n traffic-lab`
4. Check the backend services are ready: `kubectl get pods -n traffic-lab`

The NodePort for the ingress controller should be in the 30000-32767 range.

</details>

<details><summary>Solution</summary>

```bash
# Get the NodePort
NODEPORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
echo "Ingress Controller NodePort: $NODEPORT"

# Test all paths
echo "Testing /shop:"
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/shop
echo ""

echo "Testing /api:"
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/api
echo ""

echo "Testing /docs:"
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/docs
echo ""

echo "Testing default backend (/):"
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/
echo ""

# You can also test with any random path to verify default backend
echo "Testing default backend (/random):"
curl -s -H "Host: myapp.local" http://localhost:$NODEPORT/random
echo ""

# View Ingress status
kubectl get ingress traffic-director -n traffic-lab
```

</details>
