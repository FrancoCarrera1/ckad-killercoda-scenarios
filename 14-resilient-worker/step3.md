## Create a CronJob Pipeline with ConfigMap

CronJobs run on a schedule and can read dynamic configuration from ConfigMaps, enabling flexible batch pipelines.

### Task

Create a pipeline that reads configuration before processing:

**Step 1**: Create a ConfigMap named `pipeline-config` in `batch-processing` namespace with data:
- Key: `mode`
- Value: `full`

**Step 2**: Create a CronJob named `pipeline-trigger` in `batch-processing` namespace:
- **Schedule**: `*/30 * * * *` (every 30 minutes)
- **Image**: `busybox:1.36`
- **Command**: Read the `mode` from the mounted ConfigMap and echo it
- **Volume**: Mount the ConfigMap `pipeline-config` at `/config`
- **Command example**: `["sh", "-c", "echo Pipeline mode: $(cat /config/mode) && echo Processing... && sleep 5"]`

### Why ConfigMaps with CronJobs?

This pattern enables:
- **Dynamic configuration** without redeploying the CronJob
- **Environment-specific behavior** (dev vs. prod)
- **Feature flags** for pipeline behavior
- **Shared configuration** across multiple Jobs

### Requirements

- ConfigMap must contain `mode=full`
- CronJob must mount the ConfigMap as a volume
- CronJob command must read from `/config/mode`

<details><summary>Hint</summary>

ConfigMap:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: pipeline-config
  namespace: batch-processing
data:
  mode: "full"
```

CronJob with volume mount:
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pipeline-trigger
  namespace: batch-processing
spec:
  schedule: "*/30 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: pipeline
            image: busybox:1.36
            command:
            - sh
            - -c
            - echo Pipeline mode: $(cat /config/mode) && sleep 5
            volumeMounts:
            - name: config
              mountPath: /config
          volumes:
          - name: config
            configMap:
              name: pipeline-config
          restartPolicy: Never
```
</details>

<details><summary>Solution</summary>

```bash
# Create the ConfigMap
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: pipeline-config
  namespace: batch-processing
data:
  mode: "full"
EOF

# Create the CronJob
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pipeline-trigger
  namespace: batch-processing
spec:
  schedule: "*/30 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: pipeline
            image: busybox:1.36
            command:
            - sh
            - -c
            - echo Pipeline mode: \$(cat /config/mode) && echo Processing... && sleep 5
            volumeMounts:
            - name: config
              mountPath: /config
          volumes:
          - name: config
            configMap:
              name: pipeline-config
          restartPolicy: Never
EOF

# Verify ConfigMap
kubectl get configmap pipeline-config -n batch-processing -o yaml

# Verify CronJob
kubectl get cronjob pipeline-trigger -n batch-processing

# Manually trigger the CronJob to test (don't wait 30 minutes!)
kubectl create job --from=cronjob/pipeline-trigger manual-test -n batch-processing

# Check the manually created Job
kubectl get jobs -n batch-processing

# View logs
kubectl logs -n batch-processing -l job-name=manual-test

# Clean up manual test
kubectl delete job manual-test -n batch-processing
```

The output should show: `Pipeline mode: full`
</details>
