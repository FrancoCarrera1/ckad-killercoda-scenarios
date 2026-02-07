## Task description

Generate a self-signed TLS certificate using OpenSSL and create a TLS Secret in the `tls-lab` namespace.

Requirements:
- Generate a private key and certificate for the hostname `secure.example.com`
- Create a TLS Secret named `secure-tls` in the `tls-lab` namespace
- The Secret should be of type `kubernetes.io/tls`

<details><summary>Hint</summary>
Use `openssl req` to generate a self-signed certificate. The `-subj` flag can set the subject without interactive prompts. Then use `kubectl create secret tls` to create the TLS Secret.
</details>

<details><summary>Solution</summary>
```bash
# Generate private key and certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=secure.example.com/O=secure.example.com"

# Create TLS Secret
kubectl create secret tls secure-tls \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n tls-lab
```
</details>
