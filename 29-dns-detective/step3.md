## Task description

Create a Headless Service and StatefulSet to explore individual pod DNS records.

Requirements:
1. Create a Headless Service named `web-headless` in `dns-frontend` namespace
   - `clusterIP: None`
   - Selector: `app=web-sts`
2. Create a StatefulSet named `web` with 3 replicas
   - Namespace: `dns-frontend`
   - ServiceName: `web-headless`
   - Image: `nginx:1.24`
   - Labels: `app=web-sts`
3. Test DNS resolution for individual pods: `web-0.web-headless.dns-frontend.svc.cluster.local`

<details><summary>Hint</summary>
Headless services (clusterIP: None) create DNS A records for each pod. StatefulSets use these for stable network identities. Each pod gets a DNS name: `<pod-name>.<service-name>.<namespace>.svc.cluster.local`
</details>

<details><summary>Solution</summary>
```bash
# Create Headless Service
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-headless
  namespace: dns-frontend
spec:
  clusterIP: None
  selector:
    app: web-sts
  ports:
  - port: 80
    targetPort: 80
EOF

# Create StatefulSet
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
  namespace: dns-frontend
spec:
  serviceName: web-headless
  replicas: 3
  selector:
    matchLabels:
      app: web-sts
  template:
    metadata:
      labels:
        app: web-sts
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
EOF

# Wait for pods to be ready
kubectl wait --for=condition=Ready pod -l app=web-sts -n dns-frontend --timeout=60s

# Test individual pod DNS
kubectl exec -n dns-frontend frontend-app -- nslookup web-0.web-headless.dns-frontend.svc.cluster.local
kubectl exec -n dns-frontend frontend-app -- nslookup web-1.web-headless.dns-frontend.svc.cluster.local
kubectl exec -n dns-frontend frontend-app -- nslookup web-2.web-headless.dns-frontend.svc.cluster.local

# Test headless service DNS (returns all pod IPs)
kubectl exec -n dns-frontend frontend-app -- nslookup web-headless.dns-frontend.svc.cluster.local
```
</details>
