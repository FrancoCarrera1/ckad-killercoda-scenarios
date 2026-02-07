# Step 2: Allow Frontend to Backend

Now you'll create a policy that allows the frontend tier to communicate with the backend tier on port 8080.

## Task Description

Create a NetworkPolicy named `allow-frontend-to-backend` in the `lockdown` namespace that:

- Applies to pods with label `tier=backend`
- Allows **ingress** traffic from pods with label `tier=frontend`
- Allows traffic on port 8080 (TCP)

This policy enables the frontend to make API calls to the backend while still blocking all other communication.

<details><summary>Hint</summary>

You need to:
1. Select the destination pods (backend) with `podSelector`
2. Define an ingress rule
3. In the ingress rule, specify the source with `from` and `podSelector`
4. Specify the allowed port

```yaml
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 8080
```

</details>

<details><summary>Solution</summary>

```bash
# Create NetworkPolicy allowing frontend to backend
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: lockdown
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 8080
EOF

# Verify the policy was created
kubectl get networkpolicy allow-frontend-to-backend -n lockdown

# Test (this will still fail because frontend needs egress permission too)
# We're only allowing ingress to backend, not egress from frontend yet
# For full communication, you'd also need an egress policy on frontend
# But for CKAD exam purposes, we focus on the ingress side

# Describe to see the policy details
kubectl describe networkpolicy allow-frontend-to-backend -n lockdown
```

</details>

## Understanding Ingress Rules

This NetworkPolicy:
- **Selects**: Pods with `tier=backend` (the destination)
- **Allows**: Ingress (incoming) traffic
- **From**: Pods with `tier=frontend` (the source)
- **On**: Port 8080 TCP

Important: For full bidirectional communication, you also need:
1. Egress policy on frontend (to allow outgoing connections)
2. Ingress policy on backend (✓ we just created this)

In many real scenarios, you'd create separate policies for egress from the source. For this exercise, we're focusing on ingress policies, which is common in the CKAD exam.
