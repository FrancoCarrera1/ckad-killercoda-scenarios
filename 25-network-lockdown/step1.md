# Step 1: Default Deny All

The first step in implementing zero-trust networking is to deny all traffic by default. This ensures that only explicitly allowed communication can occur.

## Task Description

Create a NetworkPolicy named `default-deny-all` in the `lockdown` namespace that:

- Applies to **all pods** in the namespace (use an empty selector: `{}`)
- Denies all **ingress** traffic (incoming connections)
- Denies all **egress** traffic (outgoing connections)

After applying this policy, no pod in the namespace will be able to communicate with any other pod or external service. This is your security baseline - now you'll selectively open holes for legitimate traffic.

<details><summary>Hint</summary>

A default deny policy has:
- Empty `podSelector: {}` to match all pods
- Empty `policyTypes: [Ingress, Egress]` to apply both types
- No `ingress` or `egress` rules (which means deny all)

```yaml
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

</details>

<details><summary>Solution</summary>

```bash
# Create default deny all NetworkPolicy
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: lockdown
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

# Verify the NetworkPolicy was created
kubectl get networkpolicy -n lockdown

# Test that communication is blocked
# Try to curl from frontend to backend (should timeout/fail)
kubectl exec frontend -n lockdown -- curl -s --max-time 2 http://backend-svc:8080 || echo "Blocked as expected"

# You can describe the policy to see details
kubectl describe networkpolicy default-deny-all -n lockdown
```

</details>

## Understanding Default Deny

When you apply this policy:
- **Ingress**: No pod can receive traffic from any source
- **Egress**: No pod can send traffic to any destination

This includes:
- Pod-to-pod communication within the namespace
- Pod-to-service communication
- Communication to pods in other namespaces
- Communication to external IPs
- Even DNS resolution (which you'll fix in Step 4)

The policy is applied to all pods because `podSelector: {}` matches everything. Now you'll add additional policies to selectively allow traffic.
