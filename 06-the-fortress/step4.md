# Step 4: Review PSS Violation Events

When Pod Security Standards reject a pod, Kubernetes generates events that help you understand what went wrong. Let's examine these events.

## Your Task

1. **View events in the `secure-apps` namespace**:
   - Use `kubectl get events` to see PSS violations
   - Look for the rejection of the `root-pod` attempt

2. **Understand the violation messages**:
   - Events will show which specific requirements were not met
   - This is crucial for debugging PSS issues

3. **Compare with successful deployment**:
   - Check events related to the `compliant-nginx` pod
   - Notice there are no warnings or errors

<details><summary>Hint</summary>

To view events in a namespace:
```bash
kubectl get events -n <namespace>
```

For more readable output:
```bash
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

To filter for warning events:
```bash
kubectl get events -n <namespace> --field-selector type=Warning
```

You can also use `kubectl describe` on the namespace itself:
```bash
kubectl describe namespace <namespace>
```

</details>

<details><summary>Solution</summary>

```bash
# View all events in secure-apps
kubectl get events -n secure-apps --sort-by='.lastTimestamp'

# Look for PSS violation events (if the root-pod creation was attempted)
# You'll see events explaining why the pod was rejected

# View events in legacy-apps
kubectl get events -n legacy-apps --sort-by='.lastTimestamp'

# Describe the compliant pod to see its events
kubectl describe pod compliant-nginx -n secure-apps

# Describe the root-pod in legacy-apps
kubectl describe pod root-pod -n legacy-apps

# You can also check for warning-level events specifically
kubectl get events -n secure-apps --field-selector type=Warning
```

Example rejection message:
```
violates PodSecurity "restricted:latest":
- runAsNonRoot != true (container "nginx" must not set securityContext.runAsNonRoot=false)
- unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"])
- seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
```

</details>

## Key Takeaways

### PSS Violation Messages Tell You Exactly What's Wrong
- `runAsNonRoot != true` → Need to set `runAsNonRoot: true`
- `unrestricted capabilities` → Need to drop all capabilities
- `seccompProfile` → Need to set RuntimeDefault or Localhost
- `allowPrivilegeEscalation != false` → Need to set `allowPrivilegeEscalation: false`

### Events Are Your Friend
- Always check events when debugging pod creation issues
- Events persist for about an hour by default
- Use `--sort-by='.lastTimestamp'` to see most recent events first

### Namespace Labels Control Enforcement
- Changing the label changes the enforcement level
- You can use different levels for different namespaces
- This allows gradual migration to stricter policies
