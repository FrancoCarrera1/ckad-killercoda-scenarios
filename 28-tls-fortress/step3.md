## Task description

Test the HTTPS connection to your application and verify the certificate.

You need to:
1. Get the Ingress controller's NodePort
2. Use `curl` with `--resolve` to test HTTPS connectivity
3. Verify the certificate subject contains `secure.example.com`

<details><summary>Hint</summary>
Use `kubectl get svc -n ingress-nginx` to find the HTTPS NodePort. Use `curl -k` to skip certificate verification (since it's self-signed), and `--resolve` to map the hostname to localhost. Use `-v` or `openssl s_client` to inspect the certificate.
</details>

<details><summary>Solution</summary>
```bash
# Get the HTTPS NodePort
HTTPS_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

# Test HTTPS connection (use -k to accept self-signed cert)
curl -k --resolve secure.example.com:${HTTPS_PORT}:127.0.0.1 https://secure.example.com:${HTTPS_PORT}/

# Verify certificate subject
echo | openssl s_client -connect 127.0.0.1:${HTTPS_PORT} -servername secure.example.com 2>/dev/null | openssl x509 -noout -subject

# You should see: subject=CN = secure.example.com, O = secure.example.com
```
</details>
