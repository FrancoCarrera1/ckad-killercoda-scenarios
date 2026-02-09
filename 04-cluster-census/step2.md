# Step 2: List and Sort Pods

## Task

Create comprehensive pod inventories with different filters and sorting.

### Requirements

1. List **all pods across ALL namespaces**, sorted by creation timestamp (oldest first), and save to `/root/all-pods.txt`

2. List only pods in the `kube-system` namespace and save to `/root/system-pods.txt`

## Why This Matters

In the CKAD exam, you need to:
- Quickly find pods across all namespaces (`--all-namespaces` or `-A`)
- Sort resources by different fields (creation time, name, status, etc.)
- Filter by namespace with `-n` flag

These are high-frequency operations in exam questions!

<details><summary>Hint 1: Listing pods across all namespaces</summary>

Use `--all-namespaces` or the shorthand `-A`:
```bash
kubectl get pods --all-namespaces
# or
kubectl get pods -A
```

</details>

<details><summary>Hint 2: Sorting by creation timestamp</summary>

Use `--sort-by` with a JSONPath expression:
```bash
kubectl get pods -A --sort-by=.metadata.creationTimestamp
```

The `.metadata.creationTimestamp` field contains when the pod was created.

</details>

<details><summary>Hint 3: Filtering by namespace</summary>

Use `-n` or `--namespace`:
```bash
kubectl get pods -n kube-system
```

</details>

<details><summary>Solution</summary>

```bash
# List all pods across all namespaces, sorted by creation time
kubectl get pods --all-namespaces --sort-by=.metadata.creationTimestamp > /root/all-pods.txt

# Verify the file
cat /root/all-pods.txt

# List pods only in kube-system namespace
kubectl get pods -n kube-system > /root/system-pods.txt

# Verify the file
cat /root/system-pods.txt

# You can also verify the sorting worked
# (older pods should appear first in all-pods.txt)
```

**Note**: The `--sort-by` flag requires a JSONPath expression that points to a field in the resource. Common fields to sort by:
- `.metadata.name` - alphabetically by name
- `.metadata.creationTimestamp` - by age
- `.status.phase` - by status (Pending, Running, etc.)

</details>
