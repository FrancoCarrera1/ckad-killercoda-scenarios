# Step 1: Label Namespaces with Pod Security Standards

Pod Security Standards are enforced at the namespace level using special labels. You need to configure two namespaces with different security levels.

## Your Task

1. **Label the `secure-apps` namespace**:
   - Set `pod-security.kubernetes.io/enforce=restricted`
   - Set `pod-security.kubernetes.io/warn=restricted`
   - This will enforce the highest security standards

2. **Label the `legacy-apps` namespace**:
   - Set `pod-security.kubernetes.io/enforce=baseline`
   - Set `pod-security.kubernetes.io/warn=baseline`
   - This allows legacy workloads that meet basic security requirements

3. **Verify the labels**:
   - Check that both namespaces have the correct labels applied

<details><summary>Hint</summary>

Use `kubectl label` to add labels to namespaces:
```bash
kubectl label namespace <namespace-name> <key>=<value>
```

You can add multiple labels in one command or apply them separately.

To view namespace labels:
```bash
kubectl get namespace <namespace-name> --show-labels
```

Or use:
```bash
kubectl describe namespace <namespace-name>
```

</details>

<details><summary>Solution</summary>

```bash
# Label secure-apps with restricted policy
kubectl label namespace secure-apps \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/warn=restricted

# Label legacy-apps with baseline policy
kubectl label namespace legacy-apps \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/warn=baseline

# Verify the labels
kubectl get namespace secure-apps --show-labels
kubectl get namespace legacy-apps --show-labels

# Or use describe for detailed view
kubectl describe namespace secure-apps
kubectl describe namespace legacy-apps
```

</details>

## Understanding the Labels

- **enforce**: Pods violating this level will be rejected
- **warn**: Violations will generate user-facing warnings
- **audit**: Violations will be recorded in the audit log (optional, not used in this scenario)

The security levels are:
- **restricted**: Most secure, enforces pod hardening best practices
- **baseline**: Minimally restrictive, prevents known privilege escalations
- **privileged**: Unrestricted (not recommended for production)
