# The DNS Detective

DNS is the backbone of service discovery in Kubernetes. Understanding how DNS works — from short names to FQDNs, from regular services to headless StatefulSet pod records — is essential for debugging connectivity issues.

## Scenario

You have applications running in two namespaces:
- `dns-frontend` - Contains frontend applications
- `dns-backend` - Contains backend services

Your task is to explore and understand:
1. Same-namespace DNS resolution (short names)
2. Cross-namespace DNS resolution (namespace-qualified and FQDN)
3. Headless services and StatefulSet pod DNS records
4. DNS debugging tools and techniques

By the end of this scenario, you'll be able to troubleshoot any DNS-related issue in Kubernetes!

Click **Start** to begin!
