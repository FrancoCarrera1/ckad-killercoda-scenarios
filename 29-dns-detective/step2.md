## Task description

Test cross-namespace DNS resolution from the `dns-frontend` namespace to the `dns-backend` namespace.

Requirements:
1. From `frontend-app` pod, try to resolve the short name `backend-svc` (this should fail)
2. Resolve the namespace-qualified name `backend-svc.dns-backend`
3. Resolve the FQDN `backend-svc.dns-backend.svc.cluster.local`

Understand why short names don't work across namespaces but namespace-qualified names and FQDNs do.

<details><summary>Hint</summary>
Short names only work within the same namespace because of the DNS search path in `/etc/resolv.conf`. To access services in other namespaces, you must use at least the namespace-qualified form.
</details>

<details><summary>Solution</summary>
```bash
# This should fail (or timeout)
kubectl exec -n dns-frontend frontend-app -- nslookup backend-svc

# This should succeed - namespace-qualified
kubectl exec -n dns-frontend frontend-app -- nslookup backend-svc.dns-backend

# This should also succeed - FQDN
kubectl exec -n dns-frontend frontend-app -- nslookup backend-svc.dns-backend.svc.cluster.local

# Test HTTP connectivity using namespace-qualified name
kubectl exec -n dns-frontend frontend-app -- curl -s backend-svc.dns-backend
```
</details>
