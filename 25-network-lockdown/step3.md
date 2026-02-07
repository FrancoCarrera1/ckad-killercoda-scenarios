# Step 3: Allow Backend to Database

Continue building the network security by allowing the backend tier to communicate with the database tier.

## Task Description

Create a NetworkPolicy named `allow-backend-to-database` in the `lockdown` namespace that:

- Applies to pods with label `tier=database`
- Allows **ingress** traffic from pods with label `tier=backend`
- Allows traffic on port 5432 (TCP)

This completes the tier-to-tier communication path: frontend → backend → database.

<details><summary>Hint</summary>

This is similar to Step 2, but:
- Select pods with `tier=database`
- Allow from pods with `tier=backend`
- Allow port 5432

</details>

<details><summary>Solution</summary>

```bash
# Create NetworkPolicy allowing backend to database
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-database
  namespace: lockdown
spec:
  podSelector:
    matchLabels:
      tier: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: backend
    ports:
    - protocol: TCP
      port: 5432
EOF

# Verify the policy was created
kubectl get networkpolicy allow-backend-to-database -n lockdown

# View all NetworkPolicies to see the progressive lockdown
kubectl get networkpolicy -n lockdown

# Describe to see details
kubectl describe networkpolicy allow-backend-to-database -n lockdown
```

</details>

## Network Segmentation

You've now implemented proper tier-based network segmentation:

```
frontend  →  backend  →  database
  ↓            ↓            ↓
  ✗            ✗            ✗
```

- Frontend can reach backend (port 8080)
- Backend can reach database (port 5432)
- Frontend CANNOT directly reach database (defense in depth)
- No pod can receive traffic from unauthorized sources
- No pod can send traffic to unauthorized destinations

This is a common security pattern that limits the blast radius of a potential compromise.
