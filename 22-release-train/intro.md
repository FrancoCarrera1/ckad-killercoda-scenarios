# The Release Train

Welcome to the Release Train! Real-world Kubernetes deployments rarely use just one tool. You'll combine Helm and Kustomize to build a complete deployment pipeline.

## What You'll Learn

In this advanced scenario, you'll orchestrate a full-stack deployment:

- **Infrastructure with Helm**: Deploy Redis as a backing service
- **Application with Kustomize**: Deploy a webapp that connects to Redis
- **Rolling Updates**: Safely update the webapp with zero downtime
- **Rollback Strategies**: Recover from failed deployments

This mirrors real production workflows where infrastructure components (databases, caches, message queues) are managed with Helm, while custom applications use Kustomize or raw manifests.

## The Stack

You'll deploy:
- **Redis** (via Helm): A key-value store for caching
- **Webapp** (via Kustomize): An nginx-based application configured to connect to Redis

## Why This Matters for CKAD

The CKAD exam tests your ability to:
- Choose the right tool for each task
- Manage application dependencies
- Perform rolling updates safely
- Recover from failures quickly
- Work with environment variables and service discovery

This scenario integrates multiple exam domains: application deployment, observability, and troubleshooting.

## Tools You'll Use

- `helm`: Package manager for deploying Redis
- `kubectl apply -k`: Kustomize for deploying the webapp
- `kubectl rollout`: Managing deployment updates and rollbacks
- `kubectl exec`: Testing connectivity between services

All aboard the release train—let's ship this application!
