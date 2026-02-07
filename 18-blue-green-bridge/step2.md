# Deploy Green Version

Deploy the new "green" version alongside the existing blue version. Both environments will run simultaneously, but only blue receives traffic (for now).

## Task

Create the green environment with:

1. **ConfigMap** named `green-page` with key `index.html` containing `<h1>Green Version v2</h1>`
2. **Deployment** named `webapp-green`:
   - Namespace: `web-app`
   - Replicas: 3
   - Image: `nginx:1.25`
   - Labels: `app=webapp`, `version=green`
   - Mount ConfigMap as volume at `/usr/share/nginx/html`

Important: The Service `webapp-svc` should STILL point to blue. You're deploying green in dark mode — running but not serving traffic.

<details><summary>Hint</summary>

Create the ConfigMap:
```bash
kubectl create configmap green-page --from-literal=index.html='<h1>Green Version v2</h1>' -n web-app
```

The green deployment is almost identical to blue, but with:
- Different name: `webapp-green`
- Different image: `nginx:1.25`
- Different labels: `version=green`
- Different ConfigMap: `green-page`

The Service selector wasn't changed, so it still points to `version=blue`.

</details>

<details><summary>Solution</summary>

```bash
# Create ConfigMap with green content
kubectl create configmap green-page --from-literal=index.html='<h1>Green Version v2</h1>' -n web-app

# Create green deployment
cat << 'EOF' > green-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-green
  namespace: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
      version: green
  template:
    metadata:
      labels:
        app: webapp
        version: green
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        volumeMounts:
        - name: content
          mountPath: /usr/share/nginx/html
      volumes:
      - name: content
        configMap:
          name: green-page
EOF

kubectl apply -f green-deployment.yaml

# Verify both deployments are running
kubectl get deployments -n web-app
kubectl get pods -n web-app -l app=webapp

# Verify service still points to blue only
kubectl get endpoints webapp-svc -n web-app
kubectl describe service webapp-svc -n web-app | grep Selector

# Test - should still get Blue Version
kubectl run curl-test --image=curlimages/curl -n web-app --rm -it --restart=Never -- curl -s webapp-svc
```

</details>
