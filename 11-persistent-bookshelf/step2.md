## Step 2: Deploy Application with PVC

Create a Deployment that uses the PersistentVolumeClaim and write test data to it.

### Requirements

**Deployment** named `bookshelf-app` in `bookshelf` namespace:
- **Replicas**: 1
- **Image**: `nginx:1.24`
- **Volume**: Mount `bookshelf-pvc` at `/usr/share/nginx/html/books`

After creating the Deployment:
1. Wait for the pod to be running
2. Exec into the pod and create a test file:
   ```bash
   echo "Kubernetes In Action" > /usr/share/nginx/html/books/book1.txt
   ```

### Key Concepts

- **PVC in Pods**: Reference the PVC by name in the pod/deployment spec
- **Volume Binding**: Once a pod uses the PVC, it will bind to the PV (if using WaitForFirstConsumer)
- **Mount Path**: The directory where the volume is accessible inside the container

<details><summary>Hint</summary>

Create a Deployment and add the PVC volume:

```bash
kubectl create deployment bookshelf-app --image=nginx:1.24 -n bookshelf --dry-run=client -o yaml > deployment.yaml
```

Then edit to add the volume and volumeMount:
```yaml
spec:
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        volumeMounts:
        - name: bookshelf-storage
          mountPath: /usr/share/nginx/html/books
      volumes:
      - name: bookshelf-storage
        persistentVolumeClaim:
          claimName: bookshelf-pvc
```

</details>

<details><summary>Solution</summary>

```bash
# Create Deployment with PVC
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bookshelf-app
  namespace: bookshelf
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bookshelf
  template:
    metadata:
      labels:
        app: bookshelf
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        volumeMounts:
        - name: bookshelf-storage
          mountPath: /usr/share/nginx/html/books
      volumes:
      - name: bookshelf-storage
        persistentVolumeClaim:
          claimName: bookshelf-pvc
EOF

# Wait for pod to be ready
kubectl wait --for=condition=ready pod -l app=bookshelf -n bookshelf --timeout=60s

# Write test data
POD_NAME=$(kubectl get pods -n bookshelf -l app=bookshelf -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD_NAME -n bookshelf -- sh -c "echo 'Kubernetes In Action' > /usr/share/nginx/html/books/book1.txt"

# Verify the file exists
kubectl exec $POD_NAME -n bookshelf -- cat /usr/share/nginx/html/books/book1.txt

# Check PVC is now Bound
kubectl get pvc -n bookshelf
```

The PVC should now be in `Bound` state since a pod is using it.

</details>

### What Just Happened?

1. The Deployment created a pod that references the PVC
2. Kubernetes scheduler saw the pod needed the PVC
3. Because of WaitForFirstConsumer, binding happened when the pod was scheduled
4. The PV is now bound to the PVC and mounted in the pod
5. Data written to `/usr/share/nginx/html/books` is stored in the PV

### Verification

The Deployment should be running, the PVC should be Bound, and the test file should exist.
