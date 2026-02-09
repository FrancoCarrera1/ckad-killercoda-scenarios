# Step 1: Create Multiple Secret Types

## Task

Create three different types of secrets in the `vault` namespace to demonstrate mastery of all secret types.

### Requirements

1. Create a **generic secret** named `app-credentials` with:
   - `username=admin`
   - `password=S3cur3P@ss!`

2. Create a **TLS secret** named `vault-tls` from the certificate files:
   - Certificate: `/root/certs/tls.crt`
   - Key: `/root/certs/tls.key`

3. Create a **docker-registry secret** named `registry-creds` with:
   - Server: `registry.example.com`
   - Username: `deployer`
   - Password: `d3pl0y`
   - Email: `deployer@example.com`

## Why This Matters

Kubernetes has specialized secret types for common use cases:
- **Opaque/Generic**: The default type for any key-value secrets
- **TLS**: Automatically validates that you provide `tls.crt` and `tls.key`
- **Docker Registry**: Special format for container registry authentication

Understanding these types is essential for the CKAD exam!

<details><summary>Hint 1: Creating a generic secret</summary>

Use `kubectl create secret generic`:
```bash
kubectl create secret generic <name> \
  --from-literal=username=admin \
  --from-literal=password=S3cur3P@ss! \
  -n <namespace>
```

</details>

<details><summary>Hint 2: Creating a TLS secret</summary>

Use `kubectl create secret tls`:
```bash
kubectl create secret tls <name> \
  --cert=/path/to/tls.crt \
  --key=/path/to/tls.key \
  -n <namespace>
```

</details>

<details><summary>Hint 3: Creating a docker-registry secret</summary>

Use `kubectl create secret docker-registry`:
```bash
kubectl create secret docker-registry <name> \
  --docker-server=registry.example.com \
  --docker-username=deployer \
  --docker-password=d3pl0y \
  --docker-email=deployer@example.com \
  -n <namespace>
```

</details>

<details><summary>Solution</summary>

```bash
# Create generic secret
kubectl create secret generic app-credentials \
  --from-literal=username=admin \
  --from-literal=password='S3cur3P@ss!' \
  -n vault

# Create TLS secret
kubectl create secret tls vault-tls \
  --cert=/root/certs/tls.crt \
  --key=/root/certs/tls.key \
  -n vault

# Create docker-registry secret
kubectl create secret docker-registry registry-creds \
  --docker-server=registry.example.com \
  --docker-username=deployer \
  --docker-password=d3pl0y \
  --docker-email=deployer@example.com \
  -n vault

# Verify all secrets
kubectl get secrets -n vault

# Check secret types
kubectl get secret app-credentials -n vault -o jsonpath='{.type}'
echo ""
kubectl get secret vault-tls -n vault -o jsonpath='{.type}'
echo ""
kubectl get secret registry-creds -n vault -o jsonpath='{.type}'
echo ""

# View the structure (base64 encoded)
kubectl get secret app-credentials -n vault -o yaml
```

Expected types:
- app-credentials: `Opaque`
- vault-tls: `kubernetes.io/tls`
- registry-creds: `kubernetes.io/dockerconfigjson`

</details>
