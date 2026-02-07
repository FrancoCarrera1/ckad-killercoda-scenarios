## Step 1: Create Parallel Job

Your first task is to create a Job that processes 6 batches of data in parallel (3 at a time).

### Requirements

Create a Job named `data-processor` in the `data-pipeline` namespace with:
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "echo Processing batch $RANDOM && sleep 5"]`
- **Completions**: 6 (total number of successful pod completions needed)
- **Parallelism**: 3 (maximum number of pods running simultaneously)
- **BackoffLimit**: 2 (number of retries before marking the job as failed)
- **ActiveDeadlineSeconds**: 120 (job timeout in seconds)

### Key Concepts

- **Completions**: Total successful pods needed before the Job is considered complete
- **Parallelism**: How many pods run concurrently
- **BackoffLimit**: How many pod failures are tolerated before giving up
- **ActiveDeadlineSeconds**: Maximum time the Job can run before being terminated

<details><summary>Hint</summary>

You can create the Job using kubectl with the `--dry-run=client -o yaml` approach to generate the YAML, then add the Job-specific fields:

```bash
kubectl create job data-processor --image=busybox:1.36 -n data-pipeline \
  --dry-run=client -o yaml > job.yaml
```

Then edit the YAML to add:
```yaml
spec:
  completions: 6
  parallelism: 3
  backoffLimit: 2
  activeDeadlineSeconds: 120
  template:
    spec:
      containers:
      - name: data-processor
        image: busybox:1.36
        command: ["sh", "-c", "echo Processing batch $RANDOM && sleep 5"]
      restartPolicy: Never
```

</details>

<details><summary>Solution</summary>

```bash
# Create the Job with all specifications
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
  namespace: data-pipeline
spec:
  completions: 6
  parallelism: 3
  backoffLimit: 2
  activeDeadlineSeconds: 120
  template:
    spec:
      containers:
      - name: data-processor
        image: busybox:1.36
        command: ["sh", "-c", "echo Processing batch \$RANDOM && sleep 5"]
      restartPolicy: Never
EOF

# Watch the Job progress
kubectl get jobs -n data-pipeline -w
```

You should see the Job create 3 pods at a time, completing 6 total before finishing.

</details>

### Verification

Your Job should be created with the correct specifications. The verify script will check all configuration values.
