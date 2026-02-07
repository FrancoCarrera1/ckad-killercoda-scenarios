## Task description

Convert the deprecated manifests to current API versions. Create fixed versions in `/root/fixed-manifests/`.

Create three new manifest files with the following changes:

**Deployment** (`deployment.yaml`):
- Change API version from `extensions/v1beta1` to `apps/v1`
- Add required `spec.selector.matchLabels` that matches `spec.template.metadata.labels`

**Ingress** (`ingress.yaml`):
- Change API version from `networking.k8s.io/v1beta1` to `networking.k8s.io/v1`
- Update backend structure: change `serviceName`/`servicePort` to `service.name`/`service.port.number`
- Add required `pathType: Prefix` to each path

**CronJob** (`cronjob.yaml`):
- Change API version from `batch/v1beta1` to `batch/v1`

<details><summary>Hint</summary>

Use `kubectl api-resources` to find the correct API group and version for each resource:
```bash
kubectl api-resources | grep -E "deployments|ingresses|cronjobs"
```

Create the directory first: `mkdir -p /root/fixed-manifests`

Key changes:
- Deployment: `spec.selector.matchLabels.app: legacy-app`
- Ingress: `backend.service.name` and `backend.service.port.number`
- CronJob: Just update the API version to `batch/v1`

</details>

<details><summary>Solution</summary>

```bash
# Create directory for fixed manifests
mkdir -p /root/fixed-manifests

# Fixed Deployment
cat > /root/fixed-manifests/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-app
  namespace: archaeology
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy-app
  template:
    metadata:
      labels:
        app: legacy-app
    spec:
      containers:
      - name: app
        image: nginx:1.24
        ports:
        - containerPort: 80
EOF

# Fixed Ingress
cat > /root/fixed-manifests/ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: legacy-ingress
  namespace: archaeology
spec:
  rules:
  - host: legacy.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: legacy-svc
            port:
              number: 80
EOF

# Fixed CronJob
cat > /root/fixed-manifests/cronjob.yaml << 'EOF'
apiVersion: batch/v1
kind: CronJob
metadata:
  name: legacy-cron
  namespace: archaeology
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cron
            image: busybox:1.36
            command: ["echo", "Running legacy cron"]
          restartPolicy: OnFailure
EOF
```

</details>

> **Note:** The validation for this step checks for files in `/root/fixed-manifests/`. If you applied your manifests directly to the cluster without saving them to that directory, the validation may fail even though the resources are running. If all your objects are deployed and running in the `archaeology` namespace, feel free to skip to the next step.
