# Step 3: Create ExternalName and Headless Services

Two special service types complete our service menu: ExternalName for aliasing external DNS names, and Headless services for direct pod DNS resolution.

## Task Part 1: ExternalName Service

Create an ExternalName service named `external-api` in the `service-menu` namespace that:
- Points to the external DNS name `api.example.com`
- Type is ExternalName

This allows pods in your cluster to reference `external-api` instead of the full external DNS name.

## Task Part 2: Headless Service

Create a Headless service named `web-headless` in the `service-menu` namespace that:
- Selects pods with label `app=web`
- Exposes port 80
- Has `clusterIP: None` (this makes it headless)

Headless services don't provide load balancing. Instead, DNS queries return the IP addresses of all matching pods directly.

## Verification

Verify the DNS resolution using nslookup from a test pod:

```bash
kubectl run test-dns --image=busybox:1.36 -n service-menu --rm -it --restart=Never -- nslookup web-headless
```

You should see multiple A records, one for each pod.

<details><summary>Hint</summary>

For ExternalName:
- Use `spec.type: ExternalName`
- Use `spec.externalName: api.example.com`
- No selector or ports needed

For Headless:
- Use `spec.clusterIP: None`
- Include normal selector and ports
- Type should be ClusterIP (or omitted)

</details>

<details><summary>Solution</summary>

```bash
# Create ExternalName service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: external-api
  namespace: service-menu
spec:
  type: ExternalName
  externalName: api.example.com
EOF

# Create Headless service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-headless
  namespace: service-menu
spec:
  clusterIP: None
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF

# Verify ExternalName service
kubectl get svc external-api -n service-menu

# Verify Headless service
kubectl get svc web-headless -n service-menu

# Test DNS resolution for headless service
kubectl run test-dns --image=busybox:1.36 -n service-menu --rm -it --restart=Never -- nslookup web-headless

# You can also check individual pod DNS
kubectl run test-dns --image=busybox:1.36 -n service-menu --rm -it --restart=Never -- nslookup web-headless.service-menu.svc.cluster.local
```

</details>
