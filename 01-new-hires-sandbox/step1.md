# Step 1: Create Namespace and ServiceAccount

## Task

Create a dedicated namespace for Angelica with proper labels and a ServiceAccount for her workloads.

### Requirements

1. Create a namespace named `dev-angelica` with the following labels:
   - `team=frontend`
   - `env=dev`

2. Create a ServiceAccount named `angelica-sa` in the `dev-angelica` namespace

## Why This Matters

- **Namespaces** provide logical isolation between different teams or projects
- **Labels** help organize and select resources (crucial for filtering and automation)
- **ServiceAccounts** provide identity for pods, allowing them to interact with the Kubernetes API

<details><summary>Hint 1: Creating a namespace with labels</summary>

Use `kubectl create namespace` followed by `kubectl label` to add labels, or create a YAML manifest with labels included.

The imperative approach:

```bash
kubectl create namespace <name>
kubectl label namespace <name> key=value
```

</details>

<details><summary>Hint 2: Creating a ServiceAccount</summary>

Use `kubectl create serviceaccount` with the `-n` flag to specify the namespace.

```bash
kubectl create serviceaccount <name> -n <namespace>
```

</details>

<details><summary>Solution</summary>

```bash
# Create the namespace with labels
kubectl create namespace dev-angelica
kubectl label namespace dev-angelica team=frontend env=dev

# Create the ServiceAccount
kubectl create serviceaccount angelica-sa -n dev-angelica

# Verify your work
kubectl get namespace dev-angelica --show-labels
kubectl get serviceaccount angelica-sa -n dev-angelica
```

Alternative single-command approach for namespace:

```bash
kubectl create namespace dev-angelica --dry-run=client -o yaml | \
  kubectl label --local -f - team=frontend env=dev --dry-run=client -o yaml | \
  kubectl apply -f -
```

</details>

## Verification

Run the verification script to check your work:

```bash
/usr/local/bin/step1-verify.sh
```
