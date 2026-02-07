# Create Deployment with Rolling Update Strategy

Create a Deployment for the payment service with specific rolling update parameters to control how pods are replaced during updates.

## Task

Create a Deployment named `payment-service` in the `payments` namespace with the following specifications:

- **Replicas**: 4
- **Image**: `nginx:1.24`
- **Labels**: `app=payment`
- **Strategy**: RollingUpdate
  - `maxUnavailable`: 1
  - `maxSurge`: 1
- **Record**: Annotate with change-cause for tracking

With `maxUnavailable=1`, at least 3 pods will always be available during updates.
With `maxSurge=1`, at most 5 pods will exist during updates.

<details><summary>Hint</summary>

You can create a deployment with `kubectl create deployment` and then edit it, or use a YAML manifest.

To set the rolling update strategy, you need to modify the `spec.strategy` section:
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
    maxSurge: 1
```

For change-cause tracking, use:
```bash
kubectl annotate deployment payment-service kubernetes.io/change-cause="Initial deployment with nginx 1.24" -n payments
```

</details>

<details><summary>Solution</summary>

```bash
# Create deployment YAML
cat << 'EOF' > payment-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
  namespace: payments
  labels:
    app: payment
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: payment
  template:
    metadata:
      labels:
        app: payment
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
EOF

# Apply the deployment
kubectl apply -f payment-deployment.yaml

# Annotate with change-cause
kubectl annotate deployment payment-service -n payments kubernetes.io/change-cause="Initial deployment with nginx 1.24"

# Verify
kubectl get deployment payment-service -n payments
kubectl describe deployment payment-service -n payments | grep -A 3 "RollingUpdate"
```

</details>
