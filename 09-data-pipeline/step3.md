## Step 3: Manual Job Trigger

Sometimes you need to run a scheduled job immediately without waiting for the next scheduled time. Learn how to manually trigger a Job from a CronJob.

### Requirements

1. Manually create a Job named `manual-archive` from the `record-archiver` CronJob
2. Wait for the manually triggered job to complete
3. Also wait for the `data-processor` Job from Step 1 to complete successfully

### Key Concepts

- **Manual Job Creation**: `kubectl create job --from=cronjob/<name>` creates a one-time Job using the CronJob's template
- This is useful for:
  - Testing CronJob configurations before scheduling
  - Running urgent batch jobs outside the schedule
  - Troubleshooting job failures

<details><summary>Hint</summary>

Use the `kubectl create job` command with the `--from` flag:

```bash
kubectl create job <job-name> --from=cronjob/<cronjob-name> -n <namespace>
```

To wait for jobs to complete:
```bash
kubectl wait --for=condition=complete job/<job-name> -n <namespace> --timeout=60s
```

</details>

<details><summary>Solution</summary>

```bash
# Manually trigger a job from the CronJob
kubectl create job manual-archive --from=cronjob/record-archiver -n data-pipeline

# Watch the manual job
kubectl get jobs -n data-pipeline

# Wait for the manual job to complete
kubectl wait --for=condition=complete job/manual-archive -n data-pipeline --timeout=60s

# Also wait for the data-processor job to complete
kubectl wait --for=condition=complete job/data-processor -n data-pipeline --timeout=120s

# View the logs from the manual job
kubectl logs -n data-pipeline -l job-name=manual-archive

# Check all jobs
kubectl get jobs -n data-pipeline
```

You should see both jobs showing COMPLETIONS values indicating success.

</details>

### CKAD Exam Tip

In the exam, you might need to:
- Quickly create a Job for a one-time task: `kubectl create job`
- Modify an existing Job: Remember Jobs are immutable, you must delete and recreate
- Debug failed Jobs: Check pod logs, events, and the job's status conditions
- Understand the difference between Job restartPolicy (Never or OnFailure) vs Pod restart behavior

### Verification

Your manually triggered job should exist and the data-processor job should have completed successfully.
