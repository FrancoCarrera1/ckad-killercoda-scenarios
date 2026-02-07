# Step 3: Deploy Within Quota Headroom

Now that you understand the constraints, let's work within them! You need to calculate the remaining quota headroom and deploy a multi-replica application.

## The Situation

- **Current state**: 5 pods exist, each using the default 100m CPU (from LimitRange)
- **Total CPU used**: 5 × 100m = 500m
- **Namespace quota**: 2000m (2 CPU)
- **Remaining headroom**: 2000m - 500m = 1500m

## Your Task

Create a Deployment named `efficient-app` in the `controlled` namespace with:

1. **3 replicas**
2. **Container**:
   - Name: `app`
   - Image: `nginx:1.24`
   - CPU request: `200m`
   - Memory request: `64Mi`

3. **Verify it fits**:
   - 3 replicas × 200m CPU = 600m
   - Total would be: 500m (existing) + 600m (new) = 1100m
   - This is under the 2000m quota ✓
   - Each pod requests 64Mi (under the 256Mi LimitRange max) ✓

But wait! We have 5 pods already, and the quota allows max 5 pods. What do we do?

## The Catch

The pod quota is 5, and you already have 5 pods. You need to:

1. **Delete some existing pods** to make room (delete pod-4 and pod-5)
2. **Create the Deployment** with 3 replicas
3. **Verify** all 3 replicas are running

<details><summary>Hint</summary>

To check current quota usage:
```bash
kubectl describe resourcequota compute-quota -n controlled
```

To delete pods:
```bash
kubectl delete pod pod-4 pod-5 -n controlled
```

To create the deployment:
```bash
kubectl create deployment efficient-app --image=nginx:1.24 --replicas=3 -n controlled
```

Then set the resource requests:
```bash
kubectl set resources deployment efficient-app -n controlled \
  --requests=cpu=200m,memory=64Mi
```

Or create via YAML for precise control.

</details>

<details><summary>Solution</summary>

```bash
# Check current quota usage
kubectl describe resourcequota compute-quota -n controlled

# Current state: 5 pods using 500m CPU total

# Delete 2 pods to make room for the 3-replica deployment
kubectl delete pod pod-4 pod-5 -n controlled

# Now we have 3 pods, allowing us to add 3 more (Deployment replicas)

# Method 1: Create deployment and set resources
kubectl create deployment efficient-app --image=nginx:1.24 --replicas=3 -n controlled

kubectl set resources deployment efficient-app -n controlled \
  --requests=cpu=200m,memory=64Mi \
  --limits=cpu=200m,memory=64Mi

# Method 2: Create via YAML (more precise)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: efficient-app
  namespace: controlled
spec:
  replicas: 3
  selector:
    matchLabels:
      app: efficient-app
  template:
    metadata:
      labels:
        app: efficient-app
    spec:
      containers:
      - name: app
        image: nginx:1.24
        resources:
          requests:
            cpu: 200m
            memory: 64Mi
          limits:
            cpu: 200m
            memory: 64Mi
EOF

# Wait for deployment to be ready
kubectl wait --for=condition=Available deployment/efficient-app -n controlled --timeout=60s

# Verify the deployment
kubectl get deployment efficient-app -n controlled
kubectl get pods -n controlled -l app=efficient-app

# Check quota usage now
kubectl describe resourcequota compute-quota -n controlled

# You should see:
# - Used pods: 6 (3 original + 3 deployment)
# - Used CPU: 900m (3 × 100m + 3 × 200m)
# - Still under quota limits!
```

</details>

## Calculating Quota Headroom

### Before Deployment
- Pods: 3/5 used (after deleting 2)
- CPU: 300m/2000m used
- Memory: ~384Mi/2Gi used

### After Deployment
- Pods: 6/5... wait, that's over!

**Important**: You need to ensure total pods ≤ 5. Since the Deployment needs 3 replicas, you can only have 2 other pods running.

### Corrected Calculation
- Delete `pod-4` and `pod-5` → leaves 3 pods (300m CPU)
- Add 3 deployment replicas (600m CPU)
- Total: 6 pods, 900m CPU
- But the pod quota is 5!

**Solution**: Delete one more pod, or reduce deployment replicas to 2.

Let's adjust: delete `pod-3`, `pod-4`, `pod-5` to leave 2 pods, then deploy 3 replicas = 5 total.

<details><summary>Corrected Solution</summary>

```bash
# Delete 3 pods to make room
kubectl delete pod pod-3 pod-4 pod-5 -n controlled

# Now create the deployment (as shown above)
# Total will be 2 + 3 = 5 pods (fits quota)
```

</details>
