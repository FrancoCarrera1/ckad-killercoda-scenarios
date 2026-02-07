# Step 4: Allow DNS

The final piece of the puzzle is DNS. Without DNS resolution, pods can't resolve Service names to IP addresses. You'll create a policy that allows all pods to query the cluster DNS service.

## Task Description

Create a NetworkPolicy named `allow-dns` in the `lockdown` namespace that:

- Applies to **all pods** in the namespace (empty selector: `{}`)
- Allows **egress** traffic to the `kube-system` namespace
- Allows traffic on port 53 for both **TCP and UDP**

DNS uses both protocols:
- UDP port 53 for standard queries
- TCP port 53 for large responses or zone transfers

<details><summary>Hint</summary>

You need to:
1. Select all pods with `podSelector: {}`
2. Add an egress rule
3. Target the kube-system namespace with `namespaceSelector`
4. Allow both TCP and UDP on port 53

```yaml
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
```

</details>

<details><summary>Solution</summary>

```bash
# Create NetworkPolicy allowing DNS
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: lockdown
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
EOF

# Verify the policy was created
kubectl get networkpolicy allow-dns -n lockdown

# View all NetworkPolicies in the namespace
kubectl get networkpolicy -n lockdown

# Test DNS resolution (should now work)
kubectl exec frontend -n lockdown -- nslookup backend-svc

# Describe to see details
kubectl describe networkpolicy allow-dns -n lockdown
```

</details>

## Understanding Namespace Selectors

The `namespaceSelector` allows you to target pods in a specific namespace. In this case:

- `kubernetes.io/metadata.name: kube-system` targets the kube-system namespace
- This is where CoreDNS runs (the cluster DNS service)
- By allowing egress to kube-system on port 53, pods can resolve Service names

## Complete Network Policy Set

You now have four NetworkPolicies working together:

1. **default-deny-all**: Denies all traffic by default
2. **allow-frontend-to-backend**: frontend → backend:8080
3. **allow-backend-to-database**: backend → database:5432
4. **allow-dns**: all pods → kube-system:53 (DNS)

This creates a defense-in-depth architecture with:
- Least privilege access (only what's needed)
- Network segmentation (tier-to-tier isolation)
- Essential services enabled (DNS)
- Clear audit trail (policies as code)
