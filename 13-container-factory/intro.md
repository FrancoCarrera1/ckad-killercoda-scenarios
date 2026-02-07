# The Container Factory

Welcome to the Container Factory! As a developer in a cloud-native environment, you need to build efficient container images that are production-ready.

## Scenario Overview

In this scenario, you'll learn how to:
- Write multi-stage Dockerfiles to optimize image size
- Build, tag, and manage container images
- Save and load images for offline transfer
- Inspect image properties and verify optimization

## Why This Matters

**Multi-stage builds** are essential for creating small, secure container images. By separating build dependencies from runtime dependencies, you can:
- Reduce image size by 10x or more
- Minimize attack surface by excluding build tools
- Speed up deployments with smaller images
- Lower storage and bandwidth costs

## Real-World Context

You're working with a Go application that needs to be containerized. The build process requires the Go compiler and build tools, but the runtime only needs the compiled binary. Using multi-stage builds, you'll create an optimized image that's production-ready.

## Learning Objectives

By the end of this scenario, you will:
- Create multi-stage Dockerfiles with builder and runtime stages
- Build and tag container images efficiently
- Use `docker save` and `docker load` for offline image transfer
- Inspect images to verify size optimization
- Understand image layers and their impact on size

Let's start building efficient containers!
