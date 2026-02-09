# Step 3: Advanced Output Formatting

## Task

Use JSONPath and custom columns to extract specific information from cluster resources.

### Requirements

1. Use **JSONPath** to extract all node names and their internal IP addresses, save to `/root/node-info.txt`
   - Format: Each line should show node name and IP

2. Use **custom-columns** to list all services showing only NAME and CLUSTER-IP columns, save to `/root/services.txt`

## Why This Matters

In the CKAD exam, you need to:
- Extract specific fields from resources (JSONPath is the fastest way)
- Create custom output formats when the default table doesn't show what you need
- Quickly gather specific information without parsing full YAML

These skills are tested frequently and save significant time!

<details><summary>Hint 1: JSONPath basics</summary>

JSONPath syntax in kubectl:
```bash
kubectl get <resource> -o jsonpath='{.items[*].field.subfield}'
```

For nodes:
- Node name: `.items[*].metadata.name`
- Internal IP: `.items[*].status.addresses[?(@.type=="InternalIP")].address`

</details>

<details><summary>Hint 2: Formatting JSONPath output</summary>

You can add newlines and text in JSONPath:
```bash
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
```

- `{range .items[*]}...{end}` - loop through items
- `{"\t"}` - tab character
- `{"\n"}` - newline character

</details>

<details><summary>Hint 3: Custom columns</summary>

Use `-o custom-columns=COLUMN_NAME:jsonpath`:
```bash
kubectl get services -A -o custom-columns=NAME:.metadata.name,CLUSTER-IP:.spec.clusterIP
```

</details>

<details><summary>Solution</summary>

```bash
# Get node names and internal IPs using JSONPath
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}' > /root/node-info.txt

# Verify the file
cat /root/node-info.txt

# Alternative JSONPath approach (simpler but less formatted)
# kubectl get nodes -o jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/node-info.txt

# Get all services with custom columns
kubectl get services --all-namespaces -o custom-columns=NAME:.metadata.name,CLUSTER-IP:.spec.clusterIP > /root/services.txt

# Verify the file
cat /root/services.txt
```

**Understanding the JSONPath**:

For nodes:
- `{range .items[*]}` - iterate over all nodes
- `{.metadata.name}` - get the node name
- `{"\t"}` - add a tab separator
- `{.status.addresses[?(@.type=="InternalIP")].address}` - filter addresses for InternalIP type
- `{"\n"}` - add a newline
- `{end}` - end the loop

For services with custom-columns:
- `NAME:.metadata.name` - Column "NAME" shows metadata.name
- `CLUSTER-IP:.spec.clusterIP` - Column "CLUSTER-IP" shows spec.clusterIP

</details>

## Deep Dive: JSONPath vs Custom Columns

**JSONPath** (`-o jsonpath`):
- More flexible, can create any format
- Requires manual formatting (tabs, newlines)
- Best for extracting specific fields or complex filtering

**Custom Columns** (`-o custom-columns`):
- Automatically creates a table format
- Easier for creating readable columns
- Best for creating custom tables
