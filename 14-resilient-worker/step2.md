## Build a Job with Retry Logic

Real-world batch jobs encounter transient failures. Use `backoffLimit` to configure automatic retry behavior.

### Task

Create a Job named `flaky-worker` in the `batch-processing` namespace that simulates random failures:

**Job Configuration:**
- **Name**: `flaky-worker`
- **Namespace**: `batch-processing`
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "if [ $((RANDOM % 3)) -eq 0 ]; then echo 'Success'; exit 0; else echo 'Failed'; exit 1; fi"]`
- **backoffLimit**: 4 (allow up to 4 retries)
- **restartPolicy**: `Never` (create new Pod for each retry)

### Understanding Retry Behavior

**backoffLimit** controls how many times Kubernetes will retry a failed Job:
- Each failure creates a new Pod (with `restartPolicy: Never`)
- Backoff delay increases exponentially: 10s, 20s, 40s...
- After `backoffLimit` failures, the Job is marked as Failed

**restartPolicy options:**
- `Never`: Create new Pod for each retry (recommended for Jobs)
- `OnFailure`: Restart container in the same Pod

### What to Observe

After creating the Job, watch its behavior:
```bash
kubectl get pods -n batch-processing -l job-name=flaky-worker -w
```

You'll see:
- Multiple Pods created as retries occur
- Some Pods with status `Error` or `Failed`
- Eventually either success or final failure after 4 attempts

<details><summary>Hint</summary>

Job manifest:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: flaky-worker
  namespace: batch-processing
spec:
  backoffLimit: 4
  template:
    spec:
      containers:
      - name: worker
        image: busybox:1.36
        command:
        - sh
        - -c
        - |
          if [ $((RANDOM % 3)) -eq 0 ]; then
            echo 'Success'
            exit 0
          else
            echo 'Failed'
            exit 1
          fi
      restartPolicy: Never
```
</details>

<details><summary>Solution</summary>

```bash
# Create the flaky Job
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: flaky-worker
  namespace: batch-processing
spec:
  backoffLimit: 4
  template:
    spec:
      containers:
      - name: worker
        image: busybox:1.36
        command:
        - sh
        - -c
        - |
          if [ \$((RANDOM % 3)) -eq 0 ]; then
            echo 'Success'
            exit 0
          else
            echo 'Failed'
            exit 1
          fi
      restartPolicy: Never
EOF

# Watch Pod creation and retry behavior
kubectl get pods -n batch-processing -l job-name=flaky-worker -w

# In another terminal, check Job status
kubectl get job flaky-worker -n batch-processing

# View logs from all Pods (including failed ones)
for pod in $(kubectl get pods -n batch-processing -l job-name=flaky-worker -o name); do
  echo "=== $pod ==="
  kubectl logs -n batch-processing $pod
done

# Check Job events for retry information
kubectl describe job flaky-worker -n batch-processing
```

Due to the 33% success rate, you'll likely see 1-3 failed Pods before success, or 4+ failures if unlucky.
</details>
