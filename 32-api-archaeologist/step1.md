## Task description

Attempt to apply the old manifests to see what errors occur. Understanding these errors is the first step in the conversion process.

Try applying each manifest file from `/root/old-manifests/`:
- `deployment.yaml`
- `ingress.yaml`
- `cronjob.yaml`

Observe the error messages carefully. They'll tell you exactly what's wrong with each deprecated API version.

<details><summary>Hint</summary>

Use `kubectl apply -f /root/old-manifests/deployment.yaml` and similar commands for each file.

Look for error messages about:
- API versions no longer being served
- Missing required fields
- Structural changes in the API

</details>

<details><summary>Solution</summary>

```bash
# Try applying the old Deployment
kubectl apply -f /root/old-manifests/deployment.yaml
# Error: extensions/v1beta1 Deployment is no longer served

# Try applying the old Ingress
kubectl apply -f /root/old-manifests/ingress.yaml
# Error: networking.k8s.io/v1beta1 Ingress is no longer served

# Try applying the old CronJob
kubectl apply -f /root/old-manifests/cronjob.yaml
# Error: batch/v1beta1 CronJob is no longer served

# All three will fail because these API versions have been removed
```

</details>
