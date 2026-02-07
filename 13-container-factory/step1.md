## Build a Multi-Stage Docker Image

Your first task is to create an optimized Dockerfile using multi-stage builds for the Go application.

### Task

Write a multi-stage Dockerfile at `/root/container-factory/Dockerfile` with the following specifications:

**Stage 1 (builder):**
- Use base image `golang:1.21-alpine`
- Set working directory to `/build`
- Copy `go.mod`, `go.sum` (if exists), and `main.go` to the container
- Build a static binary with: `CGO_ENABLED=0 go build -o /app main.go`

**Stage 2 (runtime):**
- Use base image `alpine:3.19`
- Copy the binary from the builder stage (`/app`) to `/app`
- Set the ENTRYPOINT to `["/app"]`

After creating the Dockerfile, build the image and tag it as `myapp:v1`.

### Requirements

- The Dockerfile must use multi-stage builds (two FROM statements)
- The final image should be based on Alpine Linux
- Build the image with the tag `myapp:v1`

<details><summary>Hint</summary>

Multi-stage Dockerfile structure:
```dockerfile
# Stage 1: Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 go build -o /app main.go

# Stage 2: Runtime stage
FROM alpine:3.19
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Build command:
```bash
docker build -t myapp:v1 /root/container-factory
```
</details>

<details><summary>Solution</summary>

```bash
# Create the Dockerfile
cat > /root/container-factory/Dockerfile << 'EOF'
# Stage 1: Builder
FROM golang:1.21-alpine AS builder
WORKDIR /build
COPY go.mod main.go ./
RUN CGO_ENABLED=0 go build -o /app main.go

# Stage 2: Runtime
FROM alpine:3.19
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
EOF

# Build the image
cd /root/container-factory
docker build -t myapp:v1 .

# Verify the build
docker images | grep myapp
```
</details>
