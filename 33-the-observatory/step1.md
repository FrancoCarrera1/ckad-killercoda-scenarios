## Task description

Monitor resource usage across your cluster using `kubectl top`. This command requires metrics-server to be running (it's already deployed for you).

Tasks:
1. Check resource usage for all nodes in the cluster
2. Check resource usage for all pods in the `observatory` namespace
3. Identify which pod is consuming the most CPU
4. Identify which pod is consuming the most memory
5. Save the combined output of node and pod metrics to `/root/resource-usage.txt`

**Note**: It may take 1-2 minutes for metrics to be available after pods start. If you get an error, wait a moment and try again.

<details><summary>Hint</summary>

Use these commands:
```bash
kubectl top nodes
kubectl top pods -n observatory
```

You can also sort by specific columns:
```bash
kubectl top pods -n observatory --sort-by=cpu
kubectl top pods -n observatory --sort-by=memory
```

Redirect output with `>` or `>>` to save to a file.

</details>

<details><summary>Solution</summary>

```bash
# Check node resource usage
kubectl top nodes

# Check pod resource usage in observatory namespace
kubectl top pods -n observatory

# Sort by CPU usage
kubectl top pods -n observatory --sort-by=cpu

# Sort by memory usage
kubectl top pods -n observatory --sort-by=memory

# Save combined output to file
{
  echo "=== NODE METRICS ==="
  kubectl top nodes
  echo ""
  echo "=== POD METRICS ==="
  kubectl top pods -n observatory
  echo ""
  echo "=== TOP CPU CONSUMERS ==="
  kubectl top pods -n observatory --sort-by=cpu
  echo ""
  echo "=== TOP MEMORY CONSUMERS ==="
  kubectl top pods -n observatory --sort-by=memory
} > /root/resource-usage.txt

# View the saved file
cat /root/resource-usage.txt
```

The `cpu-hog` pod should be consuming the most CPU, and `mystery-crash` (if running) should show memory usage.

</details>
