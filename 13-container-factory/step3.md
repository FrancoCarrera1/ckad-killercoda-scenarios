## Inspect and Run Container

Now verify that your multi-stage build produced an optimized image by inspecting its size and running it.

### Task

1. **Check image size**: Use `docker images` to verify the final image is under 15MB. This demonstrates the power of multi-stage builds compared to including build tools in the final image.

2. **Inspect image details**: Use `docker inspect myapp:v1` to view detailed image metadata (you can pipe to `jq` or `grep` for specific fields)

3. **View image history**: Run `docker history myapp:v1` to see the layers that make up the image

4. **Run the container**: Execute the container to verify it works correctly and outputs the expected message

5. **Verify execution**: Check that the container ran successfully with exit code 0

### Why This Matters

Image size directly impacts:
- Deployment speed (faster pulls)
- Storage costs (less disk usage)
- Security (smaller attack surface)
- Network bandwidth (faster transfers)

A well-optimized image can be 10-50x smaller than a naive build!

<details><summary>Hint</summary>

Check image size:
```bash
docker images myapp:v1
```

Inspect image (find size):
```bash
docker inspect myapp:v1 | grep -i size
```

View history:
```bash
docker history myapp:v1
```

Run container:
```bash
docker run --name test-run myapp:v1
```

Check exit code:
```bash
docker ps -a --filter name=test-run
```
</details>

<details><summary>Solution</summary>

```bash
# Check image size (should be under 15MB)
docker images myapp:v1

# Inspect image for detailed info
docker inspect myapp:v1 | grep -A 2 "Size"

# View image history to see layers
docker history myapp:v1

# Run the container
docker run --name factory-test myapp:v1

# Verify it ran successfully (exit code 0)
docker ps -a --filter name=factory-test

# Check logs
docker logs factory-test

# Cleanup
docker rm factory-test
```

You should see output: `Hello from the Container Factory! Build v1`

The image size should be approximately 7-12MB (Alpine ~7MB + small Go binary), far smaller than the ~300MB+ golang base image!
</details>
