## Task description

Create a DNS debugging pod with networking tools and explore DNS configuration.

Requirements:
1. Create a pod named `dnsutils` in `dns-frontend` namespace using image `registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3`
2. Use the pod to run DNS debugging commands:
   - `nslookup` to query DNS records
   - `dig` for detailed DNS information
   - Inspect CoreDNS logs

<details><summary>Hint</summary>
The `dnsutils` image contains useful networking tools. CoreDNS logs can be viewed with `kubectl logs -n kube-system -l k8s-app=kube-dns`.
</details>

<details><summary>Solution</summary>
```bash
# Create dnsutils pod
kubectl run dnsutils --image=registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3 -n dns-frontend -- sleep 3600

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod dnsutils -n dns-frontend --timeout=60s

# Use nslookup for basic DNS queries
kubectl exec -n dns-frontend dnsutils -- nslookup kubernetes.default

# Use dig for detailed DNS information
kubectl exec -n dns-frontend dnsutils -- dig frontend-svc.dns-frontend.svc.cluster.local

# Check DNS configuration
kubectl exec -n dns-frontend dnsutils -- cat /etc/resolv.conf

# View CoreDNS configuration
kubectl get configmap coredns -n kube-system -o yaml

# View CoreDNS logs
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=20

# Test DNS resolution for different record types
kubectl exec -n dns-frontend dnsutils -- dig +short web-headless.dns-frontend.svc.cluster.local
kubectl exec -n dns-frontend dnsutils -- dig +short web-0.web-headless.dns-frontend.svc.cluster.local
```
</details>
