## Task description

Apply default-deny-all ingress NetworkPolicies in both `api-gateway` and `backend` namespaces.

This ensures that all traffic is blocked by default, and only explicitly allowed traffic can reach pods in these namespaces.

Requirements:
- Create a NetworkPolicy named `default-deny-ingress` in the `api-gateway` namespace
- Create a NetworkPolicy named `default-deny-ingress` in the `backend` namespace
- Both policies should deny all ingress traffic by default

<details><summary>Hint</summary>
A default deny policy has an empty ingress array and selects all pods with an empty podSelector.
</details>

<details><summary>Solution</summary>
```bash
# Default deny for api-gateway namespace
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: api-gateway
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF

# Default deny for backend namespace
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF
```
</details>
