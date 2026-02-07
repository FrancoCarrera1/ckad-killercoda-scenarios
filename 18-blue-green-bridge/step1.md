# Deploy Blue Version

Deploy the initial "blue" version of your application. This is the current production version that will serve all traffic.

## Task

Create the blue environment with:

1. **ConfigMap** named `blue-page` with key `index.html` containing `<h1>Blue Version v1</h1>`
2. **Deployment** named `webapp-blue`:
   - Namespace: `web-app`
   - Replicas: 3
   - Image: `nginx:1.24`
   - Labels: `app=webapp`, `version=blue`
   - Mount ConfigMap as volume at `/usr/share/nginx/html`
3. **Service** named `webapp-svc`:
   - Selector: `app=webapp`, `version=blue` (both labels!)
   - Port: 80

The Service initially routes to blue pods only.

<details><summary>Hint</summary>

Create the ConfigMap:
```bash
kubectl create configmap blue-page --from-literal=index.html='<h1>Blue Version v1</h1>' -n web-app
```

For the Deployment, you'll need to mount the ConfigMap as a volume. The volume configuration looks like:
```yaml
volumes:
- name: content
  configMap:
    name: blue-page
```

And in the container:
```yaml
volumeMounts:
- name: content
  mountPath: /usr/share/nginx/html
```

For the Service, make sure the selector includes BOTH labels:
```yaml
selector:
  app: webapp
  version: blue
```

</details>

<details><summary>Solution</summary>

```bash
# Create ConfigMap with blue content
kubectl create configmap blue-page --from-literal=index.html='<h1>Blue Version v1</h1>' -n web-app

# Create blue deployment
cat << 'EOF' > blue-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-blue
  namespace: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
      version: blue
  template:
    metadata:
      labels:
        app: webapp
        version: blue
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        volumeMounts:
        - name: content
          mountPath: /usr/share/nginx/html
      volumes:
      - name: content
        configMap:
          name: blue-page
EOF

kubectl apply -f blue-deployment.yaml

# Create service pointing to blue
cat << 'EOF' > webapp-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-svc
  namespace: web-app
spec:
  selector:
    app: webapp
    version: blue
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl apply -f webapp-service.yaml

# Verify
kubectl get deployments,svc -n web-app
kubectl get pods -n web-app -l version=blue

# Test the service (optional - create a test pod)
kubectl run curl-test --image=curlimages/curl -n web-app --rm -it --restart=Never -- curl -s webapp-svc
```

</details>
