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
   - Set volume mount to `readOnly: true`

3. **Environment Variables**:
   - Set env var `DB_USER` from secret `app-credentials`, key `username`
   - Set env var `DB_PASS` from secret `app-credentials`, key `password`

4. **Image Pull Secret**:
   - Use `registry-creds` as imagePullSecret

## Why This Matters

This demonstrates two key approaches to working with secrets:
- **Volume mounts**: Best for file-based secrets (certificates, config files)
- **Environment variables**: Best for simple key-value pairs (credentials, API tokens)
- **ImagePullSecrets**: Special secret type for authenticating to private registries

Understanding when to use each method is critical for the CKAD exam!

<details><summary>Hint 1: Pod structure with secrets</summary>

You need:
1. `imagePullSecrets` at pod spec level
2. `volumes` section referencing the secret
3. `volumeMounts` in the container
4. `env` with `valueFrom.secretKeyRef` for environment variables

</details>

<details><summary>Hint 2: Environment variables from secret</summary>

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
  volumes:
  - name: secret-volume
    secret:
      secretName: app-credentials
EOF

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod/secure-app -n vault --timeout=60s

# Verify the pod is running
kubectl get pod secure-app -n vault
```

</details>
