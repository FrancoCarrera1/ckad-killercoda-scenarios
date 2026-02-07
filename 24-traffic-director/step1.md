# Step 1: Deploy Multiple Backend Services

Before we can route traffic, we need backend services to route to. You'll create three separate deployments, each with custom HTML content and a corresponding service.

## Task

Create three complete application stacks in the `traffic-lab` namespace:

### 1. Storefront Application
- **ConfigMap** named `storefront-page` with an `index.html` key containing: `<h1>Storefront</h1>`
- **Deployment** named `storefront` with 1 replica using `nginx:1.24`
  - Mount the ConfigMap at `/usr/share/nginx/html`
- **Service** named `storefront-svc` exposing port 80

### 2. API Server
- **ConfigMap** named `api-page` with an `index.html` key containing: `<h1>API Server</h1>`
- **Deployment** named `api-server` with 1 replica using `nginx:1.24`
  - Mount the ConfigMap at `/usr/share/nginx/html`
- **Service** named `api-svc` exposing port 80

### 3. Documentation Site
- **ConfigMap** named `docs-page` with an `index.html` key containing: `<h1>Documentation</h1>`
- **Deployment** named `docs-site` with 1 replica using `nginx:1.24`
  - Mount the ConfigMap at `/usr/share/nginx/html`
- **Service** named `docs-svc` exposing port 80

All services should be ClusterIP type and select their respective deployment pods.

<details><summary>Hint</summary>

For each application:
1. Create a ConfigMap with the HTML content
2. Create a deployment that mounts the ConfigMap as a volume
3. Expose the deployment as a service

The volume mount should use `configMap` as the volume source and mount to `/usr/share/nginx/html` (nginx's default document root).

</details>

<details><summary>Solution</summary>

```bash
# Storefront
kubectl create configmap storefront-page --from-literal=index.html='<h1>Storefront</h1>' -n traffic-lab

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storefront
  namespace: traffic-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: storefront
  template:
    metadata:
      labels:
        app: storefront
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
          name: storefront-page
EOF

kubectl expose deployment storefront --name=storefront-svc --port=80 -n traffic-lab

# API Server
kubectl create configmap api-page --from-literal=index.html='<h1>API Server</h1>' -n traffic-lab

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: traffic-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
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
          name: api-page
EOF

kubectl expose deployment api-server --name=api-svc --port=80 -n traffic-lab

# Documentation Site
kubectl create configmap docs-page --from-literal=index.html='<h1>Documentation</h1>' -n traffic-lab

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: docs-site
  namespace: traffic-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: docs-site
  template:
    metadata:
      labels:
        app: docs-site
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
          name: docs-page
EOF

kubectl expose deployment docs-site --name=docs-svc --port=80 -n traffic-lab

# Verify all services are created
kubectl get svc -n traffic-lab
```

</details>
