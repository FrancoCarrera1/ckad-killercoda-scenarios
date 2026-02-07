## Task description

Perform a comprehensive cluster health assessment. Check node conditions, system pods, and cluster events.

Tasks:
1. Check the condition of all nodes (Ready, MemoryPressure, DiskPressure, etc.)
2. List all pods in the `kube-system` namespace to ensure system components are healthy
3. Get all events in the cluster and filter for Warning events
4. Save Warning events to `/root/cluster-warnings.txt`
5. Save system pod status to `/root/system-health.txt`

<details><summary>Hint</summary>

Useful commands:
```bash
# Node conditions
kubectl get nodes -o wide
kubectl describe nodes

# System pods
kubectl get pods -n kube-system

# Events
kubectl get events --all-namespaces --sort-by='.lastTimestamp'
kubectl get events -A --field-selector type=Warning
```

To save output:
```bash
command > file.txt
command >> file.txt  # append
```

</details>

<details><summary>Solution</summary>

```bash
# Check node conditions and status
kubectl get nodes -o wide

# Detailed node information
kubectl describe nodes

# Check system pods in kube-system namespace
kubectl get pods -n kube-system

# Save system pod status
kubectl get pods -n kube-system -o wide > /root/system-health.txt

# Get all events sorted by time
kubectl get events --all-namespaces --sort-by='.lastTimestamp'

# Filter for Warning events only
kubectl get events -A --field-selector type=Warning

# Save warning events to file
kubectl get events -A --field-selector type=Warning --sort-by='.lastTimestamp' > /root/cluster-warnings.txt

# Additional health checks
echo "" >> /root/system-health.txt
echo "=== NODE CONDITIONS ===" >> /root/system-health.txt
kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[?(@.type==\"Ready\")].status,MEMORY:.status.conditions[?(@.type==\"MemoryPressure\")].status,DISK:.status.conditions[?(@.type==\"DiskPressure\")].status >> /root/system-health.txt

# View the saved files
echo "=== System Health ==="
cat /root/system-health.txt

echo ""
echo "=== Cluster Warnings ==="
cat /root/cluster-warnings.txt
```

A healthy cluster should show:
- All nodes in Ready state
- No MemoryPressure or DiskPressure
- All kube-system pods Running
- Minimal Warning events (some warnings are normal)

</details>
