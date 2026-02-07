#!/bin/bash
set -euo pipefail

# Check if ConfigMap exists
if ! kubectl get configmap pipeline-config -n batch-processing >/dev/null 2>&1; then
    echo "Error: ConfigMap 'pipeline-config' not found in namespace 'batch-processing'"
    exit 1
fi

# Check ConfigMap data
mode_value=$(kubectl get configmap pipeline-config -n batch-processing -o jsonpath='{.data.mode}')
if [[ "$mode_value" != "full" ]]; then
    echo "Error: ConfigMap 'mode' value is '$mode_value', expected 'full'"
    exit 1
fi

# Check if CronJob exists
if ! kubectl get cronjob pipeline-trigger -n batch-processing >/dev/null 2>&1; then
    echo "Error: CronJob 'pipeline-trigger' not found in namespace 'batch-processing'"
    exit 1
fi

# Check if CronJob has volume mount for ConfigMap
volume_name=$(kubectl get cronjob pipeline-trigger -n batch-processing -o jsonpath='{.spec.jobTemplate.spec.template.spec.volumes[?(@.configMap.name=="pipeline-config")].name}')
if [[ -z "$volume_name" ]]; then
    echo "Error: CronJob does not have ConfigMap 'pipeline-config' mounted as a volume"
    exit 1
fi

# Check if container has the volume mount
mount_path=$(kubectl get cronjob pipeline-trigger -n batch-processing -o jsonpath="{.spec.jobTemplate.spec.template.spec.containers[0].volumeMounts[?(@.name=='$volume_name')].mountPath}")
if [[ -z "$mount_path" ]]; then
    echo "Error: CronJob container does not have volume mount for ConfigMap"
    exit 1
fi

echo "Success: CronJob 'pipeline-trigger' is correctly configured with ConfigMap volume mount"
exit 0
