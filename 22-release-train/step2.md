# Deploy Webapp with Kustomize

Now deploy the application layer using Kustomize. The webapp will be configured to connect to Redis.

## Task Description

Create Kustomize manifests in `/root/webapp-kustomize/base/` and deploy the webapp.

### 1. Create deployment.yaml

A Deployment with:
- Name: `webapp`
- Replicas: `2`
- Labels: `app=webapp`
- Container image: `nginx:1.24`
- Container port: `80`
- Environment variable:
  - Name: `REDIS_HOST`
  - Value: `my-redis-master.fullstack.svc.cluster.local`

### 2. Create service.yaml

A Service with:
- Name: `webapp-svc`
- Selector: `app=webapp`
- Port: `80`

### 3. Create kustomization.yaml

List both resources:
- `deployment.yaml`
- `service.yaml`

### 4. Deploy

Apply the Kustomize configuration to the `fullstack` namespace:
```bash
kubectl apply -k /root/webapp-kustomize/base/ -n fullstack
```

Verify the webapp pods can reach Redis by exec'ing into a pod and checking the `REDIS_HOST` environment variable.

<details><summary>Hint</summary>

For the environment variable in deployment.yaml:
```yaml
env:
  - name: REDIS_HOST
    value: my-redis-master.fullstack.svc.cluster.local
```

To check env vars in a running pod:
```bash
kubectl exec -it <pod-name> -n fullstack -- env | grep REDIS
```

</details>

<details><summary>Solution</summary>

```bash
# Create deployment.yaml
cat <<EOF > /root/webapp-kustomize/base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  labels:
    app: webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
        env:
        - name: REDIS_HOST
          value: my-redis-master.fullstack.svc.cluster.local
EOF

# Create service.yaml
cat <<EOF > /root/webapp-kustomize/base/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-svc
spec:
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 80
EOF

# Create kustomization.yaml
cat <<EOF > /root/webapp-kustomize/base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
EOF

# Apply the Kustomize configuration
kubectl apply -k /root/webapp-kustomize/base/ -n fullstack

# Wait for webapp to be ready
kubectl wait --for=condition=available deployment/webapp -n fullstack --timeout=120s

# Verify the deployment
kubectl get deployment webapp -n fullstack
kubectl get pods -n fullstack

# Check the environment variable in a webapp pod
POD=$(kubectl get pod -n fullstack -l app=webapp -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -n fullstack -- env | grep REDIS_HOST
```

</details>
