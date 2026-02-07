# Congratulations!

You've successfully implemented a zero-trust network security model using Kubernetes NetworkPolicies!

## What You Learned

### 1. Default Deny Strategy
- Created a baseline deny-all policy to block all traffic
- Understood the importance of starting from a secure default
- Learned how to apply policies to all pods using empty selectors

### 2. Tier-Based Access Control
- Implemented network segmentation between application tiers
- Allowed only necessary communication paths
- Used pod selectors to define source and destination pods

### 3. Port-Based Rules
- Configured specific port access (8080, 5432, 53)
- Understood protocol specifications (TCP vs UDP)
- Applied least privilege principle to network access

### 4. Namespace Targeting
- Used namespace selectors to allow cross-namespace traffic
- Enabled DNS resolution by targeting kube-system
- Learned the label structure for namespace selection

## Key Takeaways

### NetworkPolicy Structure
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-name
  namespace: target-namespace
spec:
  podSelector: {}              # Which pods this policy applies to
  policyTypes:
  - Ingress                    # Or Egress, or both
  ingress:                     # Rules for incoming traffic
  - from:
    - podSelector: {}          # Source pods
    - namespaceSelector: {}    # Source namespace
    ports:
    - protocol: TCP
      port: 8080
  egress:                      # Rules for outgoing traffic
  - to:
    - podSelector: {}
    ports:
    - protocol: TCP
      port: 53
```

### Important Concepts

1. **Additive Policies**: Multiple NetworkPolicies can select the same pod; their rules are combined
2. **Default Allow**: If NO NetworkPolicy selects a pod, all traffic is allowed
3. **Default Deny**: Empty policy types with no rules deny all traffic of that type
4. **Bidirectional**: For full communication, you often need both ingress and egress policies

## CKAD Exam Tips

### 1. Quick Default Deny
```bash
# Deny all ingress and egress
kubectl create -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```

### 2. Common Patterns

**Allow from specific pods:**
```yaml
ingress:
- from:
  - podSelector:
      matchLabels:
        role: frontend
```

**Allow from specific namespace:**
```yaml
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        name: production
```

**Allow to external CIDR:**
```yaml
egress:
- to:
  - ipBlock:
      cidr: 10.0.0.0/8
```

### 3. Essential Commands

```bash
# List NetworkPolicies
kubectl get networkpolicy -n <namespace>

# Describe for details
kubectl describe networkpolicy <name> -n <namespace>

# Test connectivity
kubectl exec <pod> -n <namespace> -- curl <service>

# Check DNS
kubectl exec <pod> -n <namespace> -- nslookup <service>
```

### 4. Namespace Label for Targeting

Most namespaces have the label `kubernetes.io/metadata.name=<namespace-name>`:
```yaml
namespaceSelector:
  matchLabels:
    kubernetes.io/metadata.name: kube-system
```

### 5. Common Ports to Remember

- **53**: DNS (TCP and UDP)
- **80**: HTTP
- **443**: HTTPS
- **6443**: Kubernetes API server
- **3306**: MySQL
- **5432**: PostgreSQL

## Real-World Scenarios

### Allow Internet Access
```yaml
egress:
- to:
  - ipBlock:
      cidr: 0.0.0.0/0
      except:
      - 169.254.169.254/32  # Block metadata service
  ports:
  - protocol: TCP
    port: 443
```

### Allow Within Namespace Only
```yaml
ingress:
- from:
  - podSelector: {}  # Any pod in same namespace
```

### Allow From Ingress Controllers
```yaml
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        name: ingress-nginx
  - podSelector:
      matchLabels:
        app: nginx-ingress
```

## Security Best Practices

1. **Start with default deny** in all namespaces
2. **Enable DNS early** so debugging is easier
3. **Test incrementally** - add one allow rule at a time
4. **Use descriptive names** - `allow-web-to-api` is better than `netpol-1`
5. **Document exceptions** - if you allow 0.0.0.0/0, explain why
6. **Monitor traffic** - use tools like Cilium Hubble to visualize flows
7. **Automate testing** - verify policies don't break legitimate traffic

## Troubleshooting Tips

If connectivity fails:
1. Check if NetworkPolicies exist: `kubectl get netpol -A`
2. Verify pod labels match selectors: `kubectl get pods --show-labels`
3. Confirm namespace labels: `kubectl get ns --show-labels`
4. Test DNS first: `kubectl exec <pod> -- nslookup kubernetes`
5. Check CNI supports NetworkPolicies: `kubectl get pods -n kube-system | grep calico`

## Advanced Patterns

### Multi-Tier Application
```
Internet → Ingress → Frontend → Backend → Database
         ↓         ↓          ↓         ↓
      [Allow]   [Allow]    [Allow]   [Deny]
```

### Microservices with Sidecar
- Allow main container ↔ sidecar on localhost
- Use `podSelector` with multiple labels
- Consider egress for service mesh control plane

### Multi-Tenancy
- Default deny per namespace
- Allow cross-namespace for shared services
- Use namespace selectors with custom labels

Great work! You've mastered NetworkPolicies and can now implement enterprise-grade network security in Kubernetes.
