## Task description

Create NetworkPolicies that allow the `monitoring` namespace to access both `api-gateway` and `backend` namespaces.

Requirements:
- Create a NetworkPolicy in the `api-gateway` namespace allowing ingress from `monitoring` namespace (with label `team=monitoring`) on port 80
- Create a NetworkPolicy in the `backend` namespace allowing ingress from `monitoring` namespace on port 8080

This allows your monitoring tools to scrape metrics from all services.

<details><summary>Hint</summary>
You need two separate NetworkPolicies - one in each target namespace. Use `namespaceSelector` with `team=monitoring` label.
</details>

<details><summary>Solution</summary>
```bash
# Allow monitoring to access api-gateway
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-monitoring
  namespace: api-gateway
spec:
  podSelector:
    matchLabels:
      app: gateway
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          team: monitoring
    ports:
    - protocol: TCP
      port: 80
EOF

# Allow monitoring to access backend
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-monitoring
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          team: monitoring
    ports:
    - protocol: TCP
      port: 8080
EOF
```
</details>
