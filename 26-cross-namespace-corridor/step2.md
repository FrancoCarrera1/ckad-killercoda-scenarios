## Task description

Create a NetworkPolicy in the `backend` namespace that allows ingress from the `api-gateway` namespace on port 8080.

This policy should:
- Select all pods in the backend namespace (with label `app=backend`)
- Allow ingress from pods in namespaces with the label `team=gateway`
- Allow traffic on TCP port 8080

<details><summary>Hint</summary>
Use `namespaceSelector` to match namespaces with the label `team=gateway`. The policy should include both the namespace selector and the port specification.
</details>

<details><summary>Solution</summary>
```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-gateway
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
          team: gateway
    ports:
    - protocol: TCP
      port: 8080
EOF
```
</details>
