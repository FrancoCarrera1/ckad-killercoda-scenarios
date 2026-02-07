## Task description

Create a pod with all three probe types configured and expose it with a Service.

Create a pod named `healthy-app` in the `health-lab` namespace with the following specifications:
- Image: `nginx:1.24`
- **startupProbe**:
  - httpGet on path `/` port `80`
  - failureThreshold: `30`
  - periodSeconds: `2`
- **livenessProbe**:
  - httpGet on path `/` port `80`
  - initialDelaySeconds: `0`
  - periodSeconds: `5`
  - failureThreshold: `3`
- **readinessProbe**:
  - httpGet on path `/` port `80`
  - initialDelaySeconds: `0`
  - periodSeconds: `3`
  - failureThreshold: `2`

Also create a Service named `healthy-svc` in the `health-lab` namespace that selects the pod and exposes port `80`.

<details><summary>Hint</summary>
Use `kubectl run` with `--dry-run=client -o yaml` to generate a pod template, then add the probes manually. For the Service, use `kubectl expose pod` or create it declaratively.
</details>

<details><summary>Solution</summary>
```bash
# Create the pod with all three probes
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: healthy-app
  namespace: health-lab
  labels:
    app: healthy-app
spec:
  containers:
  - name: nginx
    image: nginx:1.24
    ports:
    - containerPort: 80
    startupProbe:
      httpGet:
        path: /
        port: 80
      failureThreshold: 30
      periodSeconds: 2
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 0
      periodSeconds: 5
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 0
      periodSeconds: 3
      failureThreshold: 2
EOF

# Create the Service
kubectl expose pod healthy-app -n health-lab --name=healthy-svc --port=80
```
</details>
