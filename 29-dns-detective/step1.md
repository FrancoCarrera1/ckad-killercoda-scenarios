## Task description

Test same-namespace DNS resolution from the `dns-frontend` namespace.

Explore how DNS works within a namespace:
1. Test the short name `frontend-svc`
2. Test the namespace-qualified name `frontend-svc.dns-frontend`
3. Test the FQDN `frontend-svc.dns-frontend.svc.cluster.local`
4. Examine `/etc/resolv.conf` to understand the search domains

All three DNS names should resolve to the same service IP within the same namespace.

<details><summary>Hint</summary>
Use `kubectl exec` to run commands inside the `frontend-app` pod. Use `nslookup`, `dig`, or `curl` to test DNS resolution. Check `/etc/resolv.conf` to see the DNS search path.
</details>

<details><summary>Solution</summary>
```bash
# Test short name
kubectl exec -n dns-frontend frontend-app -- nslookup frontend-svc

# Test namespace-qualified name
kubectl exec -n dns-frontend frontend-app -- nslookup frontend-svc.dns-frontend

# Test FQDN
kubectl exec -n dns-frontend frontend-app -- nslookup frontend-svc.dns-frontend.svc.cluster.local

# Check resolv.conf to see search domains
kubectl exec -n dns-frontend frontend-app -- cat /etc/resolv.conf

# You should see search domains like:
# search dns-frontend.svc.cluster.local svc.cluster.local cluster.local
```
</details>
