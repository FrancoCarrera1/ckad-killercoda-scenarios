# The TLS Fortress

Your application needs to serve traffic over HTTPS. You'll generate a self-signed certificate, create a TLS Secret, configure a TLS-enabled Ingress, and verify the secure connection.

## Scenario

You have a deployment called `secure-app` running in the `tls-lab` namespace. Your task is to:
1. Generate a self-signed TLS certificate for `secure.example.com`
2. Store the certificate in a Kubernetes TLS Secret
3. Configure an Ingress resource to use the certificate
4. Test the HTTPS connection

This is a common pattern for securing web applications in Kubernetes, even in development environments where self-signed certificates are acceptable.

Click **Start** to begin!
