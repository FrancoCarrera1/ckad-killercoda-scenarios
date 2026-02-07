## Task description

Now apply your fixed manifests! But first, create the Service that the Ingress references.

Tasks:
1. Create a Service named `legacy-svc` in the `archaeology` namespace
   - Selector: `app: legacy-app`
   - Port: 80
   - Target port: 80

2. Apply all three fixed manifests from `/root/fixed-manifests/`

3. Verify all resources are created successfully

<details><summary>Hint</summary>

Create the Service first:
```bash
kubectl expose deployment legacy-app --name=legacy-svc --port=80 -n archaeology
```

Or use `kubectl create service` command.

Then apply all fixed manifests:
```bash
kubectl apply -f /root/fixed-manifests/
```

</details>

<details><summary>Solution</summary>

```bash
# Create the Service for the Ingress
kubectl expose deployment legacy-app --name=legacy-svc --port=80 -n archaeology

# Or create it directly:
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: legacy-svc
  namespace: archaeology
spec:
  selector:
    app: legacy-app
  ports:
  - port: 80
    targetPort: 80
EOF

# Apply all fixed manifests
kubectl apply -f /root/fixed-manifests/

# Verify everything is created
kubectl get deployment,ingress,cronjob -n archaeology

# Check the Deployment pods
kubectl get pods -n archaeology

# View the CronJob details
kubectl get cronjob legacy-cron -n archaeology
```

</details>
