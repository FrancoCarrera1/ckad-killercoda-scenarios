# Step 1: Deploy Stable Version

First, you'll deploy the stable version of your application with its configuration and expose it through a Service.

## Task Description

Create the following resources in the `canary-test` namespace:

**1. ConfigMap `stable-page`**:
- Key: `index.html`
- Value: `Stable v1`

**2. Deployment `frontend-stable`**:
- Replicas: 4
- Image: `nginx:1.24`
- Labels: `app=frontend` and `track=stable`
- Mount the ConfigMap at `/usr/share/nginx/html`

**3. Service `frontend-svc`**:
- Type: ClusterIP
- Port: 80
- Selector: `app=frontend` (Note: Do NOT include the `track` label in the selector)

The key insight here is that the Service selector only matches `app=frontend`, not the `track` label. This allows both stable and canary pods to receive traffic through the same Service.

<details><summary>Hint</summary>

For the Deployment, you'll need to add labels in two places:
- Template metadata labels (for the pods)
- Selector matchLabels (to identify which pods belong to this deployment)

The Service should only select on `app=frontend` to allow multiple tracks.

</details>

<details><summary>Solution</summary>

```bash
# Create ConfigMap for stable version
kubectl create configmap stable-page -n canary-test \
  --from-literal='index.html=Stable v1'

# Create Deployment for stable version
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-stable
  namespace: canary-test
spec:
  replicas: 4
  selector:
    matchLabels:
      app: frontend
      track: stable
  template:
    metadata:
      labels:
        app: frontend
        track: stable
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html
        configMap:
          name: stable-page
EOF

# Create Service that selects app=frontend (not track label)
kubectl create service clusterip frontend-svc -n canary-test \
  --tcp=80:80 \
  --dry-run=client -o yaml | \
  kubectl apply -f - && \
  kubectl patch service frontend-svc -n canary-test -p '{"spec":{"selector":{"app":"frontend"}}}'

# Alternatively, create Service via YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: canary-test
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
EOF

# Wait for deployment to be ready
kubectl wait --for=condition=Available deployment/frontend-stable -n canary-test --timeout=60s

# Verify the setup
kubectl get deployment,service,endpoints -n canary-test
```

</details>
