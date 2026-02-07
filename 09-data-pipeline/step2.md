## Step 2: Schedule CronJob

Now create a CronJob that archives records every 15 minutes.

### Requirements

Create a CronJob named `record-archiver` in the `data-pipeline` namespace with:
- **Image**: `busybox:1.36`
- **Command**: `["sh", "-c", "echo Archiving records at $(date)"]`
- **Schedule**: `*/15 * * * *` (every 15 minutes)
- **ConcurrencyPolicy**: `Forbid` (don't allow overlapping jobs)
- **SuccessfulJobsHistoryLimit**: 3
- **FailedJobsHistoryLimit**: 1

### Key Concepts

- **Schedule**: Uses standard cron format (minute hour day month weekday)
  - `*/15 * * * *` means "every 15 minutes"
- **ConcurrencyPolicy**: Controls behavior when a new job is scheduled but the previous one is still running
  - `Allow`: Multiple jobs can run concurrently (default)
  - `Forbid`: Skip the new job if the previous one is still running
  - `Replace`: Cancel the previous job and start the new one
- **History Limits**: How many completed/failed job objects to keep for debugging

<details><summary>Hint</summary>

Use `kubectl create cronjob` to generate the base YAML:

```bash
kubectl create cronjob record-archiver --image=busybox:1.36 \
  --schedule="*/15 * * * *" -n data-pipeline \
  --dry-run=client -o yaml > cronjob.yaml
```

Then add the concurrency policy and history limits to the spec:
```yaml
spec:
  schedule: "*/15 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
```

</details>

<details><summary>Solution</summary>

```bash
# Create the CronJob with all specifications
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: record-archiver
  namespace: data-pipeline
spec:
  schedule: "*/15 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: record-archiver
            image: busybox:1.36
            command: ["sh", "-c", "echo Archiving records at \$(date)"]
          restartPolicy: Never
EOF

# View the CronJob
kubectl get cronjobs -n data-pipeline
```

The CronJob is now scheduled but won't run until the next 15-minute mark.

</details>

### Verification

Your CronJob should be created with the correct schedule and concurrency policy.
