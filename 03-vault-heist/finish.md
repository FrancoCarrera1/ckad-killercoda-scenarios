# Congratulations!

You've successfully mastered all Kubernetes secret types and implemented production-grade security practices!

## What You Learned

In this scenario, you mastered:

1. **Secret Types**
   - **Opaque (Generic)**: Created from literal values for credentials
   - **kubernetes.io/tls**: Created from certificate files for TLS
   - **kubernetes.io/dockerconfigjson**: Created for private registry authentication

2. **Secret Injection Patterns**
   - **Volume mounts**: For file-based secrets with custom permissions
   - **Environment variables**: For simple key-value secrets
   - **imagePullSecrets**: For authenticating to private container registries

3. **File Permissions**
   - Setting `defaultMode` on secret volumes
   - Understanding octal permissions (0400 = read-only for owner)
   - Verifying permissions with `ls -la` and `stat`

4. **SecurityContext**
   - `runAsNonRoot`: Prevent container from running as root
   - `runAsUser` and `runAsGroup`: Explicitly set UID/GID
   - Verifying process identity with `id` and `ps`

5. **Security Best Practices**
   - Never run containers as root (UID 0)
   - Use restrictive file permissions on secrets
   - Combine multiple security layers (defense in depth)

## CKAD Exam Tips

### Speed Techniques

1. **Fast secret creation commands**
   ```bash
   # Generic
   kubectl create secret generic <name> --from-literal=key=value -n <ns>

   # TLS
   kubectl create secret tls <name> --cert=cert.crt --key=cert.key -n <ns>

   # Docker registry
   kubectl create secret docker-registry <name> \
     --docker-server=<server> \
     --docker-username=<user> \
     --docker-password=<pass> \
     -n <ns>
   ```

2. **Viewing secret data**
   ```bash
   # Get base64-encoded data
   kubectl get secret <name> -o jsonpath='{.data.key}'

   # Decode
   kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d
   ```

3. **Quick YAML for common patterns**
   - Keep templates for env vars from secrets
   - Keep templates for volume mounts with defaultMode
   - Practice typing SecurityContext quickly

### Common Exam Patterns

1. **Environment variable from secret**
   ```yaml
   env:
   - name: PASSWORD
     valueFrom:
       secretKeyRef:
         name: my-secret
         key: password
   ```

2. **Volume mount with permissions**
   ```yaml
   volumeMounts:
   - name: secret-vol
     mountPath: /etc/secrets
   volumes:
   - name: secret-vol
     secret:
       secretName: my-secret
       defaultMode: 0400
   ```

3. **SecurityContext (container-level)**
   ```yaml
   securityContext:
     runAsNonRoot: true
     runAsUser: 1000
     runAsGroup: 1000
     allowPrivilegeEscalation: false
   ```

4. **ImagePullSecrets**
   ```yaml
   spec:
     imagePullSecrets:
     - name: registry-secret
   ```

### Common Pitfalls

- Forgetting to base64-encode when creating secrets from YAML
- Confusing `secret` vs `secretKeyRef` vs `secretRef`
- Using wrong defaultMode format (should be octal: 0400, not "400")
- Setting SecurityContext at pod level instead of container level (or vice versa)
- Not understanding that nginx:1.24 runs as root by default (need SecurityContext to change)

### File Permission Reference

| Octal | Symbolic | Meaning |
|-------|----------|---------|
| 0400 | -r------- | Read-only for owner |
| 0600 | -rw------ | Read-write for owner |
| 0644 | -rw-r--r-- | Read-write owner, read-only others |
| 0755 | -rwxr-xr-x | Executable for all, writable by owner |

### Exam Relevance

Secrets and SecurityContext are tested in:
- **Application Environment, Configuration and Security (25%)**: Primary domain
- Often combined with multi-container pods, network policies, or RBAC questions

## Key Concepts Summary

| Concept | Purpose | Exam Frequency |
|---------|---------|----------------|
| Secret types | Different formats for different use cases | High |
| Volume mounts | Mount secrets as files | High |
| Env vars | Inject secrets as environment variables | High |
| defaultMode | Control file permissions | Medium |
| SecurityContext | Run containers securely | High |
| imagePullSecrets | Access private registries | Medium |

## Security Best Practices

1. **Always use secrets for sensitive data** (never ConfigMaps)
2. **Mount secrets as volumes when possible** (more secure than env vars)
3. **Use restrictive permissions** (0400 or 0600)
4. **Run as non-root** (set runAsNonRoot: true)
5. **Use specific UIDs** (don't rely on container defaults)
6. **Enable secret encryption at rest** (cluster-level configuration)

## Next Steps

Now that you understand secrets and security, you're ready to learn:
- **RBAC**: Control who can access secrets
- **Pod Security Policies/Standards**: Enforce security at admission time
- **Network Policies**: Control network-level access
- **Service Accounts with RBAC**: Granular pod-level permissions

Outstanding work! You've mastered a critical security domain for CKAD!
