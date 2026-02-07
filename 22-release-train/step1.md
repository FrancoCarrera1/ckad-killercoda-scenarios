# Deploy Redis with Helm

First, deploy the infrastructure layer: a Redis instance that will serve as the application's cache.

## Task Description

1. **Add the Bitnami repository** (if not already added):
   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   helm repo update
   ```

2. **Install Redis** with these specifications:
   - Release name: `my-redis`
   - Namespace: `fullstack`
   - Chart: `bitnami/redis`
   - Custom values:
     - `architecture=standalone` (single instance, no replication)
     - `auth.enabled=false` (no password for simplicity)
     - `master.persistence.enabled=false` (no persistent storage)

3. **Wait for Redis to be ready**:
   - Check that the Redis pod is running
   - Verify the service is available

The Redis service will be accessible at `my-redis-master.fullstack.svc.cluster.local:6379`.

<details><summary>Hint</summary>

Install with multiple `--set` flags:
```bash
helm install my-redis bitnami/redis -n fullstack \
  --set key1=value1 \
  --set key2=value2 \
  --set key3=value3
```

Wait for pods:
```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=redis -n fullstack --timeout=120s
```

</details>

<details><summary>Solution</summary>

```bash
# Add Bitnami repo (if not already added)
helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
helm repo update

# Install Redis with custom values
helm install my-redis bitnami/redis -n fullstack \
  --set architecture=standalone \
  --set auth.enabled=false \
  --set master.persistence.enabled=false

# Wait for Redis to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=redis -n fullstack --timeout=120s

# Verify Redis is running
kubectl get pods -n fullstack
kubectl get svc -n fullstack

# Test Redis connectivity (optional)
kubectl run redis-test --rm -i --tty --image=redis:7 -n fullstack -- redis-cli -h my-redis-master.fullstack.svc.cluster.local ping
```

</details>
