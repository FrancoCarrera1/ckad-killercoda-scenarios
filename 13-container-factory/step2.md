## Tag, Save, and Load Images

Now you'll learn how to manage image tags and transfer images offline using `docker save` and `docker load`.

### Task

Perform the following operations:

1. **Tag the image**: Create an additional tag `myapp:latest` pointing to the same image as `myapp:v1`

2. **Save images**: Save BOTH tags (`myapp:v1` and `myapp:latest`) to a single tar file at `/root/container-factory/myapp.tar`

3. **Remove images**: Delete both `myapp:v1` and `myapp:latest` from your local Docker registry

4. **Load images**: Restore both images from the tar file using `docker load`

5. **Verify**: Confirm that both `myapp:v1` and `myapp:latest` exist after loading

### Why This Matters

In air-gapped environments or when you need to transfer images between systems without a registry, `docker save` and `docker load` are essential tools. They allow you to package images as tar archives for offline distribution.

<details><summary>Hint</summary>

Tag an image:
```bash
docker tag myapp:v1 myapp:latest
```

Save multiple tags:
```bash
docker save -o myapp.tar myapp:v1 myapp:latest
```

Remove images:
```bash
docker rmi myapp:v1 myapp:latest
```

Load images:
```bash
docker load -i myapp.tar
```
</details>

<details><summary>Solution</summary>

```bash
# Tag the image
docker tag myapp:v1 myapp:latest

# Verify both tags exist
docker images | grep myapp

# Save both tags to a tar file
docker save -o /root/container-factory/myapp.tar myapp:v1 myapp:latest

# Remove both images
docker rmi myapp:v1 myapp:latest

# Verify images are removed
docker images | grep myapp || echo "Images successfully removed"

# Load images back from tar file
docker load -i /root/container-factory/myapp.tar

# Verify both tags are restored
docker images | grep myapp
```
</details>
