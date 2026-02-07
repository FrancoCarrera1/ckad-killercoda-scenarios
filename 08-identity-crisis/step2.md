# Step 2: Create Custom Token with Projected Volume

Instead of using the default auto-mounted token, you can create a custom token using a projected volume. This allows you to configure the token's audience and expiration time.

## Your Task

Create a pod named `custom-token-pod` in the `identity-lab` namespace with a custom ServiceAccount token using a projected volume:

1. **Pod specifications**:
   - Image: `nginx:1.24`
   - ServiceAccount: `api-bot`

2. **Projected volume configuration**:
   - Volume name: `custom-token`
   - ServiceAccountToken source with:
     - Audience: `api.mycompany.io`
     - Expiration: `3600` seconds (1 hour)
     - Path: `token`
   - Mount path: `/var/run/secrets/custom/`

3. **Verify the token**:
   - Exec into the pod and check that the token exists at `/var/run/secrets/custom/token`
   - The token will have a custom audience (useful for external systems)

<details><summary>Hint</summary>

Projected volumes allow you to combine multiple sources into a single volume. For ServiceAccount tokens:

```yaml
volumes:
- name: custom-token
  projected:
    sources:
    - serviceAccountToken:
        audience: api.mycompany.io
        expirationSeconds: 3600
        path: token
```

Then mount it:
```yaml
volumeMounts:
- name: custom-token
  mountPath: /var/run/secrets/custom/
  readOnly: true
```

</details>

<details><summary>Solution</summary>

```bash
# Create pod with custom projected token
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: custom-token-pod
  namespace: identity-lab
spec:
  serviceAccountName: api-bot
  containers:
  - name: nginx
    image: nginx:1.24
    volumeMounts:
    - name: custom-token
      mountPath: /var/run/secrets/custom/
      readOnly: true
  volumes:
  - name: custom-token
    projected:
      sources:
      - serviceAccountToken:
          audience: api.mycompany.io
          expirationSeconds: 3600
          path: token
EOF

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod/custom-token-pod -n identity-lab --timeout=60s

# Verify the custom token exists
kubectl exec custom-token-pod -n identity-lab -- ls -la /var/run/secrets/custom/

# Should show: token

# View the token
kubectl exec custom-token-pod -n identity-lab -- cat /var/run/secrets/custom/token

# Decode the JWT to see the custom audience (requires jq, optional)
# kubectl exec custom-token-pod -n identity-lab -- cat /var/run/secrets/custom/token | cut -d. -f2 | base64 -d 2>/dev/null | jq .
```

</details>

## Understanding Projected Volumes

### Why Use Projected Volumes?

1. **Custom Audience**: Tokens for external systems (not just Kubernetes API)
2. **Custom Expiration**: Shorter-lived tokens for security
3. **Automatic Rotation**: Kubelet rotates tokens before expiration
4. **Multiple Sources**: Combine ServiceAccountToken with ConfigMaps, Secrets, etc.

### Projected Volume Sources

You can project multiple sources:
- `serviceAccountToken` - Dynamic ServiceAccount token
- `configMap` - ConfigMap data
- `secret` - Secret data
- `downwardAPI` - Pod metadata

### Token Properties

- **audience**: Who the token is intended for (validated by recipient)
- **expirationSeconds**: Token lifetime (kubelet rotates before expiry)
- **path**: Filename in the volume (default: token)

### Default Token vs Projected Token

| Feature | Default Auto-Mount | Projected Volume |
|---------|-------------------|------------------|
| Audience | `kubernetes.default.svc` | Custom (e.g., `api.mycompany.io`) |
| Expiration | Long-lived (~1 year) | Custom (e.g., 1 hour) |
| Rotation | No automatic rotation | Automatic rotation |
| Path | Fixed location | Custom mount path |

## Use Cases

- **Service Mesh**: Tokens for mutual TLS authentication
- **External Services**: Authenticate to non-Kubernetes systems
- **Short-lived Access**: Reduce blast radius of token compromise
- **Multi-Audience**: Different tokens for different purposes in the same pod
