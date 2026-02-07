# Step 2: Deploy Canary

Now you'll deploy the canary version alongside the stable version. With 1 canary pod and 4 stable pods, approximately 20% of traffic will go to the canary.

## Task Description

Create the following resources in the `canary-test` namespace:

**1. ConfigMap `canary-page`**:
- Key: `index.html`
- Value: `Canary v2`

**2. Deployment `frontend-canary`**:
- Replicas: 1
- Image: `nginx:1.25` (newer version)
- Labels: `app=frontend` and `track=canary`
- Mount the ConfigMap at `/usr/share/nginx/html`

The canary deployment uses the same `app=frontend` label, so the Service will automatically start sending traffic to it. The traffic split will be approximately 4:1 (80% stable, 20% canary) based on the pod count ratio.

<details><summary>Hint</summary>

The canary deployment is almost identical to the stable one, with these changes:
- Different name: `frontend-canary`
- Different image: `nginx:1.25`
- Different replica count: 1
- Different track label: `canary`
- Different ConfigMap: `canary-page`

</details>

<details><summary>Solution</summary>

```bash
# Create ConfigMap for canary version
kubectl create configmap canary-page -n canary-test \
  --from-literal='index.html=Canary v2'

# Create Deployment for canary version
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-canary
  namespace: canary-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
      track: canary
  template:
    metadata:
      labels:
        app: frontend
        track: canary
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html
        configMap:
          name: canary-page
EOF

# Wait for canary deployment to be ready
kubectl wait --for=condition=Available deployment/frontend-canary -n canary-test --timeout=60s

# Check the total number of endpoints (should now be 5: 4 stable + 1 canary)
kubectl get endpoints frontend-svc -n canary-test

# Verify both deployments
kubectl get deployments -n canary-test
kubectl get pods -n canary-test -l app=frontend --show-labels
```

</details>
