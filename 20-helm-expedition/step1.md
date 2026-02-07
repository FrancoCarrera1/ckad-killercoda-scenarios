# Add and Explore Helm Repository

In this step, you'll add the Bitnami repository and explore available charts.

## Task Description

1. **Add the Bitnami Helm repository** with the URL `https://charts.bitnami.com/bitnami` and name it `bitnami`
2. **Update your Helm repositories** to fetch the latest chart information
3. **Search for the Apache chart** in the Bitnami repository
4. **Show the default values** for the `bitnami/apache` chart
5. **Save the default values** to `/root/apache-values.yaml` for reference

These operations are fundamental to working with Helm—you need to know where charts are located, what configuration options they support, and how to customize them.

<details><summary>Hint</summary>

Use `helm repo add <name> <url>` to add a repository.

Use `helm repo update` to refresh the local cache of charts.

Use `helm search repo <keyword>` to find charts.

Use `helm show values <chart>` to see default configuration options.

You can redirect output to a file with `>` operator.

</details>

<details><summary>Solution</summary>

```bash
# Add the Bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update repositories to get the latest chart information
helm repo update

# Search for Apache chart
helm search repo apache

# Show default values for bitnami/apache
helm show values bitnami/apache

# Save the default values to a file
helm show values bitnami/apache > /root/apache-values.yaml

# Verify the file was created
ls -lh /root/apache-values.yaml
```

</details>
