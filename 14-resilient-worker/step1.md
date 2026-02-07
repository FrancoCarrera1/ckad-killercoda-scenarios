## Create an Indexed Job for Parallel Processing

Indexed Jobs assign a unique index to each Pod, allowing you to process distinct work items in parallel.

### Task

Create an Indexed Job named `index-processor` in the `batch-processing` namespace with these specifications:

**Job Configuration:**
- **Name**: `index-processor`
- **Namespace**: `batch-processing`
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "echo Processing partition $JOB_COMPLETION_INDEX && sleep 3"]`
- **Completions**: 4 (process 4 partitions)
- **Parallelism**: 2 (run 2 at a time)
- **completionMode**: `Indexed`
- **ttlSecondsAfterFinished**: 120 (auto-delete after 2 minutes)

### Why Indexed Jobs?

With `completionMode: Indexed`:
- Each Pod gets a unique `JOB_COMPLETION_INDEX` environment variable (0, 1, 2, 3...)
- Your application can use this index to determine which work item to process
- Kubernetes ensures all indexes complete exactly once

This is perfect for:
- Processing database partitions
- Batch processing files from a list
- Distributed map operations

### Requirements

- The Job must use `completionMode: Indexed`
- Each Pod should process a unique partition index
- The Job should auto-delete 120 seconds after completion

<details><summary>Hint</summary>

Job manifest structure:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: index-processor
  namespace: batch-processing
spec:
  completions: 4
  parallelism: 2
  completionMode: Indexed
  ttlSecondsAfterFinished: 120
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command: ["sh", "-c", "echo Processing partition $JOB_COMPLETION_INDEX && sleep 3"]
      restartPolicy: Never
```

Watch the job:
```bash
kubectl get pods -n batch-processing -w
```
</details>

<details><summary>Solution</summary>

```bash
# Create the Indexed Job
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: index-processor
  namespace: batch-processing
spec:
  completions: 4
  parallelism: 2
  completionMode: Indexed
  ttlSecondsAfterFinished: 120
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command:
        - sh
        - -c
        - echo Processing partition \$JOB_COMPLETION_INDEX && sleep 3
      restartPolicy: Never
EOF

# Watch the Job execution
kubectl get jobs -n batch-processing -w

# Check Pod indexes
kubectl get pods -n batch-processing -L job-completion-index

# View logs from each Pod
kubectl logs -n batch-processing -l job-name=index-processor

# Check Job details
kubectl describe job index-processor -n batch-processing
```

You should see 4 Pods complete with indexes 0, 1, 2, and 3. With parallelism=2, they run 2 at a time.
</details>
