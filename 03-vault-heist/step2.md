# Step 2: Deploy Secure Pod with Secrets

## Task

Create a pod that uses all three secrets in different ways while following security best practices.

### Requirements

Create a pod named `secure-app` in the `vault` namespace with the following configuration:

1. **Container**:
   - Image: `nginx:1.24`
   - Name: `webapp`

2. **Secret Mounting**:
   - Mount `app-credentials` secret as a volume at `/etc/secrets/app`
   - Set volume mount `defaultMode` to `0400` (read-only for owner)

3. **Environment Variables**:
   - Set env var `DB_USER` from secret `app-credentials`, key `username`
   - Set env var `DB_PASS` from secret `app-credentials`, key `password`

4. **Image Pull Secret**:
   - Use `registry-creds` as imagePullSecret

5. **Security Context** (container-level):
   - `runAsNonRoot: true`
   - `runAsUser: 1000`
   - `runAsGroup: 1000`

## Why This Matters

This demonstrates **defense in depth**:
- Secrets mounted with restrictive permissions (0400 = read-only for owner)
- Container runs as non-root user (UID 1000)
- ImagePullSecrets allow pulling from private registries
- Multiple ways to inject secrets (volumes vs env vars) based on use case

<details><summary>Hint 1: Pod structure with secrets</summary>

You need:
1. `imagePullSecrets` at pod spec level
2. `volumes` section referencing the secret
3. `volumeMounts` in the container
4. `env` with `valueFrom.secretKeyRef` for environment variables
5. `securityContext` at container level

</details>

<details><summary>Hint 2: Volume mount with defaultMode</summary>

```yaml
volumeMounts:
- name: secret-volume
  mountPath: /etc/secrets/app
volumes:
- name: secret-volume
  secret:
    secretName: app-credentials
    defaultMode: 0400
```

Note: `defaultMode` is in **octal** (base 8), so 0400 in YAML.

</details>

<details><summary>Hint 3: Environment variables from secret</summary>

```yaml
env:
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: app-credentials
      key: username
- name: DB_PASS
  valueFrom:
    secretKeyRef:
      name: app-credentials
      key: password
```

</details>

<details><summary>Solution</summary>

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
  namespace: vault
spec:
  imagePullSecrets:
  - name: registry-creds
  containers:
  - name: webapp
    image: nginx:1.24
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: app-credentials
          key: username
    - name: DB_PASS
      valueFrom:
        secretKeyRef:
          name: app-credentials
          key: password
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets/app
      readOnly: true
    securityContext:
      runAsNonRoot: true
      runAsUser: 1000
      runAsGroup: 1000
  volumes:
  - name: secret-volume
    secret:
      secretName: app-credentials
      defaultMode: 0400
EOF

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod/secure-app -n vault --timeout=60s

# Verify the pod is running
kubectl get pod secure-app -n vault

# Check the security context
kubectl get pod secure-app -n vault -o jsonpath='{.spec.containers[0].securityContext}'
```

</details>
