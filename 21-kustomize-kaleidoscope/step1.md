# Create Kustomize Base Configuration

The base configuration contains resources that are common to all environments. You'll create a simple web application with a deployment and service.

## Task Description

Create the following files in `/root/kustomize-app/base/`:

1. **deployment.yaml**: A Deployment with these specifications:
   - Name: `webapp`
   - Replicas: `1`
   - Labels: `app=webapp`
   - Container image: `nginx:1.24`
   - Container port: `80`

2. **service.yaml**: A Service with these specifications:
   - Name: `webapp-svc`
   - Selector: `app=webapp`
   - Port: `80`, targetPort: `80`

3. **kustomization.yaml**: List both `deployment.yaml` and `service.yaml` as resources

After creating the files, verify your base works by running:
```bash
kubectl kustomize /root/kustomize-app/base/
```

This should output the combined YAML without actually applying it.

<details><summary>Hint</summary>

Create the directory structure first:
```bash
mkdir -p /root/kustomize-app/base
cd /root/kustomize-app/base
```

A basic `kustomization.yaml` looks like:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

Use standard Kubernetes manifest structure for deployment and service.

</details>

<details><summary>Solution</summary>

```bash
# Create the base directory
mkdir -p /root/kustomize-app/base
cd /root/kustomize-app/base

# Create deployment.yaml
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  labels:
    app: webapp
spec:
  replicas: 1
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
EOF

# Create service.yaml
cat <<EOF > service.yaml
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
cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
EOF

# Verify the base configuration
kubectl kustomize /root/kustomize-app/base/
```

</details>
