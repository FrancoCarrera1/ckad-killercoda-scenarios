# Step 2: Create Path-Based Ingress Rules

Now that you have multiple backend services, create an Ingress resource to route traffic based on URL paths.

## Task

Create an Ingress resource named `traffic-director` in the `traffic-lab` namespace with the following configuration:

### Routing Rules
- **Host**: `myapp.local`
- **Path Rules**:
  - `/shop` → `storefront-svc:80`
  - `/api` → `api-svc:80`
  - `/docs` → `docs-svc:80`
- **Path Type**: `Prefix` for all paths
- **Default Backend**: `storefront-svc:80` (for any unmatched paths)

### Annotations
Add this annotation to make the Ingress work correctly with NGINX:
```yaml
nginx.ingress.kubernetes.io/rewrite-target: /
```

This annotation rewrites `/shop/something` to `/something` before forwarding to the backend, ensuring the backend receives clean paths.

<details><summary>Hint</summary>

An Ingress resource has:
- `metadata.annotations` for controller-specific configuration
- `spec.rules[].host` for hostname matching
- `spec.rules[].http.paths[]` for path-based routing
- Each path needs `path`, `pathType`, and `backend.service`
- `spec.defaultBackend` for catch-all routing (optional but requested here)

The `pathType: Prefix` means the path is matched as a prefix (e.g., `/api` matches `/api/v1/users`).

</details>

<details><summary>Solution</summary>

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: traffic-director
  namespace: traffic-lab
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /shop
        pathType: Prefix
        backend:
          service:
            name: storefront-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 80
      - path: /docs
        pathType: Prefix
        backend:
          service:
            name: docs-svc
            port:
              number: 80
  defaultBackend:
    service:
      name: storefront-svc
      port:
        number: 80
EOF

# Verify the Ingress was created
kubectl get ingress traffic-director -n traffic-lab

# Check the Ingress details
kubectl describe ingress traffic-director -n traffic-lab
```

</details>
