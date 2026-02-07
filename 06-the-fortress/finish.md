# Congratulations!

You've successfully built The Fortress and mastered Pod Security Standards!

## What You Learned

### Pod Security Standards (PSS)
- **Three levels**: Privileged (unrestricted), Baseline (minimally restrictive), Restricted (hardened)
- **Namespace-level enforcement**: Applied via labels on namespaces
- **Label modes**: `enforce` (reject), `warn` (user warning), `audit` (log only)

### Restricted Standard Requirements
- `runAsNonRoot: true` - Cannot run as root
- `allowPrivilegeEscalation: false` - Prevents privilege escalation
- `capabilities.drop: ["ALL"]` - Drops all Linux capabilities
- `seccompProfile.type: RuntimeDefault` - Applies seccomp filtering
- `readOnlyRootFilesystem: true` - Prevents filesystem tampering

### Working with Read-Only Root Filesystems
- Many containers need writable directories
- Use `emptyDir` volumes for:
  - Cache directories
  - Runtime directories
  - Temporary directories
- Mount them to override read-only restrictions

## CKAD Exam Tips

### Quick PSS Label Application
```bash
# Label a namespace for restricted enforcement
kubectl label namespace <ns> \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/warn=restricted
```

### Creating Restricted-Compliant Pods
Use this template as a starting point:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myimage:tag
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop: ["ALL"]
```

### Common Issues and Fixes

| Error | Fix |
|-------|-----|
| `runAsNonRoot != true` | Add `runAsNonRoot: true` and `runAsUser: <non-zero>` |
| `unrestricted capabilities` | Add `capabilities: { drop: ["ALL"] }` |
| `seccompProfile` not set | Add `seccompProfile: { type: RuntimeDefault }` |
| `allowPrivilegeEscalation != false` | Add `allowPrivilegeEscalation: false` |
| Container crashes with read-only filesystem | Add emptyDir volumes for writable paths |

### Baseline vs Restricted Quick Reference

**Baseline allows but Restricted blocks:**
- Running as root (UID 0)
- Using default capabilities
- No seccomp profile

**Both baseline and restricted block:**
- Privileged containers (`privileged: true`)
- Host namespaces (hostNetwork, hostPID, hostIPC)
- Host path volumes
- Dangerous capabilities (CAP_SYS_ADMIN, etc.)

### Time-Saving Tips
1. **Start with the template**: Don't write from scratch - use a known-good restricted template
2. **Read the error message**: PSS violations tell you exactly what's missing
3. **Use kubectl dry-run**: Test pod specs before applying with `--dry-run=server`
4. **Check events**: When pods fail, events show PSS violations

### Common Exam Scenarios
- "Create a pod that meets restricted standards"
- "Enable baseline security for namespace X"
- "Fix this pod so it can run in a restricted namespace"
- "Why was this pod rejected?" → Check PSS labels and events

### Debugging Workflow
1. Check namespace labels: `kubectl get ns <name> --show-labels`
2. Try to create the pod and read the error
3. Check events: `kubectl get events -n <namespace>`
4. Fix the security context based on the error message
5. Re-apply

## Best Practices

### In Production
- **Start with baseline** for new namespaces
- **Gradually migrate to restricted** as applications are updated
- **Use warn and audit** modes before enforcing
- **Document exceptions** if certain workloads can't meet restricted

### Security Considerations
- Restricted standard follows pod hardening best practices
- Running as non-root reduces attack surface significantly
- Read-only root filesystem prevents tampering
- Seccomp profiles restrict system calls

### Migration Strategy
1. Add `warn` labels first to see which pods would be rejected
2. Update pod specs to comply
3. Switch to `enforce` once compliance is achieved
4. Monitor events for violations

## Next Steps

- Explore Pod Security Admission configuration at the cluster level
- Learn about custom seccomp profiles
- Study AppArmor and SELinux integration
- Practice creating compliant pods for different application types

Excellent work securing your cluster! Pod Security Standards are a critical part of Kubernetes security and a key topic for the CKAD exam.
