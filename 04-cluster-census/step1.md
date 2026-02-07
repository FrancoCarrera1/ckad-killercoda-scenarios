# Step 1: List and Save Namespaces

## Task

Create an inventory of all namespaces in the cluster and save the output to a file.

### Requirements

List all namespaces and save the output to `/root/namespaces.txt`

## Why This Matters

In the CKAD exam, you often need to:
- Save command output to specific files (the exam instructions will specify the path)
- Document your findings
- Provide output as evidence of completion

This is a fundamental skill that appears in many exam questions!

<details><summary>Hint 1: Listing namespaces</summary>

Use `kubectl get namespaces` (or the shorthand `kubectl get ns`):
```bash
kubectl get namespaces
```

</details>

<details><summary>Hint 2: Redirecting output to a file</summary>

Use the `>` operator to redirect output:
```bash
kubectl get namespaces > /root/namespaces.txt
```

This will overwrite the file if it exists. Use `>>` to append instead.

</details>

<details><summary>Solution</summary>

```bash
# List all namespaces and save to file
kubectl get namespaces > /root/namespaces.txt

# Verify the file was created
cat /root/namespaces.txt

# You should see namespaces like:
# - default
# - kube-system
# - kube-public
# - kube-node-lease
# - app-team
# - monitoring

# Alternative with shorthand
kubectl get ns > /root/namespaces.txt
```

</details>

## Verification

Run the verification script to check your work:
```bash
/usr/local/bin/step1-verify.sh
```
